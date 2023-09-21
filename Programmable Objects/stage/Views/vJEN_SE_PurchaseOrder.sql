IF OBJECT_ID('[stage].[vJEN_SE_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vJEN_SE_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vJEN_SE_PurchaseOrder] AS
--COMMENT EMPTY FIELDS / ADD UPPER() TRIM() CustomerID PartID,WarehouseID 2022-12-19 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderType), '#', TRIM(PartNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaserName), '#', IsOrderClosed)))) AS PurchaseOrderID -- was included in ID: , '#', TRIM(PurchaseDelivLine)", '#', TRIM(PurchaseOrderSubLine), '#', TRIM(InvoiceNum),'#',TRIM(UPPER([PartNum])), '#', TRIM(UPPER(SupplierCode)), '#', OrderedQty", '#', TRIM(InvoiceNum)
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', '')))) AS PurchaseInvoiceID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(DelivCustCode))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(DelivCustCode))))) AS CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(UPPER(SupplierCode)))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(UPPER([PartNum])))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Trim(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([CurrencyCode])))) AS CurrencyID
	,UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseOrderNum))) AS PurchaseOrderCode
	,PartitionKey

	,TRIM(UPPER(Company)) AS Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,TRIM(OrderType) AS PurchaseOrderType
	,TRIM(UPPER([PartNum])) AS PartNum
	,TRIM(UPPER(SupplierCode)) AS SupplierNum
	,TRIM(DelivCustCode) AS DelivCustomerNum
	,'' AS PurchaseInvoiceNum -- -- remove so avoid duplication / InvoiceNum and in the ID /DZ
	,OrderDate AS PurchaseOrderDate
	,MAX(OrgReqDelivDate) AS OrgReqDelivDate
	,MAX(DelivDate) AS DelivDate
	,MAX(ReqDelivDate) AS ReqDelivDate
	,MAX(CommitedDelivDate) AS CommittedDelivDate
	,MAX(ActualDelivDate) AS ActualDelivDate
	,SUM(OrderedQty) AS PurchaseOrderQty
	,SUM(ReceivedQty) AS ReceiveQty
	,SUM(InvoicedQty) AS InvoiceQty
--	,IIF(AVG(ReceivedQty) < AVG(OrderedQty), 'Open', 'Closed') AS PurchaseOrderStatus
	,IIF(IsOrderClosed = '1', 'Closed', 'Open') AS PurchaseOrderStatus
	,IsOrderClosed AS IsClosed
	--,'' AS SupplierPartNum
	--,'' AS [SupplierInvoiceNum] 
	--,'' AS PartStatus
	--,0 AS MinOrderQty
	--,'' AS UoM
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
	,CASE WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '0' THEN 'Stock Item Line' WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '1' THEN 'Non Stock Item Line' ELSE NULL END AS [LineType]
	,CONVERT(NVARCHAR(50),ItemType) AS ItemType
	,TRIM(Comments) AS Comments
	--,'' AS PurchaseChannel
	--,'' AS Documents
	--,'' AS PORes1
	--,'' AS PORes2
	--,'' AS PORes3
	--,'' AS DaysSincePOrder
FROM [stage].[JEN_SE_PurchaseOrder]
	
GROUP BY
	PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine, SupplierCode, DelivCustCode, LineType, PartNum, OrderType, CurrencyCode, ItemType, OrderDate, PurchaserName, RecievingNumber, LeadTime, Comments, WarehouseCode, IsOrderClosed
GO
