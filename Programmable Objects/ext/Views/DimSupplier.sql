IF OBJECT_ID('[ext].[DimSupplier]') IS NOT NULL
	DROP VIEW [ext].[DimSupplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [ext].[DimSupplier] AS

--this view created for CoC power application purpose. /DZ
--external consultant are Rebecka Nyström & Joel Björck @accigo.se
select [SupplierID], [CompanyID], [Company], [SupplierNum], [MainSupplierName], [SupplierName], [Supplier], [TelephoneNum], [Email], [ZipCode], [City], [District], [CountryName], [Region], [SupplierCategory], [SupplierResponsible], [AddressLine], [FullAddressLine], [AccountNum], [VATNum], [InternalExternal], [CodeOfConduct], [CoCfeedback], [CustomerNum], [SupplierScore], [MinOrderQty], [MinOrderValue], [Website], [Comments] FROM dm.DimSupplierTest
GO
