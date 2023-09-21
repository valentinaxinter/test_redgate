IF OBJECT_ID('[stage].[vTRA_SE_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vTRA_SE_StockTransaction];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vTRA_SE_StockTransaction]
	AS select 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(PartNum),'#',TRIM(WarehouseCode),'#',IndexKey)))) AS StockTransactionID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(CustomerNum))))) AS CustomerID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([WarehouseCode]))))) AS WarehouseID

	,PartitionKey
	,UPPER(Company) as Company
	,trim(IndexKey) as IndexKey
	,trim(WarehouseCode) as WarehouseCode
	,trim(TransactionCode) as TransactionCode
	,trim(TransactionCodeDescription) as TransactionCodeDescription
	,cast(IsInternalTransaction as bit) as IsInternalTransaction
	,trim(CustomerNum) as CustomerNum
	,trim(SupplierNum) as SupplierNum
	,trim(SalesOrderNum) as SalesOrderNum
	,trim(SalesOrderLine) as SalesOrderLine
	,trim(PurchaseOrderNum) as PurchaseOrderNum
	,trim(PurchaseOrderLine) as PurchaseOrderLine
	,trim(SalesInvoiceNum) as SalesInvoiceNum
	,trim(SalesInvoiceLine) as SalesInvoiceLine
	,trim(PurchaseInvoiceLine) as PurchaseInvoiceLine
	,trim(PurchaseInvoiceNum) as PurchaseInvoiceNum
	,trim(PartNum) as PartNum
	, trim(BinNum) as BinNum
	,cast(TransactionDate as date) as TransactionDate
	,cast(TransactionQty as decimal(18,4)) as TransactionQty
	,cast(TransactionValue as decimal(18,4)) as TransactionValue
	,Currency
	,CAST(ExchangeRate as decimal(18,4)) as ExchangeRate
	,cast(RecordIsActive as bit) as IsActiveRecord
from stage.TRA_SE_StockTransaction
;
GO
