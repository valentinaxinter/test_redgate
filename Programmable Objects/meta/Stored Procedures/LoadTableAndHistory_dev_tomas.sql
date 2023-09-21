IF OBJECT_ID('[meta].[LoadTableAndHistory_dev_tomas]') IS NOT NULL
	DROP PROCEDURE [meta].[LoadTableAndHistory_dev_tomas];

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

exec [meta].[LoadTableAndHistory_dev_tomas] 
@PartitionKey = '2023-03-14 00:00:00', 
@targetTable = 'dw.SalesOrder', 
@sourceTable = 'stage.vTRA_FR_OLine', 
@targetNKColumn = 'SalesOrderID',
@debugOnly = ,
@dwFilterColumnName = null,
@deltaLoadStatement = 'WHERE 1 = 1',
@dateFilter = ''

*/
-- 

-- If stageView is empty then crashes.

CREATE PROCEDURE [meta].[LoadTableAndHistory_dev_tomas] (
	@PartitionKey varchar(50),
	@targetTable varchar(50), 
	@sourceTable varchar(50), 
	@targetNKColumn varchar(50),
	@sourceNKColumn varchar(50)='',
	@sourceAuditColumn varchar(50)='PartitionKey', 
	@updateAuditColumn varchar(50)='PartitionKey',
	@insertAuditColumn varchar(50)='PartitionKey',
	@ignoreColumns varchar(500)= '', 
	@debugOnly int = 0,
	@dwFilterColumnName varchar(50),
	@deltaLoadStatement varchar(600),
	@dateFilter varchar(50)
	)
