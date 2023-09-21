IF OBJECT_ID('[stage].[vJEN_SE_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vJEN_SE_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_SE_StockBalance] AS
--COMMENT EMPTY FIELDS / ADD UPPER() TRIM() INTO PartID,WarehouseID 2022-12-19 VA 
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM(UPPER([PartNum])),'#',TRIM(UPPER([WarehouseCode]))))) AS ItemWarehouseID
	,CONCAT([Company],'#',TRIM(UPPER([PartNum])),'#',TRIM(UPPER([WarehouseCode]))) AS ItemWarehouseCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM(UPPER([SupplierNum]))))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM(UPPER([PartNum]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM(UPPER([WarehouseCode]))))) AS WarehouseID
	,[PartitionKey]

	,TRIM(UPPER([WarehouseCode])) AS WarehouseCode
	,TRIM(UPPER(CurrencyCode)) AS Currency
	,[Company]
	,TRIM(UPPER([DefaultBinNo])) AS BinNum
	,TRIM(UPPER(BatchNumber)) AS BatchNum
	,TRIM(UPPER([SupplierNum])) AS [SupplierNum]
	,TRIM(UPPER([PartNum])) AS PartNum
	,[DelivTimeUnit] AS [DelivTime]
	,convert(date, [StockTakDate]) AS LastStockTakeDate
	,convert(date, [StdCostLaCaD]) AS LastStdCostCalDate
	--,Null AS SafetyStock
	,MaxStockQty
	,[StockBalance]
	,AvgCost*StockBalance AS StockValue
	,AvgCost
--	,LandedCost
	,[ReservedQty] AS ReserveQty
	,[BackOrderQty]	AS BackOrderQty
	,[QtyOrdered] AS OrderQty
	,[StockTakDiff]	AS StockTakeDiff
	,[ReOrderLevel]
	,[OptimalOrderQty]
	--,'' AS SBRes1
	--,'' AS SBRes2
	--,'' AS SBRes3
FROM 
	[stage].[JEN_SE_StockBalance]
GROUP BY
	PartitionKey, Company, WarehouseCode, CurrencyCode, Company, DefaultBinNo, BatchNumber, SupplierNum, PartNum, DelivTimeUnit, StockTakDate, StdCostLaCaD, MaxStockQty, StockBalance, ReservedQty, BackOrderQty, QtyOrdered, StockTakDiff, ReOrderLevel, OptimalOrderQty, AvgCost
GO
