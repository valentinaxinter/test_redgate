IF OBJECT_ID('[stage].[vJEN_DK_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vJEN_DK_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vJEN_DK_StockTransaction] AS 
--COMMENT EMPTY FIELD // ADD UPPER() INTO CustomerID 22-12-29 VA
SELECT 
--	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SysRowID]))))) AS StockTransactionID
--	,UPPER(CONCAT([Company],'#',TRIM([SysRowID]))) AS StockTransactionCode --StockTransactionCode
--	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER([Company]))) AS CompanyID
--    ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
-- 	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
--	,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([OrderNum])))), NULL) AS SalesOrderID
--	,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([OrderNum])))), NULL) AS PurchaseOrderID
----	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([OrderNum])))) AS PurchaseOrderID
--	,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([InvoiceNum])))), NULL) AS SalesInvoiceID
--	,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([InvoiceNum])))), NULL) AS PurchaseInvoiceID

--	,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([IssuerReceiverCode]))))), NULL) AS CustomerID
--	,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM([IssuerReceiverCode])))), NULL) AS SupplierID
--	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([CurrencyCode])))) AS CurrencyID
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
	,TRIM([TranType])		AS TransactionCode
	,TRIM([TranTypeDesc])	AS TransactionDescription
	,IIF(TRIM([IssuerReceiverCode])='', NULL,TRIM(IssuerReceiverCode)) AS IssuerReceiverCode
	,IIF(TRIM([OrderNum])='', NULL, TRIM(OrderNum)) AS OrderNum 
    ,IIF(TRIM([InvoiceNum])='', NULL,TRIM(InvoiceNum)) AS InvoiceNum
	--,'' AS InvoiceLine
    ,TRIM([PartNum]) AS PartNum
    ,IIF(TRIM([BinNumber])='', NULL,TRIM(BinNumber)) AS BinNum
    ,IIF(TRIM([BatchID])='', NULL,TRIM(BatchID)) AS BatchNum
	,convert(date, [TranDate]) AS TransactionDate
	,[CreateTime] AS TransactionTime
	,[TranQty] AS TransactionQty
	,TranValue AS TransactionValue 
	,[CostPrice]
	,SellingPrice AS SalesUnitPrice
	,'DKK' AS Currency  -- CurrencyCode changed 2023-05-16 SB
	,CONVERT(decimal(18,4), ExchangeRate) AS ExchangeRate
	,[Reference]
	,convert(date, [CreateDate]) AS AdjustmentDate
	,IIF(TRIM([TranTypeDesc]) IN ('Incoming goods','Outgoing goods'),'External','Internal') AS InternalExternal
	,PartStatus AS STRes1
	--,'' AS STRes2
	--,'' AS STRes3
	,[TranDT]
    ,[TranSource]
			 
FROM 
	[stage].[JEN_DK_StockTransaction]
GO
