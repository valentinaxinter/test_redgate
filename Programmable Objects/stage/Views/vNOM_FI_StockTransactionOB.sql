IF OBJECT_ID('[stage].[vNOM_FI_StockTransactionOB]') IS NOT NULL
	DROP VIEW [stage].[vNOM_FI_StockTransactionOB];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vNOM_FI_StockTransactionOB] AS 

--SELECT 
--	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM(IndexKey), '#', TRIM(IssuerReceiverNum), '#', TRIM([OrderNum])))) AS StockTransactionID
--	,UPPER([Company]) AS [Company]
--	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
--	,TransactionCode
--	,TransactionDescription
--	,IIF(TRIM(IssuerReceiverNum)='', NULL,TRIM(IssuerReceiverNum)) AS IssuerReceiverNum
--	,IIF(TRIM([OrderNum])='', NULL,TRIM(OrderNum)) AS OrderNum
--	,OrderLine
--	,IIF(TRIM([InvoiceNum])='', NULL,TRIM(InvoiceNum)) AS InvoiceNum
--	,InvoiceLine
--	,UPPER(TRIM([PartNum])) AS [PartNum]
--	,IIF(TRIM([BinNum])='', NULL,TRIM(BinNum)) AS BinNum
--	,IIF(TRIM([BatchNum])='', NULL,TRIM(BatchNum)) AS BatchNum
--	,CONVERT(date, TransactionDate) AS TransactionDate
--	,TransactionTime
--	,CONVERT(decimal(18,4), IIF(TRIM(TransactionQty) LIKE '%-%', 0, REPLACE(REPLACE(TRIM(TransactionQty), ',', '.'), ' ', ''))) AS TransactionQty
--	,CONVERT(decimal(18,4), IIF(TRIM(TransactionValue) LIKE '%-%', 0, REPLACE(REPLACE(TRIM(TransactionValue), ',', '.'), ' ', ''))) AS TransactionValue
--	,CONVERT(decimal(18,4), IIF(TRIM([CostPrice]) LIKE '%-%', 0, REPLACE(REPLACE(TRIM([CostPrice]), ',', '.'), ' ', '' ))) AS [CostPrice]
--	,CONVERT(decimal(18,4), IIF(TRIM(SalesUnitPrice) LIKE '%-%', 0, REPLACE(REPLACE(TRIM(SalesUnitPrice), ',', '.'), ' ', ''))) AS SalesUnitPrice
--	,IIF(TRIM([Currency])='', NULL,TRIM(Currency)) AS Currency
--	,'FI_ST_OB' AS [Reference]
--	,CONVERT(date, AdjustmentDate) AS AdjustmentDate
--	,InternalExternal

--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
--	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([InvoiceNum])))), NULL) AS PurchaseInvoiceID
--	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([OrderNum]))))), NULL) AS PurchaseOrderNumID
--	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([OrderNum]))))), NULL) AS SalesOrderNumID
--	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([InvoiceNum]))))), NULL) AS SalesInvoiceID
--	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM(IssuerReceiverNum))))), NULL) AS CustomerID
--	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company],'#',TRIM(IssuerReceiverNum)))), NULL) AS SupplierID
--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
--	,'2023-02-03 16:00' AS PartitionKey
--	,IndexKey
--	--,0 AS is_deleted
--	--,'' AS STRes1
--	--,'' AS STRes2
--	--,'' AS STRes3
--FROM [stage].[Nom_FI_StockTransactionOB20220927]

--UNION ALL

