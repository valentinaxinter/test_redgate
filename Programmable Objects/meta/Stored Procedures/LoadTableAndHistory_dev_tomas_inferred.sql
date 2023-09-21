IF OBJECT_ID('[meta].[LoadTableAndHistory_dev_tomas_inferred]') IS NOT NULL
	DROP PROCEDURE [meta].[LoadTableAndHistory_dev_tomas_inferred];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Richard Lautmann
-- Create date: 2012-03-01
-- Description:	Generic procedure for insert/update 

-- Basically how it works:
-- The procedure looks at the target table and dynamically finds the columns, except those deinfed to be
-- igored and the insert audit columns, and creates a merge statement based on those conditions.   
-- It expects the source to have the same columns, and based on that it creates a merge statement. It also requires
-- rows to have a natural key, a code in one column. 

-- How to Use 
-- exec meta.LoadTableAndHistory @targetTable='Airport', @sourceTable='KS_Import..vAirport', @targetNKColumn='AirportCode',@PartitionId=1

-- Required parameters are: PartitionId, targetTable, sourceTable and targetNKColumn. 
-- You can override the names of the source audit column, source natural key column, the insert audit column and the 
-- update audit column. You can also define columns to ignore in the comparison, default is to compare all columns
-- except audit, primary keys and natural keys.   
-- =============================================

/*

exec [meta].[LoadTableAndHistory_dev_tomas_inferred] 
@PartitionKey = '2023-01-18 16:21:56', 
@targetTable = 'dw.Part', 
@sourceTable = 'stage.vTRA_SE_Part', 
@targetNKColumn = 'PartID',
@debugOnly = 1,
@dwFilterColumnName = null,
@deltaLoadStatement = 'WHERE 1 = 1'

*/
-- 

-- If stageView is empty then crashes.

CREATE PROCEDURE [meta].[LoadTableAndHistory_dev_tomas_inferred] (
	@PartitionKey varchar(50),
	@targetTable varchar(50), 
	@sourceTable varchar(50), 
	@targetNKColumn varchar(50),
	@sourceNKColumn varchar(50)='',
	@sourceAuditColumn varchar(50)='PartitionKey', 
	@updateAuditColumn varchar(50)='PartitionKey',
	@insertAuditColumn varchar(50)='PartitionKey',
	@ignoreColumns varchar(500)='', 
	@debugOnly int = 0,
	@dwFilterColumnName varchar(50),
	@deltaLoadStatement varchar(600)
	)
