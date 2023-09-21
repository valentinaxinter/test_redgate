IF OBJECT_ID('[stage].[vROR_SE_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vROR_SE_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vROR_SE_Supplier] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT([Company], '#', TRIM([SupplierNum]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	,ParentSupplierName AS MainSupplierName
	,[dbo].[ProperCase](TRIM(SupplierName)) AS SupplierName
	,TRIM([AddressLine1]) AS AddressLine1
    ,TRIM([AddressLine2]) AS AddressLine2
    ,TRIM([AddressLine3]) AS AddressLine3
	,TelephoneNum1 AS [TelephoneNum]
	,TelephoneNum2
	,[Email]
	,TRIM([ZipCode]) AS ZipCode
	,TRIM([City]) AS City
	,'' AS District
	,CountryName
	,CountryCode
	,'' AS [Region] 
	,[State]
	,SupplierGroup
	,SupplierSubGroup
	,SupplierIndustry
	,SupplierSubIndustry
	,TRIM(SupplierType) AS SupplierCategory 
	,TRIM(SupplierResponsible) AS SupplierResponsible
	,[dbo].[ProperCase](TRIM(concat (addressline1 + ' ' + addressline2, null))) AS AddressLine
	,[dbo].[ProperCase](TRIM(concat_ws(',', coalesce([dbo].[ProperCase](CountryName), null)
		, IIF(City= ' ', null, trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100) ) )
		, IIF(ZipCode= ' ', null, [dbo].[udf_GetNumeric]([Addressline3]) )
		, coalesce(IIF([addressline1]= ' ', null, [addressline1]), IIF([addressline2]= ' ', null, [addressline2]) )
		, coalesce(IIF([addressline3]= ' ', null, [addressline3]), IIF([addressline3]= ' ', null, [addressline3]) ) ))) AS FullAddressLine
	,[AccountNum] 
	,[VATNum]
	,OrgNum AS OrganizationNum
	,CodeOfConduct
	,PurchaserPers
	,PurchaserPersonName
	,TRIM([SupplierScore]) AS SupplierScore
	,[MinOrderQty]
	,MinOrderValue	
	,MinOrderValueCurrency
	,[Website]
	,TRIM([Comments]) AS Comments
	--,'' AS SRes1
	--,'' AS SRes2
	--,'' AS SRes3
	,IsAxInterInternal AS [InternalExternal]
	,IsBusinessAreaInternal
	,IsCompanyGroupInternal
	,IsActiveRecord
	,CreatedTimeStamp
	,ModifiedTimeStamp
FROM [stage].[ROR_SE_Supplier]
--GROUP BY 
--      [PartitionKey],[Company],[SupplierNum],MainSupplierName,[SupplierName],[AddressLine1],[AddressLine2],[AddressLine3],[City],[ZipCode],[Region],District, [CountryName]
--	  ,[SupplierCategory],[SupplierResponsible],[Reference],[AccountNum],[VATNum],[SupplierScore],[CustomerNum],[TelephoneNum],[Email],[Website],[CodeOfConduct]
--	  ,[MinOrderQty],[InternalExternal],[Comments],CountryCode
GO
