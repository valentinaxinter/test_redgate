IF OBJECT_ID('[dbo].[SetSourceDelta_Global]') IS NOT NULL
	DROP PROCEDURE [dbo].[SetSourceDelta_Global];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[SetSourceDelta_Global] @MetadataSourceTable varchar(50), @stageTableName varchar(50), @Partitionkey varchar(50)
AS

-- We use stageTableName because is a unique value within everything. If we use dwtablename as before, some companies, like Jenss has 
-- more than one value for that filter.

-- I dont see the purpose of the old procedure. Another disadvantage is that we are querying the dw schema tables that are the biggest ones.
-- I think the purpose of this procedure is to show the last updated timestamp that we have on each table and thats why i changed everything

BEGIN TRY

	DECLARE @transactionName varchar(400);
	SET @transactionName = 'UPDATE SourceTable: ' + @MetadataSourceTable;

	BEGIN TRAN @transactionName;

		DECLARE @SqlStatement nvarchar(max)
		SET @SqlStatement = 'UPDATE ' + @MetadataSourceTable + ' SET DeltaLoadValue = ' + '''' + @Partitionkey + '''' + ' WHERE Stagetablename = ' + '''' + @stageTableName + ''''

		EXEC(@SqlStatement)

	COMMIT TRAN @transactionName;

END TRY

BEGIN CATCH
	IF @@ROWCOUNT > 0
		ROLLBACK;

END CATCH
GO
