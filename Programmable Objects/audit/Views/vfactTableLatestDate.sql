IF OBJECT_ID('[audit].[vfactTableLatestDate]') IS NOT NULL
	DROP VIEW [audit].[vfactTableLatestDate];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [audit].[vfactTableLatestDate] AS
----The [Status] field  might need revision. Maybe switch to PartitionKey instead or check the SourceTables potentially. /SM

SELECT Company
	,'SalesInvoice' AS TableName
	,MAX(SalesInvoiceDate) AS LatestDate
	,'SalesInvoiceDate'	AS [DateName]
	,IIF( CAST(DATEADD(day, -1 ,GETDATE()) AS date) > MAX(SalesInvoiceDate), 'Not up-to-date', 'Updated'  ) AS [Status] 
	,MAX(TRY_CAST(PartitionKey AS date)) AS LatestPartitionKey
FROM dw.SalesInvoice
WHERE  DATEADD(day, -1 ,GETDATE()) >= SalesInvoiceDate 
GROUP BY Company


--SalesOrder
UNION ALL
SELECT Company
	,'SalesOrder' AS TableName
	,MAX(SalesOrderDate) AS LatestDate
	,'SalesOrderDate'	AS [DateName]
	,IIF( CAST(DATEADD(day, -1 ,GETDATE()) AS date) > MAX(SalesOrderDate), 'Not up-to-date', 'Updated'  ) AS [Status]
	,MAX(TRY_CAST(PartitionKey AS date)) AS LatestPartitionKey
FROM dw.SalesOrder
WHERE  DATEADD(day, -1 ,GETDATE()) >= SalesOrderDate
GROUP BY Company


--SalesLedger
UNION ALL
SELECT Company
	,'SalesLedger' AS TableName
	,MAX(SalesInvoiceDate) AS LatestDate
	,'SalesInvoiceDate'	AS [DateName]
	,IIF( CAST(DATEADD(day, -1 ,GETDATE()) AS date) > MAX(SalesInvoiceDate), 'Not up-to-date', 'Updated'  ) AS [Status]
	,MAX(TRY_CAST(PartitionKey AS date)) AS LatestPartitionKey
FROM dw.SalesLedger
WHERE  DATEADD(day, -1 ,GETDATE()) >= SalesInvoiceDate 
GROUP BY Company


--PurchaseInvoice
UNION ALL
SELECT Company
	,'PurchaseInvoice' AS TableName
	,MAX(PurchaseInvoiceDate) AS LatestDate
	,'PurchaseInvoiceDate'	AS [DateName]
	,IIF( CAST(DATEADD(day, -1 ,GETDATE()) AS date) > MAX(PurchaseInvoiceDate), 'Not up-to-date', 'Updated'  ) AS [Status] 
	,MAX(TRY_CAST(PartitionKey AS date)) AS LatestPartitionKey
FROM dw.PurchaseInvoice
WHERE  DATEADD(day, -1 ,GETDATE()) >= PurchaseInvoiceDate
GROUP BY Company


--PurchaseOrder
UNION ALL
SELECT Company
	,'PurchaseOrder' AS TableName
	,MAX(PurchaseOrderDate) AS LatestDate
	,'PurchaseOrderDate'	AS [DateName]
	,IIF( CAST(DATEADD(day, -1 ,GETDATE()) AS date) > MAX(PurchaseOrderDate), 'Not up-to-date', 'Updated'  ) AS [Status]
	,MAX(TRY_CAST(PartitionKey AS date)) AS LatestPartitionKey
FROM dw.PurchaseOrder
WHERE  DATEADD(day, -1 ,GETDATE()) >= PurchaseOrderDate 
GROUP BY Company


--PurchaseLedger
UNION ALL
SELECT Company
	,'PurchaseLedger' AS TableName
	,MAX(PurchaseInvoiceDate) AS LatestDate
	,'PurchaseInvoiceDate'	AS [DateName]
	,IIF( CAST(DATEADD(day, -1 ,GETDATE()) AS date) > MAX(PurchaseInvoiceDate), 'Not up-to-date', 'Updated'  ) AS [Status]
	,MAX(TRY_CAST(PartitionKey AS date)) AS LatestPartitionKey
FROM dw.PurchaseLedger
WHERE  DATEADD(day, -1 ,GETDATE()) >= PurchaseInvoiceDate 
GROUP BY Company

--StockTransaction
UNION ALL
SELECT Company
	,'StockTransaction' AS TableName
	,MAX(TransactionDate) AS LatestDate
	,'TransactionDate'	AS [DateName]
	,IIF( CAST(DATEADD(day, -1 ,GETDATE()) AS date) > MAX(TransactionDate), 'Not up-to-date', 'Updated'  ) AS [Status]
	,MAX(TRY_CAST(PartitionKey AS date)) AS LatestPartitionKey
FROM dw.StockTransaction
WHERE  DATEADD(day, -1 ,GETDATE()) >= TransactionDate 
GROUP BY Company
GO
