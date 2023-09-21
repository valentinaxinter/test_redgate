IF OBJECT_ID('[stage].[vSCM_FI_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSCM_FI_Supplier] AS
--ADD UPPER() TRIM() INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID
--	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([SupplierNum])))) AS SupplierID
    ,CONCAT([Company], '#', TRIM([SupplierNum])) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,[PartitionKey]

	,[Company]
	,TRIM([SupplierNum]) AS SupplierNum
	,[dbo].[ProperCase](TRIM(SupplierName)) AS SupplierName
	,'' AS [MainSupplierName]
	,TRIM([AddressLine1]) AS AddressLine1
    ,TRIM([AddressLine2]) AS AddressLine2
    ,TRIM([AddressLine3]) AS AddressLine3
	,[TelephoneNum]
	,[Email]
	,TRIM([ZIP]) AS [ZipCode]
	,TRIM([City]) AS City
	,'' AS District
	,IIF(TRIM(CountryName) = '' OR TRIM(CountryName) IS NULL, 'FI', TRIM(CountryCode)) AS CountryCode
	,IIF(TRIM(CountryName) = '' OR TRIM(CountryName) IS NULL, 'Finland', TRIM(CountryName)) AS [CountryName]
	,[Region] 
	,TRIM([SupplierCategory]) AS SupplierCategory
 	,TRIM([Reference]) AS SupplierResponsible

	,[dbo].[ProperCase](TRIM(concat (addressline1+' '+ addressline2, null))) AS AddressLine
	,[dbo].[ProperCase](TRIM(concat_ws(',',coalesce([dbo].[ProperCase](CountryName),null),IIF(City= ' ',null,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))),IIF(ZIP= ' ',null,[dbo].[udf_GetNumeric]([Addressline3]))
		,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
		,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3]))))) AS FullAddressLine
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [BankAccountNum])) AS [AccountNum] --required by Ian Morgan & approved by Emil T on 20200630
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [VATNum])) AS [VATNum]
	,'' AS OrganizationNum
	,[InternalName] AS InternalExternal
	,[CodeOfConduct]
	,[CustomerCode] AS CustomerNum
	,TRIM([SupplierABC]) AS [SupplierScore]
	,[MinOrderQty]
	,NULL AS [MinOrderValue] 
	,[Website]
	,TRIM([Comment]) AS Comments
	--,'' AS [SRes1]
	--,'' AS [SRes2]
	--,'' AS [SRes3]
	,1 as IsMaterialSupplier -- all invoicing is from material supplier according to Philip Eliasson 2023-05-09 SB
FROM [stage].[SCM_FI_Supplier]
GO
