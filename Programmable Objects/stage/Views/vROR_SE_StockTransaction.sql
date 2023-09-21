IF OBJECT_ID('[stage].[vROR_SE_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vROR_SE_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vROR_SE_StockTransaction] AS 

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(IndexKey))))) AS StockTransactionID --, '#', TRIM(Partnum), '#', TRIM(TransactionTime)
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
 	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF([TransactionCodeDescription] = 'Sales', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(SalesOrderNum))))), NULL) AS SalesOrderNumID
	,IIF([TransactionCodeDescription] = 'Purchase', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(PurchaseOrderNum))))), NULL) AS PurchaseOrderNumID
	,IIF([TransactionCodeDescription] = 'Sales', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(SalesInvoiceNum))))), NULL) AS SalesInvoiceID
	,IIF([TransactionCodeDescription] = 'Purchase', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(PurchaseInvoiceNum))))), NULL) AS PurchaseInvoiceID
	,IIF([TransactionCodeDescription] = 'Sales', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(CustomerNum))))), NULL) AS CustomerID
	,IIF([TransactionCodeDescription] = 'Purchase', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(SupplierNum))))), NULL) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
	,[PartitionKey]
    ,IndexKey

    ,UPPER(TRIM([Company])) AS Company -- 
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
    ,UPPER(TRIM([PartNum])) AS PartNum
	,IIF([TransactionCodeDescription] = 'Sales', TRIM(SalesOrderNum), TRIM([PurchaseOrderNum])) AS OrderNum
	,IIF([TransactionCodeDescription] = 'Sales', TRIM(SalesOrderLine), TRIM([PurchaseOrderLine])) AS OrderLine
	,IIF([TransactionCodeDescription] = 'Sales', TRIM([SalesInvoiceNum]), TRIM([PurchaseInvoiceNum])) AS InvoiceNum
	,IIF([TransactionCodeDescription] = 'Sales', TRIM([SalesInvoiceLine]), TRIM([PurchaseInvoiceLine])) AS InvoiceLine
	,IIF([TransactionCodeDescription] = 'Sales', TRIM(CustomerNum), TRIM(SupplierNum)) AS IssuerReceiverNum
	,TRIM(TransactionCode) AS TransactionCode
	,TRIM([TransactionCodeDescription]) AS TransactionDescription
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(SalesOrderNum) AS SalesOrderNum
	,TRIM(SupplierNum) AS SupplierNum
	,TRIM([PurchaseOrderNum]) AS PurchaseOrderNum
	,TRIM([SalesOrderLine]) AS SalesOrderLine
	,TRIM([PurchaseOrderLine]) AS PurchaseOrderLine
    ,TRIM([SalesInvoiceNum]) AS SalesInvoiceNum
	,TRIM([PurchaseInvoiceNum]) AS PurchaseInvoiceNum
	,TRIM(SalesInvoiceLine) AS SalesInvoiceLine
    ,TRIM(BinNum) AS BinNum
    ,IIF(TRIM(BatchNum)='', NULL,TRIM(BatchNum)) AS BatchNum
	,CAST(CONCAT(LEFT(TransactionDate, 4), '-', SUBSTRING(TransactionDate, 6,2), '-', RIGHT(TransactionDate, 2)) AS date) AS TransactionDate  --convert(date, TransactionDate) AS 
	,[TransactionTime] AS TransactionTime
	,'1900-01-01' AS AdjustmentDate
	,CONVERT(decimal(18,4),REPLACE(TransactionQty, ',', '.')) AS TransactionQty 
	,CONVERT(decimal(18,4),REPLACE(TransactionValue, ',', '.')) AS TransactionValue 
	,IIF(CONVERT(decimal(18,4),REPLACE(TransactionQty, ',', '.')) = 0 OR CONVERT(decimal(18,4),REPLACE(TransactionQty, ',', '.')) IS NULL, 0,cast(CONVERT(decimal(18,4),REPLACE(TransactionValue, ',', '.'))/CONVERT(decimal(18,4),REPLACE(TransactionQty, ',', '.')) as decimal(18,4))) AS [CostPrice] 
	,NULL AS SalesUnitPrice 
	,TRIM(Currency) AS Currency
	,CONVERT(decimal(18,4),REPLACE([ExchangeRate], ',', '.')) AS [ExchangeRate]
	,IIF(IsInternalTransaction = '1', 'Internal', 'External') AS InternalExternal
	,TRIM([Reference]) AS [Reference]
	,[IsActiveRecord]
	,TRIM(STRes1) AS STRes1
	,[CreatedTimeStamp] AS STRes2
	,[ModifiedTimeStamp] AS STRes3
