IF OBJECT_ID('[stage].[vCER_DE_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vCER_DE_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [stage].[vCER_DE_PurchaseInvoice]
as
--ADD TRIM() UPPER() INTO PartID,WarehouseID  2023-01-03 VA
--ADD TRIM() into SupplierID 23-01-23 VA
select 
CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PurchaseInvoiceNum), '#',PurchaseInvoiceLine,'#', TRIM(PartNum)))) AS PurchaseInvoiceID, --TRIM(PurchaseInvoiceLine)
Company,
PurchaseOrderNum,
PurchaseOrderLine,
PurchaseOrderSubLine,
PurchaseOrderType,
PurchaseInvoiceNum,
PurchaseInvoiceLine,
PurchaseInvoiceType,
PurchaseInvoiceDate,
ActualDelivDate,
SupplierNum,
PartNum,
PurchaseInvoiceQty,
UoM,
case 
	when cast(UnitPrice as decimal(18,4)) = cast(VATAmount as decimal(18,4)) then 0
	else UnitPrice
end as UnitPrice,
DiscountPercent,
DiscountAmount,
TotalMiscChrg,
VATAmount,
ExchangeRate,
Currency,
CreditMemo,
--null as PurchaserName,
WarehouseCode,
PurchaseChannel,
PIRes1,
PIRes2,
PIRes3,
CONCAT(TRIM(Company),'#',TRIM(PurchaseInvoiceNum), '#', PurchaseInvoiceLine) AS PurchaseInvoiceCode,
UPPER(CONCAT(Company,'#',SupplierNum,'#',PurchaseOrderNum,'#',TRIM(PurchaseInvoiceNum))) AS PurchaseOrderCode,
CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID,
CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',  TRIM(PurchaseOrderNum),'#',PurchaseOrderLine,'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseOrderID,
CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(SupplierNum))))) AS SupplierID,
--CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',SupplierNum)))) AS SupplierID,
CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID,
CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID,
--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(PartNum)))) AS PartID,
CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID,
--CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(WarehouseCode))))) AS WarehouseID,
CONVERT(int, replace(PurchaseInvoiceDate,'-','')) AS PurchaseInvoiceDateID,
CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', SupplierNum, '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseLedgerID,
PartitionKey,
Comments AS Comment
FROM stage.CER_DE_PurchaseInvoice
GO
