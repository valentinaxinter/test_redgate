IF OBJECT_ID('[stage].[vWID_EE_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vWID_EE_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vWID_EE_Supplier] AS
--ADD UPPER()TRIM() INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
    ,CONCAT([Company],'#',[SupplierNum]) AS SupplierCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,[PartitionKey]

	,[Company]
	,TRIM([SupplierNum]) AS [SupplierNum]
	--,'' AS MainSupplierName
	,[dbo].[ProperCase]([Name]) AS SupplierName
	,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
	--,'' AS [TelephoneNum]
	--,'' AS [Email]
	,ZIP	AS ZipCode
	,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))  AS [City]
	--,'' AS [District]
	,case when len(TRIM(CountryCode)) > 2 then cc.[Alpha-2 code]
	else TRIM(CountryCode)
	end AS CountryCode
	,[dbo].[ProperCase](supplier.[CountryName]) AS CountryName
	--,'' AS [Region]
	,[SupplierCategory]
	,[Reference] AS [SupplierResponsible]
	,[dbo].[ProperCase](TRIM(concat (addressline1+' '+ addressline2, null))) as AddressLine
	,[dbo].[ProperCase](TRIM(concat_ws(',',coalesce([dbo].[ProperCase](supplier.CountryName),null),IIF(City= ' ',null,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))),IIF(ZIP= ' ',null,[dbo].[udf_GetNumeric]([Addressline3]))
		,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
		,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3]))))) AS FullAddressLine
	,[BankAccountNum] AS [AccountNum] --required by Ian Morgan & approved by Emil T on 20200630
	,[VATNum]
	,OrganizationNum
	--,'' AS [InternalExternal]
	,[CodeOfConduct]
	,[CustomerCode] AS CustomerNum
	,[ABCCode] AS [SupplierScore]
	,[MinOrderQty]
	--,0 AS MinOrderValue
	--,'' AS [Website]
	--,'' AS [Comments]
	--,'' AS SRes1
	--,'' AS SRes2
	--,'' AS SRes3
FROM [stage].[WID_EE_Supplier] as supplier
left join dbo.CountryCodes as cc
	on trim(supplier.CountryCode) = cc.[Alpha-3 code]
GO
