IF OBJECT_ID('[stage].[vJEN_SK_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vJEN_SK_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vJEN_SK_Warehouse] AS

SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseNum]))))) AS WarehouseID
	,PartitionKey

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([WarehouseNum])) AS [WarehouseCode]
	,[WarehouseName]
	,Addressline3 AS [WarehouseDistrict]
	,LEFT(CONCAT(Addressline1, ', ', Addressline2, ', ', Addressline3)  , 200) AS [WarehouseAddress]
	,'' AS [WarehouseDescription]
	,'' AS [WarehouseType]
	,'' AS [WarehouseCountry]
	,'' AS [WarehouseSite]
FROM [stage].[JEN_SK_Warehouse]
GO
