IF OBJECT_ID('[stage].[vNOM_DK_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vNOM_DK_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vNOM_DK_StockTransaction] AS 
--ADD TRIM()UPPER() INTO PartID,CustomerID 23-01-05 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM(IndexKey)))) AS StockTransactionID
	,UPPER([Company]) AS [Company]
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
	,TransactionCode
	,TransactionType AS TransactionDescription
	,IIF(TRIM(IssuerReceiverNum)='', NULL,TRIM(IssuerReceiverNum)) AS IssuerReceiverNum
	,IIF(TRIM([OrderNum])='', NULL,TRIM(OrderNum)) AS OrderNum
	,OrderLine
	,IIF(TRIM(MAX([InvoiceNum]))='', NULL,TRIM(MAX(InvoiceNum))) AS InvoiceNum
	,MAX(InvoiceLine) AS InvoiceLine
	,UPPER(TRIM([PartNum])) AS [PartNum]
	,IIF(TRIM([BinNum])='', NULL,TRIM(BinNum)) AS BinNum
	,IIF(TRIM([BatchNum])='', NULL,TRIM(BatchNum)) AS BatchNum
	,CONVERT(date, TransactionDate) AS TransactionDate
	,TransactionTime
	,TransactionQty
	,TransactionValue
	,[CostPrice]
	,SalesUnitPrice
	,IIF(TRIM([Currency])='', NULL,TRIM(Currency)) AS Currency
	,[Reference]
	,CONVERT(date, AdjustmentDate) AS AdjustmentDate
	,IIF(InternalExternal = 'I', 'Internal', 'External') AS InternalExternal
	,CreateDate AS STRes1
	,FIFOBatchID AS STRes2
	,TransactionDescription AS STRes3

	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
    --,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM(MAX([InvoiceNum]))))), NULL) AS PurchaseInvoiceID

	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([OrderNum]))))), NULL) AS PurchaseOrderNumID
	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([OrderNum]))))), NULL) AS SalesOrderNumID
	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM(MAX([InvoiceNum])))))), NULL) AS SalesInvoiceID
	,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM(IssuerReceiverNum))))), NULL) AS CustomerID
	--,IIF(TransactionCode in ('800', '801', '815'), CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM(IssuerReceiverNum)))), NULL) AS CustomerID
	,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM(IssuerReceiverNum))))), NULL) AS SupplierID
	--,IIF(TransactionCode in ('930', '931', '936', '907', '912', '913'), CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM(IssuerReceiverNum))))), NULL) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
	,PartitionKey
	,IndexKey

FROM [stage].[NOM_DK_StockTransaction]

GROUP BY IndexKey, [Company], [WarehouseCode], TransactionCode, TransactionDescription, IssuerReceiverNum, [OrderNum], OrderLine, [PartNum], [BinNum], [BatchNum], TransactionDate, TransactionTime, TransactionQty, TransactionValue, [CostPrice], SalesUnitPrice, [Currency], [Reference], AdjustmentDate, CreateDate, FIFOBatchID, TransactionType, PartitionKey, InternalExternal --, [InvoiceNum], InvoiceLine
GO
