IF OBJECT_ID('[stage].[vCER_NO_BC_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_BC_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [stage].[vCER_NO_BC_StockBalance] as

sELECT

--------------------------------------------- Keys/ IDs ---------------------------------------------
CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum),'#',TRIM(WarehouseCode))))) AS ItemWarehouseID
,UPPER(CONCAT(Company,'#',TRIM(PartNum),'#',TRIM(WarehouseCode))) AS ItemWarehouseCode
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
,PartitionKey

--------------------------------------------- Regular Fields ---------------------------------------------

---Mandatory Fields ---
,UPPER(TRIM(Company)) AS Company
,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
,UPPER(TRIM(PartNum)) AS PartNum
,CONVERT(decimal(18,4), Replace(StockBalance, ',', '.')) AS StockBalance
,CONVERT(decimal(18,4), Replace(StockValue, ',', '.')) AS StockValue
--,UPPER(TRIM(Currency)) AS Currency

---Valuable Fields ---
,UPPER(TRIM(BinNum)) AS BinNum
,UPPER(TRIM(SupplierNum)) AS SupplierNum
,CASE 
	WHEN TRIM(DelivTime_letra) = 'D' THEN DelivTime
	WHEN TRIM(DelivTime_letra) = 'W' THEN DelivTime * 7
	WHEN TRIM(DelivTime_letra) = 'M' THEN DelivTime * 30
	WHEN TRIM(DelivTime_letra) = 'Y' THEN DelivTime * 360
	ELSE 0 END AS DelivTime
,CASE WHEN LastStockTakeDate = '' OR LastStockTakeDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, LastStockTakeDate) END AS LastStockTakeDate
--,CONVERT(decimal(18,4), Replace(StockTakeDiff, ',', '.')) AS StockTakeDiff
--,CONVERT(decimal(18,4), Replace(SalesRemainingQty, ',', '.')) AS SalesRemainingQty
--,CONVERT(decimal(18,4), Replace(PurchaseRemainingqty, ',', '.')) AS PurchaseRemainingqty
--,CONVERT(decimal(18,4), Replace(AvgCost, ',', '.')) AS AvgCost

---Good-to-have Fields ---
--,CASE WHEN LastStdCostCalDate = '' OR LastStdCostCalDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, LastStdCostCalDate) END AS LastStdCostCalDate
--,CONVERT(decimal(18,4), Replace(MaxStockQty, ',', '.')) AS MaxStockQty
--,CONVERT(decimal(18,4), Replace(ReOrderLevel, ',', '.')) AS ReOrderLevel
--,CONVERT(decimal(18,4), Replace(SafetyStock, ',', '.')) AS SafetyStock
--,CONVERT(decimal(18,4), Replace(OptimalOrderQty, ',', '.')) AS OptimalOrderQty

--------------------------------------------- Meta Data ---------------------------------------------
,CONVERT(date, ModifiedTimeStamp) AS ModifiedTimeStamp
,CONVERT(date, CreatedTimeStamp) AS CreatedTimeStamp
--,TRIM(IsActiveRecord) AS IsActiveRecord

--------------------------------------------- Extra Fields ---------------------------------------------
--,UPPER(TRIM(SBRes1)) AS SBRes1
--,UPPER(TRIM(SBRes2)) AS SBRes2
--,UPPER(TRIM(SBRes3)) AS SBRes3

from [stage].[CER_NO_BC_StockBalance]
GO
