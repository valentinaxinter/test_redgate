IF OBJECT_ID('[dm_ALL].[fctPurchaseOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_ALL].[fctPurchaseOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_ALL].[fctPurchaseOrderDistinct] AS

SELECT  [PurchaseOrderNumID]
,[CompanyID]
,[SupplierID]
,[PurchaseOrderNum]
,[Company]
,[Supplier]

FROM dm.FactPurchaseOrderDistinct
GO
