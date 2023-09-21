IF OBJECT_ID('[stage].[vTMT_FI_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vTMT_FI_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vTMT_FI_Supplier] AS
--COMMENT EMPTY FIEL 23-01-09 VA
--add trim() into SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(trim(s.Company), '#', TRIM([SupplierNum]))))) AS SupplierID
--	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT('FITMT', '#', TRIM([SupplierNum]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(s.Company))) AS CompanyID
	,getdate() AS [PartitionKey] --

	,UPPER(s.Company) AS Company
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	,CONCAT(TRIM(s.Suppliernum), '-', TRIM([MainSupplierName])) AS MainSupplierName
	,TRIM([MainSupplierName]) AS SupplierName -- was SupplierName, but so few, on 20230302 meeting we, Petre, Jaako & Sam decided to only use [MainSupplierName] 20230302 /DZ
	,TRIM(AddressLine1) AS AddressLine1
    ,TRIM(AddressLine2) AS AddressLine2
    ,TRIM(AddressLine3) AS AddressLine3
	,TRIM([TelephoneNum]) AS [TelephoneNum]
	,TRIM(Email) AS [Email]
	,TRIM(ZipCode) AS ZipCode
	,TRIM([City]) AS City
	--,'' AS District
	,IIF(CountryName IS NULL, 'FI', CountryCode) AS CountryCode
	,TRIM(CountryName) AS CountryName
	--,'' AS [Region] 
	--,'' AS SupplierCategory 
	,SupplierResponsible
	,IIF(AddressLine1 = '', TRIM([AddressLine2]), TRIM([AddressLine1])) AS AddressLine
	,Concat(TRIM(CountryName), ', ', TRIM([City]), ', ', TRIM(ZipCode), ', ', IIF(AddressLine1 = '', TRIM([AddressLine2]), TRIM([AddressLine1]))) AS FullAddressLine
	,TRIM([AccountNum]) AS [AccountNum]
	,TRIM([VATNum]) AS [VATNum]
	--,'' AS OrganizationNum
	,InternalExternal AS InternalExternal
	,[CodeOfConduct]
	--,'' AS CustomerNum
	,TRIM(SupplierScore) AS SupplierScore
	--,NULL AS [MinOrderQty]
	--,NULL AS MinOrderValue	
	,[Website]
	,TRIM(Comments) AS Comments
	--,'' AS SRes1
	--,'' AS SRes2
	--,'' AS SRes3
FROM [stage].[TMT_FI_Supplier] s
--	LEFT JOIN [stage].[TMT_FI_Part] p ON p.SupplierCode = s.SupplierNum
--GROUP BY 
--      s.[PartitionKey], s.[Company], s.[SupplierNum], s.[SupplierName], s.[AddressLine1], s.[AddressLine2], s.[AddressLine3], s.[City], s.[ZipCode],  s.[CountryName]
--	  ,s.[SupplierCategory], s.[VATNum], s.[TelephoneNum], s.[Email], s.[Website], s.[CodeOfConduct], s.[Comments], s.InternalExternal, s.MainSupplierName, p.SupplierCode
GO
