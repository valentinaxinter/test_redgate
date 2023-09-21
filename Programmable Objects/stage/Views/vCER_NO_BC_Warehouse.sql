IF OBJECT_ID('[stage].[vCER_NO_BC_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_BC_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_NO_BC_Warehouse] AS 
SELECT 
	CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID,
	
	PartitionKey,
	Company,
	nullif(trim(WarehouseCode),'') as WarehouseCode,
	nullif(trim(WarehouseName),'') as WarehouseName
    --,systemCreatedAt
	--,systemModifiedAt
FROM 
	 stage.CER_NO_BC_Warehouse
GO
