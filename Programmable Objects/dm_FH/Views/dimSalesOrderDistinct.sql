IF OBJECT_ID('[dm_FH].[dimSalesOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_FH].[dimSalesOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_FH].[dimSalesOrderDistinct] AS

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
FROM dm.DimSalesOrderDistinct sod
LEFT JOIN dbo.Company com ON sod.Company = com.Company
WHERE com.BusinessArea = 'Fluid Handling Solutions' AND com.[Status] = 'Active'
GO
