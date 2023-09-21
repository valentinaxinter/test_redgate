IF OBJECT_ID('[dm_LS].[fctSalesInvoice]') IS NOT NULL
	DROP VIEW [dm_LS].[fctSalesInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dm_LS].[fctSalesInvoice] AS

SELECT 
 si.[SalesInvoiceID]
,si.[SalesOrderID]
,si.[SalesOrderNumID]
,si.[CustomerID]
,si.[CompanyID]
,si.[PartID]
,si.[WarehouseID]
,si.[SalesPersonNameID]
,si.[DepartmentID]
,si.[Company]
,si.[SalesInvoiceCode]
,si.[SalesInvoiceDateID]
,si.[ProjectID]
,si.[SalesPersonName]
,si.[CustomerNum]
,si.[PartNum]
,si.[PartType]
,si.[SalesOrderNum]
,si.[SalesOrderLine]
,si.[SalesOrderSubLine]
,si.[SalesOrderType]
,si.[SalesInvoiceNum]
,si.[SalesInvoiceLine]
,si.[SalesInvoiceType]
,si.[SalesInvoiceDate]
,si.[ActualDelivDate]
,si.[SalesInvoiceQty]
,si.[UoM]
,si.[UnitPrice]
,si.[UnitCost]
,si.[DiscountPercent]
,si.[DiscountAmount]
,si.[TotalMiscChrg]
,si.[Currency]
,si.[ExchangeRate]
,si.[VATAmount]
,si.[CreditMemo]
,si.[Department]
,si.[ProjectNum]
,si.[WarehouseCode]
,si.[CostBearerNum]
,si.[CostUnitNum]
,si.[ReturnComment]
,si.[ReturnNum]
,si.[OrderHandler]
,si.[SalesChannel]
,si.[NeedbyDate]
,si.[ExpDelivDate]
,si.[SalesOrderCode]
,si.[SalesOrderDateID]
,si.[SalesOrderDate]
,si.[ConfirmedDelivDate]
,si.[PartStatus]
,si.[AxInterSalesChannel]
,si.[DueDate]
,si.[LastPaymentDate]
,si.[SalesInvoiceStatus]
,si.[CashDiscountOffered]
,si.[CashDiscountUsed]
,si.[IsUpdatingStock]
,si.[SIRes1]
,si.[SIRes2]
,si.[SIRes3]
,si.[SIRes4]
,si.[SIRes5]
,si.[SIRes6]
FROM dm.FactSalesInvoice si
LEFT JOIN dbo.Company com ON si.Company = com.Company
WHERE com.BusinessArea = 'Lifting Solutions' AND com.[Status] = 'Active'

--WHERE Company  in ('AFISCM', 'CDKCERT', 'CEECERT', 'CFICERT', 'CLTCERT', 'CLVCERT', 'CSECERT', 'CUKCERT', 'CNOEHAU', 'CNOCERT', 'CERPL', 'CyESA', 'HFIHAKL', 'TRACLEV'
--			,'MENBE14','MENNL01','MENNL02','MENNL03','MENNL04','MENNL07','MENNL11')  -- LS basket
GO
