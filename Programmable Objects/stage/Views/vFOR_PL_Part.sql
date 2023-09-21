IF OBJECT_ID('[stage].[vFOR_PL_Part]') IS NOT NULL
	DROP VIEW [stage].[vFOR_PL_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_PL_Part] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER() INTO PartID 23-01-12 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]) ,'#', TRIM(PartNum))))) as PartID
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([PartNum])))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONCAT([Company],'#',TRIM([PartNum])) AS PartCode
	,PartitionKey

	,[Company]
	,UPPER(TRIM([PartNum])) AS PartNum
	,[PartName]
	,[PartDescription3]	AS [PartDescription]
	,GrupaGTU	AS [PartDescription2]
	,PKWIU		AS [PartDescription3]
	--,''			AS MainSupplier
	--,''			AS AlternativeSupplier
	,case when [ProductGroup]= N'Środki trwałe' then 'Fixed assets'
			else CONCAT([ProductGroup], ' - ' + pg.[Cat 2]) end AS [ProductGroup]
	,case when [ProductGroup2]= N'Środki trwałe' then 'Fixed assets'else [ProductGroup2] end as  [ProductGroup2]
	,case when [ProductGroup3]= N'Środki trwałe' then 'Fixed assets' else [ProductGroup3] end as  [ProductGroup3]
	,[ProductGroup4]
	,[Brand]
	--,'' AS [CommodityCode]
	--,'' AS PartReplacementNum
	,PartStatus
	--,'' AS [CountryOfOrigin]
	,[NetWeight]
	,UoM
	--,''	AS [Material]
	,[Barcode]
	,[ReOrderLevel]
	--,'' PartResponsible
	,[StartDate]
	--,'' AS [EndDate]
FROM [stage].[FOR_PL_Part] P 
LEFT JOIN [stage].[FOR_PL_mapProductGroup]  pg on P.[ProductGroup] = pg.grupa2
GO
