IF OBJECT_ID('[stage].[vSKS_FI_Claim]') IS NOT NULL
	DROP VIEW [stage].[vSKS_FI_Claim];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSKS_FI_Claim] AS
WITH CTE AS (
SELECT [PartitionKey], [MANDT], [QMNUM], [QMART], [QMTXT], [PRIOK], [ERNAM], [ERDAT], [MZEIT], [QMDAT], [STRUR], [MATNR], [MATKL], [PRDHA], [KUNUM], [BEZDT], [BEZUR], [LIFNUM], [VBELN], [BSTNK], [VKORG], [QMGRP], [QMCOD], [ZDESCRIPTION], [ZPARTNER]
	,CASE WHEN [VKORG] ='FI20' THEN N'SMKFI'
		WHEN [VKORG] IN ('FI25','FI26') THEN N'SCOFI' 
		ELSE VKORG									END AS Company
FROM [stage].[SKS_FI_Claim]
WHERE VKORG IN ('FI20','FI25','FI26')
)
--ADD TRIM()UPPER() INTO CustomerID,PartID 2022-12-16 VA
SELECT

	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(COMPANY, '#', QMNUM ))) AS ClaimID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(COMPANY, '#', TRIM(IIF(KUNUM IS NULL OR KUNUM = '', 'MISSINGCUSTOMER', KUNUM)), '#', TRIM([VKORG])))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(COMPANY), '#', TRIM(KUNUM), '#', TRIM([VKORG]))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(COMPANY, '#', TRIM(IIF([LIFNUM] IS NULL OR [LIFNUM] = '', 'MISSINGSUPPLIER', [LIFNUM])), '#', TRIM([VKORG])))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(COMPANY, '#', TRIM(IIF([MATNR] IS NULL OR [MATNR] = '', 'MISSINGPART',  [MATNR]) ), '#', TRIM([VKORG])))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(COMPANY), '#', TRIM([MATNR]), '#', TRIM([VKORG]))))) AS PartID 
	,[PartitionKey]
      ,[MANDT]
      ,[QMNUM]	AS ClaimNum
      ,[QMART]	
      ,[QMTXT]	AS ClaimDescription --??
      ,[PRIOK]	AS ClaimPriority
      ,[ERNAM]	AS ClaimHandler
      ,[ERDAT]	AS CreateDate
      ,[MZEIT]	AS CreateTime
      ,[QMDAT]	AS StartDate
      ,[STRUR]	AS StartTime
      ,[MATNR]	AS PartNum
      ,[MATKL]
      ,[PRDHA]
      ,[KUNUM]	AS CustomerNum
      ,[BEZDT]	AS EndDate
      ,[BEZUR]	AS EndTime
      ,[LIFNUM]	AS SupplierNum
      ,[VBELN]	AS SalesOrderNum
      ,[BSTNK]	AS PurchaseOrderNum
      ,[VKORG]
      ,[QMGRP]
      ,[QMCOD]	AS ClaimGroup
      ,[ZDESCRIPTION]
      ,[ZPARTNER]
  FROM CTE
GO
