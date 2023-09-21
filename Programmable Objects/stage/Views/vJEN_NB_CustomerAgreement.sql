IF OBJECT_ID('[stage].[vJEN_NB_CustomerAgreement]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NB_CustomerAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_NB_CustomerAgreement] AS 
--COMMENT EMPTY FIELDS 23-01-03 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM(AgreementCode),'#',TRIM([PartNum]),'#',TRIM(CustomerNum))))) AS CustomerAgreementID --CustomerAgreementID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM(CustomerNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,AgreementCode
	,AgreementDescription
	,DiscountPercent
	,MAX([UnitPrice]) AS [UnitPrice]
	--,0 AS AgreementQty
	,UPPER(TRIM([Currency])) AS Currency
	,[DelivTime]
	,AgreementStart
	,AgreementEnd
	--,'' AS CustomerTerms
	--,0	AS FulfilledQty
	--,0  AS RemainingQty
	--,''	AS UoM
	--,'' AS CARes1
	--,'' AS CARes2
	--,'' AS CARes3
FROM 
	[stage].[JEN_NB_CustomerAgreement]
GROUP BY [PartitionKey], [Company], AgreementCode, AgreementDescription, [Currency], [PartNum], CustomerNum, [DiscountPercent], [DelivTime], AgreementStart, AgreementEnd
--WHERE 
--	RecordType = 'D'
GO
