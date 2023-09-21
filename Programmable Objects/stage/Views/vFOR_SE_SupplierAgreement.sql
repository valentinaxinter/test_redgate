IF OBJECT_ID('[stage].[vFOR_SE_SupplierAgreement]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_SupplierAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_SE_SupplierAgreement] AS 
--ADD trim() into SupplierID 23-01-23 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([RecordType]), '#', TRIM([PartNum]), '#', TRIM([SupplierNum]),'#', [EffectiveDate] )))) AS SupplierAgreementID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID  
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum))))) AS SupplierID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([CurrencyCode])))) AS CurrencyID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(SupplierNum) AS SupplierNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,[RecordType] AS AgreementCode
	,[RecordTypeDesc] AS AgreementDescription
	,[DiscountPercent]
	,MAX([UnitPrice]) AS [UnitPrice]
	,[OrderQty] AS AgreementQty
	,[CurrencyCode] AS Currency
	,MAX([DelivTime]) AS [DelivTime]
	--,'' AS AgreementStart
	--,'' AS AgreementEnd
	,[SupplierTerms]
	,0	AS FulfilledQty
	,0  AS RemainingQty
	--,''	AS UoM
	--,'' AS  SARes1
	--,'' AS  SARes2
	--,'' AS  SARes3
	,EffectiveDate AS [ValidFromDate]
	--,'' AS [ValidToDate]
FROM 
	[stage].[FOR_SE_SupplierAgreement]
WHERE SupplierNum <> '617' OR PartNum <> '110110014' OR RecordType <> 'SU' OR CurrencyCode <> 'SEK'
GROUP BY [PartitionKey], [Company], [RecordType], [RecordTypeDesc], PartNum, SupplierNum, [DiscountPercent], [OrderQty], [CurrencyCode],[SupplierTerms], [EffectiveDate]
--WHERE 
--	RecordType = 'D'
GO
