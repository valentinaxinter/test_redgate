IF OBJECT_ID('[stage].[vABK_SE_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vABK_SE_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vABK_SE_StockTransaction] AS 
--COMMENT EMPTY FIELD 2022-12-21 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(IndexKey))))) AS StockTransactionID --, '#', TRIM(SalesInvoiceNum) --, '#', TRIM(TransactionCode), '#', TRIM([CreatedTimeStamp]), '#', TRIM(ModifiedTimeStamp), '#', TRIM(BatchNum), '#', TRIM(CustomerNum), '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM([PartNum])
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
 	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF(TransactionCode = '1', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(SalesOrderNum))))), NULL) AS SalesOrderNumID
	,IIF(TransactionCode = '6', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(PurchaseOrderNum))))), NULL) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(SalesInvoiceNum))))) AS SalesInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(SupplierNum))))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Currency])))) AS CurrencyID
	,[PartitionKey]
    ,IndexKey

    ,UPPER(TRIM([Company])) AS Company -- 
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
    ,UPPER(TRIM([PartNum])) AS PartNum
	,TransactionCode
	,CASE WHEN TransactionCode = '1' THEN 'Outgoing goods'
		WHEN TransactionCode = '6' THEN 'Incoming goods'
		ELSE 'Internal' END AS TransactionDescription
	,CASE WHEN TransactionCode = '1' THEN CustomerNum
		WHEN TransactionCode = '6' THEN SupplierNum
		END AS IssuerReceiverNum
	,CASE WHEN TransactionCode = '1' THEN SalesOrderNum
		WHEN TransactionCode = '6' THEN PurchaseOrderNum
		END AS OrderNum 
	,CASE WHEN TransactionCode = '1' THEN SalesOrderLine
		WHEN TransactionCode = '6' THEN PurchaseOrderLine
		END AS OrderLine
    ,CASE WHEN TransactionCode = '1' THEN SalesInvoiceNum
		WHEN TransactionCode = '6' THEN PurchaseInvoiceNum
		END AS InvoiceNum
	--,'' AS InvoiceLine
    --,'' AS BinNum
    ,IIF(TRIM(BatchNum)='', NULL,TRIM(BatchNum)) AS BatchNum
	,CONVERT(date, CAST(TransactionDate AS DATE), 23) AS TransactionDate 
	,LEFT([CreatedTimeStamp], 8) AS TransactionTime
	,convert(date, LEFT(ModifiedTimeStamp,8)) AS AdjustmentDate
	,IIF(TransactionCode = '1' AND SalesInvoiceNum = '', 0, TransactionQty) AS TransactionQty -- added 20221207 after meeting with Krister, Mattias & Tobias Ö /DZ
	,IIF(TransactionCode = '1' AND SalesInvoiceNum = '', 0, TransactionValue) AS TransactionValue -- added 20221207 after meeting with Krister, Mattias & Tobias Ö /DZ
	,IIF(TransactionQty = 0 OR TransactionQty IS NULL, 0, TransactionValue/TransactionQty) AS [CostPrice] 
	--,NULL AS SalesUnitPrice 
	,TRIM(Currency) AS Currency
	,IIF(InternalExternal = 1, 'Internal', 'External') AS InternalExternal
	--,'' AS [Reference]
	--,'' AS STRes1
	--,'' AS STRes2
	--,'' AS STRes3
FROM 
	[stage].[ABK_SE_StockTransaction]
GO
