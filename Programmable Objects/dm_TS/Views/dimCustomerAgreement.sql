IF OBJECT_ID('[dm_TS].[dimCustomerAgreement]') IS NOT NULL
	DROP VIEW [dm_TS].[dimCustomerAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [dm_TS].[dimCustomerAgreement] AS

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
FROM [dm].[DimCustomerAgreement] as ca
WHERE ca.[Company] in ('FESFORA','FSEFORA', 'FFRFORA', 'FFRGPI', 'FFRLEX', 'IFIWIDN', 'IEEWIDN', 'TMTFI', 'TMTEE', 'FITMT', 'EETMT', 'ABKSE', 'ROROSE','STESE')
GO
