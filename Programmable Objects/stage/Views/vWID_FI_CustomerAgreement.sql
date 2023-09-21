IF OBJECT_ID('[stage].[vWID_FI_CustomerAgreement]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_CustomerAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vWID_FI_CustomerAgreement] AS 
--COMMENT EMPTY FIELDS / ADD UPPER() INTO PartID,CustomerID 2022-12-15 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM([Company]),'#',TRIM(AgreementCode),'#',TRIM([PartNum]),'#',TRIM(CustomerNum)))) AS CustomerAgreementID --CustomerAgreementID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM(Company),'#',TRIM(CustomerNum)))) AS CustomerID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID 
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM(Company),'#',TRIM(PartNum)))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',TRIM([Currency]))) AS CurrencyID
	,[PartitionKey]

	,TRIM([Company]) AS Company
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(PartNum) AS PartNum
	,AgreementCode
	,AgreementDescription
	,DiscountPercent
	,MAX([UnitPrice]) AS [UnitPrice]
	--,NULL AS AgreementQty
	,TRIM([Currency]) AS Currency
	,[DelivTime]
	,AgreementStart
	,AgreementEnd
	--,NULL	AS FulfilledQty
	--,NULL  AS RemainingQty
	--,''	AS UoM
	--,'' AS CustomerTerms
	--,'' AS CARes1
	--,'' AS CARes2
	--,'' AS CARes3

	
FROM 
	[stage].[WID_FI_CustomerAgreement]
GROUP BY [PartitionKey], [Company], AgreementCode, AgreementDescription, [Currency], [PartNum], CustomerNum, [DiscountPercent], [DelivTime], AgreementStart, AgreementEnd
--WHERE 
--	RecordType = 'D'
GO
