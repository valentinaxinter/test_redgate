IF OBJECT_ID('[stage].[vJEN_NO_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NO_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_NO_Warehouse] AS
--COMMENT EMPTY FIELDS 2022-12-22 VA
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
FROM [stage].[JEN_NO_Warehouse]
GO
