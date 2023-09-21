IF OBJECT_ID('[dm_FH].[dimCustomerAgreement]') IS NOT NULL
	DROP VIEW [dm_FH].[dimCustomerAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_FH].[dimCustomerAgreement] AS
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
WHERE com.BusinessArea = 'Fluid Handling Solutions' AND com.[Status] = 'Active'
GO
