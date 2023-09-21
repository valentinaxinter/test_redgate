IF OBJECT_ID('[stage].[vCER_LT_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vCER_LT_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [stage].[vCER_LT_Supplier] AS

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
    ,IIF(TRIM(ZipCode) is Null,PARSENAME(REPLACE(dbo.SplitAddress(CONCAT(AddressLine1,' ',AddressLine2,' ',AddressLine3)), '^', '.'), 2), trim(ZipCode)) AS ZipCode -- ,TRIM([ZipCode]) AS ZipCode 2023-04-04 SB & TO 
    ,IIF(TRIM(City)    IN (Null,''),PARSENAME(REPLACE(dbo.SplitAddress(CONCAT(AddressLine1,' ',AddressLine2,' ',AddressLine3)), '^', '.'), 1), trim(City)) AS City -- ,TRIM([ZipCode]) AS ZipCode 2023-04-04 SB & TO 

	,District
	,IIF(CountryName is null, 'LT', CountryCode) AS CountryCode
    ,IIF(CountryName is null, 'Lithuania', CountryName) AS CountryName
	,[Region] 
	,TRIM([SupplierCategory]) AS SupplierCategory 
	,TRIM([SupplierResponsible]) AS SupplierResponsible
	,[dbo].[ProperCase](TRIM(concat (addressline1+' '+ addressline2, null))) AS AddressLine
	,[dbo].[ProperCase](TRIM(concat_ws(',',coalesce([dbo].[ProperCase](CountryName),null),IIF(City= ' ',null,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))),IIF(ZipCode= ' ',null,[dbo].[udf_GetNumeric]([Addressline3]))
		,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
		,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3]))))) AS FullAddressLine
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [AccountNum])) AS [AccountNum] --required by Ian Morgan & approved by Emil T on 20200630
	,[VATNum]
	,OrganizationNum
	,[InternalExternal]
	,[CodeOfConduct]
	,CustomerNum
	,TRIM([SupplierScore]) AS SupplierScore
	,COALESCE(TRY_CONVERT(decimal(18,4), [MinOrderQty]),0) AS [MinOrderQty]
	,0 AS MinOrderValue	
	,[Website]
	,TRIM([Comments]) AS Comments
	,'' AS SRes1
	,'' AS SRes2
	,'' AS SRes3
	,iif(trim([SupplierCategory]) IN ('PRODUCT SUPPLIER','Axel Johnson International Group'),1,0) AS IsMaterialSupplier
FROM [stage].[CER_LT_Supplier]
--GROUP BY 
--      [PartitionKey],[Company],[SupplierNum],MainSupplierName,[SupplierName],[AddressLine1],[AddressLine2],[AddressLine3],[City],[ZipCode],[Region],District, [CountryName]
--	  ,[SupplierCategory],[SupplierResponsible],[Reference],[AccountNum],[VATNum],[SupplierScore],[CustomerNum],[TelephoneNum],[Email],[Website],[CodeOfConduct]
--	  ,[MinOrderQty],[InternalExternal],[Comments], OrganizationNum
GO
