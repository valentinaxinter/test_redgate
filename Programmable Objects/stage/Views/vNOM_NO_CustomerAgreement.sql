IF OBJECT_ID('[stage].[vNOM_NO_CustomerAgreement]') IS NOT NULL
	DROP VIEW [stage].[vNOM_NO_CustomerAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vNOM_NO_CustomerAgreement] AS 
--COMMENT EMPTY FIELDS 23-01-09 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(AgreementCode),'#',TRIM([PartNum]),'#',TRIM(CustomerNum),'#',AgreementStart)))) AS CustomerAgreementID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID  
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM([Currency])))) AS CurrencyID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM(CustomerNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,AgreementCode
	,AgreementDescription
	--,NULL AS DiscountPercent
	,CONVERT(decimal(18,4), [UnitPrice]) AS [UnitPrice]
	,AgreementQty
	,UPPER(TRIM([Currency])) AS Currency
	,[DelivTime]
	,AgreementStart
	,AgreementEnd
	,CustomerTerms
	--,0	AS FulfilledQty
	--,0  AS RemainingQty
	--,''	AS UoM
	--,'' AS CARes1
	--,'' AS CARes2
	--,'' AS CARes3
FROM 
	[stage].[NOM_NO_CustomerAgreement]
GROUP BY [PartitionKey], [Company], AgreementCode, AgreementDescription, [Currency], [PartNum], [DelivTime], AgreementStart, AgreementEnd, CustomerTerms, [UnitPrice], CustomerNum, AgreementQty
GO
