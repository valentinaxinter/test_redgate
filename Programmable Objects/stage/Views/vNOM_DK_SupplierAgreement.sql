IF OBJECT_ID('[stage].[vNOM_DK_SupplierAgreement]') IS NOT NULL
	DROP VIEW [stage].[vNOM_DK_SupplierAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vNOM_DK_SupplierAgreement] AS 
--COMMENT EMPTY FIELDS // ADD TRIM() INTO PartID 23-01-05
--ADD  TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]), '#', TRIM([SupplierNum]), '#', [AgreementStart], '#', [AgreementEnd])))) AS SupplierAgreementID --CustomerAgreementID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([SupplierNum]))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([SupplierNum]))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Currency)))) AS CurrencyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([PartNum]))))) AS PartID
	,[PartitionKey]

	,UPPER([Company]) AS [Company]
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	,UPPER(TRIM([PartNum])) AS PartNum
	,AgreementCode AS [AgreementCode]
	,AgreementDescription AS [AgreementDescription]
	,[DiscountPercent]
	,[UnitPrice] AS [UnitPrice]
	,[SARes1] AS UoM
	,AgreementQty AS [AgreementQty]
	,Currency AS [Currency]
	,CONVERT(int, [DelivTime]) AS [DelivTime]
	,IIF([AgreementStart] = 0, '1900-01-01', CONVERT(Date, [AgreementStart])) AS [AgreementStart]
	,IIF([AgreementEnd] = 0, '1900-01-01', CONVERT(Date, [AgreementEnd])) AS [AgreementEnd]
	,[SupplierTerms]
	--,0	AS FulfilledQty
	--,0  AS RemainingQty
	,[SARes1]
	--,'' AS [SARes2]
	--,'' AS [SARes3]
FROM 
	[stage].[NOM_DK_SupplierAgreement]
GROUP BY [PartitionKey], [Company], [SupplierNum], [PartNum], AgreementCode, AgreementDescription, [DiscountPercent], AgreementQty, Currency, [DelivTime], [SupplierTerms], [UnitPrice],[AgreementStart],[AgreementEnd], [SARes1]
GO
