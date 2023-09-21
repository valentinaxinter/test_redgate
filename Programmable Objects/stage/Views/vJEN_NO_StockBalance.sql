IF OBJECT_ID('[stage].[vJEN_NO_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NO_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vJEN_NO_StockBalance] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO WarehouseID,PartID 2022-12-22 VA
--ADD TRIM()UPPER() INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]),'#',TRIM([WarehouseCode]),'#',MAX([FIFOValue]),'#',MAX([StockTakDate]),'#'
	,MAX([StdCostLaCaD]),'#',MAX([DelivDateSupplier]),'#',MAX([DelivDateCust]),'#',MAX([DelivDateCust])))) AS ItemWarehouseID
	,CONCAT([Company],'#',TRIM([PartNum]),'#',TRIM([SupplierNum])) AS ItemWarehouseCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([SupplierNum])))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([PartNum])))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([WarehouseCode])))) AS WarehouseID
	,[PartitionKey]

	,TRIM([WarehouseCode]) AS WarehouseCode
	,CurrencyCode AS Currency
	,[Company]
	,TRIM([DefaultBinNo]) AS BinNum
	,BatchNumber AS BatchNum
	,[SupplierNum]
	,TRIM([PartNum]) AS PartNum
	,[DelivTimeUnit] AS [DelivTime]
	,MAX(convert(date, [StockTakDate])) AS LastStockTakeDate
	,MAX(convert(date, [StdCostLaCaD])) AS LastStdCostCalDate
	--,0 AS SafetyStock
	,MaxStockQty
	,[StockBalance]
	,AvgCost*[StockBalance] AS StockValue
	,AvgCost
	,[ReservedQty]		AS ReserveQty
	,[BackOrderQty]		AS BackOrderQty
	,[QtyOrdered]		AS OrderQty
	,[StockTakDiff]		AS StockTakeDiff
	,[ReOrderLevel]
	,[OptimalOrderQty]
	--,'' AS SBRes1
	--,'' AS SBRes2
	--,'' AS SBRes3
	,MAX([FIFOValue]) AS [FIFOValue]
	--,'' AS [DelivTimeToWHS]-- will not be sent out to new companies, not delete in DW for that use as reservation
	--,'' AS [DelivTimeDesc]-- will not be sent out to new companies, not delete in DW for that use as reservation
	--,'' AS [DaysOnStock]
--	,CASE WHEN TRIM(DefaultBinNo) like '' OR DefaultBinNo like  ' '
--		THEN NULL ELSE TRIM(DefaultBinNo) END AS DefaultBinNo
	,MAX(convert(date, [DelivDateSupplier])) AS DelivDateSupplier
	,MAX(convert(date, [DelivDateCust])) AS DelivDateCust
	,MAX(convert(date, [OrderDateSupplier])) AS OrderDateSupplier
	,convert(date, '') AS OrderDateCust
	--,'' AS BatchNoPrefix-- will not be sent out to new companies, not delete in DW for that use as reservation
	--,'' AS BatchNoSuffix-- will not be sent out to new companies, not delete in DW for that use as reservation
FROM 
	[stage].[JEN_NO_StockBalance]
GROUP BY
	[PartitionKey], [Company], [PartNum], [WarehouseCode], [StockBalance], [ReservedQty], [BackOrderQty], [QtyOrdered], [StockTakDiff], [DelivTimeToWHS], [DelivTimeToWHS], [DelivTimeUnit], [DelivTimeDesc], [ReOrderLevel], [OptimalOrderQty], [DefaultBinNo], [SupplierNum], BatchNumber, MaxStockQty, CurrencyCode, AvgCost
GO
