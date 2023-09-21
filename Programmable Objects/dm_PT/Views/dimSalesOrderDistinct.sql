IF OBJECT_ID('[dm_PT].[dimSalesOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_PT].[dimSalesOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [dm_PT].[dimSalesOrderDistinct] AS

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
--LEFT JOIN dbo.Company com ON sod.Company = com.Company
--WHERE com.BusinessArea = 'Power Transmission Solutions' AND com.[Status] = 'Active'

WHERE [Company] in ('ACZARKOV', 'AcornUK', 'BSIBELL', 'JDKJENSS', 'JDKKALTE', 'JFIJENSS', 'MNLMAK', 'JNOJENSS', 'NORNO', 'JSEJENSS', 'SSWSE', 'NomoSE', 'NomoDK', ' NomoFI', 'NomoNo', 'PASSEROT', 'SKSSCOFI', 'SCOFI', 'SMKFI', 'SNLSPRUI', 'SPRUITNL', 'SVESE')  -- The PT basket
	 --AND InvoiceDate >=  DATEADD(YEAR,-5, GETDATE())  -- Added to decrease SSAS memory usage /SM 2021-04-26
GO
