IF OBJECT_ID('[prestage].[TRA_FR_Warehouse_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[TRA_FR_Warehouse_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [prestage].[TRA_FR_Warehouse_Load] AS
BEGIN

Truncate table stage.[TRA_FR_Warehouse]

INSERT INTO 
	stage.TRA_FR_Warehouse 
	(PartitionKey, Company, WarehouseCode, WarehouseName)
SELECT 
	PartitionKey, Company, WarehouseCode, WarehouseName
FROM 
	[prestage].[vTRA_FR_Warehouse]

--Truncate table prestage.[TRA_FR_Warehouse]

End
GO
