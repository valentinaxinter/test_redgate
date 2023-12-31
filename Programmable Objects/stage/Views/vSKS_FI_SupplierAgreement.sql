IF OBJECT_ID('[stage].[vSKS_FI_SupplierAgreement]') IS NOT NULL
	DROP VIEW [stage].[vSKS_FI_SupplierAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSKS_FI_SupplierAgreement] AS 
--ADD TRIM() UPPER() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(TRIM([Company]), '#', TRIM(PRODUCT), '#', TRIM(SUPPLIER), EKORG ))) AS SupplierAgreementID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(SUPPLIER), '#', TRIM(EKORG))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([CURRENCY]))) AS CurrencyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', PRODUCT ))) AS PartID
	,[PartitionKey]

--	,CASE WHEN COMPANY = 'SKSSWE' THEN 'JSESKSSW' WHEN COMPANY = '' THEN 'SCOFI' ELSE COMPANY END AS Company 
	,Company 
	,TRIM([SUPPLIER]) AS SupplierNum
	,IIF(ISNUMERIC([PRODUCT]) = 1,CAST(CAST(trim([PRODUCT]) AS int)as nvarchar(50)),(trim([PRODUCT]))) AS PartNum
	,[REC_TYPE] AS [AgreementCode]
	,[REC_TYPE_DESC] AS [AgreementDescription]
	,[DISCOUNT_PRC]	AS DiscountPercent
	,MAX([UNIT_PRICE]) AS [UnitPrice]
	,[QUANTITY] AS [AgreementQty]
	,[CURRENCY] AS [Currency]
	,[DELIVERY_TIME]	AS DelivTime
	,IIF(AGREEMENT_START = '00000000', '1900-01-01', CONVERT(date, AGREEMENT_START)) AS [AgreementStart]
	,IIF(AGREEMENT_END = '00000000', '1900-01-01', CONVERT(date, AGREEMENT_END)) AS [AgreementEnd]
	,SUPPLIER_TERMS AS [SupplierTerms]
	,0	AS FulfilledQty
	,0  AS RemainingQty
	,''	AS UoM
	,SRES1 AS [SARes1]
	,SRES2 AS [SARes2]
	,SRES3 AS [SARes3]
FROM 
	[stage].[SKS_FI_SupplierAgreement]
WHERE  EKORG NOT IN ('FI00','SE10','')
GROUP BY [PartitionKey], [Company], EKORG, SUPPLIER, PRODUCT, REC_TYPE, REC_TYPE_DESC, DISCOUNT_PRC, [QUANTITY], CURRENCY, [DELIVERY_TIME], SUPPLIER_TERMS, AGREEMENT_START, AGREEMENT_END, SRES1, SRES2, SRES3
GO
