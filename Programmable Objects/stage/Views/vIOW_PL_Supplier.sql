IF OBJECT_ID('[stage].[vIOW_PL_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vIOW_PL_Supplier];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vIOW_PL_Supplier] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,getdate() AS [PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	,'' AS MainSupplierName
	,TRIM(SupplierName) AS SupplierName
	,TRIM([AddressLine1]) AS AddressLine1
    ,TRIM([AddressLine2]) AS AddressLine2
    ,TRIM([AddressLine3]) AS AddressLine3
	,[TelephoneNumber1]
	,[TelephoneNumber2]
	,[Email]
	--,PARSENAME(REPLACE(dbo.SplitAddress(CONCAT(AddressLine1,' ',AddressLine2,' ',AddressLine3)), '^', '.'), 3) AS AddressLine1 -- TRIM([AddressLine1]) AS AddressLine1 2023-04-04 SB & TO 
    ,IIF(TRIM(ZipCode) is Null,PARSENAME(REPLACE(dbo.SplitAddress(CONCAT(AddressLine1,' ',AddressLine2,' ',AddressLine3)), '^', '.'), 2), trim(ZipCode)) AS ZipCode -- ,TRIM([ZipCode]) AS ZipCode 2023-04-04 SB & TO 
    ,IIF(TRIM(City) IN (Null,''),PARSENAME(REPLACE(dbo.SplitAddress(CONCAT(AddressLine1,' ',AddressLine2,' ',AddressLine3)), '^', '.'), 1), trim(City)) AS City -- ,TRIM([ZipCode]) AS ZipCode 2023-04-04 SB & TO 
	,'' AS District
	,IIF(CountryName is null, 'PL', CountryCode) AS CountryCode
    ,IIF(CountryName is null, 'Poland', CountryName) AS CountryName
	,'' AS [Region] 
	,'' AS SupplierCategory 
	,TRIM([SupplierResponsible]) AS SupplierResponsible
	,TRIM(concat (addressline1+' '+ addressline2, null)) AS AddressLine
	,TRIM(concat_ws(',',coalesce([dbo].[ProperCase](CountryName),null),IIF(City= ' ',null,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))),IIF(ZipCode= ' ',null,[dbo].[udf_GetNumeric]([Addressline3]))
		,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
		,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3])))) AS FullAddressLine
	,TRIM([AccountNum]) AS [AccountNum]
	,TRIM([VATNum]) AS [VATNum]
	,TRIM(OrgNum) AS OrganizationNum
	,IsAxInterInternal AS [InternalExternal]
	,IsAxInterInternal
	,[CodeOfConduct]
	,'' AS CustomerNum
	,TRIM([SupplierScore]) AS SupplierScore
	,NULL AS [MinOrderQty]
	,NULL AS MinOrderValue	
	,[Website]
	,TRIM([Comments]) AS Comments
	,SRes1
	,SRes2
	,SRes3
	,SRes4
	,SRes5
	,IsMaterialSupplier
FROM [axbus].[IOW_PL_Suppliers]
GROUP BY 
      [Company], [SupplierNum], [SupplierName], [AddressLine1], [AddressLine2], [AddressLine3], [City], [ZipCode], [CountryName], CountryCode
	  , [SupplierResponsible], [Comments], [AccountNum], [VATNum], [SupplierScore], [TelephoneNumber1], [TelephoneNumber2], [Email], [Website], [CodeOfConduct]
	  , IsAxInterInternal, OrgNum, SRes1, SRes2, SRes3, SRes4, SRes5, IsMaterialSupplier
GO
