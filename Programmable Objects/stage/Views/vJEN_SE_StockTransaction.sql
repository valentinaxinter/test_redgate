IF OBJECT_ID('[stage].[vJEN_SE_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vJEN_SE_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vJEN_SE_StockTransaction] AS 
--COMMENT EMPTY FIELDS / ADD UPPER() INTO PartID,CustomerID,WarehouseID 2022-12-19 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([SysRowID])))) AS StockTransactionID
	,CONCAT([Company],'#',TRIM([SysRowID])) AS StockTransactionCode --StockTransactionCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
 	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([CurrencyCode]))) AS CurrencyID

	,IIF([TranTypeDesc] = 'Outgoing goods', CONVERT([binary](32), HASHBYTES('SHA2_256', Upper(CONCAT(TRIM([Company]),'#',TRIM([IssuerReceiverCode]))))), NULL) AS CustomerID
	,IIF([TranTypeDesc] = 'Outgoing goods', CONVERT([binary](32), HASHBYTES('SHA2_256', Upper(CONCAT(TRIM([Company]),'#',TRIM([OrderNum]))))), NULL) AS SalesOrderNumID
	,IIF([TranTypeDesc] = 'Outgoing goods', CONVERT([binary](32), HASHBYTES('SHA2_256', Upper(CONCAT(TRIM([Company]),'#',TRIM([InvoiceNum]))))), NULL) AS SalesInvoiceID
	,IIF([TranTypeDesc] = 'Incoming goods', CONVERT([binary](32), HASHBYTES('SHA2_256', Upper(CONCAT(TRIM([Company]),'#',TRIM([IssuerReceiverCode]))))), NULL) AS SupplierID
	,IIF([TranTypeDesc] = 'Incoming goods', CONVERT([binary](32), HASHBYTES('SHA2_256', Upper(CONCAT(TRIM([Company]),'#',TRIM([OrderNum]))))), NULL) AS PurchaseOrderNumID
	,IIF([TranTypeDesc] = 'Incoming goods', CONVERT([binary](32), HASHBYTES('SHA2_256', Upper(CONCAT(TRIM([Company]),'#',TRIM([InvoiceNum]))))), NULL) AS PurchaseInvoiceID

	,[PartitionKey]
    ,[SysRowID] AS IndexKey
    ,TRIM([Company]) AS Company -- 
	,TRIM([WarehouseCode]) AS WarehouseCode
	,[TranType]		AS TransactionCode
	,[TranTypeDesc]	AS TransactionDescription
	,IIF(TRIM([IssuerReceiverCode])='', NULL,TRIM(IssuerReceiverCode)) AS IssuerReceiverNum
	,IIF(TRIM([OrderNum])='', NULL, TRIM(OrderNum)) AS OrderNum 
	--,'' AS OrderLine
    ,IIF(TRIM([InvoiceNum])='', NULL,TRIM(InvoiceNum)) AS InvoiceNum
	--,'' AS InvoiceLine
    ,TRIM([PartNum]) AS PartNum
    ,IIF(TRIM([BinNumber])='', NULL,TRIM(BinNumber)) AS BinNum
    ,IIF(TRIM([BatchID])='', NULL,TRIM(BatchID)) AS BatchNum
	,convert(date, [TranDate]) AS TransactionDate 
	,[CreateTime] AS TransactionTime
	,[TranQty]		AS TransactionQty
	,[TranValue] AS TransactionValue 
	,[CostPrice] 
	,[SellingPrice] AS SalesUnitPrice 
	,'SEK' AS Currency  --CurrencyCode, changed 2023-05-16 SB
	,CONVERT(decimal(18,4), ExchangeRate) AS ExchangeRate
	,[Reference]
	,convert(date, [CreateDate]) AS AdjustmentDate
	,IIF(TRIM([TranTypeDesc]) IN ('Incoming goods','Outgoing goods'),'External','Internal') AS InternalExternal
	,PartStatus AS STRes1
	--,'' AS STRes2
	--,'' AS STRes3
    ,IIF(TRIM([FIFOBatchID])='', NULL,TRIM(FIFOBatchID)) AS FIFOBatchID
    ,IIF(TRIM([SupplierBatchID])='', NULL,TRIM(SupplierBatchID)) AS SupplierBatchID
	,[TranDT]
    ,[TranSource]
--	Simple logic for counting StockBalance, maybe to simple ?
--	,SUM(TranQty) OVER (PARTITION BY  WarehouseCode , PartNum, BatchID ORDER BY TranDate asc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
--	,SUM(TranQty) OVER (PARTITION BY  WarehouseCode , PartNum, BatchID ORDER BY TranDate asc) AS StockBalanceCount --Original
--	,SUM(TranQty) OVER (PARTITION BY  WarehouseCode , PartNum, BatchID ORDER BY TranDT ASC) AS StockBalanceCount -- DZ modified  -- ET 20200916 decision, solution in measures
--	,SUM(TranValue) OVER (PARTITION BY  WarehouseCode , PartNum, BatchID ORDER BY TranDate asc) AS StockBalanceValue --Original
--	,SUM(TranValue) OVER (PARTITION BY  WarehouseCode , PartNum, BatchID ORDER BY TranDT ASC) AS StockBalanceValue -- DZ modified  -- ET 20200916 decision, solution in measures
				 
FROM 
	[stage].[JEN_SE_StockTransaction]
WHERE convert(date, [TranDate]) >= '2020-01-01'
GO
