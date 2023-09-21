IF OBJECT_ID('[stage].[vNOM_FI_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vNOM_FI_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vNOM_FI_StockBalance] AS
--ADD TRIM() INTO PartID 2022-12-15 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]))))) AS ItemWarehouseID
	,TRIM(WarehouseCode) AS WarehouseCode
	,UPPER(CONCAT([Company],'#',TRIM([PartNum]),'#',TRIM([WarehouseCode]))) AS ItemWarehouseCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER([Company]))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,UPPER(Company) AS Company
	,CASE WHEN TRIM(BinNum) like '' OR BinNum like ' ' THEN NULL ELSE TRIM(BinNum) END AS BinNum
	,TRIM(BatchNum) AS BatchNum
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,[DelivTime]-- convert to days
	,IIF(LastStockTakeDate = 0, '1900-01-01', CONVERT(date, LastStockTakeDate)) AS LastStockTakeDate
	,IIF(LastStdCostDate = 0,  '1900-01-01', CONVERT(date, LastStdCostDate)) AS LastStdCostCalDate
	,TRIM(Currency) AS Currency
	,SafetyStock
	,ManualReservations AS MaxStockQty
	,StockBalance
	,StockValue
	,AvgCost
	,ReserveQty
	,BackOrderQty
	,OrderQty
	,StockTakeDiff
	,ReOrderLevel
	,OptimalOrderQty
	,SBRes1
	,SBRes2
	,SBRes3
FROM 
	[stage].[NOM_FI_StockBalance]
GO
