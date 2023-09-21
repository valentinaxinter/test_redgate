IF OBJECT_ID('[meta].[LoadTableAndHistory]') IS NOT NULL
	DROP PROCEDURE [meta].[LoadTableAndHistory];

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
CREATE PROCEDURE [meta].[LoadTableAndHistory] (@PartitionKey varchar(50),@targetTable varchar(50), @sourceTable varchar(50), 
								@targetNKColumn varchar(50), @sourceNKColumn varchar(50)='',
								@sourceAuditColumn varchar(50)='PartitionKey', @updateAuditColumn varchar(50)='PartitionKey',
								@insertAuditColumn varchar(50)='PartitionKey',@ignoreColumns varchar(500)='', @debugOnly int = 0)
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
	--**** Logging variables *******

	declare @sSql varchar(max)
	declare @sSql_detective varchar(max)
	declare @columns varchar(max), @updateColumns varchar(max), @checkChangeColumns varchar(max)
	Declare @tmpTableName varchar(500) = 'stage.[__tmp_LoadTableAndHistory_'+@sourceTable+'_'+@PartitionKey+']' --Changed to @sourceTable instead of @targetTable here to to avoid the error of tmp table already exists with same name when multiple parallel loads are active. /Sm 2021-10-06

	if @sourceNKColumn = '' 
		set @sourceNKColumn = @targetNKColumn

	set @ignoreColumns = @ignoreColumns + 'ValidFrom,ValidTo,'+
							@insertAuditColumn+','+
							@updateAuditColumn+','+
							@targetNKColumn+','+
							@sourceNKColumn
	
	-- stage som strings for audit columns
	if @updateAuditColumn <> ''
		set @updateAuditColumn = ','+@updateAuditColumn+' = source.'+@sourceAuditColumn
	if @sourceAuditColumn <> ''
		set @sourceAuditColumn = ', source.'+@sourceAuditColumn
	if @insertAuditColumn <> ''
		set @insertAuditColumn =  ','+@insertAuditColumn

	-----------------------------------------------
	-- Improvement of tomas. We can include specific columns that we want to avoid checking in the merge statement
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

	--if @sourceTable in ('stage.vROR_SE_OLine','stage.vTMT_FI_OLine','stage.vWID_FI_OLine')
	--	begin
	--		set @ignoreColumns = @ignoreColumns + ',' + 'ProjectNum'
	--	end

	-----------------------------------------------
	-- Previous procedure
	--exec meta.GetTableColumnList 
	--	@targetTable, 
	--	@ignoreColumns,
	--	@ColumnList=@columns	 output, 
	--	@updateList=@updateColumns output ,
	--	@checkForChangeList=@checkChangeColumns output

	exec meta.GetTableColumnList_test 
		@targetTable, 
		@sourceTable,
		@ignoreColumns,
		@ColumnList=@columns output,
		@updateList=@updateColumns output ,
		@checkForChangeList=@checkChangeColumns output

	if @debugOnly = 1
	begin
		print('Update audit column  '+@updateAuditColumn)
		print('Source audit column  '+@sourceAuditColumn)
		print('Insert audit column  '+@insertAuditColumn)
		print @columns
		print(char(10))
		print @updateColumns
		print(char(10))
		print @checkChangeColumns
		print(char(10))
		print('Right side')
		print (right(@checkChangeColumns,3999))
		print(char(10))
		print('Ignore Columns')
		print @ignoreColumns

	end
	-- *** For performance reason, create a temp table to work with. Temp storage is too small to use.
	if object_id(@tmpTableName) is not null
		exec ('drop table ' + @tmpTableName)
	
	set @sSql = 'select * into '+@tmpTableName+' from '+@sourceTable --+ ' where PartitionKey='''+@PartitionKey+'''' --Commented due to PartitionKey is not serving the correct purpose in our case. /SM 2021-10-06 

	if @debugOnly = 0
	Begin
		exec (@sSql)
		if @@ROWCOUNT=0
		begin
			exec ('drop table ' + @tmpTableName)
			return
		end
	End
	else 
		print @sSql
	-- ***

	--------------------------------------------
	declare @version bit = 1;
	begin try
		Declare @sqlStatement_Cursor nvarchar(600) = 'DECLARE companyCursor cursor for SELECT DISTINCT Company FROM ' + @sourceTable
		Declare @companyNameIterator varchar(50)
		declare @companyPiece varchar(2000) = ''

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
	end try
	begin catch
		set @version = 0;
	end catch

	if len(@companyPiece) > 0
		begin
			set @companyPiece = left(@companyPiece, len(@companyPiece)-1)
			-- set @companyPiece = ' when  not matched by source and target.company IN (' + @companyPiece + ')' es el anterior
			set @companyPiece = ' where target.company IN (' + @companyPiece + ')' -- CAMBIO PROBANDO
		end

	--------------------------------------------
		
	-- Create the merge statement
	if @version = 0
		begin
			Set @sSql = 'MERGE '+@targetTable+' as Target 
				Using (Select * from '+@tmpTableName+' ) source
					on target.'+@targetNKColumn+' = source.'+@sourceNKColumn+'
				When matched 
					And Not ('+@checkChangeColumns+')
				then  update  
						SET '+@updateColumns+'
								'+@updateAuditColumn+'
				When Not matched by target then 
					insert ('+@targetNKColumn+','+@columns+''+REPLACE(@insertAuditColumn, 'source.', '')+')
					Values ('+@sourceNKColumn+','+@columns+' '+@sourceAuditColumn+');'
		end
	else
		begin
			Set @sSql = 'WITH target_filtered as (SELECT * FROM ' + @targetTable + ' as target' + @companyPiece + ') 
							MERGE target_filtered as Target 
			Using (Select * from '+@tmpTableName+' ) source
				on target.'+@targetNKColumn+' = source.'+@sourceNKColumn+'
			When matched 
				And Not ('+@checkChangeColumns+')
			then  update  
					SET '+@updateColumns+'
							'+@updateAuditColumn+'
			When Not matched by target then 
				insert ('+@targetNKColumn+','+@columns+''+REPLACE(@insertAuditColumn, 'source.', '')+')
				Values ('+@sourceNKColumn+','+@columns+' '+@sourceAuditColumn+');'
		end

	set @sSql_detective = 'SELECT target.' + @targetNKColumn + 
							' FROM ' + @targetTable + ' AS target
								INNER JOIN ' + @sourceTable + ' AS source ON target.' + @targetNKColumn + ' = source.' + @sourceNKColumn + 
								' WHERE ' + @checkChangeColumns

	begin try 
		if @debugOnly = 0
			begin
				exec (@sSql)
				set @rowsAffected = @@rowcount
			end 
		else 
			begin
				print(char(10))
				print ('@sqlStatement_Cursor: ' + @sqlStatement_Cursor)
				print(char(10))
				print ('@companyPiece: ' + @companyPiece)
				print(char(10))
				print @sSql	
				print(char(10))
				print('Right side')
				print(right(@sSql,3999))
				print(char(10))
				print('Sql Detective')
				PRINT (@sSql_detective)
				print(char(10))
				print('Right side')
				PRINT (RIGHT(@sSql_detective,3999))
			end
	End Try
	Begin Catch
	-- *** Logging ***	
		set @StatusNAme = 'FAIL'
		set @ErrorMessage = @ToTable+':'+ERROR_MESSAGE()
	End Catch

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
	-- *** Logging ***	



--	declare @tableNameWithoutSchema varchar(50)
--	select @tableNameWithoutSchema=dbo.Split(@targetTable, '.', 2)
--	if @debugOnly = 0
--		exec hist.Rebuild @tableNameWithoutSchema, @targetNKColumn
END
GO
