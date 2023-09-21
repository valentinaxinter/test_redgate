IF OBJECT_ID('[stage].[vMEN_NL_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vMEN_NL_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vMEN_NL_Supplier] AS
WITH CTE AS (
SELECT CASE WHEN Company = '14' THEN  CONCAT(N'MENBE',Company) 
			ELSE  CONCAT(N'MENNL',Company)  END AS CompanyCode			--Doing this to have the company code in nvarchar and don't need to repeat CAST(CONCAT('MEN-',Company) AS nvarchar(50)) everywhere /SM
		, [PartitionKey], [Company], [SupplierCode], [Name], [Adress], [PostalCode], [City], [Country], [Telephone], [VatNumber], [CurrencyCode], [Created], [Changed], [CrediteurKey], [DW_TimeStamp], [IsAxInterInternal], [OrganizationNum], [IsMaterialSupplier]
  FROM [stage].[MEN_NL_Supplier]
    
)
SELECT
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([CompanyCode],'#',UPPER(TRIM([SupplierCode]))))) AS SupplierID --- previously CONCAT([CompanyCode],'#',CrediteurKey)))
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([CompanyCode]),'#',TRIM([SupplierCode]))))) AS SupplierID --- previously CONCAT([CompanyCode],'#',CrediteurKey)))
    ,CONCAT([CompanyCode],'#',UPPER(TRIM([SupplierCode]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',[CompanyCode])) AS CompanyID 
	,[PartitionKey]

      ,[CompanyCode]			AS Company
      ,UPPER([SupplierCode])	AS SupplierNum
      ,[Name]					AS MainSupplierName
	  ,[Name]					AS SupplierName
      ,[Adress]					AS AddressLine1
	  --,NULL						AS AddressLine2
	  --,NULL						AS AddressLine3
	  ,[Telephone]				AS [TelephoneNum]
	  --,NULL						AS Email
      ,[PostalCode]				AS ZipCode
      ,[City]
	  --,NULL						AS District
      ,COALESCE(c.CountryName, Country)		AS CountryName
      --,NULL						AS Region
	  --,NULL						AS SupplierCategory 
	  --,NULL						AS SupplierResponsible
	  ,[dbo].[ProperCase](TRIM([Adress])) AS AddressLine
	  ,CONCAT(c.CountryName,', ' + City, ', ' + PostalCode, ', ' + [Adress]) AS FullAddressLine
	  --,NULL						AS AccountNum
      ,[VatNumber]				AS VATNum
	 --,'' AS OrganizationNum
	  ,cast(IsAxInterInternal as nvarchar(50))	AS InternalExternal
	  --,NULL						AS [CodeOfConduct]
	  --,NULL						AS CustomerNum
	  --,NULL						AS SupplierScore
	  --,NULL						AS [MinOrderQty]
	  --,NULL						AS [MinOrderValue]
	  --,NULL						AS Website
	  --,NULL						AS Comments
	  --,'' AS SRes1
	  --,'' AS SRes2
	  --,'' AS SRes3
	  ,upper(CTE.Country) as CountryCode
	  ,CAST(IsMaterialSupplier as bit) as IsMaterialSupplier
  FROM CTE
  LEFT JOIN dbo.CountryCodes c ON CTE.Country = c.[Alpha-2 code]
GO
