IF OBJECT_ID('[dm_DEMO].[fctPurchaseOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_DEMO].[fctPurchaseOrderDistinct];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dm_DEMO].[fctPurchaseOrderDistinct] AS

SELECT  [PurchaseOrderNumID]
,[CompanyID]
,[SupplierID]
,[PurchaseOrderNum]
,[Company]
,[Supplier]

FROM dm.FactPurchaseOrderDistinct
WHERE Company  = 'DEMO'
GO
