IF OBJECT_ID('[stage].[vCER_FI_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vCER_FI_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vCER_FI_Supplier] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	,[dbo].[ProperCase](TRIM(MainSupplierName)) AS MainSupplierName
	,[dbo].[ProperCase](TRIM(SupplierName)) AS SupplierName
    ,TRIM([AddressLine2]) AS AddressLine2
    ,TRIM([AddressLine3]) AS AddressLine3
	,[TelephoneNum]
	,[Email]
	,PARSENAME(REPLACE(dbo.SplitAddress(CONCAT(AddressLine1,' ',AddressLine2,' ',AddressLine3)), '^', '.'), 3) AS AddressLine1 -- TRIM([AddressLine1]) AS AddressLine1 2023-04-04 SB & TO 
    ,IIF(ZipCode is Null,PARSENAME(REPLACE(dbo.SplitAddress(CONCAT(AddressLine1,' ',AddressLine2,' ',AddressLine3)), '^', '.'), 2), trim(ZipCode)) AS ZipCode -- ,TRIM([ZipCode]) AS ZipCode 2023-04-04 SB & TO 
    ,IIF(City IN (Null,''),PARSENAME(REPLACE(dbo.SplitAddress(CONCAT(AddressLine1,' ',AddressLine2,' ',AddressLine3)), '^', '.'), 1), trim(City)) AS City -- ,TRIM([ZipCode]) AS ZipCode 2023-04-04 SB & TO 
	,District
	,CASE WHEN len(trim(supplier.CountryCode)) = 3 THEN cc.[Alpha-2 code] ELSE IIF(supplier.CountryName is null, 'FI', supplier.CountryCode) END AS CountryCode
    ,IIF(supplier.CountryName is null, 'Finland', supplier.CountryName) AS CountryName
	,[Region] 
	,TRIM([SupplierCategory]) AS SupplierCategory 
	,TRIM([SupplierResponsible]) AS SupplierResponsible
	,[dbo].[ProperCase](TRIM(concat (addressline1+' '+ addressline2, null))) AS AddressLine
	,[dbo].[ProperCase](TRIM(concat_ws(',',coalesce([dbo].[ProperCase](supplier.CountryName),null),IIF(City= ' ',null,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))),IIF(ZipCode= ' ',null,[dbo].[udf_GetNumeric]([Addressline3]))
		,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
		,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3]))))) AS FullAddressLine
	,([AccountNum]) AS [AccountNum] --required by Ian Morgan & approved by Emil T on 20200630
	,[VATNum]
	,CASE WHEN (CountryCode = 'SE' OR supplier.CountryName = 'Sweden') AND Left(Vatnum, 2) = 'SE' THEN LEFT(Vatnum, 12)
		ELSE Vatnum END OrganizationNum
	,[InternalExternal]
	,CONVERT(bit, IsBusinessGroupInternal) AS IsBusinessGroupInternal
	,CONVERT(bit, IsCompanyGroupInternal) AS IsCompanyGroupInternal
	,CONVERT(bit, IsMaterialSupplier) AS IsMaterialSupplier
	,[CodeOfConduct]
	,CustomerNum
	,TRIM([SupplierScore]) AS SupplierScore
	,COALESCE(TRY_CONVERT(decimal(18,4), [MinOrderQty]),0) AS [MinOrderQty]
	,NULL AS MinOrderValue	
	,[Website]
	,TRIM(supplier.[Comments]) AS Comments
	--,'' AS SRes1
	--,'' AS SRes2
	--,'' AS SRes3
FROM [stage].[CER_FI_Supplier] as supplier
	LEFT JOIN dbo.CountryCodes as cc
		ON supplier.CountryCode = cc.[Alpha-3 code]
--GROUP BY 
--      [PartitionKey],[Company],[SupplierNum],MainSupplierName,[SupplierName],[AddressLine1],[AddressLine2],[AddressLine3],[City],[ZipCode],[Region],District, [CountryName]
--	  ,[SupplierCategory],[SupplierResponsible],[Reference],[AccountNum],[VATNum],[SupplierScore],[CustomerNum],[TelephoneNum],[Email],[Website],[CodeOfConduct]
--	  ,[MinOrderQty],[InternalExternal],[Comments], OrganizationNum
GO
