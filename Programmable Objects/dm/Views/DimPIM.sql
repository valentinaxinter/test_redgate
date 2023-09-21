IF OBJECT_ID('[dm].[DimPIM]') IS NOT NULL
	DROP VIEW [dm].[DimPIM];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dm].[DimPIM] AS

with remove_duplicates as (
SELECT  
	   CONVERT(bigint,[PimID]) AS     PimID
      ,CONVERT(bigint,[PartID]) AS    PartID
      ,CONVERT(bigint,[CompanyID]) AS CompanyID
      ,[ProductID]
      ,[Manufacturer_Id]
      ,[Brand]
	  ,[Heading]
	  ,[Original_Description]
      ,[Last_category_name]
      ,[Category_name]
      ,[Category_name2]
      ,[Category_name3]
      ,[Category_name4]
      ,[Category_name5]
      ,[Category_name6]
      ,[PartNum]
      ,[Company]
	  ,ROW_NUMBER() OVER (PARTITION BY PimID, PartID order by PartitionKey asc) as rn
  FROM [dw].[PIM] 
  )
  select 
	PimID					
	,PartID					
	,CompanyID				
	,[ProductID]				
	,[Manufacturer_Id]		
	,[Brand]					
	,[Heading]				
	,[Original_Description]	
	,[Last_category_name]	
	,[Category_name]			
	,[Category_name2]		
	,[Category_name3]		
	,[Category_name4]		
	,[Category_name5]		
	,[Category_name6]		
	,[PartNum]				
	,[Company]
	from remove_duplicates
  where rn = 1
GO
