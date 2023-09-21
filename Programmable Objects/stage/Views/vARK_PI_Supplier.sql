IF OBJECT_ID('[stage].[vARK_PI_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vARK_PI_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [stage].[vARK_PI_Supplier] AS
--ADD TRIM()UPPER() INTO SupplierID 23-01-23 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID
	--CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([SupplierNum])))) AS SupplierID
    ,UPPER(CONCAT([Company], '#', TRIM([SupplierNum]))) AS SupplierCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([Company]))) AS CompanyID
	,[PartitionKey]

	,TRIM([Company]) AS Company
	,TRIM([SupplierNum]) AS [SupplierNum]
	,MainSupplierName
	,SupplierName
	,[AddressLine1]
    ,[AddressLine2]
    ,[AddressLine3]
	,[TelephoneNum]
	,[Email]
	,ZipCode
	,[City]
	,Disctrict AS [District]
	,TRIM(CountryCode) AS CountryCode
	,TRIM(CountryName) AS CountryName
	,'' CustomerNum
	,[Region]
	,[SupplierCategory]
	,[SupplierResponsible]
	,TRIM(concat ([AddressLine1]+' '+ addressline2, null)) AS AddressLine
	,TRIM(concat_ws(',', CountryName, City, IIF(ZipCode= ' ', null, ZipCode )
		,coalesce(IIF([AddressLine1]= ' ', null, [AddressLine1]), IIF([AddressLine2]= ' ', null, [AddressLine2]))
		,coalesce(IIF([AddressLine2]= ' ', null, [AddressLine2]), IIF([AddressLine3]= ' ', null, [AddressLine3])))) AS FullAddressLine
	,CONVERT([binary](32), HASHBYTES('SHA2_256', AccountNum)) AS [AccountNum] --approved by Emil T on 20200630. --Should likely be changed to Azure mask 2021-03-15 /SM
	,[VATNum]
	--,'' AS OrganizationNum
	,[InternalExternal]
	,[CodeOfConduct]
	,[SupplierScore]
	,TRY_CONVERT(decimal(18,4), [MinOrderQty]) AS [MinOrderQty]
	,[MinOrderValue]
	,[Website]
	,[Comments]
	,Res1 AS SRes1
	,Res2 AS SRes2
	,Res3 AS SRes3
FROM [stage].[ARK_PI_Supplier]
GO
