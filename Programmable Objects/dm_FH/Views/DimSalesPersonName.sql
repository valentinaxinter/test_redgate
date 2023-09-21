IF OBJECT_ID('[dm_FH].[DimSalesPersonName]') IS NOT NULL
	DROP VIEW [dm_FH].[DimSalesPersonName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_FH].[DimSalesPersonName] AS

SELECT sp.[SalesPersonNameID]
,sp.[Company]
,sp.[SalesPersonName]
FROM dm.DimSalesPersonName as sp
LEFT JOIN dbo.Company com ON sp.Company = com.Company
WHERE com.BusinessArea = 'Fluid Handling Solutions' AND com.[Status] = 'Active'
GO
