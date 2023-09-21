IF OBJECT_ID('[prestage].[vCYE_ES_PartTranLine]') IS NOT NULL
	DROP VIEW [prestage].[vCYE_ES_PartTranLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [prestage].[vCYE_ES_PartTranLine] AS
SELECT 
	concat(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,'CYESA' AS [Company]
	,TRIM(SysDate) AS SysDate
	,CONVERT(DATE, TranDate, 120) AS TranDate
	,TRIM(WarehouseCode) AS WarehouseCode
	,TRIM(BinNumber) AS BinNumber
	,TRIM(LotNum) AS LotNum
	,TRIM(TranType) AS TranType
	,TRIM(SysRowID) AS SysRowID
	,TRIM(PartNum) AS PartNum
	,CONVERT(Decimal(18,4), REPLACE(REPLACE(TranQty,'.',''),',','.')) AS TranQty
	,CONVERT(Decimal(18,4), REPLACE(REPLACE(AvgCost,'.',''),',','.')) AS AvgCost
FROM [prestage].[CYE_ES_PartTranLine]
GO
