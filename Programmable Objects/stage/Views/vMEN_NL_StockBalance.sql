IF OBJECT_ID('[stage].[vMEN_NL_StockBalance]') IS NOT NULL
	DROP VIEW [stage].[vMEN_NL_StockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vMEN_NL_StockBalance]	AS
WITH CTE AS (
SELECT	
		CASE WHEN Company = '14' THEN  CONCAT(N'MENBE',Company) 
			ELSE  CONCAT(N'MENNL',Company)  END AS CompanyCode		
	  ,[PartitionKey], [Company], [PartNum], [WareHouseCode], [LotNum], [TranDate], [QtyDec12.5], [QtyFloat], [ProductKey], [DW_TimeStamp]
  FROM [stage].[MEN_NL_StockBalance]
)
SELECT 
--ADD TRIM() UPPER() INTO WarehouseID 23-01-12 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA

	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',ProductKey,'#',UPPER([WarehouseCode]) ))) AS ItemWarehouseID 
	,CONCAT([CompanyCode],'#',[PartNum],'#',[WarehouseCode]) AS ItemWarehouseCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([CompanyCode],'#',PartNum))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([CompanyCode])))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([CompanyCode]),'#','')))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([CompanyCode],'#',''))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([CompanyCode]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([CompanyCode],'#',UPPER([WarehouseCode])))) AS WarehouseID
	  ,[PartitionKey]

      ,[CompanyCode]			AS Company
	  ,'EUR'					AS Currency
      	
	  ,[LotNum]					AS BinNum
	  ,NULL						AS BatchNum
      ,UPPER([WareHouseCode])	AS WarehouseCode
      ,NULL						AS SupplierNum
	  ,[PartNum]
	  ,NULL						AS DelivTime
	  ,'1900-01-01'				AS LastStockTakeDate
--      ,[TranDate]
--      ,[QtyDec12.5]

	  ,'1900-01-01'				AS LastStdCostCalDate
	  ,NULL						AS SafetyStock
	  ,NULL						AS MaxStockQty
	  ,TRY_CAST(ROUND(TRY_CAST([QtyDec12.5] as float),4) AS decimal(18,4))	AS StockBalance
	  ,NULL						AS StockValue
	  ,NULL						AS AvgCost
	  ,NULL						AS [ReserveQty]
	  ,NULL						AS [BackOrderQty]
	  ,NULL						AS [OrderQty]
	  ,NULL						AS [StockTakeDiff]
	  ,NULL						AS [ReOrderLevel]
	  ,NULL						AS [OptimalOrderQty]
	  ,''						AS SBRes1
	  ,''						AS SBRes2
	  ,''						AS SBRes3
  FROM CTE
GO
