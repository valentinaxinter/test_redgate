IF OBJECT_ID('[stage].[vARK_PI_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vARK_PI_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vARK_PI_StockBalance] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO PartID,WarehouseID 2022-12-16 VA
--ADD TRIM() INTO Supplier ID 23-01-23 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM(UPPER([PartNum])),'#',TRIM([WarehouseCode]))))) AS ItemWarehouseID
	,UPPER(CONCAT([Company],'#',TRIM(UPPER([PartNum])),'#',TRIM([WarehouseCode]))) AS ItemWarehouseCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM(UPPER([SupplierNum])))))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(UPPER([PartNum])))))) AS PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM(UPPER([PartNum])))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,[PartitionKey]

	,[Company]
	,TRIM([WarehouseCode]) AS WarehouseCode
	,Currency
	,[BinNum]
	,BatchNum
	,TRIM(UPPER([SupplierNum])) AS [SupplierNum]
	,TRIM(UPPER([PartNum])) AS PartNum
	,[DelivTime]
	,convert(date, SBRes1) AS LastStockTakeDate
	,convert(date, LastStdCostCalDate) AS LastStdCostCalDate
	,SafetyStock
	,MaxStockQty
	,[StockBalance]
	,StockValue
	,IIF([StockBalance] <> 0, StockValue/[StockBalance], 0) AS AvgCost --0, IIF added 20211108 efter Emil
	,ReserveQty
	,BackOrderQty
	,OrderQty
	,SBRes2 AS StockTakeDiff
	,[ReOrderLevel]
	,[OptimalOrderQty]
	--,'' AS SBRes1
	--,'' AS SBRes2
	,SBRes3
FROM 
	[stage].[ARK_PI_StockBalance]
GO
