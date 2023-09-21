IF OBJECT_ID('[stage].[vCyE_ES_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vCyE_ES_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCyE_ES_StockTransaction] AS 
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO CustomerID,PartID 23-01-03 
--ADD UPPER() INTO SupplierID 23-01-23 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM(TranType), '#', TRIM(LotNum), '#', TRIM([PartNum]), '#', TRIM([WarehouseCode]), '#', ([TranDate]), '#', TRIM([SysRowID])))) AS StockTransactionID
	,[Company]
	,TRIM([WarehouseCode]) AS WarehouseCode
	,TranType AS TransactionCode
	--,'' AS TransactionDescription
	,IIF(TRIM('')='', NULL,TRIM('')) AS IssuerReceiverNum
	,IIF(TRIM('')='', NULL,TRIM('')) AS OrderNum
	--,'' AS OrderLine
	,IIF(TRIM('')='', NULL,TRIM('')) AS InvoiceNum
	--,'' AS InvoiceLine
	,[PartNum]
	,IIF(TRIM([BinNumber])='', '',TRIM(BinNumber)) AS BinNum
	,IIF(TRIM(LotNum)='', '',TRIM(LotNum)) AS BatchNum
	,CONVERT(date, [TranDate]) AS TransactionDate
	--,'' AS TransactionTime
	,[TranQty]/1000 AS TransactionQty
	,[TranQty]/1000*AvgCost/100 AS TransactionValue
	,AvgCost/100 AS [CostPrice]
	--,NULL AS SalesUnitPrice
	,'EUR' AS Currency
	--,'' AS [Reference]
	,CONVERT(date, '1900-01-01') AS AdjustmentDate
	--,'' AS InternalExternal
	--,'' AS STRes1
	--,'' AS STRes2
	--,'' AS STRes3
	,PartitionKey
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM([PartNum]))))) AS PartID
    --,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([PartNum])))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF(TranType = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company], '#', TRIM('')))), NULL) AS PurchaseInvoiceID
	,IIF(TranType = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company], '#', TRIM('')))), NULL) AS PurchaseOrderNumID
	,IIF(TranType = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company], '#', TRIM('')))), NULL) AS SalesOrderNumID
	,IIF(TranType = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company], '#', TRIM('')))), NULL) AS SalesInvoiceID
	,IIF(TranType = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]), '#', '')))), NULL) AS CustomerID
	--,IIF(TranType = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company], '#', TRIM('')))), NULL) AS CustomerID
	,IIF(TranType = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]), '#', '')))), NULL) AS SupplierID
	--,IIF(TranType = '0x31', CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company], '#', TRIM('')))), NULL) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256', 'EUR')) AS CurrencyID
	,[SysRowID] AS IndexKey
FROM [stage].[CYE_ES_PartTranLine]
WHERE PartNum <> '' OR PartNum IS NOT NULL
GO
