IF OBJECT_ID('[stage].[vWID_FI_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vWID_FI_Supplier] AS
--ADD TRIM() UPPER()INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID
--	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([SupplierNum])))) AS SupplierID
    ,CONCAT([Company], '#', TRIM([SupplierNum])) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,[PartitionKey]
	,[Company]
	,TRIM([SupplierNum]) AS [SupplierNum]
	,TRIM([Name]) AS SupplierName
	--,'' AS [MainSupplierName]
	,[AddressLine1]
    ,[AddressLine2]
    ,IIF([AddressLine3] = '', [AddressLine2], [AddressLine3]) AS [AddressLine3]
	,[TelephoneNum]
	,[Email]
	,IIF(supplier.CountryName = 'FINLAND', TRIM(substring(REPLACE(IIF([AddressLine3] = '', [AddressLine2], [AddressLine3]),' ', ''), 0, 6)), NULL) AS [ZipCode]
	,TRIM(substring(REPLACE(IIF(IIF([AddressLine3] = '', [AddressLine2], [AddressLine3]) = '', [AddressLine2], IIF([AddressLine3] = '', [AddressLine2], [AddressLine3])),' ', ''), 6, 100)) AS [City]
	--,'' AS [District]
	,CASE WHEN LEN(TRIM(CountryCode)) = 3 THEN cc.[Alpha-2 code]
	ELSE TRIM(CountryCode)
	END AS CountryCode
	,supplier.CountryName
	--,'' AS [Region]
	,[SupplierCategory]
	,[Reference] AS [SupplierResponsible]
	,TRIM(concat(IIF([AddressLine3] = '', [AddressLine2], [AddressLine3]) + ', ' + addressline1, NULL)) AS AddressLine
	,TRIM(concat_ws(', ', supplier.CountryName, addressline2, IIF([AddressLine3] = '', [AddressLine2], [AddressLine3]))) AS FullAddressLine
	,BankAccountNum AS [AccountNum] --required by Ian M & approved by Emil T on 20200630 -- HASHBYTES('SHA2_256', [BankAccountNum]) AS 
	,[VATNum]
	,OrganizationNum
	,[ABCCode] AS [SupplierScore]
	,[CustomerCode] AS CustomerNum
	--,'' AS [Website]
	,[CodeOfConduct]
	,[MinOrderQty]
	,NULL AS [MinOrderValue]
	--,'' AS [InternalExternal]
	--,'' AS [Comments]
	--,'' AS [SRes1]
	--,'' AS [SRes2]
	--,'' AS [SRes3]
FROM [stage].[WID_FI_Supplier] as supplier
	left join dbo.CountryCodes as cc
		on TRIM(supplier.CountryCode) = cc.[Alpha-3 code]
GO
