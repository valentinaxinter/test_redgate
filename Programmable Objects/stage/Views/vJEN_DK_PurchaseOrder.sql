IF OBJECT_ID('[stage].[vJEN_DK_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vJEN_DK_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vJEN_DK_PurchaseOrder] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO CustomerID,PartID,WarehouseID 22-12-29 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderType), '#', TRIM(PartNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', (IsOrderClosed))))) AS PurchaseOrderID --, '#', UnitPrice, '#', TRIM(WarehouseCode), '#', TRIM(SupplierCode), '#', TRIM(LineType), '#', TRIM(DelivCustCode), '#', OrderDate, '#', PurchaserName, '#', OrderedQty, '#', TRIM(PurchaseOrderSubLine), '#', TRIM(InvoiceNum)
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', '')))) AS PurchaseInvoiceID --TRIM(InvoiceNum)
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company ,'#', TRIM(DelivCustCode))))) AS CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',(CONCAT(Company,'#',TRIM(DelivCustCode))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierCode))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',(CONCAT(Company,'#',TRIM(SupplierCode))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',(CONCAT(Company,'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',(CONCAT(Company,'#',TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([CurrencyCode])))) AS CurrencyID
	,UPPER(CONCAT(Company,'#',SupplierCode,'#',PurchaseOrderNum)) AS PurchaseOrderCode
	,PartitionKey AS PartitionKey

	,TRIM(UPPER([Company])) AS Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,TRIM(OrderType) AS PurchaseOrderType
	,'' AS PurchaseInvoiceNum --TRIM(InvoiceNum)
	,OrderDate AS PurchaseOrderDate
	,MAX(OrgReqDelivDate) AS OrgReqDelivDate
	,MAX(DelivDate) AS DelivDate
	,MAX(ReqDelivDate) AS ReqDelivDate
	,MAX(CommitedDelivDate) AS CommittedDelivDate
	,MAX(ActualDelivDate) AS ActualDelivDate
	,TRIM(PartNum) AS PartNum
	,TRIM(SupplierCode) AS SupplierNum
	,TRIM(DelivCustCode) AS DelivCustomerNum
	,SUM(OrderedQty) AS PurchaseOrderQty
	,SUM(ReceivedQty) AS ReceiveQty
	,SUM(InvoicedQty) AS InvoiceQty
--	,IIF(AVG(ReceivedQty) < AVG(OrderedQty), 'Open', 'Closed') AS PurchaseOrderStatus
	,IIF(IsOrderClosed = '1', 'Closed', 'Open') AS PurchaseOrderStatus
	,IsOrderClosed AS IsClosed
	--,'' SupplierPartNum
	--,'' AS [SupplierInvoiceNum]
	--,'' AS PartStatus
	--,0 AS MinOrderQty
	--,'' AS UoM
	--,0 AS DiscountAmount
	--,0 AS LandedCost
	,AVG(UnitPrice) AS UnitPrice
	,AVG(IIF(UnitPrice*OrderedQty*ExchangeRate = 0, 0, 100*DiscountAmount/(UnitPrice*OrderedQty*ExchangeRate))) AS DiscountPercent --was DiscountPercent -- changed 20230227 /DZ
	,SUM(DiscountAmount) AS DiscountAmount --was UnitPrice*OrderedQty*DiscountPercent/100  -- changed 20230227 /DZ
	,SUM(TotalMiscChrg) AS TotalMiscChrg
	,AVG(ExchangeRate) AS ExchangeRate
	,CASE WHEN CurrencyCode = '15' THEN 'EUR' WHEN CurrencyCode = '2' THEN 'USD' ELSE CurrencyCode END AS Currency
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	,TRIM(RecievingNumber) AS ReceivingNum
	,IIF(LeadTime = 'na', NULL, Leadtime) AS DelivTime
	,TRIM(Comments) AS Comments
	--,'' AS PurchaseChannel
	--,'' Documents
	--,'' AS PORes1
	--,'' AS PORes2
	--,'' AS PORes3
	,CASE WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '0' THEN 'Stock Item Line' WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '1' THEN 'Non Stock Item Line' ELSE NULL END AS [LineType]
	,CONVERT(NVARCHAR(50),ItemType) AS ItemType
	--,'' AS DaysSincePOrder
	--,POHead.PHRes1 AS PHRes1
	--,POHead.PHRes2 AS PHRes2
	--,POHead.PHRes3 AS PHRes3
FROM 
	[stage].[JEN_DK_PurchaseOrder]
	
GROUP BY PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine, SupplierCode, DelivCustCode, LineType, PartNum, OrderType, CurrencyCode, ItemType, OrderDate, PurchaserName, RecievingNumber, LeadTime, Comments, WarehouseCode, IsOrderClosed
	--PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine, SupplierCode, DelivCustCode, LineType, InvoiceNum, PartNum, OrderType, UnitPrice, DiscountPercent, OrderedQty, ReceivedQty, InvoicedQty, TotalMiscChrg, ExchangeRate, CurrencyCode, ItemType, OrderDate, OrgReqDelivDate, CommitedDelivDate, ActualDelivDate, DelivDate, ReqDelivDate, PurchaserName, RecievingNumber, LeadTime, Comments, WarehouseCode
GO
