IF OBJECT_ID('[dm_PT].[fctSalesOrder]') IS NOT NULL
	DROP VIEW [dm_PT].[fctSalesOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dm_PT].[fctSalesOrder] AS

SELECT 
 so.[SalesOrderID]
,so.[SalesOrderNumID]
,so.[CustomerID]
,so.[CompanyID]
,so.[PartID]
,so.[WarehouseID]
,so.[ProjectID]
,so.[SalesPersonNameID]
,so.[DepartmentID]
,so.[SalesOrderDateID]
,so.[Company]
,so.[CustomerNum]
,so.[SalesOrderNum]
,so.[SalesOrderLine]
,so.[SalesOrderSubLine]
,so.[SalesOrderType]
,so.[SalesOrderCategory]
,so.[SalesOrderDate]
,so.[NeedbyDate]
,so.[ExpDelivDate]
,so.[ConfirmedDelivDate]
,so.[SalesInvoiceNum]
,so.[SalesOrderQty]
,so.[DelivQty]
,so.[RemainingQty]
,so.[UoM]
,so.[UnitPrice]
,so.[UnitCost]
,so.[Currency]
,so.[ExchangeRate]
,so.[OpenRelease]
,so.[OrderStatus]
,so.[DiscountAmount]
,so.[DiscountPercent]
,so.[PartNum]
,so.[PartType]
,so.[PartStatus]
,so.[SalesPersonName]
,so.[WarehouseCode]
,so.[SalesChannel]
,so.[AxInterSalesChannel]
,so.[Department]
,so.[ProjectNum]
,so.[ActualDelivDate]
,so.[SalesInvoiceQty]
,so.[TotalMiscChrg]
,so.[IsUpdatingStock]
,so.[SORes1]
,so.[SORes2]
,so.[SORes3]
,so.[SORes4]
,so.[SORes5]
,so.[SORes6]
FROM dm.FactSalesOrder so
LEFT JOIN dbo.Company com ON so.Company = com.Company
WHERE com.BusinessArea = 'Power Transmission Solutions' AND com.[Status] = 'Active'

--WHERE [Company] in ('SVESE', 'ACZARKOV', 'AcornUK', 'BSIBELL', 'JDKJENSS', 'JDKKALTE', 'JFIJENSS', 'MNLMAK', 'JNOJENSS', 'NORNO', 'JSEJENSS', 'SSWSE', 'NomoSE', 'NomoDK', 'NomoFI', 'NomoNo', 'PASSEROT', 'SKSSCOFI', 'SCOFI', 'SMKFI', 'SNLSPRUI', 'SPRUITNL')  -- The PT basket 

 --AND SalesOrderDate >= DATEADD(YEAR,-5, GETDATE()) --Added to decrease SSAS memory usage /SM 2021-04-26
-- The PT basket
-- 'ACZARKOV', 'AUKACOR', 'BSIBELL', 'JDKJENSS', 'JDKKALTE', 'JFIJENSS', 'JNOJENSS', 'JNOORBEL', 'JSEJENSS', 'JSESKSSW', 'MNLMAK', 'NomoSE', 'NomoDK', 'NomoFI', 'NomoNo', 'PASSEROT', 'SKSSCOFI', 'SCOFI', 'SMKFI', 'SNLSPRUI', 'SVESE'
--GROUP BY   -- Aggregate those fields in dw.FactOrder which have more than one values, such as different NeedbyDate & DelivDate and different discountPercent, left over fields should by in GROUP BY
GO
