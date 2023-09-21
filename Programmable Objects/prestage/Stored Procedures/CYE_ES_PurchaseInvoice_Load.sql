IF OBJECT_ID('[prestage].[CYE_ES_PurchaseInvoice_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[CYE_ES_PurchaseInvoice_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [prestage].[CYE_ES_PurchaseInvoice_Load] AS

BEGIN

Truncate table stage.[CYE_ES_PurchaseInvoice]

insert into stage.CYE_ES_PurchaseInvoice(
	PartitionKey,
	[Company],
	PurchaseOrderNum,
	PurchaseOrderLine,
	PurchaseOrderSubLine,
	PurchaseOrderType,
	PurchaseInvoiceNum,
	PurchaseInvoiceLine,
	PurchaseInvoiceType,
	PurchaseInvoiceDate,
	ActualDelivDate,
	[SupplierNum],
	[PartNum],
	PurchaseInvoiceQty,
	UoM,
	[UnitPrice],
	DiscountPercent,
	DiscountAmount,
	TotalMiscChrg,
	VATAmount,
	ExchangeRate,
	Currency,
	CreditMemo,
	PurchaserName,
	WarehouseCode,
	PurchaseChannel,
	Comment,
	PIRes1,
	PIRes2,
	PIRes3
)
select 
	PartitionKey,
	'CyESA',
	PurchaseOrderNum,
	PurchaseOrderLine,
	PurchaseOrderSubLine,
	PurchaseOrderType,
	PurchaseInvoiceNum,
	PurchaseInvoiceLine,
	PurchaseInvoiceType,
	PurchaseInvoiceDate,
	ActualDelivDate,
	[SupplierNum],
	[PartNum],
	PurchaseInvoiceQty,
	UoM,
	[UnitPrice],
	DiscountPercent,
	DiscountAmount,
	TotalMiscChrg,
	VATAmount,
	ExchangeRate,
	Currency,
	CreditMemo,
	PurchaserName,
	WarehouseCode,
	PurchaseChannel,
	Comment,
	PIRes1,
	PIRes2,
	PIRes3
from [prestage].[vCYE_ES_PurchaseInvoice]

--Truncate table prestage.[CYE_ES_POLine] --Two loads in LSSourceTables_CYESA_dev uses the same prestage. Truncating would create conflicts. /SM 2022-02-23

End
GO
