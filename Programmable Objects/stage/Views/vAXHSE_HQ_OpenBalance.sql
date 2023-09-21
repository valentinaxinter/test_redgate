IF OBJECT_ID('[stage].[vAXHSE_HQ_OpenBalance]') IS NOT NULL
	DROP VIEW [stage].[vAXHSE_HQ_OpenBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[vAXHSE_HQ_OpenBalance] AS
SELECT distinct	--We use distinct because AccountNum = 8316 and 8317 have what looks like duplicate rows. But they all have opening balance 0 so it doesn't matter much /SM 2021-12-17
		
	  CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', JournalDate, '#', AccountNum, '#', CostUnitNum ))) AS OpenBalanceID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', AccountNum ))) AS AccountID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', RIGHT('000000' + [CostUnitNum], 6 ) ))) AS CostUnitID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', CostBearerNum ))) AS CostBearerID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', '' ))) AS ProjectID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	  ,CONVERT(varchar, GETDATE(), 23) AS PartitionKey
      ,[Company]
      ,[AccountNum]
      ,RIGHT('000000'+ [CostUnitNum], 6 ) AS  [CostUnitNum]
      ,[CostBearerNum]
      ,[ProjectNum]
      ,[JournalType]
      ,[JournalDate]
	  ,[JournalDate] as AccountingDate
      ,[Description]
      ,[OpeningBalance]
      ,[Currency]
      ,[ExchangeRate]
      ,[OBRes1]
      ,[OBRes2]
      ,[OBRes3]
  FROM [stage].[AXI_HQ_OpenBalance]
  where upper(Company) = 'AXHSE'
/*
  union 

  SELECT distinct	
		
	  CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', TransactionDate, '#', AccountNum))) AS OpenBalanceID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', AccountNum ))) AS AccountID
	  ,NULL	 AS CostUnitID
	  ,NULL  AS CostBearerID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', '' ))) AS ProjectID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	  ,CONVERT(varchar, GETDATE(), 23) AS PartitionKey

      ,[Company]
      ,[AccountNum]
	  ,[AccountingDate]
	  ,'OB' AS JournalType
      ,concat ('OpenBalance', '-' ,[Description]) as "Description"
      ,[Opening Balance]						  as [OpeningBalance]
	  ,[TransactionDate]						  as [JournalDate]
      ,NULL AS  [CostUnitNum]
      ,NULL AS	[CostBearerNum]
      ,NULL AS	[ProjectNum]
      ,NULL AS	[Currency]
      , 1	AS	[ExchangeRate]
      ,NULL AS	[OBRes1]
      ,NULL AS	[OBRes2]
      ,NULL AS	[OBRes3]



  FROM [stage].[AXHSE_HQ_OpenBalance_sharepoint]
  where upper(Company) = 'AXHSE'
*/
GO
