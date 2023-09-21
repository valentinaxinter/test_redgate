IF OBJECT_ID('[dm].[DimSalesPersonName]') IS NOT NULL
	DROP VIEW [dm].[DimSalesPersonName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm].[DimSalesPersonName]
AS
SELECT
	CONVERT(bigint,SalesPersonNameID) as SalesPersonNameID,
	Company,
	SalesPersonName
FROM dw.SalesPersonName;
GO
