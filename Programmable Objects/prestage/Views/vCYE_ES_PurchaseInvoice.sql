IF OBJECT_ID('[prestage].[vCYE_ES_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [prestage].[vCYE_ES_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [prestage].[vCYE_ES_PurchaseInvoice] AS
SELECT
	CONVERT(nvarchar(50), CONCAT(CONVERT (date, SYSDATETIME()), ' 00:00:00')) AS PartitionKey,
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
	'0' AS CreditMemo,
	PurchaserName,
	WarehouseCode,
	PurchaseChannel,
	Comment,
	PIRes1,
	PIRes2,
	PIRes3
FROM [prestage].CYE_ES_PurchaseInvoice
GO
