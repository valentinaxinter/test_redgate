IF OBJECT_ID('[stage].[vFOR_ES_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vFOR_ES_StockBalance] AS 
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]))))) AS ItemWarehouseID,
	UPPER(CONCAT([Company],'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]))) AS ItemWarehouseCode,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID,
	[PartitionKey]	,
	[Company]		,
	WarehouseCode	,
	WarehouseName	,
	PartNum			,
	MaxStockQty		,
	StockBalance	,
	StockValue		,
	ReserveQty		,
	OrderQty		,
	SafetyStock		,
	AvgCost			
FROM 
	 [stage].[FOR_ES_StockBalance]
GO
