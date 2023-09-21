IF OBJECT_ID('[stage].[vJEN_SK_SupplierAgreement]') IS NOT NULL
	DROP VIEW [stage].[vJEN_SK_SupplierAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_SK_SupplierAgreement] AS 
--COMMENT empty fields 2022-12-12 VA
--ADD TRIM() INTO Supplier 23-01-23 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]), '#', TRIM(AgreementCode), '#', TRIM([PartNum]), '#', TRIM([SupplierNum]), '#', TRIM([Currency]))))) AS SupplierAgreementID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(SupplierNum))))) AS SupplierID  
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Currency])))) AS CurrencyID --Redundant?
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,AgreementCode
	,AgreementDescription
	,[DiscountPercent]
	,MAX([UnitPrice]) AS [UnitPrice]
	--,0 AS AgreementQty
	,UPPER(TRIM([Currency])) AS Currency
	,MAX([DelivTime]) AS [DelivTime]
	,MAX(AgreementStart) AS AgreementStart
	,AgreementEnd
	--,'' AS [SupplierTerms]
	--,0	AS FulfilledQty
	--,0  AS RemainingQty
	--,''	AS UoM
	--,'' AS  SARes1
	--,'' AS  SARes2
	--,'' AS  SARes3
FROM 
	[stage].[JEN_SK_SupplierAgreement]

GROUP BY [PartitionKey], [Company], AgreementCode, AgreementDescription, PartNum, SupplierNum, [DiscountPercent],  [Currency],  AgreementEnd
--WHERE 
--	RecordType = 'D'
GO
