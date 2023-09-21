IF OBJECT_ID('[stage].[vSKS_FI_Budget]') IS NOT NULL
	DROP VIEW [stage].[vSKS_FI_Budget];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[vSKS_FI_Budget] AS								-- This table is budget for projects and relates for to the financial budget rather then the sales budget. ET 20220830
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO CustomerID 2022-12-16 VA
SELECT  	
		CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', TRIM([PBUKR]), '#', TRIM([PSPNR]) )))) AS BudgetID
		,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([COMPANY]),'#',TRIM([KUNNR]),'#',TRIM([PBUKR]))))) AS CustomerID
		--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([COMPANY],'#',TRIM([KUNNR]),'#',TRIM([PBUKR])))) AS CustomerID
		,CONVERT([binary](32),HASHBYTES('SHA2_256',[COMPANY])) AS CompanyID
		,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PRDGRP]),'#', TRIM([PBUKR]))))) AS PartID
		,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#','')))) AS WarehouseID
		,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([COMPANY]),'#',[PSPNR])))) AS ProjectID
		,YEAR(GETDATE())*10000 + MONTH(GETDATE())*100 + DAY(GETDATE())	AS BudgetPeriodDateID -- Currently can't find any periods of any kind in the date. Using Today for now. /SM 2021

	  ,[PartitionKey]
	  --,''	AS BudgetType
	  ,'ZBIS.SALES_BUDJE'		AS BudgetName	--Might not be correctly mapped field since POSID is more related to ProjectNum/Name.
	  ,[POST1]		AS BudgetDescription
	  ,[COMPANY]	AS Company
	  
	  ,CONCAT(YEAR(GETDATE()),'-', MONTH(GETDATE()))	AS BudgetPeriod
	  ,GETDATE()	AS BudgetPeriodDate
      --,''	AS PeriodType
      ,IIF(ISNUMERIC([KUNNR]) = 1,CAST(CAST(trim([KUNNR]) AS int)as nvarchar(50)),(trim([KUNNR])))  AS CustomerNum
      ,[KDGRP]	AS CustomerGroup
	  ,IIF(ISNUMERIC([PRDGRP]) = 1,CAST(CAST(trim([PRDGRP]) AS int)as nvarchar(50)),(trim([PRDGRP]))) AS PartNum
      ,[PRDGRP]	AS ProductGroup
      ,[SALESMEN]	AS SalesPersonCode
	  ,[SALESMEN]	AS SalesPersonName
      
      ,[BUDJ_SALES]	AS BudgetSales
      ,[BUDJ_COST]	AS BudgetCost
	  
	  ,[PWPOS]		AS Currency
	  ,[BUDJ_SALES] - [BUDJ_COST] AS GrossProfitInvoiced
	  ,([BUDJ_SALES] - [BUDJ_COST])/NULLIF([BUDJ_SALES],0)	AS [GrossMarginInvoiced%]
	  --,0			AS BudgetFinance
	  --,''			AS WarehouseCode
	  --,''			AS CostBearerNum
	  --,''			AS CostUnitNum
	  ,[POSKI]		AS ProjectNum
	  --,''			AS AccountNum
	  --,''			AS AccountGroupNum
	  --,''			AS BRes1
	  --,''			AS BRes2
	  --,''			AS BRes3
  FROM [stage].[SKS_FI_Budget]
GO
