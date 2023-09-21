IF OBJECT_ID('[stage].[vFOR_ES_SupplierAgreement]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_SupplierAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_ES_SupplierAgreement] AS 
--COMMENT EMPTY FIELD 2022-12-21 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(TRIM([Company]), '#', TRIM(AgreementCode), '#', TRIM([PartNum]), '#', TRIM([SupplierNum])))) AS SupplierAgreementID --CustomerAgreementID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([SupplierNum])))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(Currency))) AS CurrencyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([PartNum])))) AS PartID
	,[PartitionKey]

	,[Company]
	,[AgreementCode]
	,[AgreementDescription]
	,TRIM([SupplierNum]) AS SupplierNum
	,TRIM([PartNum]) AS PartNum
	,[DiscountPercent]
	,[UnitPrice] AS [UnitPrice]
	,[AgreementQty]
	,[Currency]
	,[AgreementStart]
	,[AgreementEnd]
	,[SupplierTerms]
	,[SARes1]
FROM 
	 [stage].[FOR_ES_SupplierAgreement]
GO
