IF OBJECT_ID('[stage].[vJEN_DK_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vJEN_DK_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [stage].[vJEN_DK_Supplier] AS
--ADD TRIM() INTO SupplierID 23-01-23 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
	--CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))) AS SupplierCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,TRIM(UPPER([SupplierNum])) AS [SupplierNum]
	,[Name] AS MainSupplierName
	,[dbo].[ProperCase]([Name]) AS SupplierName
	,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
	,[TelephoneNum]
	,[Email]
	,[dbo].[udf_GetNumeric]([Addressline3]) AS ZipCode
	,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))  AS [City]
	--,'' AS [District]
	,[dbo].[ProperCase]([CountryName]) AS CountryName
	,[Region]
	,[SupplierCategory]
	,[Reference] AS [SupplierResponsible]
	,[dbo].[ProperCase](TRIM(concat (addressline1+' '+ addressline2, null))) AS AddressLine
	,[dbo].[ProperCase](TRIM(concat_ws(',',coalesce([dbo].[ProperCase](CountryName),null),IIF(City= ' ',null,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))),IIF(ZIP= ' ',null,[dbo].[udf_GetNumeric]([Addressline3]))
	,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
	,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3]))))) AS FullAddressLine
	--,'' AS [AccountNum] 
	,[VATNum]
	--,'' AS OrganizationNum
	,[InternalName] AS [InternalExternal]
	,[CodeOfConduct]
	,[CustomerCode] AS CustomerNum
	,[ABCCode] AS [SupplierScore]
	,TRY_CONVERT(decimal(18,4),[MinOrderQty]) AS [MinOrderQty]
	--,0 AS [MinOrderValue]
	--,'' AS [Website]
	--,'' AS [Comments]
	--,'' AS SRes1
	--,'' AS SRes2
	--,'' AS SRes3
	, CountryCode
FROM [stage].[JEN_DK_Supplier]
GO