AS
BEGIN
	--**** Logging variables *******
	Declare  @ProcName varchar(100) = OBJECT_NAME(@@PROCID)
			, @FromTable varchar(100) = @sourceTable
			, @ToTable varchar(100)  = @targetTable
			, @startTime datetime = getdate() AT TIME ZONE 'UTC' AT TIME ZONE 'Central Europe Standard Time' -- Added double conversion to make sure we get the swedish timestamp /SM 2021-10-07
			, @endTime datetime
			, @rowsAffected int
			, @StatusName varchar(10)='OK'
			, @ErrorMessage varchar(max)	
			, @sSql varchar(max)
			, @sSql_detective varchar(max)
			, @columns varchar(max), @updateColumns varchar(max), @checkChangeColumns varchar(max)
			, @tmpTableName varchar(500) = 'stage.[__tmp_LoadTableAndHistory_'+@sourceTable+'_'+@PartitionKey+']' --Changed to @sourceTable instead of @targetTable here to to avoid the error of tmp table already exists with same name when multiple parallel loads are active. /Sm 2021-10-06
			, @minDateQuery varchar(max)
	--**** Logging variables *******	

	set @minDateQuery = (select concat('Select ',right(@deltaLoadStatement, charindex('=', reverse(@deltaLoadStatement)) - 1)))

	print(@minDateQuery)

	if @sourceNKColumn = '' 
		set @sourceNKColumn = @targetNKColumn

	set @ignoreColumns = @ignoreColumns + 'ValidFrom,ValidTo,'+
							@insertAuditColumn+','+
							@updateAuditColumn+','+
							@targetNKColumn+','+
							@sourceNKColumn
	
	-- stage some strings for audit columns
	if @updateAuditColumn <> ''
		set @updateAuditColumn = ','+@updateAuditColumn+' = source.'+@sourceAuditColumn
	if @sourceAuditColumn <> ''
		set @sourceAuditColumn = ', source.'+@sourceAuditColumn
	if @insertAuditColumn <> ''
		set @insertAuditColumn =  ','+@insertAuditColumn

	-- ******* Exclude specific fields ******* --
	-- We can include specific columns that we want to avoid checking in the merge statement for each company. TO
	declare @ignore_sqlStatement nvarchar(max)
	declare @append_ignoreColumns varchar(500) = ''

	declare @paramDefinition nvarchar(300) = N'@append_ignoreColumns varchar(600) OUTPUT, @sourceTable varchar(60)'
	set @ignore_sqlStatement = 'select @append_ignoreColumns = @append_ignoreColumns + '','' + columnName 
								from dbo.ignoreTableColumns where stageTableName = ' + '''' + @sourceTable + ''''

	EXEC sp_executesql @ignore_sqlStatement,
				@paramDefinition,
				@append_ignoreColumns = @append_ignoreColumns OUTPUT,
				@sourceTable = @sourceTable;

	if len(@append_ignoreColumns) > 0
		begin
			set @ignoreColumns = @ignoreColumns + @append_ignoreColumns
		end

	-- ******* Exclude specific fields ******* --

	-- ******* Get column list ******* --
	exec meta.GetTableColumnList_test
		@targetTable, 
		@sourceTable,
		@ignoreColumns,
		@ColumnList=@columns output,
		@updateList=@updateColumns output ,
		@checkForChangeList=@checkChangeColumns output

	-- ******* Get column list ******* --

	if @debugOnly = 1

	begin
		print('@updateAuditColumn '+ @updateAuditColumn)
		print(char(10))
		print('@sourceAuditColumn '+ @sourceAuditColumn)
		print(char(10))
		print('@insertAuditColumn '+ @insertAuditColumn)
		print(char(10))
		print('@columns: ' + @columns)
		print(char(10))
		print('@updateColumns ' + @updateColumns)
		print(char(10))
		print('Left @checkChangeColumns ' + @checkChangeColumns)
		print(char(10))
		print('Right @checkChangeColumns' + right(@checkChangeColumns,3999))
		print(char(10))
		print('@ignoreColumns: ' + @ignoreColumns)
		print(char(10))
	end


	-- ******* Generate @tmpTableName from @sourceTable (stage view) ******* --

	-- If I'm not debugging, I will materialize @tmpTableName and use it then for the cursor
	-- otherwise, I will use the cursor with the @sourceTable cause I know there will be no issues
	if @debugOnly = 0

	Begin
		-- *** For performance reason, create a temp table to work with. Temp storage is too small to use.
		if object_id(@tmpTableName) is not null
			exec ('drop table ' + @tmpTableName)
	
		set @sSql = 'select * into ' + @tmpTableName + ' from ' + @sourceTable 

		exec (@sSql)
		if @@ROWCOUNT=0
		begin
			exec ('drop table ' + @tmpTableName)
			return
		end
	End
	else 
		print @sSql
	-- ******* Generate @tmpTableName from @sourceTable (stage view) ******* --


	-- ******* Generate dynamic company in () ******* --

	-- When I'm not debugging, the cursor will use the table created above. Otherwise we use
	-- the stage view as we described before
	declare @cursor_success bit = 0;
	Declare @sqlStatement_Cursor nvarchar(600)
	Declare @companyNameIterator varchar(50)
	declare @companyPiece varchar(2000)


	if @debugOnly = 0
	begin
		set @cursor_success = 1;

		begin try
			set @sqlStatement_Cursor = 'DECLARE companyCursor cursor for SELECT DISTINCT Company FROM ' + @tmpTableName
			set @companyPiece = ''

			exec sp_executesql @sqlStatement_Cursor

			OPEN companyCursor
			FETCH NEXT FROM companyCursor
				INTO @companyNameIterator

			WHILE @@FETCH_STATUS = 0
			BEGIN
				set @companyPiece = @companyPiece + '''' + @companyNameIterator + '''' + ','

				fetch next FROM companyCursor
					INTO @companyNameIterator
			END

			close companyCursor
			deallocate companyCursor

			if len(@companyPiece) > 0
				begin
					set @companyPiece = left(@companyPiece, len(@companyPiece)-1)
					-- set @companyPiece = ' when  not matched by source and target.company IN (' + @companyPiece + ')' es el anterior
					--set @companyPiece = ' where target.company IN (' + @companyPiece + ')' -- CAMBIO PROBANDO
					set @companyPiece = ' target.company IN (' + @companyPiece + ')' -- CAMBIO PROBANDO
				end

		end try

		begin catch
			set @cursor_success = 0;
		end catch
	end
	else
		begin
			set @cursor_success = 1;

			begin try
				set @sqlStatement_Cursor = 'DECLARE companyCursor cursor for SELECT DISTINCT Company FROM ' + @sourceTable
				set @companyPiece = ''

				exec sp_executesql @sqlStatement_Cursor

				OPEN companyCursor
				FETCH NEXT FROM companyCursor
					INTO @companyNameIterator

				WHILE @@FETCH_STATUS = 0
				BEGIN
					set @companyPiece = @companyPiece + '''' + @companyNameIterator + '''' + ','

					fetch next FROM companyCursor
						INTO @companyNameIterator
				END

				close companyCursor
				deallocate companyCursor

				if len(@companyPiece) > 0
					begin
						set @companyPiece = left(@companyPiece, len(@companyPiece)-1)
						-- set @companyPiece = ' when  not matched by source and target.company IN (' + @companyPiece + ')' es el anterior
						--set @companyPiece = ' where target.company IN (' + @companyPiece + ')' -- CAMBIO PROBANDO
						set @companyPiece = ' target.company IN (' + @companyPiece + ')' -- CAMBIO PROBANDO
					end

			end try

			begin catch
				set @cursor_success = 0;
			end catch
		end

	-- ******* Generate dynamic company in () ******* --
		
	-- ******* Create the merge statement ******* --

	-- If we failed in generating the dynamic, we will not disable enable things (@cursor_success = 0). We delete "WHEN NOT MATCHED BY SOURCE part"
	-- We should log that the cursor did not work, or stop the process (Better logging)
	print('@cursor_success: ' + cast(@cursor_success as varchar(10)))
	print(char(10))
	--SET @cursor_success = 0
	if @cursor_success = 0
		begin
			Set @sSql = 'MERGE '+@targetTable+' as Target 
				Using (Select * from '+@tmpTableName+' ) source
					on target.'+@targetNKColumn+' = source.'+@sourceNKColumn+'
				When matched And (' + CHAR(10) + 'Not ('+@checkChangeColumns+') or (target.is_deleted = 1 or target.is_deleted is null or target.is_inferred = 1 or target.is_inferred is null)'+CHAR(10)+')
				then  update  
						SET '+@updateColumns+'
								'+@updateAuditColumn+ +
							', is_deleted = 0, is_inferred = 0'
							+' 
				When Not matched by target then 
					insert ('+@targetNKColumn+','+@columns+''+REPLACE(@insertAuditColumn, 'source.', '')+ ', is_deleted, is_inferred'+')
					Values ('+@sourceNKColumn+','+@columns+' '+@sourceAuditColumn+ ', 0, 0' +');'
		end
	else if @cursor_success = 1 and @deltaLoadStatement != 'WHERE 1 = 1'
		begin
			--Set @sSql = 'WITH target_filtered as (SELECT * FROM ' + @targetTable + ' as target' + @companyPiece + ') 
			--				MERGE target_filtered as Target 
			--Using (Select * from '+@tmpTableName+' ) source
			--	on target.'+@targetNKColumn+' = source.'+@sourceNKColumn+'
			--When matched And Not ('+@checkChangeColumns+') 
			--then  update  
			--		SET '+@updateColumns+'
			--				'+@updateAuditColumn+'
			--When Not matched by target 
			--then 
			--	insert ('+@targetNKColumn+','+@columns+''+REPLACE(@insertAuditColumn, 'source.', '')+')
			--	Values ('+@sourceNKColumn+','+@columns+' '+@sourceAuditColumn+');'

			Set @sSql = 'MERGE '+@targetTable+' as Target
			Using (Select * from '+@tmpTableName+' ) source
				on target.'+@targetNKColumn+' = source.'+@sourceNKColumn+'
			When matched And (' + CHAR(10) + 'Not ('+@checkChangeColumns+') or (target.is_deleted = 1 or target.is_deleted is null or target.is_inferred = 1 or target.is_inferred is null)'+CHAR(10)+')
			then  update  
					SET '+@updateColumns+'
							'+@updateAuditColumn +
							', is_deleted = 0, is_inferred = 0'
							+'
			When Not matched by target 
			then 
				insert ('+@targetNKColumn+','+@columns+''+REPLACE(@insertAuditColumn, 'source.', '')+ ', is_deleted, is_inferred' +            ')
				Values ('+@sourceNKColumn+','+@columns+' '+@sourceAuditColumn+ ', 0, 0' + ')'
				+ ' WHEN NOT MATCHED BY SOURCE AND ' + @companyPiece 
				+ ' AND target.' + @dwFilterColumnName + ' != CAST(''1900-01-01'' as DATE)' 
				+ ' AND target.' + @dwFilterColumnName + ' >= (' + @minDateQuery + ')'
				+ ' AND is_inferred = 0 THEN UPDATE SET is_deleted = 1'
				+';'
		end
	else if @cursor_success = 1 and @deltaLoadStatement = 'WHERE 1 = 1'
		begin
			--Set @sSql = 'WITH target_filtered as (SELECT * FROM ' + @targetTable + ' as target' + @companyPiece + ') 
			--				MERGE target_filtered as Target 
			--Using (Select * from '+@tmpTableName+' ) source
			--	on target.'+@targetNKColumn+' = source.'+@sourceNKColumn+'
			--When matched And Not ('+@checkChangeColumns+') 
			--then  update  
			--		SET '+@updateColumns+'
			--				'+@updateAuditColumn+'
			--When Not matched by target 
			--then 
			--	insert ('+@targetNKColumn+','+@columns+''+REPLACE(@insertAuditColumn, 'source.', '')+')
			--	Values ('+@sourceNKColumn+','+@columns+' '+@sourceAuditColumn+');'

			Set @sSql = 'MERGE '+@targetTable+' as Target
			Using (Select * from '+@tmpTableName+' ) source
				on target.'+@targetNKColumn+' = source.'+@sourceNKColumn+'
			When matched And (' + CHAR(10) + 'Not ('+@checkChangeColumns+') or (target.is_deleted = 1 or target.is_deleted is null or target.is_inferred = 1 or target.is_inferred is null)'+CHAR(10)+')
			then  update  
					SET '+@updateColumns+'
							'+@updateAuditColumn +
							', is_deleted = 0, is_inferred = 0'
							+'
			When Not matched by target 
			then 
				insert ('+@targetNKColumn+','+@columns+''+REPLACE(@insertAuditColumn, 'source.', '')+ ', is_deleted, is_inferred' +            ')
				Values ('+@sourceNKColumn+','+@columns+' '+@sourceAuditColumn+ ', 0, 0' + ')'
				+ ' WHEN NOT MATCHED BY SOURCE AND ' + @companyPiece 
				+ ' AND is_inferred = 0 THEN UPDATE SET is_deleted = 1'
				+';'
		end

	-- ******* Create the merge statement ******* --


	-- ******* Create sql detective query ******* --
	/*
	We can copy the result and change all the = into != to see which are actually the changes
	between the stage view and the target
	*/

	set @sSql_detective = 'SELECT target.' + @targetNKColumn + 
							' FROM ' + @targetTable + ' AS target
								INNER JOIN ' + @sourceTable + ' AS source ON target.' + @targetNKColumn + ' = source.' + @sourceNKColumn + 
								' WHERE ' + @checkChangeColumns;
	-- ******* Create sql detective query ******* --



	-- ******* Execute statements ******* --

	begin try 
		if @debugOnly = 0
			begin
				exec (@sSql)
				set @rowsAffected = @@rowcount
			end 
		else 
			begin
				print ('@sqlStatement_Cursor: ' + @sqlStatement_Cursor)
				print(char(10))
				print ('@companyPiece: ' + @companyPiece)
				print(char(10))
				print ('Left @sSql: ' + @sSql)
				print(char(10))
				print('Right @sSql: ' + right(@sSql,3999))
				print(char(10))
				print('Left @sSql_detective: ' + @sSql_detective)
				print(char(10))
				print('Right @sSql_detective: ' + RIGHT(@sSql_detective,3999))
				print(char(10))
			end
	End Try
	Begin Catch
		set @StatusNAme = 'FAIL'
		set @ErrorMessage = @ToTable+':'+ERROR_MESSAGE()
	End Catch

	-- ******* Execute statements ******* --
	
	
	
	-- ******* Cleaning and logging ******* --
	set @endTime = getdate() AT TIME ZONE 'UTC' AT TIME ZONE 'Central Europe Standard Time' -- Added double conversion to make sure we get the swedish timestamp /SM 2021-10-07
	if @debugOnly = 0
	begin
		--Drop temp table
		if object_id(@tmpTableName) is not null
		exec ('drop table ' + @tmpTableName)

		exec audit.writeLog @PartitionKey=@PartitionKey, @ProcName = @ProcName, @FromTable =@FromTable, @ToTable=@ToTable
						, @startTime=@startTime, @endTime=@endTime
						, @rowsAffected=@rowsAffected, @StatusName=@StatusName, @ErrorMessage=@ErrorMessage
		if @StatusName <> 'OK'
			RAISERROR(@ErrorMessage, 16, 1)
	end
	-- ******* Cleaning and logging ******* --
	
END
GO
