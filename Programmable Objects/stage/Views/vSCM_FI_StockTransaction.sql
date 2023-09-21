IF OBJECT_ID('[stage].[vSCM_FI_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSCM_FI_StockTransaction] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO PartID,CustomerID 2022-12-21 VA
--ADD UPPER() INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([SysRowID])))) AS StockTransactionID --TRIM(OrderNum), '#', TRIM(PartNum), '#', TRIM([InvoiceNum]), '#', TRIM([BatchID]), '#', TRIM([BinNum]), '#', TRIM([TranDT]), '#', TRIM([WarehouseCode])
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(TRIM([Company]), '#', TRIM([PartNum])))) AS PartID
 	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,IIF((TRIM([TranSource]) = 'Purchase' AND TRIM([TranType]) like 'PUR-STK%' AND TRIM([TranType]) not like 'ADJ-%'), CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(TRIM([Company]), '#', TRIM([InvoiceNum])))), NULL) AS PurchaseInvoiceID
	,IIF((TRIM([TranSource]) = 'Purchase' AND TRIM([TranType]) like 'PUR-STK%' AND TRIM([TranType]) not like 'ADJ-%'), CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(TRIM([Company]), '#', TRIM([PurchaseOrderNum])))), NULL) AS PurchaseOrderNumID
	,IIF((TRIM([TranSource]) = 'Sales'), CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(TRIM([Company]), '#', TRIM([OrderNum])))), NULL) AS SalesOrderNumID
	,IIF((TRIM([TranSource]) = 'Sales'), CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(TRIM([Company]), '#', TRIM([InvoiceNum])))), NULL) AS SalesInvoiceID
	,IIF((TRIM([TranSource]) = 'Sales'), CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER( CONCAT(TRIM([Company]), '#', TRIM(IssueRecCode))))), NULL) AS CustomerID
 	--,IIF((TRIM([TranSource]) = 'Sales'), CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(TRIM([Company]), '#', TRIM(IssueRecCode)))), NULL) AS CustomerID
	,IIF((TRIM([TranSource]) = 'Purchase' AND TRIM([TranType]) like 'PUR-STK%' AND TRIM([TranType]) not like 'ADJ-%'), CONVERT([binary](32)
		, HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(IssueRecCode))))),  HASHBYTES('SHA2_256',[Company])) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([CurrencyCode]))) AS CurrencyID
	
	,[PartitionKey]

    ,[Company]
    ,TRIM([WarehouseCode]) AS WarehouseCode
	,[TranType] AS TransactionCode
    ,CASE WHEN TRIM([TranSource]) = 'Purchase' AND TRIM([TranType]) like 'PUR-STK%' AND TRIM([TranType]) not like 'ADJ-%' THEN 'Incoming goods' 
		WHEN TRIM([TranType]) like 'ADJ-%' THEN 'Adjustment'
		WHEN TRIM([TranSource]) = 'Sales' THEN 'Outgoing goods' 
		WHEN TRIM([TranSource]) = 'Stock' THEN 'Transit goods'
		ELSE 'unknown'
		END AS [TransactionDescription]
    ,IIF(TRIM(IssueRecCode) = '', NULL, TRIM(IssueRecCode)) AS IssuerReceiverNum
    ,IIF(TRIM([OrderNum]) = '', NULL, TRIM(OrderNum)) AS OrderNum
	--,'' AS [OrderLine]
    ,IIF(TRIM([InvoiceNum]) = '', NULL, TRIM(InvoiceNum)) AS InvoiceNum
	--,'' AS [InvoiceLine]
    ,TRIM([PartNum]) AS PartNum
    ,IIF(TRIM([BinNum]) = '', NULL, TRIM(BinNum)) AS BinNum
    ,IIF(TRIM([BatchID]) = '', NULL, TRIM(BatchID)) AS BatchNum
    ,CONVERT(date, [TransactionDate]) AS TransactionDate
	,[CreateTime] AS TransactionTime
    ,SellingShipQty AS [TransactionQty]
	,CASE WHEN TRIM([TranType]) like 'ADJ-%' THEN [TranValue] WHEN SellingShipQty < 0 THEN ABS([TranValue])*-1 ELSE ABS([TranValue]) END AS [TransactionValue]  -- DZ added conditions ----AND TRIM([TranType]) LIKE '%STK-CUS%') THEN
    ,[CostPrice]
    ,SellPrice AS [SalesUnitPrice]
    ,IIF(TRIM([CurrencyCode])='', NULL,TRIM(CurrencyCode)) AS Currency
    ,TRIM([Reference]) AS Reference
    ,CONVERT(date, [CreateDate]) AS [AdjustmentDate]
	, CASE WHEN TRIM(TranType) IN ('PUR-STK','STK-CUS') THEN 'External' ELSE 'Internal' END AS InternalExternal   --,NULL AS InternalExternal  added 2023-03-15 SB
	--,'' AS [STRes1]
	--,'' AS [STRes2]
	--,'' AS [STRes3]
	,[SysRowID] AS [IndexKey]
FROM 
	[stage].[SCM_FI_StockTransaction]
/*
GROUP BY
	PartitionKey, [SysRowID], Company, PartNum, OrderNum,PurchaseOrderNum, InvoiceNum, WarehouseCode, BinNum, BatchID, TransactionDate, CreateDate, CreateTime, TranType, [TranSource], Reference, SellingShipQty, IssueRecCode, CostPrice, SellPrice, CurrencyCode, TranValue, [TranDT]
	*/
GO
