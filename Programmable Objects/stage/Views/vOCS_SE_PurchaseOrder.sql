IF OBJECT_ID('[stage].[vOCS_SE_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vOCS_SE_PurchaseOrder]	AS 

SELECT 
-------------------------------------------- Keys/ IDs ---------------------------------------------
CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine))))) AS PurchaseOrderID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID
--,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(DelivCustomerNum))))) AS CustomerID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(TRIM(Currency)))) AS CurrencyID
,UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum),'#',TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
,PartitionKey AS PartitionKey

--------------------------------------------- Regular Fields ---------------------------------------------
---Mandatory Fields ---
,UPPER(TRIM(Company)) AS Company
,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
--,UPPER(TRIM(PurchaseOrderSubLine)) AS PurchaseOrderSubLine
,UPPER(TRIM(PartNum)) AS PartNum
,UPPER(TRIM(SupplierNum)) AS SupplierNum
,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
,CASE WHEN PurchaseOrderDate = '' OR PurchaseOrderDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, PurchaseOrderDate) END AS PurchaseOrderDate
,CONVERT(decimal(18,4), Replace(PurchaseOrderQty, ',', '.')) AS PurchaseOrderQty
,CONVERT(decimal(18,4), Replace(PurchaseReceiveQty, ',', '.')) AS ReceiveQty
,CONVERT(decimal(18,4), Replace(PurchaseInvoiceQty, ',', '.')) AS InvoiceQty
,CONVERT(decimal(18,4), Replace(UnitPrice, ',', '.')) AS UnitPrice
,CONVERT(decimal(18,4), Replace(ExchangeRate, ',', '.')) AS ExchangeRate
,UPPER(TRIM(Currency)) AS Currency
,TRIM(IsOrderClosed) AS IsClosed

---Valuable Fields ---
,UPPER(TRIM(PurchaseOrderType)) AS PurchaseOrderType
,UPPER(TRIM(PurchaseOrderStatus)) AS PurchaseOrderStatus
--,CASE WHEN OrgCommittedShipDate = '' OR OrgCommittedShipDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, OrgCommittedShipDate) END AS OrgCommittedShipDate
--,CASE WHEN CommittedShipDate = '' OR CommittedShipDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, CommittedShipDate) END AS CommittedShipDate
,CASE WHEN ActualShipDate = '' OR ActualShipDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, ActualShipDate) END AS ActualShipDate
,CASE WHEN OrgReqDelivDate = '' OR OrgReqDelivDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, OrgReqDelivDate) END AS OrgReqDelivDate
,CASE WHEN OrgCommittedDelivDate = '' OR OrgCommittedDelivDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, OrgCommittedDelivDate) END AS OrgCommittedDelivDate
,CASE WHEN CommittedDelivDate = '' OR CommittedDelivDate is NULL THEN TRY_CONVERT(date,'1900-01-01') ELSE TRY_CONVERT(date, CommittedDelivDate) END AS CommittedDelivDate
,CASE WHEN ActualDelivDate = '' OR ActualDelivDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, ActualDelivDate) END AS ActualDelivDate
,CONVERT(decimal(18,4), Replace(DiscountPercent, ',', '.')) AS DiscountPercent
,CONVERT(decimal(18,4), Replace(DiscountAmount, ',', '.')) AS DiscountAmount
,UPPER(TRIM(PurchaserName)) AS PurchaserName
,TRIM(PartStatus) AS PartStatus

--- Good-to-have Fields ---
,UPPER(TRIM(PurchaseInvoiceNum)) AS PurchaseInvoiceNum
,UPPER(TRIM(SupplierPartNum)) AS SupplierPartNum
,UPPER(TRIM(SupplierInvoiceNum)) AS SupplierInvoiceNum
--,UPPER(TRIM(DelivCustomerNum)) AS DelivCustomerNum
--,CONVERT(decimal(18,4), Replace(MinOrderQty, ',', '.')) AS MinOrderQty
,UPPER(TRIM(UoM)) AS UoM
--,UPPER(TRIM(ReceivingNum)) AS ReceivingNum
,TRIM(DelivTime) AS DelivTime
--,UPPER(TRIM(PurchaseChannel)) AS PurchaseChannel
--,CONVERT(decimal(18,4), Replace(LandedCost, ',', '.')) AS LandedCost
--,UPPER(TRIM(Documents)) AS Documents
--,UPPER(TRIM(Comments)) AS Comments

--------------------------------------------- Meta Data ---------------------------------------------
,CONVERT(date, ModifiedTimeStamp) AS ModifiedTimeStamp
,CONVERT(date, CreatedTimeStamp) AS CreatedTimeStamp
,TRIM(IsActiveRecord) AS IsActiveRecord

--------------------------------------------- Extra Fields ---------------------------------------------
--,UPPER(TRIM(PORes1)) AS PORes1
--,UPPER(TRIM(PORes2)) AS PORes2
--,UPPER(TRIM(PORes3)) AS PORes3

FROM [stage].[OCS_SE_PurchaseOrder]
GO
