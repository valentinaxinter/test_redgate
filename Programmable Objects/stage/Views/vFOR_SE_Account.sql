IF OBJECT_ID('[stage].[vFOR_SE_Account]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_Account];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Good-to-know:
-- DESCRIBE (AND DATE) ANY CHANGES TO STANDARD SCRIPT HERE.

CREATE VIEW [stage].[vFOR_SE_Account] AS
SELECT

--------------------------------------------- Keys/ IDs ---------------------------------------------
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', [AccountNum]))) AS AccountID,
	CONCAT(Company, '#', [AccountNum], '#', [AccountName]) AS AccountCode,
	CONVERT([binary](32), HASHBYTES('SHA2_256',Company)) AS CompanyID,
	PartitionKey,

--------------------------------------------- Regular Fields ---------------------------------------------
---Mandatory Fields ---
	Company,
	[AccountNum],
	[AccountName],
	NULL AS [AccountName2],
	[Account],
	[AccountGroupNum],
	IIF(AccountType = 'B', '1', '') AS BalanceAccount,
	'' AS TransactionAccount,
	IIF([AccountType2] = 'Assets', '1', '') AS Assets,
	IIF([AccountNum] = '780700', '1', '') AS Amortization,
	IIF([AccountType2] = 'Cost', '1', '') AS Costs,
	IIF([AccountType2] = 'Liabilities and Equity', '1', '') AS LiabilitiesAndEquity,
	IIF([AccountType2] = 'Revenue', '1', '') AS Revenue,
	IIF([AccountNum] between '140000' AND '199999', '1', '') AS CurrentAssets,
	IIF([AccountNum] between '240000' AND '259999', '1', '') AS CurrentLiabilities,
--	IIF([AccountGroupNum] = '78', '1', '') AS Deprecation,
	IIF([AccountNum] BETWEEN '780000' AND '780610' OR [AccountNum] = '781000', '1', '') AS Deprecation,
	IIF([AccountNum] between '200000' AND '219999', '1', '') AS Equity,
	IIF([AccountNum] between '150000' AND '179999', '1', '') AS AccountReceivables,
	IIF([AccountNum] between '190000' AND '199999', '1', '') AS CashAndEquivalents,
	IIF([AccountNum] between '820000' AND '840000', '1', '') AS Interest,
	IIF([AccountNum] between '220000' AND '299999', '1', '') AS Liability,
	IIF([AccountNum] between '890000' AND '893999', '1', '') AS Tax,
	IIF([Statement] = 'Materials', '1', '') AS Materials,
	IIF([Statement] = 'Expenses', '1', '') AS Expenses,
	CASE 
	     WHEN [AccountType] = 'B' THEN 'B'
		 WHEN [AccountType] = 'I' THEN 'R'
		 ELSE [AccountType]
      END as [AccountType],
	
---Valuable Fields ---
	[AccountGroupName],
	[Statement],
	[AccountStatus],

--- Good-to-have Fields ---
	[AccountType2],
	[AccountType3],
	[AccountType4],
	[AccountType5],
	'' AS AccountType6,
	'' AS AccountType7,
	'' AS AccountType8,
	'' AS AccountType9,
	'' AS AccountType10,
	[AccountGroup],
	NULL AS [AccountGroup2],
	NULL AS [AccountGroup3],
	[StatementNum],
	

--------------------------------------------- Meta Data ---------------------------------------------
--,CONVERT(date, ModifiedTimeStamp) AS ModifiedTimeStamp
--,CONVERT(date, CreatedTimeStamp) AS CreatedTimeStamp
--,TRIM(IsActiveRecord) AS IsActiveRecord
--------------------------------------------- Extra Fields ---------------------------------------------
UPPER(TRIM('')) AS AccRes1,
UPPER(TRIM('')) AS AccRes2,
UPPER(TRIM('')) AS AccRes3

FROM 
	stage.FOR_SE_Account  -- from the static stage.fncCNO_Account which is directly imported from Excel file, 20210517 /DZ
GO
