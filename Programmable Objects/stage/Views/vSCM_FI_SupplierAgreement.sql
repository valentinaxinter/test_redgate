IF OBJECT_ID('[stage].[vSCM_FI_SupplierAgreement]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_SupplierAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSCM_FI_SupplierAgreement] AS 
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO PartID 2022-12-21 VA
--ADD TRIM()UPPER() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(TRIM([Company]), '#', TRIM([RecordType]), '#', TRIM([PartNum]), '#', TRIM([SupplierNum])))) AS SupplierAgreementID --CustomerAgreementID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([SupplierNum]))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([SupplierNum])))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([CurrencyCode]))) AS CurrencyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([PartNum])))) AS PartID
	,[PartitionKey]

	,[Company]
	,TRIM([SupplierNum]) AS SupplierNum
	,TRIM([PartNum]) AS PartNum
	,[RecordType] AS [AgreementCode]
	,[RecordTypeDesc] AS [AgreementDescription]
	,[DiscountPercent]
	,MAX([UnitPrice]) AS [UnitPrice]
	,[OrderQty] AS [AgreementQty]
	,[CurrencyCode] AS [Currency]
	,[DelivTime]
	,cast ('1900-01-01' as date) AS [AgreementStart]
	,cast ('1900-01-01'as date) AS [AgreementEnd]
	,[SupplierTerms]
	--,0	AS FulfilledQty
	--,0  AS RemainingQty
	--,''	AS UoM
	--,'' AS [SARes1]
	--,'' AS [SARes2]
	--,'' AS [SARes3]
FROM 
	[stage].[SCM_FI_SupplierAgreement]
GROUP BY [PartitionKey], [Company], [SupplierNum], [PartNum], [RecordType], [RecordTypeDesc], [DiscountPercent], [OrderQty], [CurrencyCode], [DelivTime], [SupplierTerms]
GO
