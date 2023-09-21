IF OBJECT_ID('[dm_TS].[dimSupplierAgreement]') IS NOT NULL
	DROP VIEW [dm_TS].[dimSupplierAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [dm_TS].[dimSupplierAgreement] AS

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
FROM [dm].[DimSupplierAgreement] as sa
WHERE sa.[Company] in ('FESFORA','FSEFORA', 'FFRFORA', 'FFRGPI', 'FFRLEX', 'IFIWIDN', 'IEEWIDN', 'TMTFI', 'TMTEE', 'FITMT', 'EETMT', 'ABKSE', 'ROROSE','STESE', 'FORPL'
, 'CERPL','CERBG'
,'FORBG')
GO
