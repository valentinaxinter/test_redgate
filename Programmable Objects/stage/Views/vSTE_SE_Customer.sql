IF OBJECT_ID('[stage].[vSTE_SE_Customer]') IS NOT NULL
	DROP VIEW [stage].[vSTE_SE_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [stage].[vSTE_SE_Customer] AS
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID
	,[PartitionKey] 
	,UPPER(TRIM("Company")) AS [Company]
	,UPPER(TRIM("CustomerNum")) AS [CustomerNum]
	,"CustomerName" 		
	,"AddressLine1" 		
	,"AddressLine2"		
	,"ZipCode"			
	,"City"				
	,"CountryName"		
	,"CountryCode"		
	,"TelephoneNumber1"	
	,"Email"				
	,"VATNum"			
	,"ModifiedTimeStamp"	
	,"CustomerGroup"		
	,"SalesPerson"
	,"CreditLimit"		--create
	,"Currency Code" 	--create
	,"PaymentTerms" 	--create	
	,"IsAxInterInternal" as [InternalExternal]
	
	


FROM
	[stage].[STE_SE_Customer]
GO
