IF OBJECT_ID('[stage].[vSalesPersonName]') IS NOT NULL
	DROP VIEW [stage].[vSalesPersonName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSalesPersonName]
AS
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company,'#',SalesPersonName))) as SalesPersonNameID,
	Company,
	SalesPersonName
FROM stage.SalesPersonName;
GO
