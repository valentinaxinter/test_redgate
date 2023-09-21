IF OBJECT_ID('[prestage].[TRA_FR_SOline_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[TRA_FR_SOline_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [prestage].[TRA_FR_SOline_Load] AS
BEGIN

Truncate table stage.[TRA_FR_SOline]

INSERT INTO 
	stage.TRA_FR_SOline 
	(PartitionKey, Company, PartNum, [SalesPersonName], [CustomerNum], [PartType], [SalesOrderNum], [SalesOrderLine], [SalesOrderSubLine], [SalesOrderType], [SalesInvoiceNum], [SalesInvoiceLine], [SalesInvoiceType], [SalesInvoiceDate], [ActualDelivDate], [SalesInvoiceQty], [UoM], [UnitPrice], [UnitCost], [DiscountPercent], [DiscountAmount], [TotalMiscChrg],[CashDiscountOffered], [CashDiscountUsed], [VATAmount], [Currency], [ExchangeRate], [CreditMemo], [SalesChannel], [Department], [WarehouseCode], [CostBearerNum], [CostUnitNum], [ReturnComment], [ReturnNum], [ProjectNum], [IndexKey], [SIRes1], [SIRes2], [SIRes3])
SELECT 
	PartitionKey, Company, PartNum, [SalesPersonName], [CustomerNum], [PartType], [SalesOrderNum], [SalesOrderLine], [SalesOrderSubLine], [SalesOrderType], [SalesInvoiceNum], [SalesInvoiceLine], [SalesInvoiceType], [SalesInvoiceDate], [ActualDelivDate], [SalesInvoiceQty], [UoM], [UnitPrice], [UnitCost], [DiscountPercent], [DiscountAmount], [TotalMiscChrg],[CashDiscountOffered], [CashDiscountUsed], [VATAmount], [Currency], [ExchangeRate], [CreditMemo], [SalesChannel], [Department], [WarehouseCode], [CostBearerNum], [CostUnitNum], [ReturnComment], [ReturnNum], [ProjectNum], [IndexKey], [SIRes1], [SIRes2], [SIRes3]
FROM 
	[prestage].[vTRA_FR_SOline]

--Truncate table prestage.[TRA_FR_SOline]

End
GO
