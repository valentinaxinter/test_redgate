IF OBJECT_ID('[stage].[vSCM_FI_Part]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSCM_FI_Part] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER() INTO PartID 2022-12-21
-- Made change 2023-05-26 because of  IT Support Ticket 104973 where box quantity was requested as a new field. Since the stage table can have multiple partnums per site and UoM, a CTE had to be made to do the correct grouping.
with first_result as (
SELECT 
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company] ,'#', [PartNum]))) AS PartID--,'#', [Site]
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', MAX(TRIM([PartNum])))))) AS PartID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,CONCAT([Company], '#', MAX(TRIM([PartNum])), '#', MAX([Site])) AS PartCode
	,PartitionKey

	,[Company]
	,MAX(TRIM([PartNum])) AS [PartNum]
	,'' AS UoM
	--,'' AS [PartName]
	,[PartDescription]
	,[PartDescription2]
	--,'' AS [PartDescription3]
	--,NULL AS MainSupplier
	--,NULL AS AlternativeSupplier
	,[ProductGroup]
	,[ProductGroup2]
	,MAX([Site]) AS [ProductGroup3]
	--,MAX(replace(ConvFactor,'.0000','')) AS [ProductGroup4]
	,iif(trim(UOM) = 'BOX' and ConvFactor != '0.0000', MAX(replace(ConvFactor,'.0000','')), '') AS [ProductGroup4]
	,[Brand] -- added 20201125
	,[CommodityCode]
	--,'' AS PartReplacementNum
	--,'' AS PartStatus
	,[CountryOfOrigin]
	,[NetWeight]
	--,'' AS [Material]
	--,'' AS [Barcode]
	,MAX([ReorderLevel]) AS [ReOrderLevel]
	--,'' AS PartResponsible
	--,'' AS [StartDate]
	--,'' AS [EndDate]
FROM [stage].[SCM_FI_Part]
GROUP BY
	PartitionKey, [Company], [PartDescription], [PartDescription2], [ProductGroup], [ProductGroup2], [CommodityCode], [CountryOfOrigin], [NetWeight], [Brand], [UOM], [ConvFactor]
	)

select 	
     PartID  
	,CompanyID
	,max(PartCode) AS PartCode
	,PartitionKey
	,[Company]
	,[PartNum]
	,UoM
	,[PartDescription]
	,[PartDescription2]
	,[ProductGroup]
	,[ProductGroup2]
	,MAX([ProductGroup3]) AS [ProductGroup3]
	,MAX([ProductGroup4]) AS  [ProductGroup4]
	,[Brand] -- added 20201125
	,[CommodityCode]
	,[CountryOfOrigin]
	,[NetWeight]
	,[ReOrderLevel]
	
from first_result

group by PartID, CompanyID, PartitionKey, [Company], [PartNum], [PartDescription], [PartDescription2], [ProductGroup], [ProductGroup2],  [CommodityCode], [CountryOfOrigin], [NetWeight], [Brand], [UOM],[ReOrderLevel]
GO
