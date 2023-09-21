IF OBJECT_ID('[stage].[vTMT_FI_StockTransactionOB]') IS NOT NULL
	DROP VIEW [stage].[vTMT_FI_StockTransactionOB];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTMT_FI_StockTransactionOB] AS 

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode), '#', TRIM(BinNum), '#', TRIM(PartNum), '#', TRIM([Version]), '#',TRIM(IndexKey) )))) AS StockTransactionID
	,UPPER(CONCAT(Company, '#', TRIM(IndexKey))) AS StockTransactionCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
 	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SalesOrderNum))))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SalesInvoiceNum))))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
	,CONVERT(nvarchar(50), getdate()) AS [PartitionKey]

    ,IndexKey
    ,UPPER(Company) AS Company -- 
    ,UPPER(TRIM(PartNum)) AS PartNum
	,UPPER(IIF(TRIM(TransactionCode)='Delivery', TRIM(CustomerNum), TRIM(SupplierNum))) AS IssuerReceiverNum
	,TRIM([WarehouseCode]) AS WarehouseCode
	,TRIM(TransactionCode) AS TransactionCode
	,TRIM(TransactionDescription) AS TransactionDescription
	,IIF(TRIM(TransactionCode)='Delivery', TRIM(SalesOrderNum), TRIM(PurchaseOrderNum)) AS OrderNum 
	,IIF(TRIM(TransactionCode)='Delivery', TRIM(SalesOrderLine), TRIM(PurchaseOrderLine)) AS OrderLine
    ,IIF(TRIM(TransactionCode)='Delivery', TRIM(SalesInvoiceNum),TRIM(PurchaseInvoiceNum)) AS InvoiceNum
	,IIF(TRIM(TransactionCode)='Delivery', TRIM(SalesInvoiceLine), TRIM(PurchaseInvoiceLine)) AS InvoiceLine
    ,TRIM(BinNum) AS BinNum
    ,TRIM(BatchNum) AS BatchNum
	,convert(date, TransactionDate) AS TransactionDate 
	,TransactionTime
	,TransactionQty
	,IIF(TransactionQty < 0, -1*ABS(TransactionValue), TransactionValue) AS TransactionValue
	,[CostPrice] 
	,SalesUnitPrice 
	,Currency
	,[Reference]
	,AdjustmentDate
	,TransactionType AS InternalExternal
	,STRes1
	,STRes2
	,[version] AS STRes3
FROM 
	[stage].[TMT_FI_StockTransactionOB]
GROUP BY
	IndexKey, Company, PartNum, TransactionCode, [WarehouseCode], TransactionDescription, BinNum, BatchNum, TransactionDate, TransactionTime, TransactionQty, [CostPrice], SalesUnitPrice, Currency, AdjustmentDate, TransactionType, STRes1, STRes2, [version], SalesOrderNum, SalesOrderLine, SalesInvoiceNum, SalesInvoiceLine, PurchaseOrderNum, PurchaseOrderLine, PurchaseInvoiceNum, PurchaseInvoiceLine, CustomerNum, SupplierNum, TransactionValue, [Reference]
GO
