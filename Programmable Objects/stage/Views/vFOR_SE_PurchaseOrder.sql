IF OBJECT_ID('[stage].[vFOR_SE_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_SE_PurchaseOrder] AS
--COMMENT EMPTY FIELDS 2022-12-20 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine))))) AS PurchaseOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(InvoiceNum))))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(DelivCustCode))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([CurrencyCode])))) AS CurrencyID
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierCode),'#',TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#',TRIM(PurchaseOrderSubLine) )) AS PurchaseOrderCode
	,PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
	,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
	,UPPER(TRIM(PurchaseOrderSubLine)) AS PurchaseOrderSubLine
	,TRIM(OrderType) AS PurchaseOrderType
	,CASE WHEN InvoiceNum IS NULL or InvoiceNum = '' THEN 'Open' ELSE 'Closed' END AS PurchaseOrderStatus --DZ 20210806
--	,PurchaseOrderStatus
	,OrderDate AS PurchaseOrderDate
	,OrgReqDelivDate AS OrgReqDelivDate
	,CommitedDelivDate AS CommittedDelivDate
	,ActualDelivDate AS ActualDelivDate
	,DelivDate AS DelivDate
	,ReqDelivDate AS ReqDelivDate
	,UPPER(TRIM(InvoiceNum)) AS PurchaseInvoiceNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,UPPER(TRIM(SupplierCode)) AS SupplierNum
	,SupplierPartNum
	--,'' AS [SupplierInvoiceNum]
	,UPPER(TRIM(DelivCustCode)) AS DelivCustomerNum
	--,'' AS PartStatus
	,OrderedQty AS PurchaseOrderQty
	,ReceivedQty AS ReceiveQty
	,InvoicedQty AS InvoiceQty
	,MinOrderQty
	--,'' AS UoM
	,UnitPrice AS UnitPrice
	,DiscountPercent AS DiscountPercent
	,0 AS DiscountAmount
	,LandedCostPercent/100.0 * InvoicedQty * UnitPrice AS LandedCost 
	,ExchangeRate
	,CurrencyCode AS Currency
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	--,'' AS ReceivingNum
	,LeadTime AS DelivTime
	--,'' AS PurchaseChannel
	,Documents
	,TRIM(Comments) AS Comments
	--,'' AS PORes1
	--,'' AS PORes2
	--,'' AS PORes3
	,CASE WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '0' THEN 'Stock Item Line' WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '1' THEN 'Non Stock Item Line' ELSE NULL END AS [LineType]
	,TotalMiscChrg AS TotalMiscChrg
	,CONVERT(NVARCHAR(50),ItemType) AS ItemType
	--,'' AS DaysSincePOrder
	--,POLine.PORes1 AS PORes1
	--,POLine.PORes2 AS PORes2
	--,POLine.PORes3 AS PORes3
	--,POHead.PHRes1 AS PHRes1
	--,POHead.PHRes2 AS PHRes2
	--,POHead.PHRes3 AS PHRes3
FROM 
	[stage].[FOR_SE_PurchaseOrder]
	/*
GROUP BY
	PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine,PurchaseOrderStatus,  SupplierCode, DelivCustCode, LineType, InvoiceNum, PartNum, SupplierPartNum, OrderType, UnitPrice, OrderedQty, ReceivedQty, InvoicedQty, MinOrderQty, TotalMiscChrg, LandedCostPercent, ExchangeRate, CurrencyCode, ItemType, OrderDate, OrgReqDelivDate, CommitedDelivDate, ReqDelivDate, PurchaserName, Documents, Comments, WarehouseCode --, DelivDate,  LeadTime, ActualDelivDate, DiscountPercent
	*/
GO
