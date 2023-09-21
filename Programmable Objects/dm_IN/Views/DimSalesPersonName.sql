IF OBJECT_ID('[dm_IN].[DimSalesPersonName]') IS NOT NULL
	DROP VIEW [dm_IN].[DimSalesPersonName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_IN].[DimSalesPersonName]
AS
SELECT sp.[SalesPersonNameID]
,sp.[Company]
,sp.[SalesPersonName]
FROM dm.DimSalesPersonName as sp
WHERE sp.Company IN ('OCSSE');
GO
