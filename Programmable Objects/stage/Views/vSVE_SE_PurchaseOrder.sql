IF OBJECT_ID('[stage].[vSVE_SE_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vSVE_SE_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSVE_SE_PurchaseOrder] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(UPPER([PartNum])))))) AS PurchaseOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', '')))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', '')))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM([PartNum])) AS PartNum
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,TRIM(PurchaseOrderType) AS PurchaseOrderType
	,IsOrderClosed AS PurchaseOrderStatus
	,TRY_CONVERT(Date, PurchaseOrderDate) as PurchaseOrderDate
--	,CONVERT(Date, OrgReqDelivDate) AS OrgReqDelivDate
--	,CONVERT(Date, CommittedDelivDate) AS CommittedDelivDate
	,TRY_CONVERT(Date, ActualDelivDate) as ActualDelivDate
--	,CONVERT(Date, ReqDelivDate) AS ReqDelivDate
--	,CONVERT(Date, '1900-01-01') AS DelivDate
--	,CONVERT(Date, OrgCommittedDelivDate) AS OrgCommittedDelivDate
--	,CONVERT(Date, OrgCommittedShipDate) AS OrgCommittedShipDate
--	,CONVERT(Date, ActualShipDate) AS ActualShipDate
--	,CONVERT(Date, CommittedShipDate) AS CommittedShipDate
	--,'' AS PurchaseInvoiceNum
	--,'' AS SupplierInvoiceNum
	,TRIM(SupplierPartNum) AS SupplierPartNum
	,TRIM(DelivCustomerNum) AS DelivCustomerNum
	,TRIM(PartStatus) AS PartStatus
	,PurchaseOrderQty
	,PurchaseReceiveQty AS ReceiveQty
	,PurchaseInvoiceQty AS InvoiceQty
	--,NULL AS MinOrderQty
	,TRIM(UoM) AS UoM
--	,UnitPrice AS UnitPrice
	,IIF(CONVERT(decimal(18,4), ExchangeRate) = 0, UnitPrice, UnitPrice/CONVERT(decimal(18,4), ExchangeRate)) AS UnitPrice
	,LandedCost
	--,NULL AS DiscountPercent
	--,NULL AS DiscountAmount
	--,NULL AS TotalMiscChrg
	,IIF(Currency IN ('SEK'), 1, ExchangeRate) AS ExchangeRate
	,TRIM(Currency) AS Currency
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(ReceivingNum) AS ReceivingNum
	,DelivTime AS DelivTime
	,TRIM(PurchaseChannel) AS PurchaseChannel
	,TRIM(Documents) AS Documents
	,TRIM(Comments) AS Comments
	,TRIM(CreatedTimeStamp) AS PORes1
	,TRIM(ModifiedTimeStamp) AS PORes2
	,'' AS PORes3
FROM 
	[stage].[SVE_SE_PurchaseOrder]
WHERE PurchaseOrderType NOT IN ('KED', 'T', 'E')
	
--GROUP BY
--	PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine, SupplierCode, DelivCustCode, LineType, InvoiceNum, PartNum, OrderType, UnitPrice, DiscountPercent, OrderedQty, ReceivedQty, InvoicedQty, TotalMiscChrg, ExchangeRate, CurrencyCode, ItemType, OrderDate, OrgReqDelivDate, CommitedDelivDate, ActualDelivDate, DelivDate, ReqDelivDate, PurchaserName, RecievingNumber, LeadTime, Comments, WarehouseCode
GO
