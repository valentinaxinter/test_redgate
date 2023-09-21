IF OBJECT_ID('[stage].[vJEN_SK_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vJEN_SK_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vJEN_SK_StockTransaction] AS 
--COMMENT empty fields // ADD UPPER() INTO PartID,CustomerID,WarehouseID 2022-12-13 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([SysRowID])))) AS StockTransactionID
	,CONCAT([Company],'#',TRIM([SysRowID])) AS StockTransactionCode --StockTransactionCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([PartNum])))) AS PartID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode])))) AS WarehouseID
 	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([OrderNum])))), NULL) AS SalesOrderNumID
	,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([OrderNum])))), NULL) AS PurchaseOrderNumID
--	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([OrderNum])))) AS PurchaseOrderID
	,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([InvoiceNum])))), NULL) AS SalesInvoiceID
	,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([InvoiceNum])))), NULL) AS PurchaseInvoiceID
	,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([IssuerReceiverCode]))))), NULL) AS CustomerID
	--,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([IssuerReceiverCode])))), NULL) AS CustomerID
	,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([IssuerReceiverCode]))))), NULL) AS SupplierID
	--,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([IssuerReceiverCode])))), NULL) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([CurrencyCode]))) AS CurrencyID
	,[PartitionKey]
    ,[SysRowID] AS IndexKey
    ,TRIM([Company]) AS Company -- 
	,TRIM([WarehouseCode]) AS WarehouseCode
	,iif(convert(date, [TranDate]) = '2022-05-02' and [TranTypeDesc] = 'Incoming Goods','OB',[TranType]) AS TransactionCode
	,iif(convert(date, [TranDate]) = '2022-05-02' and [TranTypeDesc] = 'Incoming Goods','Opening balance',[TranTypeDesc]) AS TransactionDescription
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
	,'SEK' AS Currency -- Hardcoded to SEK
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
	[stage].[JEN_SK_StockTransaction]
GO
