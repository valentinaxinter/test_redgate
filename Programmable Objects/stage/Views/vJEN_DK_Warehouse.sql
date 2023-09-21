IF OBJECT_ID('[stage].[vJEN_DK_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vJEN_DK_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_DK_Warehouse] AS
--COMMENT EMPTY FIELD 22-12-29 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseNum]))))) AS WarehouseID
	,PartitionKey

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([WarehouseNum])) AS [WarehouseCode]
	,[WarehouseName]
	,Addressline3 AS [WarehouseDistrict]
	,LEFT(CONCAT(Addressline1, ', ', Addressline2, ', ', Addressline3)  , 200) AS [WarehouseAddress]
	--,'' AS [WarehouseDescription]
	--,'' AS [WarehouseType]
	--,'' AS [WarehouseCountry]
	--,'' AS [WarehouseSite]
FROM [stage].[JEN_DK_Warehouse]
GO
