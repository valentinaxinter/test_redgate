IF OBJECT_ID('[stage].[vNOM_DK_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vNOM_DK_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vNOM_DK_PurchaseOrder] AS
--ADD TRIM() INTO PartID,CustomerID 23-01-05 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseOrderID
	,UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Currency)))) AS CurrencyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(DelivCustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(DelivCustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,PartitionKey AS PartitionKey

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
	,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
	,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderSubLine
	,TRIM(PurchaseOrderType) AS PurchaseOrderType
	,PurchaseOrderDate
	,PurchaseOrderStatus
	,OpenRelease
	,OrgReqDelivDate
	,CommittedDelivDate
	,ActualDelivDate
	,ReqDelivDate
	,UPPER(TRIM(PurchaseInvoiceNum)) AS [PurchaseInvoiceNum]
	,UPPER(TRIM(PartNum)) AS PartNum
	,UPPER(TRIM(SupplierNum)) AS [SupplierNum]
	,TRIM(SupplierPartNum) AS SupplierPartNum
	,TRIM(SupplierInvoiceNum) AS SupplierInvoiceNum
	,TRIM(DelivCustomerNum) AS [DelivCustomerNum]
	,PartStatus
	,PurchaseOrderQty
	,ReceiveQty
	,PurchaseInvoiceQty AS InvoiceQty
	,MinOrderQty
	,[UoM]
	,UnitPrice
	,DiscountPercent
	,DiscountAmount
	,LandedCost
	,ExchangeRate
	,Currency
	,TRIM(PurchaserName) AS PurchaserName
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,TRIM(RecievingNum) AS ReceivingNum
	,DelivTime
	,PurchaseChannel
	,Documents
	,TRIM(Comments) AS Comments
	,PORes1 
	,PORes2 
	,PORes3
FROM 
	[stage].[NOM_DK_PurchaseOrder]
	
GROUP BY
	PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, SupplierNum, DelivCustomerNum, PurchaseOrderStatus, PurchaseInvoiceNum, PartNum, OpenRelease, PurchaseOrderType, UnitPrice, PurchaseOrderQty, ReceiveQty, PurchaseInvoiceQty, MinOrderQty, UoM,  ExchangeRate, Currency, PurchaseOrderDate, ActualDelivDate, OrgReqDelivDate, CommittedDelivDate, ReqDelivDate, PurchaserName, WarehouseCode, DiscountPercent, DiscountAmount, RecievingNum, DelivTime, DelivTimeWorkDays, PurchaseChannel, SupplierPartNum, SupplierInvoiceNum,PartStatus,Documents, Comments, PORes1, PORes2, PORes3, LandedCost --, SysRowID, LeadTime
GO
