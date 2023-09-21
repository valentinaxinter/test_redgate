IF OBJECT_ID('[stage].[vARK_PI_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vARK_PI_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [stage].[vARK_PI_StockTransaction] AS 
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM(IndexKey))))) AS StockTransactionID --
	,CONCAT([Company], '#', TRIM(IndexKey)) AS IndexKey --StockTransactionCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
 	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([OrderNum]))))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([OrderNum]))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([InvoiceNum]))))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([InvoiceNum]))))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(IssuerReceiverNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(IssuerReceiverNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM([Currency])))) AS CurrencyID
	,[PartitionKey]

    ,[Company] -- 
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
	,TransactionCode
	,[TransactionDescription]
	,IssuerReceiverNum
    ,OrderNum
	,OrderLine
	,InvoiceNum
	,InvoiceLine
	,TRIM([PartNum]) AS PartNum --UPPER(TRIM([PartNum]))
    ,TRIM(Outlier) AS BinNum --added by request of Jiri /DZ 2022-04-07
    ,TRIM(BatchNum) AS BatchNum
	,CONVERT(date, [TransactionDate]) AS TransactionDate
	,TransactionTime
	,[TransactionQty]
	,TransactionValue
	,[CostPrice]
	,[SalesUnitPrice]
	,UPPER(TRIM([Currency])) AS [Currency]
	,Reference
	,AdjustmentDate
	,IIF(Reference = 'I', 'Internal', 'External') AS InternalExternal
	,IndexKey AS STRes1
	,STRes2
	,LEFT(TRIM(IssuerReceiverName), 100) AS STRes3 --added by request of Jiri /DZ 2022-04-07
	
FROM [stage].[ARK_PI_StockTransaction]
	--WHERE [TransactionDate] >= DATEADD(year, -1, GETDATE()) --Added this where clause as semi-incremental load functinoality since it doesn't work easily on meta-param table. /SM 2021-10-01	
WHERE
	[TransactionDate] >= '2016-01-01'
GO
