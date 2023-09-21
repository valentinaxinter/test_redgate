IF OBJECT_ID('[dm_TS].[dimSalesOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_TS].[dimSalesOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [dm_TS].[dimSalesOrderDistinct] AS


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
WHERE (com.BusinessArea = 'Transport Solutions' OR com.Company = 'CERPL') AND com.[Status] = 'Active'


--WHERE Company  in ('FESFORA', 'FSEFORA', 'FFRFORA', 'FFRGPI', 'FFRLEX', 'IFIWIDN', 'IEEWIDN', 'TMTFI', 'TMTEE', 'FITMT', 'EETMT', 'ABKSE', 'ROROSE')  -- TS basket by 2021-03-04
GO
