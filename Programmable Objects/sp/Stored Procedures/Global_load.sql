IF OBJECT_ID('[sp].[Global_load]') IS NOT NULL
	DROP PROCEDURE [sp].[Global_load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*

exec [sp].[Global_load] 
@PartitionKey = '2023-02-17 07:14:14', 
@targetTable = 'dw.CostBearer', 
@sourcetable = 'stage.vFOR_SE_CostBearer', 
@dwFilterColumnName = 'null',
@deltaLoadStatement = 'where 1 = 1',
@debug = 1
*/

-- stage -> filter field mmedjrev
-- dw -> SalesOrderDate

CREATE PROCEDURE [sp].[Global_load] (
		@PartitionKey varchar(50), 
		@targetTable varchar(50), 
		@sourcetable varchar(50),
		@dwFilterColumnName varchar(50),
		@deltaLoadStatement varchar(600),
		@debug bit = 0,
		@dateFilter varchar(50) = ''
		) AS

BEGIN

	declare @targetNKColumn varchar(50);

	declare @targetTableColumnIdQuery nvarchar(max) = 

	'select @targetNKColumn = columnName
			from (
    SELECT schema_name(t.schema_id) + ''.'' + t.[name] as table_view, 
        case when t.[type] = ''U'' then ''Table''
            when t.[type] = ''V'' then ''View''
            end as [object_type],
        case when c.[type] = ''PK'' then ''Primary key''
            when c.[type] = ''UQ'' then ''Unique constraint''
            when i.[type] = 1 then ''Unique clustered index''
            when i.type = 2 then ''Unique index''
            end as constraint_type, 
        isnull(c.[name], i.[name]) as constraint_name,
        substring(column_names, 1, len(column_names)-1) as columnName
    FROM sys.objects t
        left outer join sys.indexes i
            on t.object_id = i.object_id
        left outer join sys.key_constraints c
            on i.object_id = c.parent_object_id 
            AND i.index_id = c.unique_index_id
       cross apply (select col.[name] + '', ''
                        from sys.index_columns ic
                            inner join sys.columns col
                                on ic.object_id = col.object_id
                                and ic.column_id = col.column_id
                        where ic.object_id = t.object_id
                            AND ic.index_id = i.index_id
                                order by col.column_id
                                for xml path ('''') ) D (column_names)
    WHERE is_unique = 1
        AND t.is_ms_shipped <> 1
    UNION ALL
    SELECT schema_name(fk_tab.schema_id) + ''.'' + fk_tab.name as foreign_table,
        ''Table'',
        ''Foreign key'',
        fk.name as fk_constraint_name,
        schema_name(pk_tab.schema_id) + ''.'' + pk_tab.name
    FROM sys.foreign_keys fk
        inner join sys.tables fk_tab
            on fk_tab.object_id = fk.parent_object_id
        inner join sys.tables pk_tab
            on pk_tab.object_id = fk.referenced_object_id
        inner join sys.foreign_key_columns fk_cols
            on fk_cols.constraint_object_id = fk.object_id
    UNION ALL
    SELECT schema_name(t.schema_id) + ''.'' + t.[name],
        ''Table'',
        ''Check constraint'',
        con.[name] as constraint_name,
        con.[definition]
    FROM sys.check_constraints con
        left outer join sys.objects t
            on con.parent_object_id = t.object_id
        left outer join sys.all_columns col
            on con.parent_column_id = col.column_id
            AND con.parent_object_id = col.object_id
    UNION ALL
    SELECT schema_name(t.schema_id) + ''.'' + t.[name],
        ''Table'',
        ''Default constraint'',
        con.[name],
        col.[name] + '' = '' + con.[definition]
    FROM sys.default_constraints con
        left outer join sys.objects t
            on con.parent_object_id = t.object_id
        left outer join sys.all_columns col
            on con.parent_column_id = col.column_id
            and con.parent_object_id = col.object_id
			) a
		where constraint_type = ''Primary key''
		and table_view = ' + ''''  + @targetTable + ''''

	-- Ejecuto el procedure para asignar @targetNKColumn
	exec sp_executesql @targetTableColumnIdQuery, N'@targetTable varchar(50), @targetNKColumn varchar(50) OUTPUT', @targetTable = @targetTable, @targetNKColumn = @targetNKColumn output;
	
	-- Verifico que funcione correctamente
	--print( @targetNKColumn )

	-- Re asigno para mandarselo correctamente al otro procedure
	--set @sourceTable = 'stage.v' + @sourceTable;
	--set @targetTable = 'dw.' + @targetTable;

	if @debug = 1
		begin
			print('Target table: '+ @targetTable		  )
			print('Source Table: '+ @sourceTable		  )
			print('Target NK Column: '+ @targetNKColumn	  )
			print('PartitionKey: '+ @PartitionKey		  )
			print('dwFilterColumnName: '+ @dwFilterColumnName)
			print('deltaLoadStatement: '+ @deltaLoadStatement)
			print('dateFilter: '+ @dateFilter)

            print(char(10))

            exec [meta].[LoadTableAndHistory_dev_tomas] 
				@targetTable=@targetTable,
				@sourceTable=@sourceTable,
				@targetNKColumn=@targetNKColumn,
				@PartitionKey=@PartitionKey,
				@debugOnly = 1,
				@dwFilterColumnName = @dwFilterColumnName,
				@deltaLoadStatement = @deltaLoadStatement,
				@dateFilter = @dateFilter
		end
	else
		begin
			-- Llamo al procedure final con los parametros que corresponden
			exec [meta].[LoadTableAndHistory_dev_tomas] 
				@targetTable=@targetTable,
				@sourceTable=@sourceTable,
				@targetNKColumn=@targetNKColumn,
				@PartitionKey=@PartitionKey,
				@debugOnly = 0,
				@dwFilterColumnName = @dwFilterColumnName,
				@deltaLoadStatement = @deltaLoadStatement,
				@dateFilter = @dateFilter
				--, @MetadataSourceTable = @MetadataSourceTable
		end


END
GO
