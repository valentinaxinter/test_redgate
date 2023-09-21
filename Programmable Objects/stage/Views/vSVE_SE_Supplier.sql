IF OBJECT_ID('[stage].[vSVE_SE_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vSVE_SE_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSVE_SE_Supplier] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(trim(Company), '#', TRIM([SupplierNum]))))) AS SupplierID
--	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT('FITMT', '#', TRIM([SupplierNum]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	,[PartitionKey] --

	,UPPER(Company) AS Company
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	,'' AS MainSupplierName
	,TRIM(SuplierName) AS SupplierName
	,TRIM(AddressLine1) AS AddressLine1
    ,TRIM(AddresLine2) AS AddressLine2
    ,TRIM([TelephoneNum2]) AS AddressLine3
	,TRIM([TelephoneNum1]) AS [TelephoneNum]
	,TRIM(Email) AS [Email]
	,TRIM(ZipCode) AS ZipCode
	,TRIM([City]) AS City
	,IIF(CountryName IS NULL, 'SE', CountryCode) AS CountryCode
	,TRIM(CountryName) AS CountryName
	--,'' AS [Region] 
	--,'' AS SupplierCategory 
	,'' AS SupplierResponsible
	,IIF(AddressLine1 = '', TRIM([AddresLine2]), TRIM([AddressLine1])) AS AddressLine
	,Concat(TRIM(CountryName), ', ', TRIM([City]), ', ', TRIM(ZipCode), ', ', IIF(AddressLine1 = '', TRIM([AddresLine2]), TRIM([AddressLine1]))) AS FullAddressLine
	,TRIM([AcountNum]) AS [AccountNum]
	,TRIM([VATNum]) AS [VATNum]
	,TRIM([OrgNum]) AS OrganizationNum
	,IsAxInterInternal AS InternalExternal
	,TRIM([CodeOfConduct]) AS [CodeOfConduct]
	--,'' AS CustomerNum
	,'' AS SupplierScore
	--,NULL AS [MinOrderQty]
	--,NULL AS MinOrderValue	
	,[Website]
	,CreatedTimeStamp AS Comments
	,SRes1
	,ModifiedTimeSTamp AS SRes2
	,IsActiveRecord AS SRes3
FROM [stage].[SVE_SE_Supplier]
/*GROUP BY 
      [PartitionKey],[Company],[SupplierNum],[SupplierName],[AddressLine1],[AddressLine2],[AddressLine3],[City],[ZIP],[Region],[CountryName]
	  ,[SupplierCategory],[Reference],[BankAccountNum],[VATNum],[SupplierABC],[CustomerCode],[TelephoneNum],[Email],[Website],[CodeOfConduct]
	  ,[MinOrderQty],[InternalName],[Comment] */
GO
