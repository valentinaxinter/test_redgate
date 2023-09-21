IF OBJECT_ID('[dm_IN].[dimSalesOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_IN].[dimSalesOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dm_IN].[dimSalesOrderDistinct] AS

SELECT sod.[CompanyID]
,sod.[Company]
,sod.[SalesOrderNumID]
,sod.[SalesOrderNum]
,sod.[CustomerID]
,sod.[Customer]
,sod.[SalesPersonName]
,sod.[SalesChannel]
,sod.[AxInterSalesChannel]
,sod.[Department]

FROM dm.DimSalesOrderDistinct as sod

WHERE sod.Company  in ('OCSSE')  -- Industry basket
GO
