IF OBJECT_ID('[stage].[vCER_DK_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_DK_Supplier] AS
--ADD TRIM() SupplierID 23-01-23 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
--	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,[PartitionKey]

	,Company
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
	,CountryName
	,[Region] 
	,TRIM([SupplierCategory]) AS SupplierCategory 
	,TRIM([SupplierResponsible]) AS SupplierResponsible
	,[dbo].[ProperCase](TRIM(concat (addressline1+' '+ addressline2, null))) AS AddressLine
	,[dbo].[ProperCase](TRIM(concat_ws(',',coalesce([dbo].[ProperCase](CountryName),null),IIF(City= ' ',null,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))),IIF(ZipCode= ' ',null,[dbo].[udf_GetNumeric]([Addressline3]))
		,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
		,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3]))))) AS FullAddressLine
	,[AccountNum] 
	,[VATNum]
	--,'' AS OrganizationNum
	,[InternalExternal]
	,[CodeOfConduct]
	--,'' AS CustomerNum
	,SupplierScore
	,[MinOrderQty]
	,MinOrderValue	
	,[Website]
	,TRIM([Comments]) AS Comments
	,SRes1
	,SRes2
	,SRes3
	,case when len(CountryCode) > 2 then LEFT(CountryCode,2)
	else CountryCode
	end as CountryCode
	,case when  left(SupplierCategory,1) in ('8','9') then '0' else '1' end as [IsMaterialSupplier]
FROM [stage].[CER_DK_Supplier]
/*GROUP BY 
      [PartitionKey],[Company],[SupplierNum],MainSupplierName,[SupplierName],[AddressLine1],[AddressLine2],[AddressLine3],[City],[ZipCode],[Region],District, [CountryName]
	  ,[SupplierCategory],[SupplierResponsible],[Reference],[AccountNum],[VATNum],[SupplierScore],[CustomerNum],[TelephoneNum],[Email],[Website],[CodeOfConduct]
	  ,[MinOrderQty],[InternalExternal],[Comments]
	  */
GO
