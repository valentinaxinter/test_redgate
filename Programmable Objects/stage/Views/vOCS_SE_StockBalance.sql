IF OBJECT_ID('[stage].[vOCS_SE_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_StockBalance];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vOCS_SE_StockBalance] AS 
SELECT 
CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum),'#',TRIM(WarehousCode))))) AS ItemWarehouseID
,UPPER(CONCAT(Company,'#',TRIM(PartNum),'#',TRIM(WarehousCode))) AS ItemWarehouseCode
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehousCode))))) AS WarehouseID
,PartitionKey
--Mandatory Fields ---
,UPPER(TRIM(Company)) AS Company
,UPPER(TRIM(WarehousCode)) AS WarehouseCode
,UPPER(TRIM(PartNum)) AS PartNum
,CONVERT(decimal(18,4), Replace(PhysicalStockBalance, ',', '.')) AS StockBalance
,CONVERT(decimal(18,4), Replace(PhysicalStockValue, ',', '.')) AS StockValue
,UPPER(TRIM('SEK')) AS Currency
,cast(1 as decimal(18,4)) as ExchangeRate


---Valuable Fields ---
,UPPER(TRIM(BinNum)) AS BinNum
,UPPER(TRIM(SupplierNum)) AS SupplierNum
,DelivTime AS DelivTime
,CASE WHEN LastStockTakeDate = '' OR LastStockTakeDate is NULL or LastStockTakeDate = 0 THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, LastStockTakeDate, 112) END AS LastStockTakeDate
,CONVERT(decimal(18,4), Replace(StockTakeDiff, ',', '.')) AS StockTakeDiff
,CONVERT(decimal(18,4), Replace(SalesRemainingQty, ',', '.')) AS SalesRemainingQty
,CONVERT(decimal(18,4), Replace(PurchaseRemainingqty, ',', '.')) AS PurchaseRemainingqty
,CONVERT(decimal(18,4), Replace(AvgCost, ',', '.')) AS AvgCost

---Good-to-have Fields ---
,CASE WHEN LastStdCostCalDate = '' OR LastStdCostCalDate is NULL or LastStdCostCalDate = 0 THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, LastStdCostCalDate, 112) END AS LastStdCostCalDate
,CONVERT(decimal(18,4), Replace(MaxStockQty, ',', '.')) AS MaxStockQty
,CONVERT(decimal(18,4), Replace(ReOrderLevel, ',', '.')) AS ReOrderLevel
,CONVERT(decimal(18,4), Replace(SafetyStock, ',', '.')) AS SafetyStock
,CONVERT(decimal(18,4), Replace(OptimalOrderQty, ',', '.')) AS OptimalOrderQty

--------------------------------------------- Meta Data ---------------------------------------------
,CONVERT(date, ModifiedTimeStamp) AS ModifiedTimeStamp
,CONVERT(date, CreatedTimeStamp) AS CreatedTimeStamp
--,TRIM(IsActiveRecord) AS IsActiveRecord

--------------------------------------------- Extra Fields ---------------------------------------------
--,UPPER(TRIM(SBRes1)) AS SBRes1
--,UPPER(TRIM(SBRes2)) AS SBRes2
--,UPPER(TRIM(SBRes3)) AS SBRes3

	FROM [stage].[OCS_SE_StockBalance]
GO
