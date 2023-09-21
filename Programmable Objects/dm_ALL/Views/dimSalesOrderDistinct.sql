IF OBJECT_ID('[dm_ALL].[dimSalesOrderDistinct]') IS NOT NULL
	DROP VIEW [dm_ALL].[dimSalesOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_ALL].[dimSalesOrderDistinct] AS

SELECT 
 [CompanyID]
,[Company]
,[SalesOrderNumID]
,[SalesOrderNum]
,[CustomerID]
,[Customer]
,[SalesPersonName]
,[SalesChannel]
,[AxInterSalesChannel]
,[Department]
FROM dm.DimSalesOrderDistinct
GO
