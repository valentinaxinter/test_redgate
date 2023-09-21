IF OBJECT_ID('[dm_IN].[dimCustomerAgreement]') IS NOT NULL
	DROP VIEW [dm_IN].[dimCustomerAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_IN].[dimCustomerAgreement] AS
SELECT ca.[CompanyID]
,ca.[CustomerID]
,ca.[PartID]
,ca.[CurrencyID]
,ca.[Company]
,ca.[CustomerNum]
,ca.[PartNum]
,ca.[AgreementCode]
,ca.[AgreementDescription]
,ca.[DiscountPercent]
,ca.[UnitPrice]
,ca.[AgreementQty]
,ca.[Currency]
,ca.[DelivTime]
,ca.[AgreementStart]
,ca.[AgreementEnd]
,ca.[CustomerTerms]
,ca.[FulfilledQty]
,ca.[RemainingQty]
,ca.[UoM]
,ca.[PartitionKey]
,ca.[ExchangeRate]
FROM [dm].[DimCustomerAgreement] ca
LEFT JOIN dbo.Company com ON ca.Company = com.Company
WHERE com.BusinessArea = 'Industrial Solutions' AND com.[Status] = 'Active'


--WHERE [Company] in ('AFISCM', 'CDKCERT', 'CEECERT', 'CFICERT', 'CLTCERT', 'CLVCERT', 'CSECERT', 'CUKCERT', 'CNOEHAU', 'CNOCERT', 'CERPL', 'CyESA', 'HFIHAKL', 'TRACLEV',
--'MENBE14','MENNL01','MENNL02','MENNL03','MENNL04','MENNL07','MENNL11')
GO