AS
BEGIN

	IF @targetTable is not null and LOWER(substring(@targetTable, CHARINDEX('.', @targetTable) + 1, len(@targetTable) - CHARINDEX('.', @targetTable))) != 'stage'
	BEGIN
		--**** Declare variables *******
		Declare  @ProcName varchar(100) = OBJECT_NAME(@@PROCID)
				, @FromTable varchar(100) = @sourceTable
				, @ToTable varchar(100)  = @targetTable
				, @startTime datetime = getdate() AT TIME ZONE 'UTC' AT TIME ZONE 'Central Europe Standard Time' -- Added double conversion to make sure we get the swedish timestamp /SM 2021-10-07
				, @endTime datetime
				, @rowsAffected int
				, @StatusName varchar(10)='OK'
				, @ErrorMessage varchar(max)	
				, @sSql varchar(max)
				, @sSql2 varchar(max)
				, @sSql_detective varchar(max)
				, @columns varchar(max), @updateColumns varchar(max), @checkChangeColumns varchar(max)
				, @tmpTableName varchar(500) = 'stage.[__tmp_LoadTableAndHistory_'+@sourceTable+'_'+@PartitionKey+']' --Changed to @sourceTable instead of @targetTable here to to avoid the error of tmp table already exists with same name when multiple parallel loads are active. /Sm 2021-10-06
				, @minDateQuery varchar(max)
				, @factList varchar(2000) = ', dw.SalesOrder, dw.SalesOrderLog, dw.SalesInvoice, dw.PurchaseOrder, dw.PurchaseInvoice, dw.SalesLedger, dw.StockTransaction, dw.ProductionOrder'
				, @dimList varchar(200) = ', dw.Part, dw.Customer, dw.Supplier, dw.Warehouse, dw.CustomerAgreement, dw.SupplierAgreement, dw.Department, dw.Account, dw.CostUnit, dw.CostBearer, dw.StockBalance'
				, @MergeExecuted varchar(50)
				, @st datetime
				, @et datetime

		declare @date date;

		set @date = CASE 
					WHEN DATEPART(HOUR, @startTime) >= 21
						THEN cast(dateadd(dd,1,@startTime ) as date)
					ELSE cast(@startTime as date) 
					end
		--**** Declare variables *******	

		-- The way we are working now, we should never receive a LEN(@dateFilter) = 0.
		if LEN(@dateFilter) = 0
			begin
				set @minDateQuery = (select concat('Select ',right(@deltaLoadStatement, charindex('=', reverse(@deltaLoadStatement)) - 1)))
			end
		else 
			begin
				set @minDateQuery = 'SELECT CAST( ' + @dateFilter + ' AS DATE )'
			end

		print('@minDateQuery: ' + @minDateQuery)
		print(char(10))

		if @sourceNKColumn = '' 
			set @sourceNKColumn = @targetNKColumn

		set @ignoreColumns = @ignoreColumns + 'ValidFrom,ValidTo,'+
								@insertAuditColumn+','+
								@updateAuditColumn+','+
								@targetNKColumn+','+
								@sourceNKColumn
	
		-- Stage some strings for audit columns
		if @updateAuditColumn <> ''
			set @updateAuditColumn = ','+@updateAuditColumn+' = source.'+@sourceAuditColumn
		if @sourceAuditColumn <> ''
			set @sourceAuditColumn = ', source.'+@sourceAuditColumn
		if @insertAuditColumn <> ''
			set @insertAuditColumn =  ','+@insertAuditColumn

		-- ******* Exclude specific fields ******* --
		-- We can include specific columns that we want to avoid checking in the merge statement for each company. TO
		-- Was done specially because there are some cases on which there is a change due to their internal ERP
		-- that changes records everytime we pull again. But there is no reason that for instance all part changes
		-- in a gap of 3 minutes between one pipeline run and another one.
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
		-- We call the procedure to get the list of columns that are going to be used in the final merge statement.
		-- The test one is being used but actually is the one that works
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
			
			print('Creating tmp table ' + @tmpTableName)
			set @st = GETDATE()
			exec (@sSql)
			set @et = GETDATE()

			if @@ROWCOUNT=0
			begin
				exec ('drop table ' + @tmpTableName)
				print('Table dropped')
				return
			end

			BEGIN TRY
				INSERT INTO audit.TmpTableLog (sourceTable, timeInSeconds)
				VALUES (@sourceTable, DATEDIFF(SECOND, @st, @et));
			END TRY
			BEGIN CATCH
				-- Log or handle the error as needed.
				-- For example, you can use PRINT to display an error message or write to an error log table.

				PRINT 'An error occurred during the INSERT statement: ' + ERROR_MESSAGE();
			END CATCH


		End
		else 
			print @sSql
		-- ******* Generate @tmpTableName from @sourceTable (stage view) ******* --


		-- ******* Generate dynamic company in () ******* --
		-- In order to filter the target table in a proper way, I need to see all the distinct values on Company field
		-- that the source table has and store it in a variable for future use.

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

		print('@cursor_success: ' + cast(@cursor_success as varchar(10)))
		print(char(10))

		-- ******* Check if dim and create the merge statement ******* --
		/*
		If it's a dimension we will use is_inferred field.
		Due to that reason, we will have two roads.
		Step_1) For dimensions included in @dimList
		Step_2) For all the other tables thar are not included in @dimList

		-- If we failed in generating the dynamic, we will not disable enable things (@cursor_success = 0). We delete "WHEN NOT MATCHED BY SOURCE part"
		-- We should log that the cursor did not work, or stop the process (Better logging)

		*/

		if CHARINDEX(@targetTable,@dimList) > 0
		begin
		-- Step_1)
			if @cursor_success = 0
				-- Option 1
				begin
					print('Step_1 @cursor_success = 0')
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

					set @MergeExecuted = 'Step_1 - Option 1'
				end
			-- We can't filter dimensions since it's not a transactional table. We should never filter them unless we have the last time a record was modified,
			-- but we will take that in future.

			--else if @cursor_success = 1 and @deltaLoadStatement != 'WHERE 1 = 1'
			--	begin
			--
			--		Set @sSql = 'MERGE '+@targetTable+' as Target
			--		Using (Select * from '+@tmpTableName+' ) source
			--			on target.'+@targetNKColumn+' = source.'+@sourceNKColumn+'
			--		When matched And (' + CHAR(10) + 'Not ('+@checkChangeColumns+') or (target.is_deleted = 1 or target.is_deleted is null or target.is_inferred = 1 or target.is_inferred is null)'+CHAR(10)+')
			--		then  update  
			--				SET '+@updateColumns+'
			--						'+@updateAuditColumn +
			--						', is_deleted = 0, is_inferred = 0'
			--						+'
			--		When Not matched by target 
			--		then 
			--			insert ('+@targetNKColumn+','+@columns+''+REPLACE(@insertAuditColumn, 'source.', '')+ ', is_deleted, is_inferred' +            ')
			--			Values ('+@sourceNKColumn+','+@columns+' '+@sourceAuditColumn+ ', 0, 0' + ')'
			--			+ ' WHEN NOT MATCHED BY SOURCE AND ' + @companyPiece 
			--			+ ' AND target.' + @dwFilterColumnName + ' != CAST(''1900-01-01'' as DATE)' 
			--			+ ' AND target.' + @dwFilterColumnName + ' >= (' + @minDateQuery + ')'
			--			+ ' AND (is_inferred = 0 or is_inferred is null) THEN UPDATE SET is_deleted = 1'
			--			+';'
			--	end
			else if @cursor_success = 1 and @deltaLoadStatement = 'WHERE 1 = 1'
				-- Option 2
				begin
					print('Step_1 @cursor_success = 1 and @deltaLoadStatement = WHERE 1 = 1')
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
						+ CHAR(10) + ' WHEN NOT MATCHED BY SOURCE AND ' + @companyPiece 
						+ ' AND (is_inferred = 0 or is_inferred is null) THEN UPDATE SET is_deleted = 1'
						+';'

					set @MergeExecuted = 'Step_1 - Option 2'
				end
		end

		else

		begin
		--Step_2)	
		-- We will now treat the fact tables that we want in a special way.
		-- The special way means that there it is not clear on which field to filter from.
		-- Then the decision is just to insert or update the existing values
		-- There will be no action for the rest, meaning deleted records will not be catched
		-- When they are in the factList we manage deleted records, else Step_3)

			if CHARINDEX(@targetTable,@factList) > 0

			begin

				if @cursor_success = 0
					-- Option 1
					begin
						PRINT('Step_2 @cursor_success = 0')
						Set @sSql = 'MERGE '+@targetTable+' as Target 
							Using (Select * from '+@tmpTableName+' ) source
								on target.'+@targetNKColumn+' = source.'+@sourceNKColumn+'
							When matched And Not ('+@checkChangeColumns+') or (target.is_deleted = 1 or target.is_deleted is null)
							then  update  
									SET '+@updateColumns+'
											'+@updateAuditColumn+ +
										', is_deleted = 0'
										+' 
							When Not matched by target then 
								insert ('+@targetNKColumn+','+@columns+''+REPLACE(@insertAuditColumn, 'source.', '')+ ', is_deleted'+')
								Values ('+@sourceNKColumn+','+@columns+' '+@sourceAuditColumn+ ', 0' +');'

						set @MergeExecuted = 'Step_2 - Option 1'
					end
				else if @cursor_success = 1 and @deltaLoadStatement != 'WHERE 1 = 1'
					-- Option 2
					begin
						PRINT('Step_2 @cursor_success = 1 and @deltaLoadStatement != WHERE 1 = 1')
						Set @sSql = 'MERGE '+@targetTable+' as Target
						Using (Select * from '+@tmpTableName+' ) source
							on target.'+@targetNKColumn+' = source.'+@sourceNKColumn+'
						When matched And Not ('+@checkChangeColumns+') or (target.is_deleted = 1 or target.is_deleted is null)
						then  update  
								SET '+@updateColumns+'
										'+@updateAuditColumn +
										', is_deleted = 0'
										+'
						When Not matched by target 
						then 
							insert ('+@targetNKColumn+','+@columns+''+REPLACE(@insertAuditColumn, 'source.', '')+ ', is_deleted' +            ')
							Values ('+@sourceNKColumn+','+@columns+' '+@sourceAuditColumn+ ', 0' + ')'
							+ CHAR(10) + ' WHEN NOT MATCHED BY SOURCE AND ' + @companyPiece 
							+ ' AND target.' + @dwFilterColumnName + ' != CAST(''1900-01-01'' as DATE)' 
							+ ' AND target.' + @dwFilterColumnName + ' >= (' + @minDateQuery + ')'
							+ ' THEN UPDATE SET is_deleted = 1'
							+';'
						set @MergeExecuted = 'Step_2 - Option 2'
					end
				else if @cursor_success = 1 and @deltaLoadStatement = 'WHERE 1 = 1'
					-- Option 3
					begin

						-- In the cases we don't know what is the exact date from where we get data from (We dont have @dateFilter)
						-- we will take the earliest date of the stage view and use that one as the start point
						/* This was done mainly for TRACLEV, IOWTRADE and CYESA*/
						-- Then we need to set a new logic for @minDateQuery
						PRINT('Step_2 @cursor_success = 1 and @deltaLoadStatement = WHERE 1 = 1')
						set @minDateQuery = 'SELECT MIN(CAST( ' + @dwFilterColumnName + ' AS DATE )) FROM ' + @tmpTableName

						Set @sSql = 'MERGE '+@targetTable+' as Target
						Using (Select * from '+@tmpTableName+' ) source
							on target.'+@targetNKColumn+' = source.'+@sourceNKColumn+'
						When matched And Not ('+@checkChangeColumns+') or (target.is_deleted = 1 or target.is_deleted is null)
						then  update  
								SET '+@updateColumns+'
										'+@updateAuditColumn +
										', is_deleted = 0'
										+'
						When Not matched by target 
						then 
							insert ('+@targetNKColumn+','+@columns+''+REPLACE(@insertAuditColumn, 'source.', '')+ ', is_deleted' +            ')
							Values ('+@sourceNKColumn+','+@columns+' '+@sourceAuditColumn+ ', 0' + ')'
							+ CHAR(10) + ' WHEN NOT MATCHED BY SOURCE AND ' + @companyPiece 
							 + ' AND target.' + @dwFilterColumnName + ' >= (' + @minDateQuery + ')'
							 + ' AND target.' + @dwFilterColumnName + ' != CAST(''1900-01-01'' as DATE)' 
							 + ' THEN UPDATE SET is_deleted = 1'

							+';'
						set @MergeExecuted = 'Step_2 - Option 3'
					

					end
			end
			else
			-- Step_3)
			begin
				-- Option 1
				PRINT('Step_3')
				Set @sSql = 'MERGE '+@targetTable+' as Target
					Using (Select * from '+@tmpTableName+' ) source
						on target.'+@targetNKColumn+' = source.'+@sourceNKColumn+'
					When matched And Not ('+@checkChangeColumns+') or (target.is_deleted = 1 or target.is_deleted is null)
					then  update  
							SET '+@updateColumns+'
									'+@updateAuditColumn +
									', is_deleted = 0'
									+'
					When Not matched by target 
					then 
						insert ('+@targetNKColumn+','+@columns+''+REPLACE(@insertAuditColumn, 'source.', '')+ ', is_deleted' +            ')
						Values ('+@sourceNKColumn+','+@columns+' '+@sourceAuditColumn+ ', 0' + ');'

				set @MergeExecuted = 'Step_2 - Option 1'
			end
		end


		-- ******* Check if dim and create the merge statement ******* --


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
					print('--------------------------------------------------------------------------------------------------------------------------------')
					print('--------------------------------------------------------------------------------------------------------------------------------')
					print ('Left @sSql: ' + @sSql)
					print(char(10))
					print('Right @sSql: ' + right(@sSql,3999))
					print('--------------------------------------------------------------------------------------------------------------------------------')
					print('--------------------------------------------------------------------------------------------------------------------------------')
					print(char(10))
					print('--------------------------------------------------------------------------------------------------------------------------------')
					print('--------------------------------------------------------------------------------------------------------------------------------')
					print('Left @sSql_detective: ' + @sSql_detective)
					print(char(10))
					print('Right @sSql_detective: ' + RIGHT(@sSql_detective,3999))
					print('--------------------------------------------------------------------------------------------------------------------------------')
					print('--------------------------------------------------------------------------------------------------------------------------------')
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
			begin
				exec ('drop table ' + @tmpTableName)
				print('Drop table at the end')

			end

			exec audit.writeLog @PartitionKey=@PartitionKey
			, @ProcName = @ProcName
			, @FromTable =@FromTable
			, @ToTable=@ToTable
			, @startTime=@startTime
			, @endTime=@endTime
			, @rowsAffected=@rowsAffected
			, @StatusName=@StatusName
			, @ErrorMessage=@ErrorMessage
			, @MergeExecuted = @MergeExecuted
			, @Date = @date

			if @StatusName <> 'OK'
			begin
				RAISERROR(@ErrorMessage, 16, 1)
			end
		end
		-- ******* Cleaning and logging ******* --
	END
END
GO
