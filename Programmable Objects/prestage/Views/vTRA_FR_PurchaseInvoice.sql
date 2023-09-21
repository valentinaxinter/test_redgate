IF OBJECT_ID('[prestage].[vTRA_FR_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [prestage].[vTRA_FR_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [prestage].[vTRA_FR_PurchaseInvoice] AS

SELECT 
	CONCAT(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,Prop_0 AS [Company]
	,Prop_1 AS [PurchaseOrderNum]
	,Prop_2 AS [PurchaseOrderLine]
	,Prop_3 AS [PurchaseOrderSubLine]
	,Prop_4 AS [PurchaseOrderType]
	,Prop_5 AS [PurchaseInvoiceNum]
	,Prop_6 AS [PurchaseInvoiceLine]
	,Prop_7 AS [PurchaseInvoiceType]
	,Prop_8 AS [PurchaseInvoiceDate]
	,Prop_9 AS [ActualDelivDate]
	,Prop_10 AS [SupplierNum]
	,Prop_11 AS [PartNum]
	,Prop_12 AS [PurchaseInvoiceQty]
	,Prop_13 AS [UoM]
	,Prop_14 AS [UnitPrice]
	,Prop_15 AS [DiscountPercent]
	,Prop_16 AS [DiscountAmount]
	,Prop_17 AS [TotalMiscChrg]
	,Prop_18 AS [VATAmount]
	,Prop_19 AS [ExchangeRate]
	,Prop_20 AS [Currency]
	,Prop_21 AS [CreditMemo]
	,Prop_22 AS [PurchaserName]
	,Prop_23 AS [WarehouseCode]
	,Prop_24 AS [PurchaseChannel]
	,Prop_25 AS [Comment]
	,Prop_26 AS [PIRes1]
	,Prop_27 AS [PIRes2]
	,Prop_28 AS [PIRes3]

FROM [prestage].[TRA_FR_PurchaseInvoice]
GO
