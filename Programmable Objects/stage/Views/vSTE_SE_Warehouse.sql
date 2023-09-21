IF OBJECT_ID('[stage].[vSTE_SE_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vSTE_SE_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [stage].[vSTE_SE_Warehouse] AS
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	,[PartitionKey] 
	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
	,[WarehouseName] 
	,[WarehouseDistrict] 
	,[WarehouseAddress] 
	,[WarehouseDescription] 
	,[WarehouseType] 
	,[WarehouseCountry]
	,[Site] 
from  stage.STE_SE_Warehouse
GO
