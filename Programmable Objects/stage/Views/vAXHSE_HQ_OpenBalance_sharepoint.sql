IF OBJECT_ID('[stage].[vAXHSE_HQ_OpenBalance_sharepoint]') IS NOT NULL
	DROP VIEW [stage].[vAXHSE_HQ_OpenBalance_sharepoint];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vAXHSE_HQ_OpenBalance_sharepoint] AS
SELECT distinct	
		
	  CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', TransactionDate, '#', AccountNum))) AS OpenBalanceID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', AccountNum ))) AS AccountID
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
  FROM [stage].[AXHSE_HQ_OpenBalance_sharepoint]
  where upper(Company) = 'AXHSE'
GO
