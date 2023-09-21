IF OBJECT_ID('[dm].[FactStockBalance]') IS NOT NULL
	DROP VIEW [dm].[FactStockBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm].[FactStockBalance] AS

SELECT 
	CONVERT(bigint, [ItemWarehouseID]) AS StockBalanceID
    ,CONVERT(bigint, sb.CompanyID) AS CompanyID
	,CONVERT(bigint, SupplierID ) AS SupplierID
    ,CONVERT(bigint, PartID ) AS PartID
    ,CONVERT(bigint, WarehouseID ) AS WarehouseID
	,CONCAT(Right(Year(getdate()), 2), RIGHT(CONCAT('0', Month( getdate()) ),2), '-', c.Currency) AS CurrencyMonthKey
	
	,sb.Company
	,c.Currency
	,[BinNum]
	,[BatchNum]
	,[SupplierNum]
	,[PartNum]
	,[DelivTime]
	,[LastStockTakeDate]
	,[LastStdCostCalDate]
	,[SafetyStock]
	,[MaxStockQty]
	,[StockBalance]
	,[StockValue]
	,AvgCost
	,[ReserveQty]
	,[BackOrderQty]
	,[OrderQty]
	,[StockTakeDiff]
	,[ReOrderLevel]
	,OptimalOrderQty
	,sb.[WarehouseCode]
	,SBRes1
	,SBRes2
	,SBRes3
FROM 
	[dw].[StockBalance] AS sb
	LEFT JOIN dm.DimCompany AS c 
		ON sb.Company = c.Company
WHERE is_deleted != '1'
GO
