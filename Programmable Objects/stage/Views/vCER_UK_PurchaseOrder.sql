IF OBJECT_ID('[stage].[vCER_UK_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vCER_UK_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vCER_UK_PurchaseOrder] AS
--change ID creation 2023-08-24 VA
SELECT
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine), '#', TRIM(WarehouseCode), '#', TRIM(PurchaserName))))) AS PurchaseOrderID 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#',TRIM(InvoiceNum))))) AS PurchaseOrderID
		--,'#',TRIM(UPPER([PartNum])), '#', TRIM(UPPER(SupplierCode)), '#', OrderedQty
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', '')))) AS PurchaseInvoiceID --TRIM(InvoiceNum)
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(DelivCustCode))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([CurrencyCode])))) AS CurrencyID
	,UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine))) AS PurchaseOrderCode --, '#', TRIM(InvoiceNum)
	,PartitionKey AS PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,TRIM(OrderType) AS PurchaseOrderType
	,MAX(OrderDate) AS PurchaseOrderDate
	,MAX(PurchaseOrderStatus) AS PurchaseOrderStatus
	,MAX(OrgReqDelivDate) AS OrgReqDelivDate
	,MAX(CommitedDelivDate) AS CommittedDelivDate
	,MAX(ActualDelivDate) AS ActualDelivDate
	,MAX(ReqDelivDate) AS ReqDelivDate
	,MAX(DelivDate) AS DelivDate
	,TRIM(InvoiceNum) AS PurchaseInvoiceNum --TRIM(InvoiceNum)
	,TRIM(UPPER([PartNum])) AS PartNum
	,TRIM(UPPER(SupplierCode)) AS SupplierNum
	--,'' AS SupplierPartNum
	--,'' AS [SupplierInvoiceNum] 
	,TRIM(DelivCustCode) AS DelivCustomerNum
	--,'' AS PartStatus
	,MAX(OrderedQty) AS PurchaseOrderQty
	,SUM(ReceivedQty) AS ReceiveQty
	,SUM(InvoicedQty) AS InvoiceQty
	--,0 AS MinOrderQty
	--,'' AS UoM
	,AVG(UnitPrice) AS UnitPrice
	,AVG(DiscountPercent) AS DiscountPercent
	,SUM(DiscountAmount) AS DiscountAmount
	--,0 AS LandedCost
	,CONVERT(decimal(18,5), IIF(AVG(ExchangeRate) = 0, 0, 1/AVG(ExchangeRate))) AS ExchangeRate --should be from original currency (eg. SEK) to local (=EUR)
	,CASE WHEN CurrencyCode = '15' THEN 'EUR' WHEN CurrencyCode = '2' THEN 'USD' ELSE CurrencyCode END AS Currency
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	,TRIM(RecievingNumber) AS ReceivingNum
	,IIF(LeadTime = 'na', NULL, Leadtime) AS DelivTime
	--,'' AS PurchaseChannel
	,FlagLineConfirmed AS Documents-- added afer request of CertexSE Petter Walling ticket #inc-95188 and approved by Emil T /20230207 DZ
	,MAX(TRIM(Comments)) AS Comments
	,CASE WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '0' THEN 'Stock Item Line' WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '1' THEN 'Non Stock Item Line' ELSE NULL END AS [LineType]
	,SUM(TotalMiscChrg) AS TotalMiscChrg
	,CONVERT(NVARCHAR(50), ItemType) AS ItemType
	,MAX(IIF(InvoiceNum != ' ', 1, 0)) AS IsClosed
	--,'' AS DaysSincePOrder
	--,'' AS PORes1
	--,'' AS PORes2
	--,'' AS PORes3
FROM 
	[stage].[CER_UK_PurchaseOrder]
WHERE 	TRIM(InvoiceNum) != 'DELETED'
GROUP BY
	PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine, SupplierCode, DelivCustCode, LineType, PartNum, OrderType, CurrencyCode, ItemType
	,  PurchaserName, RecievingNumber, LeadTime, WarehouseCode, FlagLineConfirmed, InvoiceNum
	--OrderDate, OrgReqDelivDate, CommitedDelivDate, ActualDelivDate, DelivDate, ReqDelivDate, , UnitPrice, DiscountPercent, OrderedQty, ReceivedQty, InvoicedQty, TotalMiscChrg, ExchangeRate, InvoiceNum, Comments, PurchaseOrderStatus
GO
