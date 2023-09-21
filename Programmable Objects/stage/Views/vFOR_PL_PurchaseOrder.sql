IF OBJECT_ID('[stage].[vFOR_PL_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vFOR_PL_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vFOR_PL_PurchaseOrder]
	AS 
	
SELECT 
--------------------------------------------- Keys IDs ---------------------------------------------

CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#',TRIM(PurchaseOrderSubline))))) AS PurchaseOrderID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM('PurchaseInvoiceNum'))))) AS PurchaseInvoiceID -- Created a fake ID in order to avoid breaking the model due to null values in a field that is part of a relationship
,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(TRIM(Currency)))) AS CurrencyID
,UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum),'#',TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
, PartitionKey
--------------------------------------------- Regular Fields ---------------------------------------------
,UPPER(TRIM(Company)) AS Company
,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
,UPPER(TRIM(PurchaseOrderSubline)) AS PurchaseOrderSubline
,UPPER(TRIM(PartNum)) AS PartNum
,UPPER(TRIM(SupplierNum)) AS SupplierNum
,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
,iif(trim(PurchaseOrderDate) = '' or PurchaseOrderDate is null,cast('1900-01-01' as date), PurchaseOrderDate) as PurchaseOrderDate
,CONVERT(decimal(18,4), Replace(PurchaseOrderQty, ',', '.')) AS PurchaseOrderQty
,CONVERT(decimal(18,4), Replace(ReceiveQty, ',', '.')) AS ReceiveQty
--,CONVERT(decimal(18,4), Replace(qty, ',', '.')) AS InvoiceQty
,CONVERT(decimal(18,4), Replace(UnitPrice, ',', '.')) as UnitPrice
,CONVERT(decimal(18,4), Replace(ExchangeRate, ',', '.')) AS ExchangeRate
, Currency
, cast(IsClosed as bit) as IsClosed 

,cast(ActualDelivDate as date) as ActualDelivDate
,cast(CommittedDelivDate		as date) as CommittedDelivDate
,cast(OrgCommittedDelivDate		as date) as OrgCommittedDelivDate
,cast(CommittedShipDate			as date) as CommittedShipDate
,cast(OrgCommittedShipDate		as date) as OrgCommittedShipDate
,cast(OrgReqDelivDate			as date) as OrgReqDelivDate
,cast(DiscountAmount  as decimal(18,4)) as DiscountAmount
,cast(DiscountPercent as decimal(18,4)) as DiscountPercent

,PurchaserName
,DelivCustomerNum
,SupplierPartNum
,SupplierInvoiceNum
,UoM
,ReceivingNum
,Comments
,[PurchaseOrderType]
,PurchaseOrderStatus



FROM stage.FOR_PL_PurchaseOrder
GO
