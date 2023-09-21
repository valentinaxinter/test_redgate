IF OBJECT_ID('[stage].[vCER_FI_SupplierAgreement]') IS NOT NULL
	DROP VIEW [stage].[vCER_FI_SupplierAgreement];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vCER_FI_SupplierAgreement] AS 

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(AgreementCode), '#', TRIM([PartNum]), '#', TRIM([SupplierNum]), '#', TRIM([Currency]))))) AS SupplierAgreementID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,UPPER(TRIM(AgreementCode)) AS AgreementCode
	,UPPER(TRIM(AgreementDescription)) AS AgreementDescription
	,[DiscountPercent]
	,MAX([UnitPrice]) AS [UnitPrice]
	,NULL AS AgreementQty
	,UPPER(TRIM([Currency])) AS Currency
	,MAX([DelivTime]) AS [DelivTime]
	,MAX(AgreementStart) AS AgreementStart
	,AgreementEnd
	--,0 AS FulfilledQty
	--,0 AS RemainingQty
	--,'' AS UoM
	--,'' AS SupplierTerms
	--,'' AS SARes1
	--,'' AS SARes2
	--,'' AS SARes3
FROM 
	[stage].[CER_FI_SupplierAgreement]

GROUP BY [PartitionKey], [Company], AgreementCode, AgreementDescription, PartNum, SupplierNum, [DiscountPercent],  [Currency],  AgreementEnd
GO
