IF OBJECT_ID('[stage].[vCER_DK_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO












CREATE VIEW [stage].[vCER_DK_StockBalance] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]))))) AS ItemWarehouseID
	,UPPER(CONCAT([Company],'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]))) AS ItemWarehouseCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#','')))) AS SupplierID -- var '0000000'
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,IIF(UPPER(TRIM([WarehouseCode])) IS NULL, 'MissingWHS', UPPER(TRIM([WarehouseCode]))) AS WarehouseCode
	,'DKK'	AS Currency
	,BinNum --Currently there are some duplicates here and BinNum needs to be aggregated. It is only around 6 duplicate rows /SM 2021-05-21
	,BatchNum
	,'' AS SupplierNum
	,UPPER(TRIM([PartNum])) AS PartNum
	,[DelivTime]
	,LastStockTakeDate
	,LastStdCostCalDate
	,SafetyStock
	,MaxStockQty
	,[StockBalance]
	,StockValue
	,AvgCost
	,[ReserveQty]
	,[BackOrderQty]
	,[OrderQty]
	,[StockTakeDiff]
	,[ReOrderLevel]
	,[OptimalOrderQty]
	,SBRes1
	,SBRes2
	,SBRes3
FROM 
	[stage].[CER_DK_StockBalance]
WHERE PartNum IS NOT NULL
GO
