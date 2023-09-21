IF OBJECT_ID('[dm_ALL].[DimSalesPersonName]') IS NOT NULL
	DROP VIEW [dm_ALL].[DimSalesPersonName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_ALL].[DimSalesPersonName] AS
SELECT  [SalesPersonNameID]
,[Company]
,[SalesPersonName]
FROM dm.DimSalesPersonName
GO
