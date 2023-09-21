IF OBJECT_ID('[dm_PT].[dimCustomerAgreement]') IS NOT NULL
	DROP VIEW [dm_PT].[dimCustomerAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_PT].[dimCustomerAgreement] AS
-- AS decided by Ian & Random Forest AB on the 7th May 2020, the data is spliting after data-warehouse for each Business Group
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
WHERE com.BusinessArea = 'Power Transmission Solutions' AND com.[Status] = 'Active'
--It is a dynamic Company addition in the sub-dataset in a way that so long a company is added in its parent dataset, this company will automatically appear in its assigend Business Area sub-dataset.
--This company addtion should in its first hand appear in the dbo.Company with correct attributes.

--WHERE [Company] in ('ACZARKOV', 'AcornUK', 'BSIBELL', 'JDKJENSS', 'JDKKALTE', 'JFIJENSS', 'MNLMAK', 'JNOJENSS', 'JNOORBEL', 'JSEJENSS', 'JSESKSSW', 'NORNO', 'SSWSE', 'NomoSE', 'NomoDK', 'NomoFI', 'NomoNo', 'PASSEROT', 'SKSSCOFI', 'SCOFI', 'SMKFI', 'SNLSPRUI', 'SPRUITNL', 'SVESE')  -- The PT basket --
GO
