IF OBJECT_ID('[stage].[vCER_SE_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vCER_SE_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_SE_PurchaseOrder] AS
--COMMENT empty fields / ADD TRIM(Company) into PartID/CustomerID/WarehouseID VA - 12-13-2022
--ADD TRIM() INTO SupplierID 23-01-23 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(InvoiceNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine), '#', TRIM(OrderType), '#', UnitPrice, '#', TRIM(WarehouseCode), '#', TRIM(LineType), '#', TRIM(DelivCustCode), '#', OrderDate, '#', PurchaserName)))) AS PurchaseOrderID --,'#',TRIM(UPPER([PartNum])), '#', TRIM(UPPER(SupplierCode)), '#', OrderedQty
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(InvoiceNum))))) AS PurchaseInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(DelivCustCode))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierCode))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(UPPER(SupplierCode)))))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([CurrencyCode])))) AS CurrencyID
	--,UPPER(CONCAT(Company,'#',TRIM(UPPER(SupplierCode)),'#',PurchaseOrderNum,'#',TRIM(InvoiceNum))) AS PurchaseOrderCode
	,UPPER(CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine), '#', TRIM(InvoiceNum))) AS PurchaseOrderCode
	,PartitionKey AS PartitionKey

	,Company AS Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,TRIM(OrderType) AS PurchaseOrderType
	,OrderDate AS PurchaseOrderDate
	--,'' AS PurchaseOrderStatus
	,OrgReqDelivDate AS OrgReqDelivDate
	,CommitedDelivDate AS CommittedDelivDate
	,ActualDelivDate
	,ReqDelivDate AS ReqDelivDate
	,TRIM(InvoiceNum) AS PurchaseInvoiceNum
	,TRIM(UPPER([PartNum])) AS PartNum
	,TRIM(UPPER(SupplierCode)) AS SupplierNum
	--,'' AS SupplierPartNum
	--,'' AS [SupplierInvoiceNum] 
	,TRIM(DelivCustCode) AS DelivCustomerNum
	--,'' AS PartStatus
	,OrderedQty AS PurchaseOrderQty
	,ReceivedQty AS ReceiveQty
	,InvoicedQty AS InvoiceQty
	--,0 AS MinOrderQty
	--,'' AS UoM
	,UnitPrice AS UnitPrice
	,DiscountPercent AS DiscountPercent
	,UnitPrice*OrderedQty*DiscountPercent/100 AS DiscountAmount
	--,0 AS LandedCost
	,ExchangeRate
	,CASE WHEN CurrencyCode = '15' THEN 'EUR' WHEN CurrencyCode = '2' THEN 'USD' ELSE CurrencyCode END AS Currency
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	,RecievingNumber AS ReceivingNum
	,IIF(LeadTime = 'na', NULL, Leadtime) AS DelivTime
	--,'' AS PurchaseChannel
	,FlagLineConfirmed AS Documents-- added afer request of CertexSE Petter Walling ticket #inc-95188 and approved by Emil T /20230207 DZ
	,TRIM(Comments) AS Comments
	--,'' AS PORes1
	--,'' AS PORes2
	--,'' AS PORes3

	,CASE WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '0' THEN 'Stock Item Line' WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '1' THEN 'Non Stock Item Line' ELSE NULL END AS [LineType]
	,TotalMiscChrg AS TotalMiscChrg
	,CONVERT(NVARCHAR(50),ItemType) AS ItemType
	,DelivDate AS DelivDate
	--,'' AS DaysSincePOrder
FROM 
	[stage].[CER_SE_PurchaseOrder]
	
GROUP BY
	PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine, SupplierCode, DelivCustCode, LineType, InvoiceNum, PartNum, OrderType, UnitPrice, DiscountPercent, OrderedQty, ReceivedQty, InvoicedQty, TotalMiscChrg, ExchangeRate, CurrencyCode, ItemType, OrderDate, OrgReqDelivDate, CommitedDelivDate, ActualDelivDate, DelivDate, ReqDelivDate, PurchaserName, RecievingNumber, LeadTime, Comments, WarehouseCode, FlagLineConfirmed
GO
