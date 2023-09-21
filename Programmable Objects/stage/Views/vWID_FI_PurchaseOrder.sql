IF OBJECT_ID('[stage].[vWID_FI_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vWID_FI_PurchaseOrder] AS
--COMMENT EMPTY FIELDS/ ADD UPPER()TRIM() INTO PartID 2022-12-15 VA
--ADD TRIM() UPPER() INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PartNum), '#', TRIM(InvoiceNum)))) AS PurchaseOrderID 

	,CONCAT(Company,'#',TRIM(SupplierCode),'#',TRIM(PurchaseOrderNum), '#', TRIM(PartNum), '#', TRIM(InvoiceNum)) AS PurchaseOrderCode

	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(PurchaseOrderNum)))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(InvoiceNum)))) AS PurchaseInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Currency]))) AS CurrencyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(DelivCustCode))))) AS CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(DelivCustCode)))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierCode))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(SupplierCode)))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(PartNum)))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID
	,PartitionKey

	,Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,TRIM(OrderType) AS PurchaseOrderType
	,OrderDate AS PurchaseOrderDate
	,CASE WHEN InvoiceNum IS NULL or InvoiceNum = '' THEN 'Open' ELSE 'Closed' END AS PurchaseOrderStatus --DZ 20210806
	,OriginalCommittedDD AS OrgReqDelivDate
	,CommittedDelivDate
	,ActualDelivDate
	,ReqDelivDate
	,TRIM(InvoiceNum) AS PurchaseInvoiceNum
	,TRIM(PartNum) AS PartNum
	,TRIM(SupplierCode) AS SupplierNum
	,TRIM(PartNum) AS SupplierPartNum
	,TRIM(InvoiceNum) AS SupplierInvoiceNum
	,TRIM(DelivCustCode) AS DelivCustomerNum
	--,NULL AS PartStatus
	,OrderedQty AS PurchaseOrderQty
	,ReceivedQty AS ReceiveQty
	,InvoicedQty AS InvoiceQty
	--,NULL AS MinOrderQty
	--,'' AS UoM
	,UnitPrice
	,DiscountPercent
	,InvoicedQty*UnitPrice*DiscountPercent/100 AS DiscountAmount
	--,NULL AS LandedCost
	,ExchangeRate
	,CASE WHEN Currency = '15' THEN 'EUR' WHEN Currency = '2' THEN 'USD' ELSE Currency END AS Currency
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	,RecievingNumber AS ReceivingNum
	,LeadTime AS DelivTime
	--,NULL AS PurchaseChannel
	,CONVERT(NVARCHAR(50),ItemType) AS Documents
	,TRIM(Comments) AS Comments
--	,DelivDate
--	,CASE WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '0' THEN 'Stock Item Line' WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '1' THEN 'Non Stock Item Line' ELSE NULL END AS [LineType]
	--,'' AS PORes1
	--,'' AS PORes2
	--,'' AS PORes3
FROM 
	[stage].[WID_FI_PurchaseOrder]
	
--GROUP BY
--	PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine, SupplierCode, DelivCustCode, LineType, InvoiceNum, PartNum, OrderType, UnitPrice, DiscountPercent, OrderedQty, ReceivedQty, InvoicedQty, TotalMiscChrg, ExchangeRate, Currency, ItemType, OrderDate, OrgReqDelivDate, CommittedDelivDate, ActualDelivDate, DelivDate, ReqDelivDate, PurchaserName, RecievingNumber, LeadTime, Comments, WarehouseCode, InvoiceSupplierCode
GO
