IF OBJECT_ID('[stage].[vCER_NO_BC_Part]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_BC_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vCER_NO_BC_Part] AS 
SELECT 
	CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID,
	CONVERT(binary(32), HASHBYTES('SHA2_256', TRIM(Company))) AS CompanyID
	,PartitionKey
	,Company
	,nullif(TRIM(PartNum),'') AS PartNum
	,nullif(trim(PartDescription),'') as PartDescription
	,nullif(trim(PartDescription2),'') as PartDescription2
	,nullif(trim(ProductGroup),'') as ProductGroup
	,nullif(trim(ProductGroup2),'') as ProductGroup2
	,nullif(trim(CommodityCode),'') as CommodityCode
	,nullif(trim(CountryOfOrigin),'') as CountryOfOrigin
	,cast(NetWeight as decimal(10,4)) as NetWeight
	,nullif(TRIM(SupplierCode),'') AS MainSupplier
	,cast(ReorderLevel as decimal(10,4)) as ReOrderLevel
	,PartStatus
	,PartType as PARes1
    --,systemCreatedAt
	--,systemModifiedAt
FROM 
	 stage.CER_NO_BC_Part
GO
