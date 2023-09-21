IF OBJECT_ID('[stage].[vTRA_SE_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vTRA_SE_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vTRA_SE_PurchaseInvoice]
	AS select 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(SupplierNum))))) AS PurchaseInvoiceID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',upper(CONCAT(Company,'#',TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#')))) AS PurchaseOrderID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',upper(TRIM([Company])))) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([WarehouseCode]))))) AS WarehouseID,
	--CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum), '#', TRIM(journal))))) AS PurchaseLedgerID,
	CONVERT(int, replace(CONVERT(date, left(PurchaseInvoiceDate,10)),'-','')) AS PurchaseInvoiceDateID

	,PartitionKey
	,UPPER(Company) as Company
	,trim(PurchaseInvoiceNum) as PurchaseInvoiceNum
	,trim(PurchaseOrderNum) as PurchaseOrderNum
	,trim(PurchaseOrderLine) as PurchaseOrderLine
	,trim(PurchaseOrderType) as PurchaseOrderType
	,cast(PurchaseInvoiceDate as date) as PurchaseInvoiceDate
	,cast(ActualRecieveDate as date) as ActualRecieveDate
	,cast(IsInvoiceClosed as bit)  as IsInvoiceClosed
	,trim(SupplierNum) as SupplierNum
	,trim(PartNum) as PartNum
	,cast(PurchaseInvoiceQty as decimal(18,4)) as PurchaseInvoiceQty
	,cast(UnitPrice as decimal(18,4)) as UnitPrice
	,cast(DiscountPercent as decimal(18,4)) as DiscountPercent
	,cast(DiscountAmount as decimal(18,4)) as DiscountAmount
	,cast(VATAmount as decimal(18,4)) as VATAmount
	,cast(ExchangeRate as decimal(18,4)) as ExchangeRate
	,trim(upper(Currency)) as Currency
	,cast(IsCreditMemo as bit) as CreditMemo
	,trim(PurchaserName) as PurchaserName
	,trim(WarehouseCode) as WarehouseCode
	,cast(IsActiveRecord as bit) as IsActiveRecord
from stage.TRA_SE_PurchaseInvoice
;
GO
