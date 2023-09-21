IF OBJECT_ID('[stage].[vCER_SE_StockTransactions]') IS NOT NULL
	DROP VIEW [stage].[vCER_SE_StockTransactions];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [stage].[vCER_SE_StockTransactions] AS 

SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SysRowID]))))) AS StockTransactionID
	,UPPER(CONCAT([Company],'#',TRIM([SysRowID]))) AS StockTransactionCode --StockTransactionCode

--	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(([Company])))) AS CompanyID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(UPPER([PartNum])))))) AS PartID
 	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([OrderNum]))))), NULL) AS SalesOrderNumID
	,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([OrderNum]))))), NULL) AS PurchaseOrderNumID
--	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([OrderNum])))) AS PurchaseOrderID
	,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([InvoiceNum]))))), NULL) AS SalesInvoiceID
	,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([InvoiceNum]))))), NULL) AS PurchaseInvoiceID
	,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([IssuerReceiverCode]))))), NULL) AS CustomerID
	,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([IssuerReceiverCode]))))), NULL) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([CurrencyCode])))) AS CurrencyID
	,[PartitionKey]

    
    ,TRIM([Company]) AS Company -- 
	,TRIM([WarehouseCode]) AS WarehouseCode
	,iif(convert(date, [TranDate]) = '2010-01-01' AND [TranTypeDesc] = 'Incoming goods','OB',[TranType]) AS TransactionCode
    ,iif(convert(date, [TranDate]) = '2010-01-01' AND [TranTypeDesc] = 'Incoming goods','Opening balance',[TranTypeDesc])	AS TransactionDescription
	,IIF(TRIM([IssuerReceiverCode])='', NULL,TRIM(IssuerReceiverCode)) AS IssuerReceiverNum
	,IIF(TRIM([OrderNum])='', NULL, TRIM(OrderNum)) AS OrderNum 
	,'' AS OrderLine
	,IIF(TRIM([InvoiceNum])='', NULL,TRIM(InvoiceNum)) AS InvoiceNum
	,'' AS InvoiceLine
    ,TRIM(UPPER([PartNum])) AS PartNum
    ,IIF(TRIM([BinNumber])='', NULL,TRIM(BinNumber)) AS BinNum
    ,IIF(TRIM([BatchID])='', NULL,TRIM(BatchID)) AS BatchNum
    ,convert(date, [TranDate]) AS TransactionDate
    ,[CreateTime] AS TransactionTime
	,[TranQty] AS TransactionQty
    ,[TranValue] AS TransactionValue
	,[CostPrice]
    ,[SellingPrice] AS SalesUnitPrice
	,IIF(TRIM([CurrencyCode])='', NULL,TRIM(CurrencyCode)) AS Currency
	,[Reference]
	,convert(date, [CreateDate]) AS AdjustmentDate
	,InternalExternal
	,'' AS STRes1
	,'' AS STRes2
	,'' AS STRes3
    ,[SysRowID] AS IndexKey
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
	[stage].[CER_SE_StockTransactions]
GO
