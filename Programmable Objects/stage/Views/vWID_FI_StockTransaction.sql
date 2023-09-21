IF OBJECT_ID('[stage].[vWID_FI_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vWID_FI_StockTransaction] AS 
--ADD UPPER()TRIM() INTO PartID,CustomerID 2022-12-15 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(st.[Company], '#', TRIM([SysRowID])))) AS StockTransactionID
	,st.[Company]
	,TRIM([WarehouseCode]) AS WarehouseCode
	,iif(CONVERT(date, [TranDate]) = '2012-10-31' and [TranTypeDesc] = 'Incoming Goods','OB',TranType) AS TransactionCode --CONCAT([Company], '#', TRIM([SysRowID]))
	,iif(CONVERT(date, [TranDate]) = '2012-10-31' and [TranTypeDesc] = 'Incoming Goods','Opening balance',[TranTypeDesc]) AS TransactionDescription
	,IIF(TRIM([IssuerReceiverCode])='', NULL,TRIM(IssuerReceiverCode)) AS IssuerReceiverNum
	,IIF(TRIM([OrderNum])='', NULL,TRIM(OrderNum)) AS OrderNum
	--,NULL AS OrderLine
	,IIF(TRIM([InvoiceNum])='', NULL,TRIM(InvoiceNum)) AS InvoiceNum
	--,NULL AS InvoiceLine
	,[PartNum]
	,IIF(TRIM([BinNumber])='', NULL,TRIM(BinNumber)) AS BinNum
	,IIF(TRIM([BatchID])='', NULL,TRIM(BatchID)) AS BatchNum
	,CONVERT(date, [TranDate]) AS TransactionDate
	,[CreateTime] AS TransactionTime
	,[TranQty] AS TransactionQty
	,IIF([PartNum] = '722018', 0, [TranValue]) AS TransactionValue -- to adjust the largiest straingh value in ERP iScala, a temp solution until Lauri find a good one
--	,[TranValue]  AS TransactionValue
	,[CostPrice]
	,[SellingPrice] AS SalesUnitPrice
	,IIF(TRIM([Currency])='', NULL,TRIM(Currency)) AS Currency
	,[Reference]
	,CONVERT(date, [CreateDate]) AS AdjustmentDate
--	,CASE WHEN c.CustomerGroup = 'CONCERN' OR c.CustomerGroup = 'INTERNAL SALES' THEN 'Internal'
--		ELSE 'External' END AS InternalExternal
	,IIF([TranTypeDesc] IN ('Incoming goods', 'Outgoing goods'), 'External', 'Internal') AS InternalExternal
	--,'' AS STRes1
	--,'' AS STRes2
	--,'' AS STRes3
--  ,FIFOBatchID
--  ,SupplierBatchID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',st.[Company])) AS CompanyID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(st.[Company]),'#',TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(st.[Company],'#',TRIM([PartNum])))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(st.[Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(st.[Company],'#',TRIM([InvoiceNum])))), NULL) AS PurchaseInvoiceID
	,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(st.[Company],'#',TRIM([OrderNum])))), NULL) AS PurchaseOrderNumID
	,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(st.[Company],'#',TRIM([OrderNum])))), NULL) AS SalesOrderNumID
	,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(st.[Company],'#',TRIM([InvoiceNum])))), NULL) AS SalesInvoiceID
	,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(st.[Company]),'#',TRIM([IssuerReceiverCode]))))), NULL) AS CustomerID
	--,IIF(TranSource = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(st.[Company],'#',TRIM([IssuerReceiverCode])))), NULL) AS CustomerID
	,IIF(TranSource <> '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(st.[Company],'#',TRIM([IssuerReceiverCode])))), NULL) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Currency]))) AS CurrencyID
	,st.PartitionKey
	,[SysRowID] AS IndexKey
FROM [stage].[WID_FI_StockTransaction] st
	--LEFT JOIN dw.Customer c ON st.Company = c.Company AND st.IssuerReceiverCode = c.CustomerNum
GO
