IF OBJECT_ID('[stage].[vSKS_FI_ProductionOrder]') IS NOT NULL
	DROP VIEW [stage].[vSKS_FI_ProductionOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vSKS_FI_ProductionOrder] AS

WITH CTE AS (
SELECT 
	[PartitionKey], [MANDT], [SYSROWID], [COMPANY], [WAREHOUSECODE], [TRANSTYPE], [TRANSTYPEDESC], [PARTNUM], [TRANQTY], [BINNUM], [BARTCHNUM], [TRANSACTIONDATE], [CREATEDATE], [TRANSACTIONTIME], [ORDERNUM], [INVOICENUM], [COSTPRICE], [SELLINGPRICE], [CURRENCY], [ISSUERRECEIVERCODE], [TRANSOURCE], [TRANVALUE], [REFERENCE], [SRES1], [SRES2], [SRES3]
	,CAST(CASE WHEN [WAREHOUSECODE] = 'F251' THEN 'FI25'
			WHEN [WAREHOUSECODE] = 'F261' THEN 'FI26'
			--WHEN [WAREHOUSECODE] = 'SE10' THEN 'SE10'
			WHEN [WAREHOUSECODE] = 'F201' THEN 'FI20'
		ELSE [WAREHOUSECODE] END  AS nvarchar(10)) AS SKSCompCode
FROM 
	[stage].[SKS_FI_StockTransaction]  
WHERE [WAREHOUSECODE] IN ('FI25','FI26', 'FI20')
	and (TRIM(partnum) != '' and PARTNUM is not null)    -- Filter out PartNum that are missing a value. These are related to subcontracting/service and should not affect the stockvalue. /ET 2022-08-18
),
VKORG AS (
	SELECT Company, VKORG FROM stage.SKS_FI_Part WHERE COMPANY IN ('SMKFI', 'SCOFI')
)

SELECT 
    CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(st.Company), '#', TRIM([SYSROWID]), '#',TRIM(PartNum))))) AS [ProductionOrderID]
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(st.Company)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(st.Company),'#',TRIM(st.PartNum),'#', MAX(TRIM(VKORG.VKORG)))))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(st.[Company]),'#',TRIM(st.[WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(st.Company),'#',TRIM([SYSROWID]))))) AS SalesOrderNumID  
	,[PartitionKey] 
	
    ,UPPER(TRIM(st.[Company])) AS "Company"                                  
    ,UPPER(TRIM([SYSROWID])) AS "ProductionOrderNum"                                   
    ,IIF(ISNUMERIC([PARTNUM]) = 1,CAST(CAST(trim([PARTNUM]) AS int)as nvarchar(50)),(trim([PARTNUM]))) AS   "PartNum"                                                                   
    ,'Component' as [PartType]
    ,TRY_CONVERT(decimal(18,4), IIF(CHARINDEX('-',TRANQTY) > 0, '-' + REPLACE(TRIM(TranQty), '-',''), TRIM(TRANQTY))) AS "OrderQuantity"
    ,TRY_CONVERT(decimal(18,4), IIF(CHARINDEX('-',TRANQTY) > 0, '-' + REPLACE(TRIM(TranQty), '-',''), TRIM(TRANQTY))) AS "CompletedQuantity"                        
    ,'Completed' as [Status] 
	,CASE WHEN TRANSACTIONDATE = '' OR TRANSACTIONDATE is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, TRANSACTIONDATE) END AS "OrderCreateDate"   
	,CASE WHEN TRANSACTIONDATE = '' OR TRANSACTIONDATE is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, TRANSACTIONDATE) END AS "StartDate"
	,CASE WHEN TRANSACTIONDATE = '' OR TRANSACTIONDATE is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, TRANSACTIONDATE) END AS "EndDate"                                                               
    ,UPPER(TRIM([WarehouseCode])) AS "WarehouseCode"                               
    ,UPPER(TRIM([SYSROWID])) AS "SalesOrderNum"                              
    ,'EUR' AS [Currency]
    , 1 as [ExchangeRate]
    ,TRY_CONVERT(decimal(18,4), IIF(CHARINDEX('-',TRANVALUE) > 0, '-' + REPLACE(TRIM(TRANVALUE), '-',''), TRIM(TRANVALUE))) AS [MaterialCost]
	
FROM [stage].SKS_FI_StockTransaction st
		LEFT JOIN VKORG ON st.Company = VKORG.COMPANY
WHERE TransType='261' and st.Company IN ('SMKFI', 'SCOFI')
GROUP BY st.Company, [SYSROWID], PartNum, st.[WAREHOUSECODE], TRANQTY, TRANSACTIONDATE, TRANVALUE, [PartitionKey]
GO
