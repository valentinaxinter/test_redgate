IF OBJECT_ID('[stage].[vCYE_ES_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vCYE_ES_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCYE_ES_StockBalance] AS
--ADD TRIM() INTO WarehouseID 23-01-03 VA 
--ADD TRIM() INTO SupplierID 23-01-03 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([PartNum]), '#', TRIM([WarehouseCode]), '#', TRIM(BinNum), '#', TRIM(BatchNum))))) AS ItemWarehouseID
	,UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))) AS WarehouseCode
	,UPPER(CONCAT([Company], '#', TRIM([PartNum]), '#', TRIM([WarehouseCode]))) AS ItemWarehouseCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([SupplierNum]))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,PartitionKey

	,UPPER([Company]) AS Company
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,CASE WHEN TRIM(BinNum) like '' OR BinNum like ' ' THEN NULL ELSE TRIM(BinNum) END AS BinNum
	,TRIM(BatchNum) AS BatchNum
	--,NULL AS [DelivTime]-- convert to days
	,CONVERT(date, '1900-01-01') AS LastStockTakeDate
	,CONVERT(date, '1900-01-01') AS LastStdCostCalDate
	,CONVERT(date, '1900-01-01') AS DelivDateSupplier
	,CONVERT(date, '1900-01-01') AS DelivDateCust
	,CONVERT(date, '1900-01-01') AS OrderDateSupplier
	,CONVERT(date, '1900-01-01') AS OrderDateCust
	,TRIM(Currency) AS Currency
	--,NULL AS SafetyStock
	--,NULL AS MaxStockQty
	,CONVERT(decimal(18,4), REPLACE(StockBalance, ',', '.')) AS StockBalance
	,CONVERT(decimal(18,4), REPLACE(StockValue, ',', '.')) AS StockValue
	,CONVERT(decimal(18,4), REPLACE(AvgCost, ',', '.')) AS AvgCost
	,CONVERT(decimal(18,4), REPLACE(ReserveQty, ',', '.')) AS ReserveQty
	,CONVERT(decimal(18,4), REPLACE(BackOrderQty, ',', '.')) AS BackOrderQty
	,CONVERT(decimal(18,4), REPLACE(OrderQty, ',', '.')) AS OrderQty
	,CONVERT(decimal(18,4), REPLACE(StockTakeDiff, ',', '.')) AS StockTakeDiff
	,CONVERT(decimal(18,4), REPLACE(ReOrderLevel, ',', '.')) AS ReOrderLevel
	,CONVERT(decimal(18,4), REPLACE(OptimalOrderQty, ',', '.')) AS OptimalOrderQty
	,SBRes1
	,SBRes2
	,SBRes3
	
FROM 
	[stage].[CYE_ES_StockBalance]
--	LEFT JOIN dw.PurchaseOrder po ON st.Company = po.Company AND st.PartNum = po.PartNum
--GROUP BY
--	st.[PartitionKey],st.[Company],st.[PartNum],st.[WarehouseCode],st.[IssuerReceiverNum]
GO
