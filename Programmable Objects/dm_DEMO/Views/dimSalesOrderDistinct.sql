IF OBJECT_ID('[dm_DEMO].[dimSalesOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_DEMO].[dimSalesOrderDistinct];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dm_DEMO].[dimSalesOrderDistinct] AS

SELECT  sod.[CompanyID]
,sod.[Company]
,sod.[SalesOrderNumID]
,sod.[SalesOrderNum]
,sod.[CustomerID]
,sod.[Customer]
,sod.[SalesPersonName]
,sod.[SalesChannel]
,sod.[AxInterSalesChannel]
,sod.[Department]
FROM dm.DimSalesOrderDistinct sod
where sod.Company = 'DEMO'
GO
