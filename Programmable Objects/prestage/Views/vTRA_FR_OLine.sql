IF OBJECT_ID('[prestage].[vTRA_FR_OLine]') IS NOT NULL
	DROP VIEW [prestage].[vTRA_FR_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [prestage].[vTRA_FR_OLine] AS

SELECT 
	CONCAT(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,Prop_0 AS [Company]
	,Prop_1 AS [CustomerNum]
	,Prop_2 AS [SalesOrderNum]
	,Prop_3 AS [SalesOrderLine]
	,Prop_4 AS [SalesOrderSubLine]
	,Prop_5 AS [SalesOrderType]
	,Prop_6 AS [SalesOrderCategory]
	,Prop_7 AS [SalesOrderStatus]
	,CONVERT(date, CONCAT(SUBSTRING(Prop_8, 7,4), SUBSTRING(Prop_8, 4,2), SUBSTRING(Prop_8, 1,2))) AS [SalesOrderDate]
	,CONVERT(date, CONCAT(SUBSTRING(Prop_9, 7,4), SUBSTRING(Prop_9, 4,2), SUBSTRING(Prop_9, 1,2))) AS [NeedbyDate]
	,CONVERT(date, CONCAT(SUBSTRING(Prop_10, 7,4), SUBSTRING(Prop_10, 4,2), SUBSTRING(Prop_10, 1,2))) AS [ExpDelivDate]
	,CONVERT(date, CONCAT(SUBSTRING(Prop_11, 7,4), SUBSTRING(Prop_11, 4,2), SUBSTRING(Prop_11, 1,2))) AS [ActualDelivDate]
	,Prop_12 AS [SalesInvoiceNum]
	,TRY_CONVERT(decimal(18, 2), Prop_13) AS [SalesOrderQty]
	,TRY_CONVERT(decimal(18, 2), Prop_14) AS [DelivQty]
	,TRY_CONVERT(decimal(18, 2), Prop_15) AS [RemainingQty]
	,Prop_16 AS [UoM]
	,TRY_CONVERT(decimal(18, 2), Prop_17) AS [UnitPrice]
	,TRY_CONVERT(decimal(18, 2), Prop_18) AS [UnitCost]
	,Prop_19 AS [Currency]
	,TRY_CONVERT(decimal(18, 2), Prop_20) AS [ExchangeRate]
	,TRY_CONVERT(decimal(18, 2), Prop_21) AS [DiscountPercent]
	,TRY_CONVERT(decimal(18, 2), Prop_22) AS [DiscountAmount]
	,Prop_23 AS [PartNum]
	,Prop_24 AS [PartType]
	,Prop_25 AS [PartStatus]
	,Prop_26 AS [SalesPersonName]
	,Prop_27 AS [WarehouseCode]
	,Prop_28 AS [SalesChannel]
	,Prop_29 AS [Department]
	,Prop_30 AS [ProjectNum]
	,Prop_31 AS [Cancellation]
	,Prop_32 AS [IndexKey]
	,Prop_33 AS [SORes1]
	,Prop_34 AS [SORes2]
	,Prop_35 AS [SORes3]

FROM [prestage].[TRA_FR_OLine]
GO
