IF OBJECT_ID('[prestage].[vTRA_FR_Warehouse]') IS NOT NULL
	DROP VIEW [prestage].[vTRA_FR_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [prestage].[vTRA_FR_Warehouse] AS

SELECT 
	CONCAT(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,Prop_0 AS [Company]
	,Prop_1 AS [WarehouseCode]
	,Prop_2 AS [WarehouseName]
FROM [prestage].[TRA_FR_Warehouse]
GO