FROM [stage].[ROR_SE_Stocktransaction]

--UNION ALL

--SELECT 
--	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(WarehouseCode), '#', TRIM([PartNum]), '#', TRIM(TransactionCode), '#', TRIM(TransactionDate))))) AS StockTransactionID --, '#', TRIM(Partnum), '#', TRIM(TransactionTime)
--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
--    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
-- 	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
--	,IIF(TransactionCode = '1', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', '')))), NULL) AS SalesOrderNumID
--	,IIF(TransactionCode = '6', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', '')))), NULL) AS PurchaseOrderNumID
--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', '')))) AS SalesInvoiceID
--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', '')))) AS PurchaseInvoiceID
--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', '')))) AS CustomerID
--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', '')))) AS SupplierID
--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
--	,[PartitionKey]
--    ,'' AS IndexKey

--    ,UPPER(TRIM([Company])) AS Company -- 
--	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
--    ,UPPER(TRIM([PartNum])) AS PartNum
--	,TRIM(TransactionCode) AS TransactionCode
--	,TRIM([TransactionCodeDescription]) AS TransactionDescription
--	,'' AS IssuerReceiverNum
--	,'' AS CustomerNum
--	,'' AS SalesOrderNum
--	,'' AS SupplierNum
--	,'' AS PurchaseOrderNum
--	,'' AS SalesOrderLine
--	,'' AS PurchaseOrderLine
--    ,'' AS SalesInvoiceNum
--	,'' AS PurchaseInvoiceNum
--	,'' AS SalesInvoiceLine
--    ,'' AS BinNum
--    ,'' AS BatchNum
--	,TransactionDate AS TransactionDate  --convert(date, TransactionDate) AS 
--	,'' AS TransactionTime
--	,'1900-01-01' AS AdjustmentDate
--	,CONVERT(decimal(18,4), REPLACE(TransactionQty, ',', '.')) AS TransactionQty 
--	,CONVERT(decimal(18,4), REPLACE(TransactionValue, ',', '.')) AS TransactionValue 
--	,IIF(CONVERT(decimal(18,4), REPLACE(TransactionQty, ',', '.')) = 0 OR CONVERT(decimal(18,4),REPLACE(TransactionQty, ',', '.')) IS NULL, 0,cast(CONVERT(decimal(18,4),REPLACE(TransactionValue, ',', '.'))/CONVERT(decimal(18,4),REPLACE(TransactionQty, ',', '.')) as decimal(18,4))) AS [CostPrice] 
--	,NULL AS SalesUnitPrice 
--	,TRIM(Currency) AS Currency
--	,CONVERT(decimal(18,4), REPLACE([ExchangeRate], ',', '.')) AS [ExchangeRate]
--	,IIF(CONVERT(decimal(18,4), REPLACE(TransactionQty, ',', '.')) = 0, 'Internal', 'External') AS InternalExternal
--	,TRIM([Reference]) AS [Reference]
--	,'1' AS [IsActiveRecord]
--	,'' AS STRes1
--	,'' AS STRes2
--	,'' AS STRes3
--FROM [stage].[ROR_SE_StockTransactionOB20180101]
GO
