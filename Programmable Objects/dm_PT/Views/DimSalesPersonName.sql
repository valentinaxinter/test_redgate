IF OBJECT_ID('[dm_PT].[DimSalesPersonName]') IS NOT NULL
	DROP VIEW [dm_PT].[DimSalesPersonName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_PT].[DimSalesPersonName]
AS

SELECT sp.[SalesPersonNameID]
,sp.[Company]
,sp.[SalesPersonName]
FROM dm.DimSalesPersonName sp
LEFT JOIN dbo.Company com ON sp.Company = com.Company
WHERE com.BusinessArea = 'Power Transmission Solutions' AND com.[Status] = 'Active'

--WHERE Company IN ('ACZARKOV', 'AcornUK', 'BSIBELL', 'JDKJENSS', 'JDKKALTE', 'JFIJENSS', 'MNLMAK', 'JNOJENSS', 'NORNO', 'JSEJENSS', 'SSWSE', 'NomoSE', 'NomoDK', 'NomoFI', 'NomoNo', 'PASSEROT', 'SKSSCOFI', 'SCOFI', 'SMKFI', 'SNLSPRUI', 'SPRUITNL', 'SVESE', 'SPRUITNL');
GO
