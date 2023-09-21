IF OBJECT_ID('[stage].[vHAK_FI_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vHAK_FI_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE   VIEW [stage].[vHAK_FI_Supplier] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	,[dbo].[ProperCase](TRIM(MainSupplierName)) AS MainSupplierName
	,[dbo].[ProperCase](TRIM(SupplierName)) AS SupplierName
	,TRIM([AddressLine1]) AS AddressLine1
    ,TRIM([AddressLine2]) AS AddressLine2
    ,TRIM([AddressLine3]) AS AddressLine3
	,[TelephoneNum]
	,[Email]
	,TRIM([ZipCode]) AS ZipCode
	,TRIM([City]) AS City
	,District
	,IIF(TRIM(CountryName) = '' OR TRIM(CountryName) IS NULL, 'FI', TRIM(CountryCode)) AS CountryCode
	,IIF(TRIM(CountryName) = '' OR TRIM(CountryName) IS NULL, 'Finland', TRIM(CountryName)) AS [CountryName]
	,[Region] 
	,TRIM([SupplierCategory]) AS SupplierCategory 
	,TRIM([SupplierResponsible]) AS SupplierResponsible
	,[dbo].[ProperCase](TRIM(concat (addressline1+' '+ addressline2, null))) AS AddressLine
	,[dbo].[ProperCase](TRIM(concat_ws(',',coalesce([dbo].[ProperCase](CountryName),null),IIF(City= ' ',null,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))),IIF(ZipCode= ' ',null,[dbo].[udf_GetNumeric]([Addressline3]))
		,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
		,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3]))))) AS FullAddressLine
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [AccountNum])) AS [AccountNum] --required by Ian Morgan & approved by Emil T on 20200630
	,[VATNum]
	,'' AS OrganizationNum
	,IIF(trim(SupplierCategory) = 'Group supplier', '1', '0') AS  [InternalExternal] 
	,[CodeOfConduct]
	,CustomerNum
	,TRIM([SupplierScore]) AS SupplierScore
	,[MinOrderQty]
	,0 AS MinOrderValue	
	,[Website]
	,TRIM([Comments]) AS Comments
	,IIF(trim(SupplierCategory) = 'Other', '0', '1') AS IsMaterialSupplier
	,NULL AS SRes1
	,NULL AS SRes2
	,NULL AS SRes3
FROM [stage].[HAK_FI_Supplier]
--GROUP BY 
--      [PartitionKey],[Company],[SupplierNum],MainSupplierName,[SupplierName],[AddressLine1],[AddressLine2],[AddressLine3],[City],[ZipCode],[Region],District, [CountryName]
--	  ,[SupplierCategory],[SupplierResponsible],[Reference],[AccountNum],[VATNum],[SupplierScore],[CustomerNum],[TelephoneNum],[Email],[Website],[CodeOfConduct]
--	  ,[MinOrderQty],[InternalExternal],[Comments]
GO
