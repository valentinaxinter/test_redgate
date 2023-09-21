IF OBJECT_ID('[stage].[vCER_DK_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_DK_PurchaseOrder] AS
--COMMENT EMPTY FIELDS / ADD TRIM() INTO PartID,WarehouseID 2022-12-14 VA
--ADD TRIM() INTO SupplierID 23-01-23 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(PurchaseInvoiceNum)))) AS PurchaseOrderID --,'#',TRIM(UPPER([PartNum])), '#', TRIM(UPPER(SupplierCode)), '#', OrderedQty
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(OrderNum)))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(DelivCustomerNum))))) AS CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(DelivCustomerNum))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(SupplierNum))))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(trim(Company),'#',TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(Currency))) AS CurrencyID
	,UPPER(CONCAT(Company,'#',TRIM(SupplierNum),'#',OrderNum,'#',TRIM(PurchaseInvoiceNum))) AS PurchaseOrderCode
	,PartitionKey AS PartitionKey

	,Company AS Company
	,OrderNum AS PurchaseOrderNum
	,OrderLine AS PurchaseOrderLine
	,OrderSubLine AS PurchaseOrderSubLine
	,CASE WHEN WarehouseCode IN ('0','2D') THEN 'Dropshipment' END AS PurchaseOrderType
		
	,PurchaseOrderDate
	,CASE WHEN OpenRelease = '1' THEN 'Closed' 
		  ELSE  'Open' END AS  PurchaseOrderStatus
	,CASE WHEN OrgReqDelivDate <= '1900-01-01' or OrgReqDelivDate = '' or OrgReqDelivDate is null THEN '1900-01-01' 
	      ELSE OrgReqDelivDate END  AS OrgReqDelivDate
	,CASE WHEN CommitedDelivDate <= '1900-01-01' or CommitedDelivDate = '' or CommitedDelivDate is null THEN '1900-01-01' 
	      ELSE CommitedDelivDate END AS CommittedDelivDate
	,CASE WHEN ActualDeliveryDate <= '1900-01-01' or ActualDeliveryDate = '' or ActualDeliveryDate is null THEN '1900-01-01' 
	      ELSE ActualDeliveryDate END   AS ActualDelivDate
	,CASE WHEN ReqDelivDate <= '1900-01-01' or ReqDelivDate = '' or ReqDelivDate is null THEN '1900-01-01' 
	      ELSE ReqDelivDate END  AS ReqDelivDate
	,PurchaseInvoiceNum
	,TRIM(UPPER([PartNum])) AS PartNum
	,TRIM(UPPER(SupplierNum)) AS SupplierNum
	,SupplierPartNum
	--,'' AS [SupplierInvoiceNum] 
	,TRIM(DelivCustomerNum) AS DelivCustomerNum
	--,'' AS PartStatus
	,PurchaseOrderQty
	,PurchaseInvoiceQty	AS InvoiceQty
	,ReceiveQty
	,[PurchaseInvoiceQty]
	,MinOrderQty
	,UoM
	,UnitPrice
	,DiscountPercent
	,DiscountAmount
	,LandedCostPrice * PurchaseOrderQty  AS LandedCost
	,ExchangeRate
	,Currency
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	,ReceivingNum
	,DelivTime
	--,'' AS PurchaseChannel
	--,'' AS Documents
	,TRIM(Comments) AS Comments
	--,'' AS PORes1
	--,'' AS PORes2
	--,'' AS PORes3
	--
	--,'' AS [LineType]
	--,0 AS TotalMiscChrg
	--,'' AS ItemType
	--,'' AS DelivDate
	--,'' AS DaysSincePOrder
FROM 
	[stage].[CER_DK_PurchaseOrder]
	/*
GROUP BY
	PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine, SupplierCode, DelivCustCode, LineType, InvoiceNum, PartNum, OrderType, UnitPrice, DiscountPercent, OrderedQty, ReceivedQty, InvoicedQty, TotalMiscChrg, ExchangeRate, CurrencyCode, ItemType, OrderDate, OrgReqDelivDate, CommitedDelivDate, ActualDelivDate, DelivDate, ReqDelivDate, PurchaserName, RecievingNumber, LeadTime, Comments, WarehouseCode
	*/
GO
