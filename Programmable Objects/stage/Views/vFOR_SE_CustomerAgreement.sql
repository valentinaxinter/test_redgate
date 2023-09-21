IF OBJECT_ID('[stage].[vFOR_SE_CustomerAgreement]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_CustomerAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_SE_CustomerAgreement] AS 
--COMMENT EMPTY FIELDS 2022-12-20 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([RecordType]), '#', TRIM([PartNum]), '#', TRIM([CustNum]))))) AS CustomerAgreementID --CustomerAgreementID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM(CustNum)) AS CustomerNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,[RecordType] AS AgreementCode
	,[RecTypeDesc] AS AgreementDescription
	,[DiscountPercent]
	,MAX([UnitPrice])	as [UnitPrice]
	,[OrderQty] AS AgreementQty
	,UPPER(TRIM([CurrencyCode])) AS Currency
	,[DelivTime]
	--,'' AS AgreementStart
	--,'' AS AgreementEnd
	--,'' AS CustomerTerms
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([CurrencyCode])))) AS CurrencyID
	--,'' AS [ValidFromDate]
	--,'' AS [ValidToDate]
	--,0	AS FulfilledQty
	--,0  AS RemainingQty
	--,''	AS UoM
	--,'' AS CARes1
	--,'' AS CARes2
	--,'' AS CARes3
FROM 
	[stage].[FOR_SE_CustomerAgreement]
GROUP BY [PartitionKey],[Company],[RecordType],[RecTypeDesc],[CurrencyCode],[PartNum],[CustNum],[DiscountPercent], [OrderQty], [DelivTime]
--WHERE 
--	RecordType = 'D'
GO
