IF OBJECT_ID('[stage].[vFOR_SE_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_SE_StockTransaction] AS 
--COMMENT EMPTY FIELDS 2022-12-20 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([SysRowID]))))) AS StockTransactionID
	,CONCAT([Company], '#', TRIM([SysRowID])) AS IndexKeyCode --StockTransactionCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
 	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF((TRIM([TranSource]) = 'Sales'), CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([OrderNum]))))), NULL) AS SalesOrderNumID
	,IIF((TRIM([TranSource]) = 'Purchase' AND TRIM([TranType]) like 'PUR-STK%' AND TRIM([TranType]) not like 'ADJ-%'), CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([OrderNum]))))), NULL) AS PurchaseOrderNumID
	,IIF((TRIM([TranSource]) = 'Sales'), CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([InvoiceNum]))))), NULL) AS SalesInvoiceID
	,IIF((TRIM([TranSource]) = 'Purchase' AND TRIM([TranType]) like 'PUR-STK%' AND TRIM([TranType]) not like 'ADJ-%'), CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([InvoiceNum]))))), NULL) AS PurchaseInvoiceID
	,IIF((TRIM([TranSource]) = 'Sales'), CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(IssueRecCode))))), NULL) AS CustomerID
	,IIF((TRIM([TranSource]) = 'Purchase' AND TRIM([TranType]) like 'PUR-STK%' AND TRIM([TranType]) not like 'ADJ-%')
		, CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(IssueRecCode)))))
		, HASHBYTES('SHA2_256',[Company])) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([CurrencyCode])))) AS CurrencyID
	,[PartitionKey]

    ,UPPER([Company]) AS [Company] -- 
	,UPPER(TRIM([PartNum])) AS PartNum
	,IIF(TRIM(IssueRecCode)='', NULL, UPPER(TRIM(IssueRecCode))) AS IssuerReceiverNum
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
	,IIF(LEFT(TRIM([TranType]),4) = 'ADJ-' AND convert(date, [TransactionDate])  = '2014-05-31','OB',TRIM([TranType])) AS TransactionCode
	,CASE WHEN TRIM([TranSource]) = 'Purchase' AND TRIM([TranType]) like 'PUR-STK%' AND LEFT(TRIM([TranType]),4) != 'ADJ-' THEN 'Incoming goods' 
		WHEN TRIM([TranType])	= 'PUR-DRP' THEN  'Incoming goods'
		WHEN LEFT(TRIM([TranType]),4) = 'ADJ-' AND convert(date, [TransactionDate])  = '2014-05-31' THEN 'Opening balance'
		WHEN LEFT(TRIM([TranType]),4) = 'ADJ-' THEN 'Adjustment'
		WHEN TRIM([TranSource]) = 'Sales' THEN 'Outgoing goods' 
		WHEN TRIM([TranSource]) = 'Stock' THEN 'Transit goods'
		ELSE 'unknown'
		END AS [TransactionDescription]
    ,IIF(TRIM([OrderNum])='', NULL,UPPER(TRIM(OrderNum))) AS OrderNum
	--,'' AS OrderLine
	,IIF(TRIM([InvoiceNum])='', NULL,UPPER(TRIM(InvoiceNum))) AS InvoiceNum
	--,'' InvoiceLine
    ,IIF(TRIM([BinNum])='', NULL,TRIM(BinNum)) AS BinNum
    ,IIF(TRIM([BatchID])='', NULL,TRIM(BatchID)) AS BatchNum
	,convert(date, [TransactionDate]) AS TransactionDate
	,[CreateTime] AS TransactionTime
	,SellingShipQty AS [TransactionQty]
	,CASE WHEN TRIM([TranType]) like 'ADJ-%' THEN [TranValue] WHEN SellingShipQty < 0 THEN ABS([TranValue])*-1 ELSE ABS([TranValue]) END AS TransactionValue
	,[CostPrice]
	,SellPrice AS [SalesUnitPrice]
	,IIF(TRIM([CurrencyCode])='', NULL,TRIM(CurrencyCode)) AS Currency
	,TRIM([Reference]) AS Reference
	,convert(date, [CreateDate]) AS AdjustmentDate
	,CASE WHEN TRIM([TranSource]) = 'Purchase' AND TRIM([TranType]) like 'PUR-STK%' AND TRIM([TranType]) not like 'ADJ-%' THEN 'External' 
		WHEN TRIM([TranType])	= 'PUR-DRP' THEN  'External'
		WHEN TRIM([TranType]) like 'ADJ-%' THEN 'Internal'
		WHEN TRIM([TranSource]) = 'Sales' THEN 'External' 
		WHEN TRIM([TranSource]) = 'Stock' THEN 'Internal'
		ELSE 'Internal'
		END  AS InternalExternal
	--,'' AS STRes1
	--,'' AS STRes2
	--,'' AS STRes3
    ,IIF(TRIM([FifoBatchID])='', NULL,TRIM(FIFOBatchID)) AS FIFOBatchID
    ,IIF(TRIM([BatchID])='', NULL,TRIM(BatchID)) AS SupplierBatchID
	,[TranDT]
    ,TRIM([TranSource]) AS TransactionSource
	  -- DZ added conditions ----AND TRIM([TranType]) LIKE '%STK-CUS%') THEN
	,[SysRowID] AS IndexKey 
	,SUM(SellingShipQty) OVER (PARTITION BY  WarehouseCode , PartNum, BatchID ORDER BY TranDT ASC) AS StockBalanceCount 
	,SUM(TranValue) OVER (PARTITION BY  WarehouseCode , PartNum, BatchID ORDER BY TranDT ASC) AS StockBalanceValue
FROM 
	[stage].[FOR_SE_StockTransaction]
GO
