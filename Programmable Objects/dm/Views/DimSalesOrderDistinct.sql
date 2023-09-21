IF OBJECT_ID('[dm].[DimSalesOrderDistinct]') IS NOT NULL
	DROP VIEW [dm].[DimSalesOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm].[DimSalesOrderDistinct] AS
--based on the [dm].[FactSalesOrderDistinctExt]
WITH SalesOrderDistinct AS
(SELECT
	CONVERT (bigint, o.CompanyID ) AS CompanyID
	,CONVERT(bigint, o.SalesOrderNumID) AS SalesOrderNumID
	,MIN(CONVERT(bigint, o.CustomerID)) AS CustomerID  --MIN(CONVERT(bigint, o.CustomerID)) AS CustomerID removed 2022-08-23 -- 29/8 re-installed, must have
	,MIN(o.Company) AS Company
	,MIN(o.SalesOrderNum) AS SalesOrderNum
	,MIN(CONCAT(c.CustomerNum, '-', c.CustomerName)) AS Customer -- must remain, ST needs
	,'' AS SalesPersonName -- o.SalesPersonName  AS SalesPersonName
	,o.SalesChannel AS SalesChannel
	,o.AxInterSalesChannel AS AxInterSalesChannel
	,o.Department AS Department  --Sam/DZ 20221111
FROM 
	dw.SalesOrder AS o
	LEFT JOIN dw.Customer AS c ON o.CompanyID = c.CompanyID AND o.CustomerID = c.CustomerID
WHERE o.SalesOrderNumID is not null  --o.Company not like 'MEN%' and Mennen has gaven duplications and CERNO had Null in SalesOrderNumID
GROUP BY
		o.CompanyID, SalesOrderNumID, SalesChannel, AxInterSalesChannel, o.Department
)
	SELECT 
		CompanyID
		,Company
		,MIN(SalesOrderNumID) AS SalesOrderNumID
		,SalesOrderNum
		,MIN(CustomerID) AS CustomerID -- MIN(CustomerID) AS CustomerID removed 2022-08-23-- 29/8 re-installed, must have
		,MIN(Customer) AS Customer -- MIN(Customer) AS Customer removed 2022-08-23 -- 29/8 re-installed, must have
		,'' AS SalesPersonName --MIN(SalesPersonName) AS SalesPersonName --added 2022-04-27, there are cases (eg.SalesOrderNum = '1982017029') where one order can connect to several salesperson, but in total is a small percentage (0,05% = 2804/5114219), we choose one so that 1:* relationship is valid
		,MIN(SalesChannel) AS SalesChannel --added 2022-04-27, there are cases (eg.SalesOrderNum = '1982017029') where one order can connect to several SalesChannel, but in total is a small percentage (0,05% = 2804/5114219), we choose one so that 1:* relationship is valid
		,MIN(AxInterSalesChannel) AS AxInterSalesChannel --the same as SalesChannel & SalesPersonName
		,MIN(Department) AS Department
	FROM SalesOrderDistinct
	WHERE SalesOrderNumID is not NULL 

	--SalesOrderDate >= DATEADD(year, DATEDIFF(YEAR, 0, dateadd(year, - 4, GETDATE())), 0)
	GROUP BY CompanyID, Company, SalesOrderNum--, Department --, CustomerID, Customer --, SalesOrderNumID
GO
