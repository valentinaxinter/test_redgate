IF OBJECT_ID('[stage].[vARK_PI_CustomerAgreement]') IS NOT NULL
	DROP VIEW [stage].[vARK_PI_CustomerAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vARK_PI_CustomerAgreement] AS 
--ADD UPPER()TRIM() INTO CustomerID,PartID 2022-12-16 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(TRIM([Company]), '#', TRIM([AgreementCode]), '#', TRIM([PartNum]), '#', TRIM(CustomerNum)))) AS CustomerAgreementID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([Currency]))) AS CurrencyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([PartNum])))) AS PartID
	,[PartitionKey]

	,[Company]
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM([PartNum]) AS PartNum
	,[AgreementCode]
	,[AgreementDescription]
	,[DiscountPercent]
	,([UnitPrice]) AS [UnitPrice]
	,[AgreementQty]
	,[FullfiledQty] AS FulfilledQty
	,[AgreementQty] -[FullfiledQty] AS RemainingQty
	--,'' AS UoM
	,[Currency]
	,[DelivTime]
	,[AgreementStart]
	,[AgreementEnd]
	,[CustomerTerms]
	,[AgreementQty] AS CARes1
	,[FullfiledQty] AS CARes2
	,CARes3
FROM 
	[stage].[ARK_PI_CustomerAgreement]
WHERE [AgreementQty] <> 0
--GROUP BY [PartitionKey], [Company], CustomerNum, [PartNum], [AgreementCode], [AgreementDescription], [DiscountPercent], [AgreementQty], [Currency], [DelivTime],[AgreementStart],[AgreementEnd],[CustomerTerms],[FullfiledQty],CARes2,CARes3
GO
