IF OBJECT_ID('[stage].[vCER_UK_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vCER_UK_StockTransaction];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vCER_UK_StockTransaction] AS 

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SysRowID]))))) AS StockTransactionID
	,UPPER(CONCAT([Company], '#', TRIM([SysRowID]))) AS StockTransactionCode --StockTransactionCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(([Company]))))) AS CompanyID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#' ,TRIM(UPPER([PartNum])))))) AS PartID
 	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF(TranSource = '0x31', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([OrderNum]))))), NULL) AS SalesOrderNumID
	,IIF(TranSource <> '0x31', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([OrderNum]))))), NULL) AS PurchaseOrderNumID
--	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([OrderNum])))) AS PurchaseOrderID
	,IIF(TranSource = '0x31', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([InvoiceNum]))))), NULL) AS SalesInvoiceID
	,IIF(TranSource <> '0x31', CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM([InvoiceNum]))))), NULL) AS PurchaseInvoiceID
	,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([IssuerReceiverCode]))))), NULL) AS CustomerID
	,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([IssuerReceiverCode]))))), NULL) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([CurrencyCode])))) AS CurrencyID
	,[PartitionKey]

    
    ,TRIM([Company]) AS Company -- 
	,TRIM([WarehouseCode]) AS WarehouseCode
	,[TranType]		AS TransactionCode
    ,[TranTypeDesc]	AS TransactionDescription
	,TRIM([IssuerReceiverCode]) AS IssuerReceiverNum
	,IIF(TRIM([OrderNum])='', NULL, TRIM(OrderNum)) AS OrderNum 
	,IIF([TranType] = '01', TRIM([OrderNum]), '') AS SalesOrderNum
	,IIF([TranType] = '01', TRIM([InvoiceNum]), '') AS SalesInvoiceNum
	,IIF([TranType] = '01', TRIM([IssuerReceiverCode]), '') AS CustomerNum
	,IIF([TranType] = '00', TRIM([OrderNum]), '') AS PurchaseOrderNum
	,IIF([TranType] = '00', TRIM([InvoiceNum]), '') AS PurchaseInvoiceNum
	,IIF([TranType] = '00', TRIM([IssuerReceiverCode]), '') AS SupplierNum
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
	,'GBP' AS Currency
	,1 AS ExchangeRate
	,[Reference]
	,convert(date, [CreateDate]) AS AdjustmentDate
	,InternalExternal
	,IIF(InternalExternal = 'Internal', 1, 0) AS IsInternalTransaction
	,'' AS STRes1
	,'' AS STRes2
	,'' AS STRes3
    ,[SysRowID] AS IndexKey
	,IIF(TRIM([FIFOBatchID])='', NULL,TRIM(FIFOBatchID)) AS FIFOBatchID
    ,IIF(TRIM([SupplierBatchID])='', NULL,TRIM(SupplierBatchID)) AS SupplierBatchID
	,[TranDT]
    ,[TranSource]
				 
FROM 
	[stage].[CER_UK_StockTransaction]
GO
