IF OBJECT_ID('[stage].[vWID_FI_SupplierAgreement]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_SupplierAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vWID_FI_SupplierAgreement] AS 
--COMMENT EMPTY FIELDS
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]), '#', TRIM(AgreementCode), '#', TRIM([PartNum]), '#', TRIM([SupplierNum]), '#', TRIM([Currency]))))) AS SupplierAgreementID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID 
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(SupplierNum))))) AS SupplierID  
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Currency])))) AS CurrencyID --Redundant?
	,[PartitionKey]

	,([Company]) AS Company --UPPER
	,(TRIM(SupplierNum)) AS SupplierNum
	,(TRIM(PartNum)) AS PartNum
	,AgreementCode
	,AgreementDescription
	,[DiscountPercent]
	,([UnitPrice]) AS [UnitPrice] --MAX
	--,NULL AS AgreementQty
	,(TRIM([Currency])) AS Currency
	,([DelivTime]) AS [DelivTime] --MAX
	,(AgreementStart) AS AgreementStart
	,AgreementEnd
	--,'' AS [SupplierTerms]
	--,0	AS FulfilledQty
	--,0  AS RemainingQty
	--,''	AS UoM
	--,'' AS  SARes1
	--,'' AS  SARes2
	--,'' AS  SARes3
FROM 
	[stage].[WID_FI_SupplierAgreement]
--WHERE  UnitPrice <> 0
GROUP BY [PartitionKey], [Company], AgreementCode, AgreementDescription, TRIM(PartNum), TRIM(SupplierNum), [DiscountPercent],  TRIM([Currency]),  AgreementEnd, [UnitPrice], [DelivTime], AgreementStart

--	RecordType = 'D'
GO
