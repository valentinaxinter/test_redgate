IF OBJECT_ID('[stage].[vSTE_SE_Part]') IS NOT NULL
	DROP VIEW [stage].[vSTE_SE_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [stage].[vSTE_SE_Part] as
Select
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]) ,'#', TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,[PartitionKey] 
	,UPPER(TRIM("Company")) AS [Company]
	,UPPER(TRIM("PartNum"))	AS [PartNum] 			
	,"PartDescription"		
	,"PartDescription2"		
	,"ProductGroup"			
	,"ProductGroup2"			
	,"CountryOfOriginCode"
	,"CountryOfOriginname"
	,"ModifiedTimeStamp"		
	,"UoM"					
	,"PrimarySupplier"	as	[MainSupplier]
	,"CommodityCode"			
	,"NetWeight"				
	,"ReOrderLevel"	
	,"Barcode"
	,"PartResponsible"
	,"PartStatus"
	,"PartStatusIsActiveRecord" as [IsActiveRecord]


from
	stage.STE_SE_Part
GO
