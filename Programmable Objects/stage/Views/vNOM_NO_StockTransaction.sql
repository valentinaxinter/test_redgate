IF OBJECT_ID('[stage].[vNOM_NO_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vNOM_NO_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vNOM_NO_StockTransaction] AS 
--ADD UPPER() TRIM() INTO CustomerID 23-01-09 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM(IndexKey)))) AS StockTransactionID
	,UPPER([Company]) AS [Company]
	,UPPER(TRIM([PartNum])) AS [PartNum]
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
	,IIF(TRIM(IssuerReceiverNum)='', NULL,TRIM(IssuerReceiverNum)) AS IssuerReceiverNum
	,TransactionCode
	,TransactionType AS TransactionDescription
	,IIF(TRIM([OrderNum])='', NULL,TRIM(OrderNum)) AS OrderNum
	,OrderLine
	,IIF(TRIM([InvoiceNum])='', NULL,TRIM(InvoiceNum)) AS InvoiceNum
	,InvoiceLine
	,IIF(TRIM([BinNum])='', NULL,TRIM(BinNum)) AS BinNum
	,IIF(TRIM([BatchNum])='', NULL,TRIM(BatchNum)) AS BatchNum
	,CONVERT(date, TransactionDate) AS TransactionDate
	,TransactionTime
	,CONVERT(decimal(18,2), TransactionQty) AS TransactionQty
	,CONVERT(decimal(18,2), TransactionValue) AS TransactionValue
	,CONVERT(decimal(18,2),  CostPrice) AS [CostPrice]
	,CONVERT(decimal(18,2),  SalesUnitPrice) AS SalesUnitPrice
	,IIF(TRIM([Currency])='', NULL,TRIM(Currency)) AS Currency
	,[Reference]
	,CONVERT(date, AdjustmentDate) AS AdjustmentDate
	,IIF(InternalExternal = 'I', 'Internal', 'External') AS InternalExternal
	,CreateDate AS STRes1
	,FIFOBatchID AS STRes2
	,TransactionDescription AS STRes3

	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
    --,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([InvoiceNum])))), NULL) AS PurchaseInvoiceID
--	,IIF(TransactionCode in ('930', '931', '936'), CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([OrderNum])))), NULL) AS PurchaseOrderNumID
	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([OrderNum]))))), NULL) AS PurchaseOrderNumID
	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([OrderNum]))))), NULL) AS SalesOrderNumID
	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([InvoiceNum]))))), NULL) AS SalesInvoiceID
	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM(IssuerReceiverNum))))), NULL) AS CustomerID
	--,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM(IssuerReceiverNum)))), NULL) AS CustomerID
	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM(IssuerReceiverNum))))), NULL) AS SupplierID
	--,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM(IssuerReceiverNum))))), NULL) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
	,PartitionKey
	,IndexKey

FROM [stage].[NOM_NO_StockTransaction]
GO
