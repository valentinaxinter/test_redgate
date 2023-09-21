IF OBJECT_ID('[stage].[vAXI_HQ_Customer]') IS NOT NULL
	DROP VIEW [stage].[vAXI_HQ_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [stage].[vAXI_HQ_Customer] AS
SELECT 
	  CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', CustomerNum ))) AS CustomerID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	  ,CONCAT(Company,'#', CustomerNum ) AS CustomerCode
	  ,CONVERT(varchar, GETDATE(), 23) AS PartitionKey

	  ,[Company]
      ,[CustomerNum]
      ,[MainCustomerName]
      ,[CustomerName]
      ,[AddressLine1]
      ,[AddressLine2]
      ,[AddressLine3]
      ,[TelephoneNum1]
      ,[TelephoneNum2]
      ,[Email]
      ,[ZipCode]
      ,[City]
      ,[State]
      ,[SalesDistrict]
      ,[CountryName]
      ,[Division]
      ,[CustomerIndustry]
      ,[CustomerSubIndustry]
	  ,CONCAT(NULLIF(TRIM(AddressLine1),'') ,', ' +  NULLIF(TRIM(AddressLine2),'')) AS AddressLine
	  ,CONCAT(NULLIF(TRIM(CountryName),'') ,', ' + NULLIF(TRIM([City]),''),', ' + NULLIF(TRIM([ZipCode]),''),', ' + NULLIF(TRIM(AddressLine1),''),', ' + NULLIF(TRIM(AddressLine2),'')  ) AS FullAddressLine
      ,[CustomerGroup]
      ,[CustomerSubGroup]
      ,[SalesPersonCode]
      ,[SalesPersonName]
      ,[SalesPersonResponsible]
      ,[VATNum]
	  --,'' AS OrganizationNum
      ,[AccountNum]
      ,'AxInter'	AS [InternalExternal]
      ,[CustomerScore]
      ,[CustomerType]
      , CognosCompany as CRes1
  FROM [stage].[AXI_HQ_Customer]
	where UPPER(Company) = 'AXISE'
GO
