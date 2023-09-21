IF OBJECT_ID('[dm_DS].[DimSalesPersonName]') IS NOT NULL
	DROP VIEW [dm_DS].[DimSalesPersonName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_DS].[DimSalesPersonName] AS
SELECT  sp.[SalesPersonNameID]
,sp.[Company]
,sp.[SalesPersonName]
FROM dm.DimSalesPersonName sp
LEFT JOIN dbo.Company com ON sp.Company = com.Company
WHERE com.BusinessArea = 'Driveline Solutions' AND com.[Status] = 'Active' 

--WHERE Company IN ('MIT', 'ATZ', 'Transaut') ;
GO
