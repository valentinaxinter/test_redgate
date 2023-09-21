IF OBJECT_ID('[dm].[DimCompany]') IS NOT NULL
	DROP VIEW [dm].[DimCompany];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [dm].[DimCompany] AS

SELECT       
	CONVERT(bigint, CONVERT([binary](32), HASHBYTES('SHA2_256', company))) AS CompanyID
--	, CONVERT([binary](32), HASHBYTES('SHA2_256', company)) AS CompanyIDhashed
	, [Company]
	, TRIM([CompanyName]) AS [CompanyName]
	, [CompanyGroup]
	, [Division]
	, [BusinessArea]
	, [Country]
	, [Currency]
	, [CompanyShortO365]
	, [CompanyShort]
	, [CompanyShortAD]
	, [CompanyCode]
	, [FromPeriod]
	, [DateAdd]
	, [ValidatedSales]
	, ValidatedPurchase
	, CompanyLogo
FROM            
	dbo.company

	where [Status] = 'Active' 
	--companyname not in ('TRS Motorsport','Peter Harbo', 'S.E. Lodéns Industrimontage​','Klätterteknik','IWRC','GISAB','Drivsystem 05','Cleanroom Cranes','Bronco Transmission') -- excluded these companies since they are either part of another company or sold
GO
