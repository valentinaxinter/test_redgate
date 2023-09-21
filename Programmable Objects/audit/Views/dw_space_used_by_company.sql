IF OBJECT_ID('[audit].[dw_space_used_by_company]') IS NOT NULL
	DROP VIEW [audit].[dw_space_used_by_company];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [audit].[dw_space_used_by_company] as

SELECT 'dw.SalesOrder' AS TableName, [Company], COUNT(1) AS [Rows]--, SUM(COUNT(1)) OVER ()  as [RowsTotal]
  FROM [dw].[SalesOrder]
  GROUP BY Company

UNION ALL

SELECT 'dw.SalesInvoice' AS TableName, [Company], COUNT(1) AS [Rows]--, SUM(COUNT(1)) OVER ()  as [RowsTotal]
FROM [dw].[SalesInvoice]
GROUP BY Company

UNION ALL

SELECT 'dw.StockTransaction' AS TableName, [Company], COUNT(1) AS [Rows]--, SUM(COUNT(1)) OVER ()  as [RowsTotal]
FROM [dw].StockTransaction
GROUP BY Company

UNION ALL

SELECT 'dw.SalesOrderLog' AS TableName, [Company], COUNT(1) AS [Rows]--, SUM(COUNT(1)) OVER ()  as [RowsTotal]
FROM [dw].SalesOrderLog
GROUP BY Company

UNION ALL

SELECT 'dw.SalesLedger' AS TableName, [Company], COUNT(1) AS [Rows]--, SUM(COUNT(1)) OVER ()  as [RowsTotal]
FROM [dw].SalesLedger
GROUP BY Company

UNION ALL

SELECT 'dw.Part' AS TableName, [Company], COUNT(1) AS [Rows]--, SUM(COUNT(1)) OVER ()  as [RowsTotal]
FROM [dw].Part
GROUP BY Company

UNION ALL

SELECT 'dw.PurchaseInvoice' AS TableName, [Company], COUNT(1) AS [Rows]--, SUM(COUNT(1)) OVER ()  as [RowsTotal]
FROM [dw].PurchaseInvoice
GROUP BY Company

UNION ALL

SELECT 'dw.PurchaseOrder' AS TableName, [Company], COUNT(1) AS [Rows]--, SUM(COUNT(1)) OVER ()  as [RowsTotal]
FROM [dw].PurchaseOrder
GROUP BY Company

UNION ALL

SELECT 'dw.Customer' AS TableName, [Company], COUNT(1) AS [Rows]--, SUM(COUNT(1)) OVER ()  as [RowsTotal]
FROM [dw].Customer
GROUP BY Company

UNION ALL

SELECT 'dw.StockBalance' AS TableName, [Company], COUNT(1) AS [Rows]--, SUM(COUNT(1)) OVER ()  as [RowsTotal]
FROM [dw].StockBalance
GROUP BY Company
GO
