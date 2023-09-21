IF OBJECT_ID('[stage].[vAXI_HQ_Account]') IS NOT NULL
	DROP VIEW [stage].[vAXI_HQ_Account];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO












/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [stage].[vAXI_HQ_Account] AS

SELECT 
	CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company, '#', [AccountNum]))) AS AccountID
	,CONVERT(binary(32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONCAT(Company, '#', [AccountNum]) AS AccountCode
	,CONVERT(varchar, GETDATE(), 23) AS PartitionKey
	,[Company]
	,[AccountNum]
	,[AccountName]
	,m.Beskrivning AS [AccountName2]
	,CONCAT(AccountNum,'-',AccountName) AS Account
	,[AccountStatus]
	,IIF([BalanceAccount] = 'True', '1', [BalanceAccount]) AS [BalanceAccount]
	,IIF([TransactionAccount] = 'True', '1', [TransactionAccount]) AS [TransactionAccount]
	,IIF([Assets] = 'True', '1', [Assets]) AS [Assets]
	,IIF([AccountNum] = '7817', '1' ,'') AS [Amortization]
	,CASE WHEN [Costs] = 'True' THEN '1'
		WHEN len(accountnum) = 5 and left(accountnum, 1) = '8' THEN '1' --83161 to 83173 different currencies, sub-account of 8311 
		ELSE '' END  AS [Costs]
	,IIF([LiabilitiesAndEquity] = 'True', '1', [LiabilitiesAndEquity]) AS [LiabilitiesAndEquity]
	,IIF([Revenue] = 'True', '1', [Revenue]) AS [Revenue]
	,IIF([CurrentAssets] = 'True', '1', [CurrentAssets]) AS [CurrentAssets]
	,IIF([CurrentLiabilities] = 'True', '1', [CurrentLiabilities]) AS [CurrentLiabilities]
	--,IIF([Depreciation] = 'True' AND AccountNum <> '7817', '1', [Depreciation]) AS [Deprecation]
	,CASE	WHEN AccountNum = '7817' THEN ''
			WHEN [Depreciation] = 'True' THEN '1'
			ELSE '' END AS [Deprecation] 
	,IIF([Equity] = 'True', '1', [Equity]) AS [Equity]
	,IIF([AccountReceivables] = 'True', '1', [AccountReceivables]) AS [AccountReceivables]
	,IIF([CashAndEquivalents] = 'True', '1', [CashAndEquivalents]) AS [CashAndEquivalents]
	,'' AS Liability
	,IIF([AccountNum] BETWEEN '8910' AND '8980','1','' ) AS Tax
	,IIF([AccountNum] BETWEEN '8300' AND '8319' 
			OR [AccountNum] BETWEEN '8360' AND '8369' 
			OR [AccountNum] = '8390'
			OR [AccountNum] BETWEEN '8400' AND '8429'
			OR [AccountNum] = '8440'
			OR [AccountNum] BETWEEN '8460' AND '8490', '1', '' ) AS Interest
	,'' AS Materials
	,'' AS Expenses
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
	,[AccountGroup]
	,m.Kontogrupp	AS [AccountGroup2]
	,m.Power_BI AS [AccountGroup3]
	,IIF(len(accountnum) = 5 and left(accountnum, 1) = '8', 'Cost',  [Statement]) AS [Statement] --83161 to 83173 different currencies, sub-account of 8311 also cost
	,[StatementNum]
	,[AccRes1]
	,[AccRes2]
	,[AccRes3]
  FROM [stage].[AXI_HQ_Account] AS A
  LEFT JOIN [stage].[AXI_HQ_Account_map_complement] AS m ON A.AccountNum = m.Konto
  where upper(A.Company) = 'AXISE'
  --where A.Company = 'AXISE'
GO
