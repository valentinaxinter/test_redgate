IF OBJECT_ID('[stage].[vAXI_HQ_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vAXI_HQ_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[vAXI_HQ_Supplier] AS
SELECT 

	  CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', SupplierNum ))) AS SupplierID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	  ,CONCAT(Company,'#', SupplierNum ) AS SupplierCode
	  ,CONVERT(varchar, GETDATE(), 23) AS PartitionKey

	  ,[Company]
      ,[SupplierNum]
      ,[MainSupplierName]
      ,[SupplierName]
      ,[AddressLine1]
      ,[AddressLine2]
      ,[AddressLine3]
      ,[TelephoneNum]
      ,[Email]
      ,[ZipCode]
      ,[City]
      ,[District]
      ,[CountryName]
      ,[Region]
      ,[SupplierCategory]
      ,[SupplierResponsible]
	  ,CONCAT(NULLIF(TRIM(AddressLine1),'') ,', ' +  NULLIF(TRIM(AddressLine2),'')) AS AddressLine
	  ,CONCAT(NULLIF(TRIM(CountryName),''),  ', ' + NULLIF(TRIM([City]),'') , ', ' + NULLIF(TRIM([ZipCode]),''),', ' +  NULLIF(TRIM(AddressLine1),''),', ' + NULLIF(TRIM(AddressLine2),'')  ) AS FullAddressLine
      ,[AccountNum]
      ,[VATNum]
	  ,'' AS OrganizationNum
      ,CASE WHEN SupplierCategory IN ('D','K') THEN 'I' ELSE 'E' END AS [InternalExternal]
      ,[CodeOfConduct]
      ,[CustomerNum]
      ,[SupplierScore]
      ,[MinOrderQty]
      ,[MinOrderValue]
      ,[Website]
      ,[Comments]
      ,[SRes1]
      ,[SRes2]
      ,[SRes3]
  FROM [stage].[AXI_HQ_Supplier]
  where upper(Company) = 'AXISE'
GO
