IF OBJECT_ID('[stage].[vAXHSE_HQ_CostUnit]') IS NOT NULL
	DROP VIEW [stage].[vAXHSE_HQ_CostUnit];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[vAXHSE_HQ_CostUnit] AS
SELECT
	   CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', IIF(CostUnitNum='000---',N'000000',CostUnitNum))) )AS CostUnitID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	  ,CONCAT(Company,'#',IIF(CostUnitNum='000---',N'000000',CostUnitNum)) AS CostUnitCode
	  ,CONVERT(varchar, GETDATE(), 23) AS PartitionKey

      ,[Company]
      ,IIF(CostUnitNum='000---',N'000000',CostUnitNum)	AS [CostUnitNum]
      ,[CostUnitName]
      ,[CostUnitStatus]
      ,[CostUnitGroup]
      ,[CostUnitGroup2]
      ,[CostUnitGroup3]
      ,[CURes1]
      ,[CURes2]
      ,[CURes3]
  FROM [stage].[AXI_HQ_CostUnit]
  where upper(Company) = 'AXHSE'
GO
