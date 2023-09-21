IF OBJECT_ID('[stage].[vSVE_SE_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vSVE_SE_StockTransaction];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vSVE_SE_StockTransaction] AS 

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(IndexKey), '#', TRIM([WarehouseCode]), '#', TRIM([PartNum]), '#', TRIM(TransactionCode), '#', TRIM(CustomerNum), '#', TRIM(SalesOrderNum), '#', TRIM(SalesOrderLine)
	, '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine), '#', TRIM(PurchaseInvoiceNum), '#', TransactionDate, '#', TransactionTime, '#', TransactionQty, '#', TransactionValue)))) AS StockTransactionID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
 	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF(TransactionCode = '1', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(SalesOrderNum))))), NULL) AS SalesOrderNumID
	,IIF(TransactionCode = '6', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(PurchaseOrderNum))))), NULL) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(SalesInvoiceNum))))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(SupplierNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
	,[PartitionKey]

    ,IndexKey
    ,UPPER(TRIM([Company])) AS Company -- 
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
    ,UPPER(TRIM([PartNum])) AS PartNum
	,TRIM(TransactionCode) AS TransactionCode
	,TRIM(TransactionCodeDescription) AS TransactionDescription
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(SupplierNum) AS SupplierNum
	,TRIM(SalesOrderNum) AS SalesOrderNum
	,TRIM(SalesOrderLine) AS SalesOrderLine
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
    ,TRIM(SalesInvoiceNum) AS SalesInvoiceNum
	,TRIM(SalesInvoiceLine) AS SalesInvoiceLine
	,TRIM(PurchaseInvoiceNum) AS PurchaseInvoiceNum
	,TRIM(PurchaseInvoiceLine) AS PurchaseInvoiceLine
    ,TRIM(BinNum) AS BinNum
    ,TRIM(BatchNum) AS BatchNum
	,CONVERT(date, TransactionDate) AS TransactionDate 
	,LEFT(TransactionTime, 8) AS TransactionTime
	,CASE WHEN TRIM(TransactionCode) = '3' THEN (TransactionQty) --20230810 deleted ABS
		WHEN TRIM(TransactionCode) = '4' THEN 1*(TransactionQty) --20230811 deleted ABS
		ELSE TransactionQty END AS TransactionQty
	,CASE WHEN TRIM(TransactionCode) = '3' THEN (TransactionValue) --20230810 deleted ABS
		WHEN TRIM(TransactionCode) = '4' THEN 1*(TransactionValue) --20230811 deleted ABS
		ELSE (TransactionValue) END AS TransactionValue
	,IIF((TransactionQty) = 0 OR (TransactionQty) IS NULL, 0, (TransactionValue)/(TransactionQty)) AS [CostPrice] 
	--,NULL AS SalesUnitPrice 
	,TRIM(Currency) AS Currency
	,ExchangeRate
	,CASE WHEN TRIM(TransactionCode) in ('3', '4') THEN '0'
		WHEN TRIM(TransactionCode) = 'OB' AND transactionqty = 0 THEN '0'
		ELSE '1' END AS IsInternalTransaction
	,CASE WHEN TRIM(TransactionCode) in ('3', '4') THEN 'External'
		WHEN TRIM(TransactionCode) = 'OB' AND transactionqty != 0 THEN 'External'
		ELSE 'Internal' END AS InternalExternal
	,TRIM([Reference]) AS [Reference]
	,CONCAT(TransactionDate, TransactionTime) AS STRes1
	,TRIM(PartType) AS STRes2
	,'' AS STRes3
FROM 
	[stage].[SVE_SE_StockTransaction]
WHERE CONVERT(date, TransactionDate) >= '2023-06-21' AND (PartType != 'LA' or [Sign] != '2')--and LEFT(UPPER(TRIM([PartNum])), 3) != 'XXX'-- The openingbalace is on '2018-12-31'
--WHERE (TRIM(TransactionCodeDescription) = 'RMA' and SalesOrderNum != '') OR (TRIM(TransactionCodeDescription) = 'Internal Adjustment') OR (TransactionCodeDescription = 'Incoming' and PurchaseInvoiceNum != '')
GROUP BY [PartitionKey], IndexKey, Company, WarehouseCode, PartNum, TransactionCode, TransactionCodeDescription, CustomerNum, SupplierNum, SalesOrderNum, SalesOrderLine, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine
	, SalesInvoiceNum, SalesInvoiceLine, PurchaseInvoiceNum, PurchaseInvoiceLine, BinNum, BatchNum, TransactionDate, TransactionTime, Currency, ExchangeRate, IsInternalTransaction, Reference, [Sign], TransactionQty, TransactionValue, PartType

UNION ALL
-- the "Opening Balance" from a snapshot of dw.StockBalance on 20230620 ending day
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]), '#', TRIM([PartNum]), '#', TRIM(SupplierNum))))) AS StockTransactionID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
 	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', '')))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', '')))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', '')))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', '')))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', '')))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(SupplierNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', 'SEK')) AS CurrencyID
	,'2023-06-22' AS [PartitionKey]

    ,'' AS IndexKey
    ,UPPER(TRIM([Company])) AS Company -- 
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
    ,UPPER(TRIM([PartNum])) AS PartNum
	,'OB' AS TransactionCode
	,'Opening Balance' AS TransactionDescription
	,'' AS CustomerNum
	,TRIM(SupplierNum) AS SupplierNum
	,'' AS SalesOrderNum
	,'' AS SalesOrderLine
	,'' AS PurchaseOrderNum
	,'' AS PurchaseOrderLine
	,'' AS PurchaseOrderSubLine
    ,'' AS SalesInvoiceNum
	,'' AS SalesInvoiceLine
	,'' AS PurchaseInvoiceNum
	,'' AS PurchaseInvoiceLine
    ,'' AS BinNum
    ,'' AS BatchNum
	,CONVERT(date, '2023-06-21') AS TransactionDate 
	,'00:00' AS TransactionTime
	,SUM(StockBalance) AS TransactionQty -- from different bin
	,SUM(StockValue) AS TransactionValue -- from different bin
	,IIF((SUM(StockBalance)) = 0 OR (SUM(StockBalance)) IS NULL, 0, SUM(StockValue)/SUM(StockBalance)) AS [CostPrice] 
	,'SEK' AS Currency
	,1 AS ExchangeRate
	,'0' AS IsInternalTransaction
	,'External' AS InternalExternal
	,'Using 20230621 ending dw.StockBalance data' AS [Reference]
	,'' AS STRes1
	,'' AS STRes2
	,'' AS STRes3

FROM [stage].[SVE_SE_StockTransactionOB20230621]

GROUP BY [Company], [WarehouseCode], [PartNum], SupplierNum
GO
