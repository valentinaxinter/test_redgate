IF OBJECT_ID('[stage].[vJEN_DK_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vJEN_DK_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vJEN_DK_StockBalance] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO PartID, WarehouseID 22-12-29 VA
--ADD TRIM() INTO SupplierID 23-01-23 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([PartNum]), '#', TRIM([WarehouseCode]))))) AS ItemWarehouseID --,'#',MAX([FIFOValue]),'#',MAX([StockTakDate]),'#',MAX([StdCostLaCaD]),'#',MAX([DelivDateSupplier]),'#',MAX([DelivDateCust]),'#',MAX([DelivDateCust])
	,UPPER(CONCAT([Company], '#', TRIM([PartNum]), '#', TRIM([SupplierNum]))) AS ItemWarehouseCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,[PartitionKey]

	,UPPER([Company]) AS [Company]
	,TRIM([WarehouseCode]) AS WarehouseCode
	,TRIM(CurrencyCode) AS Currency
	,TRIM([DefaultBinNo]) AS BinNum
	,TRIM(BatchNumber) AS BatchNum
	,TRIM([SupplierNum]) AS [SupplierNum]
	,TRIM([PartNum]) AS PartNum
	,[DelivTimeUnit] AS [DelivTime]
	,MAX(convert(date, [StockTakDate])) AS LastStockTakeDate
	,MAX(convert(date, [StdCostLaCaD])) AS LastStdCostCalDate
	--,NULL AS SafetyStock
	,MaxStockQty
	,[StockBalance]
	,AvgCost*StockBalance AS StockValue
	,AvgCost
	,[ReservedQty] AS ReserveQty
	,[BackOrderQty] AS BackOrderQty
	,[QtyOrdered] AS OrderQty
	,[StockTakDiff] AS StockTakeDiff
	,MIN([ReOrderLevel]) AS [ReOrderLevel]
	,[OptimalOrderQty]
	--,'' AS SBRes1
	--,'' AS SBRes2
	--,'' AS SBRes3
	,MAX([FIFOValue]) AS [FIFOValue] --MAX
	,'' AS [DelivTimeToWHS]-- will not be sent out to new companies, not delete in DW for that use as reservation
	,'' AS [DelivTimeDesc]-- will not be sent out to new companies, not delete in DW for that use as reservation
	,'' AS [DaysOnStock]
--	,CASE WHEN TRIM(DefaultBinNo) like '' OR DefaultBinNo like  ' '
--		THEN NULL ELSE TRIM(DefaultBinNo) END AS DefaultBinNo
	,MAX(convert(date, [DelivDateSupplier])) AS DelivDateSupplier --
	,MAX(convert(date, [DelivDateCust])) AS DelivDateCust --
	,MAX(convert(date, [OrderDateSupplier])) AS OrderDateSupplier
	,convert(date, '') AS OrderDateCust
	--,'' AS BatchNoPrefix-- will not be sent out to new companies, not delete in DW for that use as reservation
	--,'' AS BatchNoSuffix-- will not be sent out to new companies, not delete in DW for that use as reservation
FROM 
	[stage].[JEN_DK_StockBalance]
WHERE [StockBalance] != 0
GROUP BY
	[PartitionKey], [Company], [PartNum], [WarehouseCode], [StockBalance], [ReservedQty], [BackOrderQty], [QtyOrdered], [StockTakDiff], [DelivTimeUnit], [OptimalOrderQty], [DefaultBinNo], [SupplierNum], BatchNumber, MaxStockQty, CurrencyCode, AvgCost
GO
