IF OBJECT_ID('[dm_FH].[fctPurchaseOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_FH].[fctPurchaseOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_FH].[fctPurchaseOrderDistinct] AS

SELECT  pod.[PurchaseOrderNumID]
,pod.[CompanyID]
,pod.[SupplierID]
,pod.[PurchaseOrderNum]
,pod.[Company]
,pod.[Supplier]

FROM dm.FactPurchaseOrderDistinct pod
LEFT JOIN dbo.Company com ON pod.Company = com.Company
WHERE com.BusinessArea = 'Fluid Handling Solutions' AND com.[Status] = 'Active'
GO
