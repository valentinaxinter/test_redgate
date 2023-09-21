IF OBJECT_ID('[dm_LS].[dimSalesOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_LS].[dimSalesOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dm_LS].[dimSalesOrderDistinct] AS

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
WHERE com.BusinessArea = 'Lifting Solutions' AND com.[Status] = 'Active'


--WHERE Company  in ('AFISCM', 'CDKCERT', 'CEECERT', 'CFICERT', 'CLTCERT', 'CLVCERT', 'CSECERT', 'CUKCERT', 'CNOEHAU', 'CNOCERT', 'CyESA', 'HFIHAKL', 'TRACLEV')  -- LS basket
GO
