IF OBJECT_ID('[stage].[vNOM_NO_StockTransactionOB]') IS NOT NULL
	DROP VIEW [stage].[vNOM_NO_StockTransactionOB];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  View [stage].[vNOM_NO_StockTransactionOB]    Script Date: 2022-04-14 08:39:37 ******/
CREATE VIEW [stage].[vNOM_NO_StockTransactionOB] AS 

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', (IndexKey)))) AS StockTransactionID
	,[Company]
	,TRIM([WarehouseCode]) AS WarehouseCode
	,TransactionCode
	,TransactionDescription
	,IIF(TRIM(IssuerReceiverNum)='', NULL,TRIM(IssuerReceiverNum)) AS IssuerReceiverNum
	,IIF(TRIM([OrderNum])='', NULL,TRIM(OrderNum)) AS OrderNum
	,OrderLine
	,IIF(TRIM([InvoiceNum])='', NULL,TRIM(InvoiceNum)) AS InvoiceNum
	,InvoiceLine
	,UPPER(TRIM([PartNum])) AS [PartNum]
	,IIF(TRIM([BinNum])='', NULL,TRIM(BinNum)) AS BinNum
	,IIF(TRIM([BatchNum])='', NULL,TRIM(BatchNum)) AS BatchNum
	,CONVERT(date, TransactionDate) AS TransactionDate
	,TransactionTime
	,IIF(TransactionQty IS NULL, 0, TRY_CONVERT(decimal(18,2), REPLACE(REPLACE(TransactionQty, ' ', ''), ',', '.'))) AS TransactionQty --TRY_CONVERT(decimal(18,0), REPLACE(TransactionQty, '.', ','))
	,IIF(TransactionValue IS NULL, 0, TRY_CONVERT(decimal(18,2), REPLACE(TransactionValue, ',', '.'))) AS TransactionValue --TRY_CONVERT(decimal(18,2), REPLACE(TransactionValue, '.', ','))
	,IIF(CostPrice IS NULL, 0, TRY_CONVERT(decimal(18,2), REPLACE(REPLACE(CostPrice, ' ', ''), ',', '.'))) AS [CostPrice] --TRY_CONVERT(decimal(18,2),  REPLACE([CostPrice], '.', ','))
	,IIF(SalesUnitPrice IS NULL, 0, TRY_CONVERT(decimal(18,2), REPLACE(REPLACE(SalesUnitPrice, ' ', ''), ',', '.'))) AS SalesUnitPrice --TRY_CONVERT(decimal(18,2),  REPLACE(SalesUnitPrice, '.', ','))
	,IIF(TRIM([Currency])='', NULL, TRIM(Currency)) AS Currency
	,[Reference]
	,CONVERT(date, AdjustmentDate) AS AdjustmentDate
	,'External' AS InternalExternal
	,'' AS STRes1
	,'' AS STRes2
	,'' AS STRes3

	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER([Company]))) AS CompanyID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF(TransactionCode in ('930', '931', '936'), CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([InvoiceNum])))), NULL) AS PurchaseInvoiceID
	,IIF(TransactionCode in ('930', '931', '936'), CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([OrderNum])))), NULL) AS PurchaseOrderNumID
	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([OrderNum])))), NULL) AS SalesOrderNumID
	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([InvoiceNum])))), NULL) AS SalesInvoiceID
	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM(IssuerReceiverNum)))), NULL) AS CustomerID
	,IIF(TransactionCode in ('930', '931', '936'), CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM(IssuerReceiverNum)))), NULL) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Currency]))) AS CurrencyID
	,'2022-04-14 08:30' AS PartitionKey
	,IndexKey

FROM [stage].[NOM_NO_StockTransactionOB]
GO
