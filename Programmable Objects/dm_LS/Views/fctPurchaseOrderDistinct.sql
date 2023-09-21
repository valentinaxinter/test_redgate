IF OBJECT_ID('[dm_LS].[fctPurchaseOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_LS].[fctPurchaseOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [dm_LS].[fctPurchaseOrderDistinct] AS

SELECT pod.[PurchaseOrderNumID]
,pod.[CompanyID]
,pod.[SupplierID]
,pod.[PurchaseOrderNum]
,pod.[Company]
,pod.[Supplier]

FROM dm.FactPurchaseOrderDistinct as pod
WHERE pod.Company  in ('AFISCM', 'CDKCERT', 'CEECERT', 'CFICERT', 'CLTCERT', 'CLVCERT', 'CSECERT', 'CUKCERT', 'CNOEHAU', 'CNOCERT', 'CERPL', 'CyESA', 'HFIHAKL', 'TRACLEV')  -- LS basket
GO
