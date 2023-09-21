IF OBJECT_ID('[stage].[vJEN_NB_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NB_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vJEN_NB_StockTransaction] AS 

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SysRowID]))))) AS StockTransactionID
	,UPPER(CONCAT([Company], '#', TRIM([SysRowID]))) AS StockTransactionCode --StockTransactionCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]) ,'#', TRIM([PartNum]))))) AS PartID
 	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF(TranSource = '0x31', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([OrderNum]))))), NULL) AS SalesOrderID
	,IIF(TranSource <> '0x31', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([OrderNum]))))), NULL) AS PurchaseOrderID
--	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([OrderNum])))) AS PurchaseOrderID
	,IIF(TranSource = '0x31', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([InvoiceNum]))))), NULL) AS SalesInvoiceID
	,IIF(TranSource <> '0x31', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([InvoiceNum]))))), NULL) AS PurchaseInvoiceID
	,IIF(TranSource = '0x31', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([IssuerReceiverCode]))))), NULL) AS CustomerID
	,IIF(TranSource <> '0x31', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([IssuerReceiverCode]))))), NULL) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([CurrencyCode])))) AS CurrencyID
	,[PartitionKey]

    ,UPPER([Company]) AS Company -- 
	,UPPER(TRIM([PartNum])) AS PartNum
	,UPPER(IIF(TRIM([IssuerReceiverCode])= '', NULL, TRIM(IssuerReceiverCode))) AS IssuerReceiverCode
	,TRIM([WarehouseCode]) AS WarehouseCode
	,iif(convert(date, [TranDate]) = '2022-04-01' and TRIM([TranTypeDesc]) = 'Incoming Goods','OB',TRIM([TranType])) AS TransactionCode
	,iif(convert(date, [TranDate]) = '2022-04-01' and TRIM([TranTypeDesc]) = 'Incoming Goods','Opening balance',TRIM([TranTypeDesc])) AS TransactionDescription
	,IIF(TRIM([OrderNum])='', NULL, TRIM(OrderNum)) AS OrderNum 
    ,IIF(TRIM([InvoiceNum])='', NULL,TRIM(InvoiceNum)) AS InvoiceNum
	--,'' AS InvoiceLine
    ,IIF(TRIM([BinNumber])='', NULL,TRIM(BinNumber)) AS BinNum
    ,IIF(TRIM([BatchID])='', NULL,TRIM(BatchID)) AS BatchNum
	,convert(date, [TranDate]) AS TransactionDate
	,[CreateTime] AS TransactionTime
	,[TranQty] AS TransactionQty
	,TranValue AS TransactionValue 
	,[CostPrice]
	,SellingPrice AS SalesUnitPrice
	,[ExchangeRate] 
	,'NOK' AS Currency -- CurrencyCode, changed 2023-05-16 SB
	,[Reference]
	,convert(date, [CreateDate]) AS AdjustmentDate
	,IIF(TRIM([TranTypeDesc]) IN ('Incoming goods','Outgoing goods'),'External','Internal') AS InternalExternal
	,PartStatus AS STRes1
	--,'' AS STRes2
	--,'' AS STRes3
	,[TranDT]
    ,[TranSource]
	,TRIM([SysRowID]) AS IndexKey		 
FROM 
	[stage].[JEN_NB_StockTransaction]
GO
