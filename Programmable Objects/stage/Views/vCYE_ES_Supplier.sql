IF OBJECT_ID('[stage].[vCYE_ES_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vCYE_ES_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCYE_ES_Supplier] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT([Company], '#', TRIM([SupplierNum]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,[PartitionKey]

	,UPPER([Company]) AS Company
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	,MainSupplierName
	,[dbo].[ProperCase](TRIM(SupplierName)) AS SupplierName
	,AddressLine1
    ,AddressLine2
    ,AddressLine3
	,[TelephoneNum]
	,[Email]
	,ZipCode
	,City
	,District
	,CountryCode
	,CountryName
	,[Region] 
	,SupplierCategory 
	,SupplierResponsible
	,[dbo].[ProperCase](TRIM(concat ('' +' '+ '' , null))) AS AddressLine
	,CONCAT(CountryName, ', ', City, ', ', ZipCode, ', ',  AddressLine1) AS FullAddressLine
	,[AccountNum] 
	,[VATNum]
	--,'' AS OrganizationNum
	,InternalExternal
	,[CodeOfConduct]
	--,'' AS CustomerNum
	,SupplierScore
	,[MinOrderQty]
	,MinOrderValue	
	,[Website]
	,Comments
	,SRes1
	,SRes2
	,SRes3

FROM [stage].[CYE_ES_Supplier]
/*GROUP BY 
      [PartitionKey],[Company],[SupplierNum],[SupplierName],[AddressLine1],[AddressLine2],[AddressLine3],[City],[ZIP],[Region],[CountryName]
	  ,[SupplierCategory],[Reference],[BankAccountNum],[VATNum],[SupplierABC],[CustomerCode],[TelephoneNum],[Email],[Website],[CodeOfConduct]
	  ,[MinOrderQty],[InternalName],[Comment] */
GO
