IF OBJECT_ID('[meta].[GetTableColumnList_test]') IS NOT NULL
	DROP PROCEDURE [meta].[GetTableColumnList_test];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [meta].[GetTableColumnList_test] (@tableName varchar(50), 
											@sourceTable varchar(100),
											@ignoreColumns varchar(max), 
											@columnList varchar(max) output, 
											@updateList varchar(max) output,
											@checkForChangeList varchar(max) output)
AS
BEGIN
	SET NOCOUNT ON;
	set @columnList=''
	set @updateList=''
	set @checkForChangeList=''
	set @ignoreColumns = ',' + @ignoreColumns + ','
	declare @schemaName varchar(50) = substring(@tableName, 1, nullif(charindex('.', @tableName), 0)-1) 
	declare @tableOnlyName varchar(50) = replace(@tableName, isnull(@schemaName, '')+'.', '')
	declare @columnName varchar(100)
	declare @columnDataType varchar(200)
	declare @collationType varchar(150)
	declare columnCursor cursor for
	
	---------------------------------------------------------------
	with stage_view_columns as (
	select c.name
	FROM sys.columns c WITH(NOLOCK)  
	JOIN sys.types tp WITH(NOLOCK) ON c.user_type_id = tp.user_type_id  
	LEFT JOIN sys.check_constraints cc WITH(NOLOCK)   
			ON c.[object_id] = cc.parent_object_id   
		AND cc.parent_column_id = c.column_id  
	--WHERE c.[object_id] = (SELECT [object_id] = OBJECT_ID(@sourceTable, 'V') )
	WHERE c.[object_id] = (SELECT [object_id] = OBJECT_ID(@sourceTable) )
	)
	SELECT [target_table_columns].[name], [target_table_columns].[datatype], [target_table_columns].[collation] FROM stage_view_columns
	INNER JOIN (
 		 		select c.name,
				CASE WHEN c.is_computed = 1  
			THEN 'AS ' + OBJECT_DEFINITION(c.[object_id], c.column_id)  
			ELSE   
				CASE WHEN c.system_type_id != c.user_type_id   
					THEN  + SCHEMA_NAME(tp.[schema_id]) + '].[' + tp.name + ']'   
					ELSE  + UPPER(tp.name)   
				END  +   
				CASE   
					WHEN tp.name IN ('varchar', 'char', 'varbinary', 'binary')  
						THEN '(' + CASE WHEN c.max_length = -1   
										THEN 'MAX'   
										ELSE CAST(c.max_length AS VARCHAR(5))   
									END + ')'  
					WHEN tp.name IN ('nvarchar', 'nchar')  
						THEN '(' + CASE WHEN c.max_length = -1   
										THEN 'MAX'   
										ELSE CAST(c.max_length / 2 AS VARCHAR(5))   
									END + ')'  
					WHEN tp.name IN ('datetime2', 'time2', 'datetimeoffset')   
						THEN '(' + CAST(c.scale AS VARCHAR(5)) + ')'  
					WHEN tp.name = 'decimal'  
						THEN '(' + CAST(c.[precision] AS VARCHAR(5)) + ',' + CAST(c.scale AS VARCHAR(5)) + ')'  
					ELSE ''  
				END  
		END  as datatype,
		CASE WHEN c.collation_name IS NOT NULL AND c.system_type_id = c.user_type_id 
			THEN ' COLLATE ' + c.collation_name  
			ELSE ''  
		END as collation
	FROM sys.columns c WITH(NOLOCK)  
	JOIN sys.types tp WITH(NOLOCK) ON c.user_type_id = tp.user_type_id  
	LEFT JOIN sys.check_constraints cc WITH(NOLOCK)   
			ON c.[object_id] = cc.parent_object_id   
		AND cc.parent_column_id = c.column_id  
	--WHERE c.[object_id] = (SELECT [object_id] = OBJECT_ID(@tableName, 'U') )
	WHERE c.[object_id] = (SELECT [object_id] = OBJECT_ID(@tableName) )
	) AS target_table_columns ON stage_view_columns.name = target_table_columns.name
	---------------------------------------------------------------
	open columnCursor
	fetch next from	columnCursor
		into @columnName, @columnDataType, @collationType

	WHILE @@FETCH_STATUS = 0
	BEGIN
		if CHARINDEX(','+@columnName+',', @ignoreColumns)=0 
		Begin
			set @columnList=@columnList+@columnName +','
			set @updateList = @updateList + @columnName + ' = source.'+@columnName + ','+Char(10)
			set @checkForChangeList = @checkForChangeList + 'isnull(cast(convert(' + @columnDataType + ',' +'target.'+@columnName + ')' + @collationType + ' as varchar(max))' + ', '''' ) '+
														  '= isnull(cast(convert(' + @columnDataType + ',' +'source.'+@columnName + ')' + @collationType + ' as varchar(max))' + ', '''' )  And'+Char(10)
		End
		fetch next from	columnCursor
		into @columnName, @columnDataType, @collationType
	END

	close columnCursor
	deallocate columnCursor
	set @columnList = left(@columnList, len(@columnList)-1)
	set @updateList = left(@updateList, len(@updateList)-2)	
	set @checkForChangeList = left(@checkForChangeList, len(@checkForChangeList)-4)
	
	--print('-------------------------')
	--print('columnList')
	--print(@columnList)
	--print('-------------------------')
	--print('updateList')
	--print(@updateList)
	--print('-------------------------')
	--print('checkForChangeList')
	--print(@checkForChangeList)
	--print('-------------------------')
	--print('ignoreColumns')
	--print(@ignoreColumns)
END
GO
