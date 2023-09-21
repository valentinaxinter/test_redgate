IF OBJECT_ID('[stage].[vFOR_SE_OpenBalance]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_OpenBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vFOR_SE_OpenBalance] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', [AccountNum], '#', [CostUnitNum], '#', [Description], '#', [FiscalYear]))) AS OpenBalanceID,
	CONVERT([binary](32), HASHBYTES('SHA2_256',Company)) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company, '#', AccountNum))) AS AccountID,
	CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company, '#', CostUnitNum))) AS CostUnitID,
	CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company, '#', '')))AS CostBearerID,
	CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company, '#', ''))) AS ProjectID,
	PartitionKey,

	Company,
	[AccountNum],
	[CostUnitNum],
	'' AS CostBearerNum,
	'' AS ProjectNum,
	'' AS JournalType,
	[JournalDate],
	[JournalDate] AS [AccountingDate], --CONVERT(date, '1900-01-01')
	[Description],
	[FiscalYear],
	[FiscalPeriod],
	[AmountSystemCurrency]	AS OpeningBalance,
	Currency,
	ExchangeRate,
	'' AS OBRes1,
	'' AS OBRes2,
	'' AS OBRes3
FROM 
	stage.FOR_SE_OpenBalance
GO
