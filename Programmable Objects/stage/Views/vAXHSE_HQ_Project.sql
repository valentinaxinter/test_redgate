IF OBJECT_ID('[stage].[vAXHSE_HQ_Project]') IS NOT NULL
	DROP VIEW [stage].[vAXHSE_HQ_Project];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[vAXHSE_HQ_Project] AS
SELECT 

	  CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', [ProjectNum] ))) AS ProjectID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	  ,CONCAT(Company,'#', [ProjectNum] ) AS ProjectCode
	  ,CONVERT(varchar, GETDATE(), 23) AS PartitionKey
      ,[Company]
      ,[MainProjectNum]
      ,[ProjectNum]
      ,[ProjectDescription]
      ,[Organisation]
      ,[ProjectStatus]
      ,[ProjectCategory]
      ,[WBSElement]
      ,[ObjectNum]
      ,[Level]
      ,[Currency]
      ,[WarehouseCode]
      ,[ProjectResponsible]
      ,[Comments]
      ,[StartDate]
      ,[EndDate]
      ,[EstEndDate]
      ,[ProjectCompletion]
      ,[TotalCost]	AS ActualCost
  FROM [stage].[AXI_HQ_Project]
  where UPPER(Company) = 'AXHSE'
GO
