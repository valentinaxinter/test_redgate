IF OBJECT_ID('[stage].[vWID_FI_Part]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vWID_FI_Part] AS
--COMMENT EMPTY FIELDS / ADD UPPER()TRIP() INTO PartID 2022-12-15 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
--	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([PartNum])))) AS PartID
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
	,SupplierPartNum AS PartReplacementNum
	,PartStatus
	,[CountryOfOrigin]
	,CASE 
		WHEN PartResponsible = 'JN' THEN 'Janne Nyqvist'
		WHEN PartResponsible = 'MT' THEN 'Markku Tiikkainen'
		WHEN PartResponsible = 'RM' THEN 'Risto Malm'
		WHEN PartResponsible = 'SV' THEN 'Sami Venho'
		WHEN PartResponsible = 'TK' THEN 'Tanja Keiho'
		WHEN PartResponsible = 'TH' THEN 'Toni Hovi'
		WHEN PartResponsible = 'JMA' THEN 'Juuso Makkonen'
		ELSE 'Others' END AS PartResponsible
	,[NetWeight]
	--,'' AS UoM
	,PackingSize AS [Material]
	,EAN AS [Barcode]
	,[ReOrderLevel]
	,[StartDate]
	,[EndDate]
	,nullif(trim([InfoClient]),'') as [PARes1]

FROM [stage].[WID_FI_Part]
GO
