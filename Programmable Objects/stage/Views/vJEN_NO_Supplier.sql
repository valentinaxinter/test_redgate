IF OBJECT_ID('[stage].[vJEN_NO_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vJEN_NO_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [stage].[vJEN_NO_Supplier] AS
--ADD TRIM() INTO SupplierID 23-01-24 
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT([Company], '#', TRIM([SupplierNum]))) AS SupplierCode 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,[PartitionKey]

	,TRIM(UPPER([Company])) AS Company
	,TRIM(UPPER([SupplierNum])) AS [SupplierNum]
	,TRIM([Name]) AS MainSupplierName
	,[dbo].[ProperCase]([Name]) AS SupplierName
	,TRIM([AddressLine1]) AS [AddressLine1]
    ,TRIM([AddressLine2]) AS [AddressLine2]
    ,TRIM([AddressLine3]) AS [AddressLine3]
	,TRIM([TelephoneNum]) AS [TelephoneNum]
	,TRIM([Email]) AS [Email]
	,[dbo].[udf_GetNumeric]([Addressline3]) AS ZipCode
	,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))  AS [City]
	--,'' AS [District]
	,case when len(TRIM(supplier.CountryCode)) = 3 then cc.[Alpha-2 code]
	else isnull(nullif(TRIM(supplier.CountryCode),''),'NO')
	end AS CountryCode
	,[dbo].[ProperCase](supplier.[CountryName]) AS CountryName
	,TRIM([Region]) AS [Region]
	,TRIM([SupplierCategory]) AS [SupplierCategory]
	,TRIM([Reference]) AS [SupplierResponsible]
	,[dbo].[ProperCase](TRIM(concat (addressline1+' '+ addressline2, null))) AS AddressLine
	,[dbo].[ProperCase](TRIM(concat_ws(',', coalesce([dbo].[ProperCase](supplier.CountryName),null), IIF(City= ' ',null,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))), IIF(ZIP= ' ', null, [dbo].[udf_GetNumeric]([Addressline3]))
	,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
	,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3]))))) AS FullAddressLine
	--,'' AS [AccountNum] 
	,TRIM([VATNum]) AS [VATNum]
	--,'' AS OrganizationNum
	,TRIM([InternalName]) AS [InternalExternal]
	,TRIM([CodeOfConduct]) AS [CodeOfConduct]
	,TRIM([CustomerCode]) AS CustomerNum
	,TRIM([ABCCode]) AS [SupplierScore]
	,NULL AS [MinOrderQty] --CONVERT(decimal(18,4), [MinOrderQty])
	,NULL AS [MinOrderValue]
	--,'' AS [Website]
	--,'' AS [Comments]
	--,'' AS SRes1
	--,'' AS SRes2
	--,'' AS SRes3

FROM [stage].[JEN_NO_Supplier] as supplier
	LEFT JOIN dbo.CountryCodes as cc
		on supplier.CountryCode = cc.[Alpha-3 code]
GO
