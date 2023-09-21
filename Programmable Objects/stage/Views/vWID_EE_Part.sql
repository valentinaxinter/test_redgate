IF OBJECT_ID('[stage].[vWID_EE_Part]') IS NOT NULL
	DROP VIEW [stage].[vWID_EE_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [stage].[vWID_EE_Part] AS
--ROWS CREATED FROM BUDGET TABLE 23-01-12 VA
--COMMENT EMPTY FIELDS 23-01-12 VA
SELECT 

	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([PartNum])))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONCAT([Company], '#', TRIM([PartNum])) AS PartCode
	,PartitionKey

	,[Company]
	,TRIM([PartNum]) AS [PartNum]
	--,'' AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	--,'' AS [PartDescription3]
	,TRIM(MainSupplier) AS MainSupplier
	,TRIM(AlternativeSupplier) AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	--,'' AS [ProductGroup3]
	,CodeOfConduct AS [ProductGroup4]
	,TRIM([Brand]) AS [Brand]
	,[CommodityCode]
	--,'' AS PartReplacementNum
	,PartStatus
	,[CountryOfOrigin]
	,CASE 
		WHEN PartResponsible = 'JN' THEN 'Janne Nyqvist'
		WHEN PartResponsible = 'MT' THEN 'Markku Tiikkainen'
		WHEN PartResponsible = 'RM' THEN 'Risto Malm'
		WHEN PartResponsible = 'SV' THEN 'Sami Venho'
		WHEN PartResponsible = 'TK' THEN 'Tanja Keiho'
		ELSE 'Others' END AS PartResponsible
	,[NetWeight]
	--,'' AS UoM
	,PackingSize AS [Material]
	--,'' AS [Barcode]
	,[ReOrderLevel]
	,[StartDate]
	,[EndDate]
	,nullif(trim([InfoClient]),'') as [PARes1]
FROM [stage].[WID_EE_Part]
GO
