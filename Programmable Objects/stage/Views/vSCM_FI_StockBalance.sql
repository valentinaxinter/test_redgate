IF OBJECT_ID('[stage].[vSCM_FI_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vSCM_FI_StockBalance] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO PartID 2022-12-21 VA
--ADD TRIM() UPPER() INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([PartNum]), '#', TRIM([WarehouseCode]) , '#', TRIM(BatchNumber)))) AS ItemWarehouseID
	,TRIM([WarehouseCode]) AS WarehouseCode
	,CurrencyCode AS Currency
	,CONCAT([Company], '#', TRIM([PartNum]), '#', TRIM([WarehouseCode])) AS ItemWarehouseCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([PartNum])))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([SupplierNum])))) AS SupplierID -- var '0000000'
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,[PartitionKey]

	,[Company]
	,TRIM(DefaultBinNo) AS BinNum
	,TRIM(BatchNumber) AS [BatchNum]
	,TRIM([SupplierNum]) AS [SupplierNum]
	,TRIM([PartNum]) AS PartNum
	--,NULL AS [DelivTime]
	,CONVERT(date, [StockTakDate]) AS [LastStockTakeDate]
	,CONVERT(date, '1900-01-01') AS [LastStdCostCalDate]
	--,NULL AS [SafetyStock]
	,MaxStockQty
	,[StockBalance]
	--,NULL AS [StockValue]
	--,0 AS AvgCost
	,[ReservedQty] AS [ReserveQty]
	,[BackOrderQty]
	,[QtyOrdered] AS [OrderQty]
	,[StockTakDiff] AS [StockTakeDiff]
	,MAX([ReOrderLevel]) AS [ReOrderLevel]
	--,NULL AS [OptimalOrderQty]
	--,'' AS [SBRes1]
	--,'' AS [SBRes2]
	--,'' AS [SBRes3]
FROM 
	[stage].[SCM_FI_StockBalance]
GROUP BY
	[PartitionKey],[Company],[PartNum],[WarehouseCode],[StockBalance],[ReservedQty],[BackOrderQty],[QtyOrdered],[StockTakDiff],DefaultBinNo,[SupplierNum], [StockTakDate],BatchNumber,MaxStockQty,CurrencyCode
GO
