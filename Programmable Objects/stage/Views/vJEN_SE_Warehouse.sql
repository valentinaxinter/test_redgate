IF OBJECT_ID('[stage].[vJEN_SE_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vJEN_SE_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_SE_Warehouse] AS
--COMMENT EMPTY FIELDS 2022-12-19
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
FROM [stage].[JEN_SE_Warehouse]
GO
