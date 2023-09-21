IF OBJECT_ID('[dw].[vALL_SalesPerson]') IS NOT NULL
	DROP VIEW [dw].[vALL_SalesPerson];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dw].[vALL_SalesPerson]
AS
SELECT
	c.Company
	, c.SalesPersonCode
	, c.SalesPersonName
	, MAX(si.SalesPersonName) AS siSalesPerson
	, MAX(so.SalesPersonName) AS soSalesPerson
FROM
	dw.Customer c
	INNER JOIN dw.SalesInvoice si ON c.CustomerID = si.CustomerID AND c.SalesPersonName = si.SalesPersonName
	INNER JOIN dw.SalesOrder so ON c.CustomerID = so.CustomerID AND c.SalesPersonName = so.SalesPersonName
GROUP BY c.Company, c.SalesPersonCode, c.SalesPersonName
GO
