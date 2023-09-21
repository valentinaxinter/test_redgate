IF OBJECT_ID('[stage].[vNOM_FI_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vNOM_FI_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [stage].[vNOM_FI_Supplier] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	,TRIM(MainSupplierName) AS MainSupplierName
	,TRIM(SupplierName) AS SupplierName
	,TRIM([AddressLine1]) AS AddressLine1
    ,TRIM([AddressLine2]) AS AddressLine2
    ,TRIM([AddressLine3]) AS AddressLine3
	,TRIM([TelephoneNum]) AS [TelephoneNum]
	,[Email]
	,TRIM(ZipCode) AS ZipCode
	,TRIM([City]) AS City
	,District
	,TRIM(CountryCode) AS CountryCode
	,TRIM(CountryName) AS CountryName
	,[Region] 
	,TRIM([SupplierCategory]) AS SupplierCategory 
	,TRIM(SupplierResponsible) AS SupplierResponsible
	,IIF(AddressLine1 = '', TRIM([AddressLine2]), TRIM([AddressLine1])) AS AddressLine
	,Concat(TRIM(CountryName), ', ', TRIM([City]), ', ', TRIM(ZipCode), ', ', IIF(AddressLine1 = '', TRIM([AddressLine2]), TRIM([AddressLine1]))) AS FullAddressLine
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [AccountNum])) AS [AccountNum]
	,[VATNum]
	,OrganisationNum as OrganizationNum
	,InternalExternal AS InternalExternal
	,[CodeOfConduct]
	,'' AS CustomerNum
	,TRIM(SupplierScore) AS SupplierScore
	,[MinOrderQty]
	,MinOrderValue	
	,[Website]
	,TRIM(Comments) AS Comments
	,SRes1
	--,'' AS SRes2
	--,'' AS SRes3
FROM [stage].[NOM_FI_Supplier]
/*GROUP BY 
      [PartitionKey],[Company],[SupplierNum],[SupplierName],[AddressLine1],[AddressLine2],[AddressLine3],[City],[ZIP],[Region],[CountryName]
	  ,[SupplierCategory],[Reference],[BankAccountNum],[VATNum],[SupplierABC],[CustomerCode],[TelephoneNum],[Email],[Website],[CodeOfConduct]
	  ,[MinOrderQty],[InternalName],[Comment] */
GO
