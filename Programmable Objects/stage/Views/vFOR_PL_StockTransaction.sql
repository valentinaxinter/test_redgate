IF OBJECT_ID('[stage].[vFOR_PL_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vFOR_PL_StockTransaction];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vFOR_PL_StockTransaction]
	AS SELECT 
	
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(PartNum),'#',TRIM(WarehouseCode),'#',IndexKey)))) AS StockTransactionID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID

	 ,PartitionKey
	--------- Mandatory fields ---------

	,Company
	,IndexKey
	,WarehouseCode
	,trim(TransactionCode) as TransactionCode
	,trim(TransactionCodeDescription) as TransactionDescription
	--,IsInternalTransaction
	,nullif(trim(PartNum),'') as PartNum
	,cast(TransactionDate as date) as TransactionDate
	,cast(TransactionQty as decimal(18,4)) as TransactionQty
	--,CreatedTimeStamp
	--,ModifiedTimeStamp

	--------- Other fields ---------
	,cast(CostPrice as decimal(18,4)) as CostPrice
	--,IsActiveRecord
	,trim(CustomerNum) as CustomerNum
	,trim(SupplierNum) as SupplierNum
	--,SalesOrderNum
	--,PurchaseOrderNum
	--,SalesInvoiceNum
	--,PurchaseInvoiceNum
	--,BinNum
	,trim(Currency) as Currency
	,iif(cast(ExchangeRate as decimal(18,4)) = 0,1,cast(ExchangeRate as decimal(18,4))) as ExchangeRate
	,trim(Reference) as Reference
	--,SalesOrderLine
	--,PurchaseOrderLine
	--,SalesInvoiceLine
	--,PurchaseInvoiceLine
	--,BatchNum
	,nullif(trim(TransactionTime),'') as TransactionTime
	--,STRes1
	--,STRes2
	--,STRes3
	,IsInternalTransaction


	FROM [stage].[FOR_PL_StockTransaction]
GO
