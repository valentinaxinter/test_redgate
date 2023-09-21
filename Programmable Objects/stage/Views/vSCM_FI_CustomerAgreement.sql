IF OBJECT_ID('[stage].[vSCM_FI_CustomerAgreement]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_CustomerAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSCM_FI_CustomerAgreement] AS 
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO CustomerID 2022-12-21 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(TRIM([Company]), '#', TRIM([RecordType]), '#', TRIM([PartNum]), '#', TRIM([CustNum])))) AS CustomerAgreementID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM([CustNum]))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([CustNum])))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([CurrencyCode]))) AS CurrencyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([PartNum])))) AS PartID
	,[PartitionKey]

	,[Company]
	,TRIM([CustNum]) AS CustomerNum
	,TRIM([PartNum]) AS PartNum
	,[RecordType] AS [AgreementCode]
	,[RecTypeDesc] AS [AgreementDescription]
	,[DiscountPercent]
	,MAX([UnitPrice]) AS [UnitPrice]
	,[OrderQty] AS [AgreementQty]
	,[CurrencyCode] AS [Currency]
	,[DelivTime]
	,'1900-01-01' AS [AgreementStart]
	,'1900-01-01' AS [AgreementEnd]
	--,NULL AS [CustomerTerms]
	--,0	AS FulfilledQty
	--,0  AS RemainingQty
	--,''	AS UoM
	--,'' AS CARes1
	--,'' AS CARes2
	--,'' AS CARes3
FROM 
	[stage].[SCM_FI_CustomerAgreement]
GROUP BY [PartitionKey], [Company], [CustNum], [PartNum], [RecordType], [RecTypeDesc], [DiscountPercent], [OrderQty], [CurrencyCode], [DelivTime]
GO
