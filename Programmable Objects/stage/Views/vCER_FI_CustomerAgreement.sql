IF OBJECT_ID('[stage].[vCER_FI_CustomerAgreement]') IS NOT NULL
	DROP VIEW [stage].[vCER_FI_CustomerAgreement];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vCER_FI_CustomerAgreement] AS 

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(AgreementCode), '#', TRIM([PartNum]), '#', TRIM(CustomerNum))))) AS CustomerAgreementID --CustomerAgreementID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM(CustomerNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,UPPER(TRIM(AgreementCode)) AS AgreementCode
	,TRIM(AgreementDescription) AS AgreementDescription
	,DiscountPercent
	,MAX([UnitPrice]) AS [UnitPrice]
	,UPPER(TRIM([Currency])) AS Currency
	,[DelivTime]
	,AgreementStart
	,AgreementEnd
	,NULL AS AgreementQty
	,NULL AS FulfilledQty
	,NULL AS RemainingQty
	--,''	AS UoM
	--,'' AS CustomerTerms
	--,'' AS CARes1
	--,'' AS CARes2
	--,'' AS CARes3
FROM 
	[stage].[CER_FI_CustomerAgreements]
GROUP BY [PartitionKey], [Company], AgreementCode, AgreementDescription, [Currency], [PartNum], CustomerNum, [DiscountPercent], [DelivTime], AgreementStart, AgreementEnd
--WHERE 
--	RecordType = 'D'
GO
