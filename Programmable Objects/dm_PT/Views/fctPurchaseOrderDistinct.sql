IF OBJECT_ID('[dm_PT].[fctPurchaseOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_PT].[fctPurchaseOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_PT].[fctPurchaseOrderDistinct] AS

SELECT pod.[PurchaseOrderNumID]
,pod.[CompanyID]
,pod.[SupplierID]
,pod.[PurchaseOrderNum]
,pod.[Company]
,pod.[Supplier]
FROM [dm].[FactPurchaseOrderDistinct] pod
--LEFT JOIN dbo.Company com ON pod.Company = com.Company
--WHERE com.BusinessArea = 'Power Transmission Solutions' AND com.[Status] = 'Active'

WHERE [Company] in ('ACZARKOV', 'AcornUK', 'BSIBELL', 'JDKJENSS', 'JDKKALTE', 'JFIJENSS', 'MNLMAK', 'JNOJENSS', 'JNOORBEL', 'JSEJENSS', 'JSESKSSW', 'NORNO', 'SSWSE', 'NomoSE', 'NomoDK', 'NomoFI', 'NomoNo', 'PASSEROT', 'SKSSCOFI', 'SCOFI', 'SMKFI', 'SNLSPRUI', 'SVESE')  -- The PT basket --
GO
