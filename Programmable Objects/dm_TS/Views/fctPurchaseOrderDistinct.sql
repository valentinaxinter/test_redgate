IF OBJECT_ID('[dm_TS].[fctPurchaseOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_TS].[fctPurchaseOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [dm_TS].[fctPurchaseOrderDistinct] AS


SELECT pod.[PurchaseOrderNumID]
,pod.[CompanyID]
,pod.[SupplierID]
,pod.[PurchaseOrderNum]
,pod.[Company]
,pod.[Supplier]

FROM dm.FactPurchaseOrderDistinct as pod

WHERE pod.Company  in ('FESFORA', 'FSEFORA', 'FFRFORA', 'FFRGPI', 'FFRLEX', 'IFIWIDN', 'IEEWIDN', 'TMTFI', 'TMTEE', 'FITMT', 'EETMT', 'ABKSE', 'ROROSE','STESE')  -- TS basket by 2021-08-05
GO
