IF OBJECT_ID('[stage].[vSKS_FI_Project]') IS NOT NULL
	DROP VIEW [stage].[vSKS_FI_Project];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSKS_FI_Project] AS

SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([COMPANY]),'#',[PSPNR])))) AS ProjectID
	,UPPER(CONCAT(TRIM([COMPANY]),'#',[PSPNR] )) AS ProjectCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([COMPANY])))) AS CompanyID
	,PartitionKey

	--,CASE WHEN COMPANY = 'SKSSWE' THEN 'JSESKSSW' ELSE COMPANY END AS Company 
	,Company
	--,PBUKR AS [CoCode]
	,'' AS MainProjectNum
	,PSPNR  AS [ProjectNum]
	,CONCAT(POSKI, ' – ',  POST1) AS [ProjectDescription]
	,'' AS [Organisation]
	--,MANDT AS [Organisation]
	,'' AS ProjectStatus
	,'' AS ProjectCategory
	
	,POSKI AS [WBSElement]
	,POSID AS [ObjectNum]
	--,PRCTR AS [ProfitCtr]
--	,OBJNR AS [ObjectNumber]
	--,PKOKR AS [COAr]
	--,KVEWE AS [Usage]
	--,KAPPL AS [Applcat]
	,STUFE AS [Level]
	,PWPOS AS [Currency]
	,WERKS AS [WarehouseCode]
	,'' AS ProjectResponsible
	,'' AS Comments
	,ERDAT AS [StartDate]
	,'' AS EndDate
	,'' AS EstEndDate
	,NULL AS ProjectCompletion
	,TRY_CAST(TOT_COST AS decimal(18,4)) AS ActualCost
FROM [stage].[SKS_FI_Project]
WHERE PBUKR NOT IN ('FI00','SE10')
GROUP BY 
      [PartitionKey],[COMPANY],PSPNR,POSKI,POST1,MANDT,PBUKR,PKOKR,POSID,OBJNR,PRCTR,KVEWE,KAPPL,STUFE,PWPOS,WERKS,ERDAT, TOT_COST
GO
