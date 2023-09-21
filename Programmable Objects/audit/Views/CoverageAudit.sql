IF OBJECT_ID('[audit].[CoverageAudit]') IS NOT NULL
	DROP VIEW [audit].[CoverageAudit];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









--------------------- Script for identifying percent null & empty string values per column and company ----------------------------------------



--Data types 
	 -- VARCHAR  CAST(cast(count(NULLIF(,'')) as decimal) /count(*) AS decimal(10,3)) as ,
	 -- DATE  CAST(cast(count(NULLIF(,'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as ,
	-- DECIMAL/Interger   CAST(cast(count() as decimal) /count(*) AS decimal(10,3)) as ,

CREATE view [audit].[CoverageAudit] AS 


SELECT 
tc.DateRef
,tc.Company
, tc.DwTable as SMSSTable
, tc.Field
, cast(tc.PercentageNull as decimal(4,3)) as PercentageNull
, comp.BusinessArea
, Comp.CompanyGroup
, Comp.CompanyName
, comp.ValidatedPurchase
, Comp.ValidatedSales
from audit.TableCoverage AS tc
LEFT JOIN dbo.Company AS Comp
ON    tc.Company    = Comp.Company
GO
