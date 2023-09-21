IF OBJECT_ID('[dw].[vALL_Warehous]') IS NOT NULL
	DROP VIEW [dw].[vALL_Warehous];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dw].[vALL_Warehous] AS

SELECT
	UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([WarehouseCode])) AS [WarehouseCode]
	,TRIM(WarehouseName) AS WarehouseName
FROM [dw].[Warehouse]
GO
