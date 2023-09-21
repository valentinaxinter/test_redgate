IF OBJECT_ID('[prestage].[TRA_FR_Oline_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[TRA_FR_Oline_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [prestage].[TRA_FR_Oline_Load] AS
BEGIN

Truncate table stage.[TRA_FR_Oline]

INSERT INTO 
	stage.TRA_FR_Oline 
	(PartitionKey, Company, PartNum, [SalesPersonName], [CustomerNum], [PartType], [SalesOrderNum], [SalesOrderLine], [SalesOrderSubLine], [SalesOrderType], [SalesOrderCategory], [SalesOrderStatus], [SalesOrderDate], [NeedbyDate], [ExpDelivDate], [ActualDelivDate], [SalesInvoiceNum],[SalesOrderQty], [DelivQty], [RemainingQty], [UoM], [UnitPrice], [UnitCost], [Currency], [ExchangeRate], [DiscountPercent], [DiscountAmount], [WarehouseCode], [IndexKey])
SELECT 
	PartitionKey, Company, PartNum, [SalesPersonName], [CustomerNum], [PartType], [SalesOrderNum], [SalesOrderLine], [SalesOrderSubLine], [SalesOrderType], [SalesOrderCategory], [SalesOrderStatus], [SalesOrderDate], [NeedbyDate], [ExpDelivDate], [ActualDelivDate], [SalesInvoiceNum],[SalesOrderQty], [DelivQty], [RemainingQty], [UoM], [UnitPrice], [UnitCost], [Currency], [ExchangeRate], [DiscountPercent], [DiscountAmount], [WarehouseCode], [IndexKey]
FROM 
	[prestage].[vTRA_FR_Oline]

--Truncate table prestage.[TRA_FR_Oline]

End
GO
