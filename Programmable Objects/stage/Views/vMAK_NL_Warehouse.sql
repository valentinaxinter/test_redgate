IF OBJECT_ID('[stage].[vMAK_NL_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vMAK_NL_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vMAK_NL_Warehouse] AS 

-- We dont have to confuse ourselves. Even though the logic in the others tables is different, the result is the same.
-- At the end [stage].[MAK_NL_Warehouse].WarehouseID = [stage].[MAK_NL_oline].WarehouseCode or [stage].[MAK_NL_soline].WarehouseCode

SELECT 
		CONVERT([binary](32),HASHBYTES('SHA2_256',upper(CONCAT(trim(Company),'#',trim([WarehouseID]))))) AS WareHouseID
		,[PartitionKey]

      ,[Company]
      ,[WarehouseID] AS [WarehouseCode]
      ,[WarehouseName]
      ,[WarehouseDistrict]
      ,[WarehouseAdress]	AS WarehouseAddress
      ,[WarehouseDescription]
      ,[WarehouseType]
      ,[WarehouseCountry]
	  --,'' AS WarehouseSite
  FROM [stage].[MAK_NL_Warehouse]
GO
