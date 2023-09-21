IF OBJECT_ID('[dm_DS].[fctPurchaseOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_DS].[fctPurchaseOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_DS].[fctPurchaseOrderDistinct] AS

SELECT  [PurchaseOrderNumID]
,[CompanyID]
,[SupplierID]
,[PurchaseOrderNum]
,[Company]
,[Supplier]

FROM dm.FactPurchaseOrderDistinct
WHERE Company  in ('MIT', 'ATZ', 'TRANSAUTO', 'IPLIOWTR')  -- DS basket
GO
