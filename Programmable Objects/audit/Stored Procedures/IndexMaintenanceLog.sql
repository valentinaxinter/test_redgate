IF OBJECT_ID('[audit].[IndexMaintenanceLog]') IS NOT NULL
	DROP PROCEDURE [audit].[IndexMaintenanceLog];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [audit].[IndexMaintenanceLog]
	@debug bit = 0
AS
	-- Declarar las variables necesarias para el cursor
	DECLARE 
	 @SqlStatement	varchar(2000)
	,@StartTime		datetime
	,@EndTime		datetime
	,@Schema		varchar(15)
	,@TableName		varchar(50)
	,@IndexName		varchar(100)
	-- ... (Declarar variables para cada columna que necesitas)

	-- Declarar el cursor
	DECLARE iterator CURSOR FOR

	SELECT TOP 15

	--DDIPS.avg_fragmentation_in_percent,
	--DDIPS.page_count,
	CASE WHEN cast(DDIPS.avg_fragmentation_in_percent as float) <= 30.00 THEN  CONCAT('ALTER INDEX ',I.name,' ON ',S.name,'.',T.name,' REORGANIZE;')
	ELSE CONCAT('ALTER INDEX ',I.name,' ON ',S.name,'.',T.name,' REBUILD;') END AS Statement,
	S.name as 'Schema',
	T.name as 'Table',
	I.name as 'Index'
	FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS DDIPS
	INNER JOIN sys.tables T on T.object_id = DDIPS.object_id
	INNER JOIN sys.schemas S on T.schema_id = S.schema_id
	INNER JOIN sys.indexes I ON I.object_id = DDIPS.object_id
	AND DDIPS.index_id = I.index_id
	WHERE DDIPS.database_id = DB_ID()
	and I.name is not null
	AND DDIPS.avg_fragmentation_in_percent > 5
	and S.name =  'dw'
	ORDER BY DDIPS.avg_fragmentation_in_percent desc

	-- Abrir el cursor
	OPEN iterator

	-- Recuperar el primer registro
	FETCH NEXT FROM iterator INTO @SqlStatement, @Schema, @TableName, @IndexName

	-- Iniciar el bucle para iterar sobre los registros
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Aquí puedes hacer lo que necesites con los valores de cada registro
		-- Por ejemplo, imprimirlos, realizar cálculos, etc.
		begin try
			set @StartTime = GETDATE()
			if @debug = 1
			begin
				print(@SqlStatement)
			end
			else
			begin
				exec(@SqlStatement);
			end
			set @EndTime = GETDATE()

			if @debug = 0
			begin
				INSERT INTO audit.IndexMaintenance (Date, TableSchema, TableName, IndexName, SecDuration, Succeeded)
				VALUES (CAST(@StartTime AS DATE), @Schema, @TableName, @IndexName, DATEDIFF(SECOND, @StartTime, @EndTime), 1)
			end
		end try
		begin catch
			set @EndTime = GETDATE()

			if @debug = 0
			begin
				INSERT INTO audit.IndexMaintenance (Date, TableSchema, TableName, IndexName, SecDuration, Succeeded)
				VALUES (CAST(@StartTime AS DATE), @Schema, @TableName, @IndexName, DATEDIFF(SECOND, @StartTime, @EndTime), 0)
			end
		end catch
		-- ...

		-- Recuperar el siguiente registro
		FETCH NEXT FROM iterator INTO @SqlStatement, @Schema, @TableName, @IndexName
	END

	-- Cerrar el cursor
	CLOSE iterator

	-- Liberar los recursos del cursor
	DEALLOCATE iterator
GO
