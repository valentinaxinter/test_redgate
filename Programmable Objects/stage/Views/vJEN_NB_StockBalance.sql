IF OBJECT_ID('[stage].[vJEN_NB_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NB_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_NB_StockBalance] AS
--COMMENT EMPTY FIELDS // ADD UPPER() INTO PartID 23-01-03 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([PartNum]), '#', TRIM([WarehouseCode]))))) AS ItemWarehouseID
	,UPPER(CONCAT([Company], '#', TRIM([PartNum]), '#' , TRIM([WarehouseCode]))) AS ItemWarehouseCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([SupplierNum]))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,[PartitionKey]

	,UPPER([Company]) AS [Company]
	,UPPER(TRIM([PartNum])) AS PartNum
	,UPPER(TRIM([SupplierNum])) AS [SupplierNum]
	,TRIM([WarehouseCode]) AS WarehouseCode
	,TRIM(CurrencyCode) AS Currency
	,TRIM([DefaultBinNo]) AS BinNum
	,TRIM(BatchNumber) AS BatchNum
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
	[stage].[JEN_NB_StockBalance]
GROUP BY
	PartitionKey, Company, WarehouseCode, CurrencyCode, Company, DefaultBinNo, BatchNumber, SupplierNum, PartNum, DelivTimeUnit, StockTakDate, StdCostLaCaD, MaxStockQty, StockBalance, ReservedQty, BackOrderQty, QtyOrdered, StockTakDiff, ReOrderLevel, OptimalOrderQty, AvgCost
GO
