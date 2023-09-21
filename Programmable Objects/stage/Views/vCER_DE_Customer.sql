IF OBJECT_ID('[stage].[vCER_DE_Customer]') IS NOT NULL
	DROP VIEW [stage].[vCER_DE_Customer];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vCER_DE_Customer]
	AS SELECT 
		 CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
		 ,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
		 --,CONCAT(Company, '#', TRIM([CustomerNum])) AS CustomerCode
		,[PartitionKey]          
		,[Company]               
		,[CustomerNum]           
		,[CustomerName]          
		,[AddressLine1]          
		,[AddressLine2]          
		,[AddressLine3]          
		,[FullAddressLine]       
		,[TelephoneNumber1]      
		,[Email]                 
		,[CountryName]           
		,[City]                  
		,[ZipCode]               
		,[CountryCode]           
		,[VATNum]                
		,[OrganizationNum]       
		,[SalesDistrict]         
		,[CreditLimit]           
		,[PaymentTerms]          
		,[InternalExternal]      
		,[IsCompanyGroupInternal]
		,[CustomerIndustry]      
		,[CustomerType]     
		,CustomerGroup
		,CustomerScore
	FROM stage.CER_DE_Customer
GO
