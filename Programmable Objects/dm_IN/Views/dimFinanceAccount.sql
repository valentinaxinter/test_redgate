IF OBJECT_ID('[dm_IN].[dimFinanceAccount]') IS NOT NULL
	DROP VIEW [dm_IN].[dimFinanceAccount];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dm_IN].[dimFinanceAccount] AS 

SELECT fa.[AccountID]
,fa.[AccountCode]
,fa.[CompanyID]
,fa.[PartitionKey]
,fa.[Company]
,fa.[AccountNum]
,fa.[AccountName]
,fa.[AccountName2]
,fa.[Account]
,fa.[AccountStatus]
,fa.[BalanceAccount]
,fa.[TransactionAccount]
,fa.[Assets]
,fa.[Amortization]
,fa.[Costs]
,fa.[LiabilitiesAndEquity]
,fa.[Revenue]
,fa.[CurrentAssets]
,fa.[CurrentLiabilities]
,fa.[Deprecation]
,fa.[Equity]
,fa.[Liability]
,fa.[Interest]
,fa.[Tax]
,fa.[Materials]
,fa.[Expenses]
,fa.[AccountReceivables]
,fa.[CashAndEquivalents]
,fa.[AccountType]
,fa.[AccountType2]
,fa.[AccountType3]
,fa.[AccountType4]
,fa.[AccountType5]
,fa.[AccountType6]
,fa.[AccountType7]
,fa.[AccountType8]
,fa.[AccountType9]
,fa.[AccountType10]
,fa.[AccountGroupNum]
,fa.[AccountGroupName]
,fa.[AccountGroupOrder]
,fa.[AccountGroup]
,fa.[AccountGroup2]
,fa.[AccountGroup3]
,fa.[Statement]
,fa.[StatementNum]
FROM [dm].[DimFinanceAccount] fa
LEFT JOIN dbo.Company com ON fa.Company = com.Company
WHERE com.BusinessArea = 'Industrial Solutions' AND com.[Status] = 'Active'

--WHERE [Company] in ('CNOCERT')
GO
