IF OBJECT_ID('[dm_AX].[dimFinanceAccount]') IS NOT NULL
	DROP VIEW [dm_AX].[dimFinanceAccount];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO











CREATE VIEW [dm_AX].[dimFinanceAccount] AS 

SELECT  [AccountID]
,[AccountCode]
,[CompanyID]
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
FROM [dm].[DimFinanceAccount]
WHERE [Company] in ('AXISE','AXHSE') -- HQ basket
GO
