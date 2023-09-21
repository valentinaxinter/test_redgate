IF OBJECT_ID('[dm].[DimFinanceAccount]') IS NOT NULL
	DROP VIEW [dm].[DimFinanceAccount];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dm].[DimFinanceAccount] AS
SELECT CONVERT(bigint, [AccountID]) AS [AccountID]
      ,[AccountCode]
      ,CONVERT(bigint, [CompanyID]) AS [CompanyID]
      ,[PartitionKey]
      ,[Company]
      ,[AccountNum]
      ,[AccountName]
	  ,[AccountName2]
      ,[Account]
      ,[AccountStatus]
      ,[BalanceAccount]
      ,[TransactionAccount]
      ,[Assets]
	  ,[Amortization]
      ,[Costs]
      ,[LiabilitiesAndEquity]
      ,[Revenue]
      ,[CurrentAssets]
      ,[CurrentLiabilities]
      ,[Deprecation]
      ,[Equity]
	  ,[Liability]
      ,[Interest]
      ,[Tax]
      ,[Materials]
      ,[Expenses]
      ,[AccountReceivables]
      ,[CashAndEquivalents]
      ,[AccountType]
      ,[AccountType2]
      ,[AccountType3]
      ,[AccountType4]
      ,[AccountType5]
      ,[AccountType6]
      ,[AccountType7]
      ,[AccountType8]
      ,[AccountType9]
      ,[AccountType10]
      ,[AccountGroupNum]
      ,[AccountGroupName]
	  ,[AccountGroupOrder]
      ,[AccountGroup]
	  ,[AccountGroup2]
	  ,[AccountGroup3] 
	  ,[Statement]
	  ,[StatementNum]
  FROM [dw].[Account]  -- was [fnc].

  where [AccountNum] != '8882'
GO
