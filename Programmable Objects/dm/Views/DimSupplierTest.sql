IF OBJECT_ID('[dm].[DimSupplierTest]') IS NOT NULL
	DROP VIEW [dm].[DimSupplierTest];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dm].[DimSupplierTest] AS

SELECT 
  	DISTINCT(CONVERT(bigint, [SupplierID])) AS SupplierID
	,CONVERT(bigint, [CompanyID]) AS CompanyID --CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(Company)))
	,[Company]
	,[SupplierNum]
	,[MainSupplierName]
	,[SupplierName]
	,CONCAT(TRIM(SupplierNum), '-', TRIM(SupplierName)) AS Supplier
	,[TelephoneNum]
	,[Email]
	,[ZipCode]
	,[City]
	,[District]
	,[CountryName]
	,[Region]
	,[SupplierCategory]
	,[SupplierResponsible]
	,[AddressLine]
	,[FullAddressLine]
	,[AccountNum]
	,[VATNum]
	,[InternalExternal]
	,CASE WHEN [CodeOfConduct] = '0' THEN 'No'
		  WHEN [CodeOfConduct] = '1' THEN  'Yes'
		  ELSE [CodeOfConduct] END AS CodeOfConduct
	,CoCfeedback
	,[CustomerNum]
	,[SupplierScore]
	,[MinOrderQty]
	,[MinOrderValue]
	,[Website]
	,[Comments]
FROM 
	[dw].[SupplierTest]
Group by 
	[SupplierID], [CompanyID], [Company], [SupplierNum], [SupplierName], [AddressLine], [TelephoneNum], [Email], [ZipCode], [City], [CountryName], [SupplierResponsible], [InternalExternal], [Region], [FullAddressLine], [SupplierCategory], [SupplierResponsible], [AccountNum], [VATNum], [SupplierScore],[CustomerNum], [MinOrderQty], [CodeOfConduct], [District], [MainSupplierName], [MinOrderValue], [Website], [Comments], CoCfeedback
GO
