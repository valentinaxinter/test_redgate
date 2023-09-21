IF OBJECT_ID('[prestage].[CYE_ES_PartTranLine_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[CYE_ES_PartTranLine_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [prestage].[CYE_ES_PartTranLine_Load] AS

BEGIN

Truncate table stage.[CYE_ES_PartTranLine]

insert into stage.CYE_ES_PartTranLine(
	[PartitionKey]
      ,[Company]
      ,[SysDate]
      ,[TranDate]
      ,[WarehouseCode]
      ,[BinNumber]
      ,[LotNum]
      ,[TranType]
      ,[PartNum]
      ,[AvgCost]
      ,[TranQty]
      ,[SysRowID]
)
select 
	  [PartitionKey]
      ,[Company]
      ,[SysDate]
      ,[TranDate]
      ,[WarehouseCode] 
      ,[BinNumber]
      ,[LotNum]
      ,[TranType]
      ,[PartNum]
      ,[AvgCost]
      ,[TranQty]
      ,[SysRowID]
from [prestage].[vCYE_ES_PartTranLine]

--Truncate table prestage.[CYE_ES_PartTranLine] --Two loads in LSSourceTables_CYESA_dev uses the same prestage. Truncating would create conflicts. /SM 2022-02-23

End
GO
