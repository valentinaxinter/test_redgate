IF OBJECT_ID('[stage].[vABK_SE_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vABK_SE_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vABK_SE_StockBalance] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO PartID 2022-12-21 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([PartNum]), '#', TRIM([WarehouseCode])))) AS ItemWarehouseID
	,CONCAT([Company], '#', TRIM([PartNum]), '#', TRIM([WarehouseCode])) AS ItemWarehouseCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', '')))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', ''))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,getdate() AS  PartitionKey

	,Company
	,TRIM(PartNum) AS PartNum
	,TRIM(WarehouseCode) AS WarehouseCode
	--,'' AS BinNum
	--,'' BatchNum
	--,'' AS SupplierNum
	--,'' [DelivTime]-- convert to days
	,CONVERT(Date, '1900-01-01') AS LastStockTakeDate
	,CONVERT(Date, IIF(LastStdCostCalDate = '0', '1900-01-01', LastStdCostCalDate)) AS LastStdCostCalDate
	,CONVERT(date, '1900-01-01') AS DelivDateSupplier
	,CONVERT(date, '1900-01-01') AS DelivDateCust
	,CONVERT(date, '1900-01-01') AS OrderDateSupplier
	,CONVERT(date, '1900-01-01') AS OrderDateCust
	,CONVERT(decimal(18,4), StockBalance) AS StockBalance
	,CONVERT(decimal(18,4), StockValue) AS StockValue
	,AvgCost
	,TRIM(Currency) AS Currency
	,ExchangeRate
	--,NULL SafetyStock
	--,NULL MaxStockQty
	--,NULL ReserveQty
	--,NULL BackOrderQty
	--,NULL OrderQty
	--,NULL StockTakeDiff
	--,NULL ReOrderLevel
	--,NULL OptimalOrderQty
	,CreatedTimeStamp AS SBRes1
	,ModifiedTimeStamp AS SBRes2
	--,'' AS SBRes3
FROM 
	[stage].[ABK_SE_StockBalance]
GO
