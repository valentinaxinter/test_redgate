IF OBJECT_ID('[prestage].[TRA_FR_PurchaseInvoice_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[TRA_FR_PurchaseInvoice_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [prestage].[TRA_FR_PurchaseInvoice_Load] AS
BEGIN

Truncate table stage.[TRA_FR_PurchaseInvoice]

INSERT INTO 
	stage.TRA_FR_PurchaseInvoice 
	(PartitionKey, Company, [PurchaseOrderNum], [PurchaseOrderLine], [PurchaseOrderSubLine], [PurchaseInvoiceNum], [PurchaseInvoiceLine], [PurchaseInvoiceType], [PurchaseInvoiceDate], [ActualDelivDate], [SupplierNum], [PartNum], [PurchaseInvoiceQty], [UoM], [UnitPrice], [DiscountPercent], [DiscountAmount], [TotalMiscChrg], [VATAmount], [ExchangeRate], [Currency], [CreditMemo], [PurchaserName], [WarehouseCode], [PurchaseChannel], [Comment], [PIRes1], [PIRes2], [PIRes3])
SELECT 
	PartitionKey, Company, [PurchaseOrderNum], [PurchaseOrderLine], [PurchaseOrderSubLine], [PurchaseInvoiceNum], [PurchaseInvoiceLine], [PurchaseInvoiceType], [PurchaseInvoiceDate], [ActualDelivDate], [SupplierNum], [PartNum], [PurchaseInvoiceQty], [UoM], [UnitPrice], [DiscountPercent], [DiscountAmount], [TotalMiscChrg], [VATAmount], [ExchangeRate], [Currency], [CreditMemo], [PurchaserName], [WarehouseCode], [PurchaseChannel], [Comment], [PIRes1], [PIRes2], [PIRes3]
FROM 
	[prestage].[vTRA_FR_PurchaseInvoice]

--Truncate table prestage.[TRA_FR_PurchaseInvoice]

End
GO
