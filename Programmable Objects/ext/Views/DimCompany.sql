IF OBJECT_ID('[ext].[DimCompany]') IS NOT NULL
	DROP VIEW [ext].[DimCompany];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [ext].[DimCompany] AS
select [CompanyID], [Company], [CompanyName], [CompanyGroup], [Division], [BusinessArea], [Country], [Currency], [CompanyShortO365], [CompanyShort], [CompanyShortAD], [CompanyCode], [FromPeriod], [DateAdd], [ValidatedSales], [ValidatedPurchase], [CompanyLogo] FROM dm.DimCompany
GO
