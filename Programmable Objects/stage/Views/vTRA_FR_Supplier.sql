IF OBJECT_ID('[stage].[vTRA_FR_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vTRA_FR_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vTRA_FR_Supplier] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,[PartitionKey]

	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	,IIF(TRIM(MainSupplierName) IS NULL OR TRIM(MainSupplierName) = '', TRIM(SupplierName), TRIM(MainSupplierName)) AS MainSupplierName
	,TRIM(SupplierName) AS SupplierName
	,TRIM([AddressLine1]) AS AddressLine1
    ,TRIM([AddressLine2]) AS AddressLine2
    ,TRIM([AddressLine3]) AS AddressLine3
	,TRIM([TelephoneNum]) AS [TelephoneNum]
	,[Email]
	,TRIM(ZipCode) AS ZipCode
	,TRIM([City]) AS City
	,District
	,TRIM(CountryName) AS CountryName -- should be removed as it is the same as countrycode
	,TRIM(CountryName) AS CountryCode -- added 2023-03-22 SB
	,[Region] 
	,TRIM([SupplierCategory]) AS SupplierCategory 
	,TRIM(SupplierResponsible) AS SupplierResponsible
	,IIF(AddressLine1 = '', TRIM([AddressLine2]), TRIM([AddressLine1])) AS AddressLine
	,Concat(TRIM(CountryName), ', ', TRIM([City]), ', ', TRIM(ZipCode), ', ', IIF(AddressLine1 = '', TRIM([AddressLine2]), TRIM([AddressLine1]))) AS FullAddressLine
	,CAST([AccountNum] AS nvarchar(50)) AS [AccountNum]
	,[VATNum]
	--,'' AS OrganizationNum
	,IIF(SupplierName like  '%traction levage%' OR InternalExternal =  'Internal', UPPER('INTERNAL'), UPPER('EXTERNAL')) AS  InternalExternal -- AxInter Internal or External
	,IIF(InternalExternal =  'Internal', '0', '1') AS  IsCompanyGroupInternal
	,[CodeOfConduct]
	,1 AS IsMaterialSupplier -- added 2023-04-28 SB.  All costs we receive are from material suppliers according to communication from Traction Levage.
	--,'' AS CustomerNum
	,TRIM(SupplierScore) AS SupplierScore
	,[MinOrderQty]
	,MinOrderValue
	,[Website]
	,TRIM(Comments) AS Comments
	,SRes1
	,SRes2
	,SRes3
FROM [stage].[TRA_FR_Supplier]
/*GROUP BY 
      [PartitionKey],[Company],[SupplierNum],[SupplierName],[AddressLine1],[AddressLine2],[AddressLine3],[City],[ZIP],[Region],[CountryName]
	  ,[SupplierCategory],[Reference],[BankAccountNum],[VATNum],[SupplierABC],[CustomerCode],[TelephoneNum],[Email],[Website],[CodeOfConduct]
	  ,[MinOrderQty],[InternalName],[Comment] */
GO
