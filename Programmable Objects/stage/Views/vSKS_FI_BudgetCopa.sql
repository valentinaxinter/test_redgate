IF OBJECT_ID('[stage].[vSKS_FI_BudgetCopa]') IS NOT NULL
	DROP VIEW [stage].[vSKS_FI_BudgetCopa];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[vSKS_FI_BudgetCopa] AS
WITH CTE AS (
SELECT [PartitionKey], [MANDT], [PALEDGER], [VRGAR], [VERSI], [PERIO], [PAOBJNR], [PASUBNR], [BELNR], [POSNR], [RPOSN], [RBELN], [TIMESTMP], [PERBL], [HZDAT], [USNAM], [GJAHR], [KNDNR], [BUKRS], [PRCTR], [PAPH2], [KLABC], [WWVMY], [ERLOS001], [REC_WAERS], [VVMAR001], [VVMAR_ME], [BZIRK], [BZTXT]
	,CAST(CASE WHEN BUKRS IN ('FI25','FI26') THEN 'SCOFI'
		WHEN BUKRS IN ('FI20') THEN 'SMKFI'  END AS nvarchar(50)) AS Company
FROM [stage].[SKS_FI_BudgetCopa]
WHERE BUKRS IN ('FI25','FI26','FI20')
)
SELECT 
		CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', PAOBJNR, '#', BELNR, '#', PERBL )))) AS BudgetID
		,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([COMPANY],'#',TRIM([KNDNR]),'#',TRIM(BUKRS)))) AS CustomerID
		,CONVERT([binary](32),HASHBYTES('SHA2_256',[COMPANY])) AS CompanyID
		,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(PAPH2),'#', TRIM([PRCTR]),'#', BUKRS)))) AS PartID
		,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#','')))) AS WarehouseID
		,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([COMPANY]),'#','')))) AS ProjectID
		,CAST(LEFT(PERBL,4) + RIGHT (PERBL,2) + '01' AS int)		AS BudgetPeriodDateID 
		
	  ,[PartitionKey]
	  ,Company
      ,LEFT(PERBL,4) + '-' + RIGHT (PERBL,2)	AS BudgetPeriod
	  ,'ZBIS_SALES_COPA' AS BudgetName
	  ,CONCAT(BUKRS, '-', PAPH2,'-',PRCTR,'-',KNDNR, '-', BZIRK)	AS BudgetDescription
	  ,CAST(LEFT(PERBL,4) + '-' + RIGHT (PERBL,2) + '-01'  AS date)	AS BudgetPeriodDate
	  ,'Monthly'	AS PeriodType
	  ,'' AS BudgetType
	  ,[KNDNR]	AS CustomerNum
	  ,BZIRK + '-' + BZTXT	AS CustomerGroup
	  ,PAPH2	AS PartNum
      ,RIGHT(PAPH2,5)	AS ProductGroup
      ,WWVMY	AS SalesPersonCode
	  ,''	AS SalesPersonName
	  ,ERLOS001	AS BudgetSales
      ,ERLOS001 - ERLOS001*(ABS(VVMAR001)*12)/100	AS BudgetCost	-- Actually margin %
	  ,REC_WAERS		AS Currency
      ,ERLOS001*(ABS(VVMAR001)*12)/100 AS GrossProfitInvoiced
	  ,ABS(VVMAR001)*12  	AS GrossMarginInvoicedPercent
	  ,0			AS BudgetFinance
	  ,right(BZIRK,3)			AS WarehouseCode
	  ,''			AS CostBearerNum
	  ,''			AS CostUnitNum
	  ,BZIRK + '-' + BZTXT			AS ProjectNum -- This field is actually showing District (Also used when we build CustomerGroup but they need it in a separate field)
	  ,''			AS AccountNum
	  ,''			AS AccountGroupNum
	  ,TRIM([PRCTR])			AS BRes1
	  ,''			AS BRes2
	  ,''			AS BRes3
  FROM CTE
GO
