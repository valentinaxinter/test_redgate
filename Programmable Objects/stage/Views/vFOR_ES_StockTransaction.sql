IF OBJECT_ID('[stage].[vFOR_ES_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vFOR_ES_StockTransaction] AS 
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(PartNum),'#',TRIM(WarehouseCode),'#',IndexKey)))) AS StockTransactionID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID,
	[PartitionKey]		,
	[Company]			,
	CostPrice,
	Currency,
	IndexKey,
	PartNum,
	Reference,
	TransactionCode,
	TransactionDate,
	TransactionDescription,
	TransactionQty,
	TransactionValue,
	WarehouseCode,
	CASE WHEN trim(cast(TransactionCode as varchar)) IN ('60','67','69','162','202','10000071','OB') OR TransactionCode is null   THEN 'I' 
	     WHEN trim(cast(TransactionCode as varchar)) IN ('13','14','15','16','18','19','20','21','59') THEN 'E'
		 ELSE 'Missing clasification' END as InternalExternal,
	TransactionType as STRes1
FROM 
	 [stage].[FOR_ES_StockTransaction]
GO
