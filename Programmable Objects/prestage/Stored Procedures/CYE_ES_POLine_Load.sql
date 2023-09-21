IF OBJECT_ID('[prestage].[CYE_ES_POLine_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[CYE_ES_POLine_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [prestage].[CYE_ES_POLine_Load] AS

BEGIN

Truncate table stage.[CYE_ES_POLine]

insert into stage.CYE_ES_POLine(
	[PartitionKey]
      ,[Company]
      ,[SupplierNum]
      ,[OrderDate]
      ,[InvoiceNum]
      ,[InvoiceLine]
      ,[PONum]
      ,[POLine]
      ,[PORelNum]
      ,[PartNum]
      ,[UnitPrice]
      ,[Qty]
      ,[Indexkey]
)
select 
	  [PartitionKey]
      ,[Company]
      ,[SupplierNum]
      ,[OrderDate]
      ,[InvoiceNum] 
      ,[InvoiceLine]
      ,[PONum]
      ,[POLine]
      ,[PORelNum]
      ,[PartNum]
      ,[UnitPrice]
      ,[Qty]
      ,[Indexkey]
from [prestage].[vCYE_ES_POLine]

--Truncate table prestage.[CYE_ES_POLine] --Two loads in LSSourceTables_CYESA_dev uses the same prestage. Truncating would create conflicts. /SM 2022-02-23

End
GO
