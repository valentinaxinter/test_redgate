IF OBJECT_ID('[dm_IN].[fctPurchaseOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_IN].[fctPurchaseOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_IN].[fctPurchaseOrderDistinct] AS

SELECT pod.[PurchaseOrderNumID]
,pod.[CompanyID]
,pod.[SupplierID]
,pod.[PurchaseOrderNum]
,pod.[Company]
,pod.[Supplier]

FROM dm.FactPurchaseOrderDistinct as pod
WHERE pod.Company  in ('OCSSE')
GO
