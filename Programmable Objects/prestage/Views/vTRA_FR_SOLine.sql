IF OBJECT_ID('[prestage].[vTRA_FR_SOLine]') IS NOT NULL
	DROP VIEW [prestage].[vTRA_FR_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [prestage].[vTRA_FR_SOLine] AS

SELECT 
	CONCAT(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,Prop_0 AS [Company]
	,Prop_1 AS [SalesPersonName]
	,Prop_2 AS [CustomerNum]
	,Prop_3 AS [PartNum]
	,Prop_4 AS [PartType]
	,Prop_5 AS [SalesOrderNum]
	,Prop_6 AS [SalesOrderLine]
	,Prop_7 AS [SalesOrderSubLine]
	,Prop_8 AS [SalesOrderType]
	,Prop_9 AS [SalesInvoiceNum]
	,Prop_10 AS [SalesInvoiceLine]
	,Prop_11 AS [SalesInvoiceType]
	,CONVERT(date, CONCAT(SUBSTRING(Prop_12, 7,4), SUBSTRING(Prop_12, 4,2), SUBSTRING(Prop_12, 1,2))) AS [SalesInvoiceDate]
	,CONVERT(date, CONCAT(SUBSTRING(Prop_13, 7,4), SUBSTRING(Prop_13, 4,2), SUBSTRING(Prop_13, 1,2))) AS [ActualDelivDate]
	,Prop_14 AS [SalesInvoiceQty]
	,Prop_15 AS [UoM]
	,Prop_16 AS [UnitPrice]
	,Prop_17 AS [UnitCost]
	,Prop_18 AS [DiscountPercent]
	,Prop_19 AS [DiscountAmount]
	,Prop_20 AS [TotalMiscChrg]
	,Prop_21 AS [CashDiscountOffered]
	,Prop_22 AS [CashDiscountUsed]
	,Prop_23 AS [VATAmount]
	,Prop_24 AS [Currency]
	,Prop_25 AS [ExchangeRate]
	,Prop_26 AS [CreditMemo]
	,Prop_27 AS [SalesChannel]
	,Prop_28 AS [Department]
	,Prop_29 AS [WarehouseCode]
	,Prop_30 AS [CostBearerNum]
	,Prop_31 AS [CostUnitNum]
	,Prop_32 AS [ReturnComment]
	,Prop_33 AS [ReturnNum]
	,Prop_34 AS [ProjectNum]
	,Prop_35 AS [IndexKey]
	,Prop_36 AS [SIRes1]
	,Prop_37 AS [SIRes2]
	,Prop_38 AS [SIRes3]
FROM [prestage].[TRA_FR_SOLine]
GO
