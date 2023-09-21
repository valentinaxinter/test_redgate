IF OBJECT_ID('[stage].[vCER_SE_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vCER_SE_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [stage].[vCER_SE_Supplier] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO SupplierID 23-01-23 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
--	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))) AS SupplierCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,TRIM(UPPER([SupplierNum])) AS [SupplierNum]
	--,'' AS MainSupplierName
	,[dbo].[ProperCase]([Name]) AS SupplierName
	,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
	,[TelephoneNum]
	,[Email]
	,[dbo].[udf_GetNumeric]([Addressline3]) AS ZipCode
	,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))  AS [City]
	,[District]
	,CASE WHEN LEN(TRIM(supplier.CountryCode)) = 3 then cc.[Alpha-2 code]
	ELSE IIF(supplier.CountryName is null, 'SE', supplier.CountryCode) 
	end AS CountryCode
	,IIF(supplier.CountryName is null, 'Sweden', supplier.[CountryName]) AS CountryName
	,[Region]
	,[SupplierCategory]
	,[Reference] AS [SupplierResponsible]
	,[dbo].[ProperCase](TRIM(concat (addressline1+' '+ addressline2, null))) AS AddressLine
	,[dbo].[ProperCase](TRIM(concat_ws(',',coalesce([dbo].[ProperCase](supplier.CountryName),null),IIF(City= ' ',null,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))),IIF(ZIP= ' ',null,[dbo].[udf_GetNumeric]([Addressline3]))
	,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
	,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3]))))) AS FullAddressLine
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [BankAccountNum])) AS [AccountNum] --required by Ian Morgan & approved by Emil T on 20200630. --Should likely be changed to Azure mask 2021-03-15 /SM
	,[VATNum]
	,OrganizationNum
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
FROM [stage].[CER_SE_Supplier] as supplier
	left join dbo.CountryCodes as cc
		on supplier.CountryCode = cc.[Alpha-3 code]
GO
