IF OBJECT_ID('[dm_LS].[dimSupplierAgreement]') IS NOT NULL
	DROP VIEW [dm_LS].[dimSupplierAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_LS].[dimSupplierAgreement] AS

SELECT  sa.[CompanyID]
,sa.[SupplierID]
,sa.[PartID]
,sa.[CurrencyID]
,sa.[Company]
,sa.[PartNum]
,sa.[SupplierNum]
,sa.[DiscountPercent]
,sa.[UnitPrice]
,sa.[AgreementQty]
,sa.[AgreementCode]
,sa.[AgreementDescription]
,sa.[AgreementStart]
,sa.[AgreementEnd]
,sa.[SupplierTerms]
,sa.[FulfilledQty]
,sa.[RemainingQty]
,sa.[UoM]
,sa.[Currency]
,sa.[DelivTime]
,sa.[PartitionKey]
,sa.[ExchangeRate]
FROM [dm].[DimSupplierAgreement] sa
LEFT JOIN dbo.Company com ON sa.Company = com.Company
WHERE com.BusinessArea = 'Lifting Solutions' AND com.[Status] = 'Active'

--WHERE [Company] in ('AFISCM', 'CDKCERT', 'CEECERT', 'CFICERT', 'CLTCERT', 'CLVCERT', 'CSECERT', 'CUKCERT', 'CNOEHAU', 'CNOCERT', 'CERPL', 'CyESA', 'HFIHAKL', 'TRACLEV')
GO
