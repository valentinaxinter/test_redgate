IF OBJECT_ID('[stage].[vJEN_DK_SupplierAgreement]') IS NOT NULL
	DROP VIEW [stage].[vJEN_DK_SupplierAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_DK_SupplierAgreement] AS 
--comment empty fields 22-12-29 VA
--ADD TRIM() INTO SupplierID 23-01-23 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]), '#', TRIM(RecordType), '#', TRIM([PartNum]), '#', TRIM([SupplierNum]), '#', TRIM(CurrencyCode))))) AS SupplierAgreementID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID  
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(SupplierNum))))) AS SupplierID  
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(CurrencyCode)))) AS CurrencyID --Redundant?
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,RecordType AS AgreementCode
	,RecordTypeDesc AS AgreementDescription
	,Discount AS [DiscountPercent]
	,MAX([UnitPrice]) AS [UnitPrice]
	--,NULL AS AgreementQty
	,UPPER(TRIM(CurrencyCode)) AS Currency
	,MAX(DelivTimeWeeks) AS [DelivTime]
	--,'' AS AgreementStart
	--,'' AS AgreementEnd
	--,'' AS [SupplierTerms]
	--,NULL	AS FulfilledQty
	--,NULL  AS RemainingQty
	--,''	AS UoM
	--,'' AS  SARes1
	--,'' AS  SARes2
	--,'' AS  SARes3
FROM 
	[stage].[JEN_DK_SupplierAgreement]

GROUP BY [PartitionKey], [Company], RecordType, RecordTypeDesc, PartNum, SupplierNum, Discount,  CurrencyCode
--WHERE 
--	RecordType = 'D'
GO
