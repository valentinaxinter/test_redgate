IF OBJECT_ID('[stage].[vFOR_PL_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vFOR_PL_Supplier];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vFOR_PL_Supplier]
	AS 
SELECT 
CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
,PartitionKey

----------- Mandatory -----------

,UPPER(TRIM([Company])) AS Company
,UPPER(TRIM([SupplierNum])) AS SupplierNum
,[dbo].[ProperCase](TRIM(SupplierName)) AS SupplierName
,TRIM([AddressLine1]) AS AddressLine1
,[ZipCode]            
,[City]  
,[CountryCode] 
,[VATNum]
-- OrgNum
,[IsAxInterInternal] as InternalExternal
-- IsMaterialSupplier

----------- Valuable -----------



,TRIM([AddressLine1]) AS FullAddressLine
,trim([TelephoneNum1]) as [TelephoneNum1]
,trim(Email) as Email
             
,[State]              
       
,[SupplierGroup]      
,[SupplierResponsible]
             
  
,[CodeOfConduct]      
--,[CreatedTimeStamp]   
--,[ModifiedTimeStamp]  
,[IsActiveRecord]     
,[Website]            
,[SRes1]   

----------- Good to have -----------

FROM stage.FOR_PL_Supplier
GO
