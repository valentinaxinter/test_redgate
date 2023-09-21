IF OBJECT_ID('[sp].[MergeView]') IS NOT NULL
	DROP PROCEDURE [sp].[MergeView];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [sp].[MergeView]
	 @PartitionKey		nvarchar(50)
	,@TableName			nvarchar(50)
	,@SchemaName		nvarchar(50)
	,@SourcetableName	nvarchar(80)
	,@Debug				bit
	,@Company			nvarchar(50)

AS
	DECLARE @SQLStatement		nvarchar(max)
	DECLARE @dwFilterColumnName nvarchar(60)
	DECLARE @deltaLoadStatement nvarchar(100)
	DECLARE @Period				nvarchar(50)
	DECLARE @TargetTable		nvarchar(100)
	DECLARE @StageView			nvarchar(100)
	DECLARE @RowCount			int 



	SET @SQLStatement = N'SELECT @dwFilterColumnName = isnull(dwFilterColumnName,''null''), @deltaLoadStatement = DeltaLoadStatement, @StageView = Stagetablename
						FROM dbo.' + @SourcetableName +' WHERE dwtablename = @TableName and Company = @Company'

	EXEC sp_executesql @SQLStatement,
					   N'@TableName NVARCHAR(50),
						 @Company NVARCHAR(50),
						 @dwFilterColumnName NVARCHAR(60) OUTPUT,
						 @deltaLoadStatement NVARCHAR(100) OUTPUT,
						 @StageView NVARCHAR(100) OUTPUT',
						 @TableName,
						 @Company,
						 @dwFilterColumnName OUTPUT,
						 @deltaLoadStatement OUTPUT,
						 @StageView OUTPUT;

	SELECT @RowCount = @@ROWCOUNT;

	IF @RowCount = 1
	BEGIN

		SELECT @Period = isnull(Period,'')
		from audit.PipelinesActivitiesLog
		WHERE PartitionKey = @PartitionKey
		and TableName = @TableName
		and Company = @Company

		SET @TargetTable = concat(@SchemaName,'.',@TableName)
		SET @StageView = concat('stage.v',@StageView)
		IF @Period IS NOT NULL
		BEGIN
			IF len(@Period) > 0
				begin
					SET @Period = '''' + @Period + ''''
				end	

			EXEC [sp].[Global_load] 
			   @PartitionKey = @PartitionKey
			  ,@targetTable  = @TargetTable
			  ,@sourcetable  = @StageView
			  ,@dwFilterColumnName = @dwFilterColumnName
			  ,@deltaLoadStatement = @deltaLoadStatement
			  ,@debug = @Debug
			  ,@dateFilter = @Period
		END
		ELSE
		BEGIN
			PRINT('Period not found. Cant execute the procedure without it')
		END
	END
	ELSE
	BEGIN
		PRINT('There where 0 or > 1 rows found in the SourceTable with those conditions')
	END
GO
