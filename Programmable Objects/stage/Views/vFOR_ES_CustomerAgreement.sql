IF OBJECT_ID('[stage].[vFOR_ES_CustomerAgreement]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_CustomerAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vFOR_ES_CustomerAgreement] AS 
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(AgreementCode),'#',TRIM([PartNum]),'#',TRIM(CustomerNum))))) AS CustomerAgreementID
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
	,DiscountPercent
	,[UnitPrice] AS [UnitPrice]
	,AgreementQty
	,FulfilledQty
	,RemainingQty
	,UPPER(TRIM([Currency])) AS Currency
	,AgreementStart
	,AgreementEnd
	,CustomerTerms
	,CARes1
FROM 
	[stage].[FOR_ES_CustomerAgreement]
GO
