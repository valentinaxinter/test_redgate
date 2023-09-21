IF OBJECT_ID('[stage].[vFOR_SE_OpenBalance2017]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_OpenBalance2017];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_SE_OpenBalance2017] AS

SELECT [OpenBalanceID], [CompanyID], [AccountID], [CostUnitID], [CostBearerID], [ProjectID], [PartitionKey], [Company], [AccountNum], [CostUnitNum], [CostBearerNum], [ProjectNum], [JournalType], [JournalDate], [AccountingDate], [Description], [FiscalYear], [FiscalPeriod], [OpeningBalance], [Currency], [ExchangeRate], [OBRes1], [OBRes2], [OBRes3]
--the 2017 OB is inserted in the GeneralLedger. SB/DZ
  FROM [stage].[vFOR_SE_OpenBalance] where FiscalYear = 2017
GO
