IF OBJECT_ID('[dm_DS].[dimSalesOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_DS].[dimSalesOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [dm_DS].[dimSalesOrderDistinct] AS

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
LEFT JOIN dbo.Company com ON sod.Company = com.Company
WHERE com.BusinessArea = 'Driveline Solutions' AND com.[Status] = 'Active'
--WHERE Company  in ('MIT', 'ATZ', 'Transaut', 'IPLIOWTR')  -- DS basket
GO
