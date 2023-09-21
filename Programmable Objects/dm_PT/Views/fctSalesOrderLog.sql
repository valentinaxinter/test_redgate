IF OBJECT_ID('[dm_PT].[fctSalesOrderLog]') IS NOT NULL
	DROP VIEW [dm_PT].[fctSalesOrderLog];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_PT].[fctSalesOrderLog] AS

SELECT sol.[SalesOrderLogID]
,sol.[CompanyID]
,sol.[CustomerID]
,sol.[PartID]
,sol.[WarehouseID]
,sol.[SalesPersonNameID]
,sol.[SalesOrderDateID]
,sol.[PartitionKey]
,sol.[Company]
,sol.[CustomerNum]
,sol.[SalesOrderNum]
,sol.[SalesOrderLine]
,sol.[SalesOrderSubLine]
,sol.[SalesOrderType]
,sol.[SalesOrderLogType]
,sol.[SalesOrderDate]
,sol.[SalesOrderLogDate]
,sol.[SalesInvoiceNum]
,sol.[SalesOrderQty]
,sol.[UoM]
,sol.[UnitPrice]
,sol.[UnitCost]
,sol.[Currency]
,sol.[ExchangeRate]
,sol.[OpenRelease]
,sol.[DiscountPercent]
,sol.[DiscountAmount]
,sol.[PartNum]
,sol.[PartType]
,sol.[SalesPersonName]
,sol.[Department]
,sol.[WarehouseCode]
  FROM [dm].[FactSalesOrderLog] sol
  LEFT JOIN dbo.Company com ON sol.Company = com.Company
WHERE com.BusinessArea = 'Power Transmission Solutions' AND com.[Status] = 'Active'

--WHERE Company in ('SKSSCOFI', 'SCOFI', 'SMKFI', 'BSIBELL', 'NomoSE', 'NomoDK', 'NomoFI', 'NomoNo', 'ACZARKOV', 'JSEJENSS', 'JDKJENSS', 'JNOJENSS', 'JSESKSSW', /*'MAK',*/ 'PPLPASSE', 'SNLSPRUI','SVESE' /*, 'PASSEROT'*/)  -- The PT basket
GO