--SELECT 
--	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM(IndexKey), '#', TRIM(IssuerReceiverNum), '#', TRIM([OrderNum])))) AS StockTransactionID
--	,UPPER([Company]) AS [Company]
--	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
--	,TransactionCode
--	,TransactionDescription
--	,IIF(TRIM(IssuerReceiverNum)='', NULL,TRIM(IssuerReceiverNum)) AS IssuerReceiverNum
--	,IIF(TRIM([OrderNum])='', NULL,TRIM(OrderNum)) AS OrderNum
--	,OrderLine
--	,IIF(TRIM([InvoiceNum])='', NULL,TRIM(InvoiceNum)) AS InvoiceNum
--	,InvoiceLine
--	,UPPER(TRIM([PartNum])) AS [PartNum]
--	,IIF(TRIM([BinNum])='', NULL,TRIM(BinNum)) AS BinNum
--	,IIF(TRIM([BatchNum])='', NULL,TRIM(BatchNum)) AS BatchNum
--	,CONVERT(date, TransactionDate) AS TransactionDate
--	,TransactionTime
--	,CONVERT(decimal(18,4), IIF(TRIM(TransactionQty) LIKE '%-%', 0, REPLACE(REPLACE(TRIM(TransactionQty), ',', '.'), ' ', ''))) AS TransactionQty
--	,CONVERT(decimal(18,4), IIF(TRIM(TransactionValue) LIKE '%-%', 0, REPLACE(REPLACE(TRIM(TransactionValue), ',', '.'), ' ', ''))) AS TransactionValue
--	,CONVERT(decimal(18,4), IIF(TRIM([CostPrice]) LIKE '%-%', 0, REPLACE(REPLACE(TRIM([CostPrice]), ',', '.'), ' ', '' ))) AS [CostPrice]
--	,CONVERT(decimal(18,4), IIF(TRIM(SalesUnitPrice) LIKE '%-%', 0, REPLACE(REPLACE(TRIM(SalesUnitPrice), ',', '.'), ' ', ''))) AS SalesUnitPrice
--	,IIF(TRIM([Currency])='', NULL,TRIM(Currency)) AS Currency
--	,'FI_ST_Hist' AS [Reference]
--	,CONVERT(date, AdjustmentDate) AS AdjustmentDate
--	,'External' AS InternalExternal

--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
--	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([InvoiceNum])))), NULL) AS PurchaseInvoiceID
--	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([OrderNum]))))), NULL) AS PurchaseOrderNumID
--	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([OrderNum]))))), NULL) AS SalesOrderNumID
--	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([InvoiceNum]))))), NULL) AS SalesInvoiceID
--	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM(IssuerReceiverNum))))), NULL) AS CustomerID
--	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company],'#',TRIM(IssuerReceiverNum)))), NULL) AS SupplierID
--	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
--	,'2023-02-03 16:00' AS PartitionKey
--	,IndexKey
--	--,0 AS is_deleted
--	--,'' AS STRes1
--	--,'' AS STRes2
--	--,'' AS STRes3
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM(TransactionCode), '#', TRIM(IssuerReceiverNum), '#', TRIM([OrderNum]), '#', TRIM([OrderLine]), '#', TRIM(PartNum), '#', TRIM(TransactionQty), '#', TRIM(WarehouseCode)))) AS StockTransactionID
	,'2023-02-03 16:00' AS PartitionKey
	,UPPER([Company]) AS [Company]
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
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
	,IIF(TransactionQty IS NULL, 0, TRY_CONVERT(decimal(18,2), REPLACE(REPLACE(TransactionQty, ' ', ''), ',', '.'))) AS TransactionQty 
	,IIF(TransactionValue IS NULL, 0, TRY_CONVERT(decimal(18,2), REPLACE(TransactionValue, ',', '.'))) AS TransactionValue
	,IIF(CostPrice IS NULL, 0, TRY_CONVERT(decimal(18,2), REPLACE(REPLACE(CostPrice, ' ', ''), ',', '.'))) AS [CostPrice]
	,IIF(SalesUnitPrice IS NULL, 0, TRY_CONVERT(decimal(18,2), REPLACE(REPLACE(SalesUnitPrice, ' ', ''), ',', '.'))) AS SalesUnitPrice 
	,IIF(TRIM([Currency])='', NULL,TRIM(Currency)) AS Currency
	,'FI_ST_Hist' AS [Reference]
	,CONVERT(date, AdjustmentDate) AS AdjustmentDate
	,'External' AS InternalExternal

	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([InvoiceNum])))), NULL) AS PurchaseInvoiceID
	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([OrderNum]))))), NULL) AS PurchaseOrderNumID
	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([OrderNum]))))), NULL) AS SalesOrderNumID
	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([InvoiceNum]))))), NULL) AS SalesInvoiceID
	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM(IssuerReceiverNum))))), NULL) AS CustomerID
	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company],'#',TRIM(IssuerReceiverNum)))), NULL) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
FROM [stage].[Nom_FI_StocktransactionOB_Tobias2ndPatch]  -- this version is used one and after has modified the citatet techen in v.202305
--Main: [stage].[Nom_FI_StocktransactionOBwithHist_20230203], delete blank partnum, push in 70 by Tobias Ö 20230208.
--TÖ 1st patch 70 lines
--TÖ 2nd patch 12 lines
--Total = Main + 1st + 2nd
GO
