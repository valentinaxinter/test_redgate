IF OBJECT_ID('[stage].[vSKS_FI_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vSKS_FI_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vSKS_FI_StockTransaction] AS 
WITH CTE AS (
SELECT 
	[PartitionKey], [MANDT], [SYSROWID], [COMPANY], [WAREHOUSECODE], [TRANSTYPE], [TRANSTYPEDESC], [PARTNUM], [TRANQTY], [BINNUM], [BARTCHNUM], [TRANSACTIONDATE], [CREATEDATE], [TRANSACTIONTIME], [ORDERNUM], [INVOICENUM], [COSTPRICE], [SELLINGPRICE], [CURRENCY], [ISSUERRECEIVERCODE], [TRANSOURCE], [TRANVALUE], [REFERENCE], [SRES1], [SRES2], [SRES3]
	,CAST(CASE WHEN [WAREHOUSECODE] = 'F251' THEN 'FI25'
			WHEN [WAREHOUSECODE] = 'F261' THEN 'FI26'
			WHEN [WAREHOUSECODE] = 'SE10' THEN 'SE10'
			WHEN [WAREHOUSECODE] = 'F201' THEN 'FI20'
		ELSE [WAREHOUSECODE] END  AS nvarchar(10)) AS SKSCompCode
FROM 
	[stage].[SKS_FI_StockTransaction]  
WHERE [WAREHOUSECODE] NOT IN ('FI00','SE10')
	and (TRIM(partnum) != '' and PARTNUM is not null)    -- Filter out PartNum that are missing a value. These are related to subcontracting/service and should not affect the stockvalue. /ET 2022-08-18
)
--ADD TRIM()UPPER()INTO PartID,CustomerID,WarehouseID 2022-12-16
SELECT distinct
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#',  SYSROWID))) AS StockTransactionID	--Temporary PK due to SYSROWID not working with daily refresh. Needs revision /SM 2022-02-28
	,CONCAT([Company], '#', TRIM(SYSROWID)) AS IndexKey --StockTransactionCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', (TRIM([Company])))) AS CompanyID
    --,CONVERT([binary](32), HASHBYTES('SHA2_256', (CONCAT(TRIM([Company]), '#', TRIM([PartNum]), '#', SKSCompCode)))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', (UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]), '#', TRIM(SKSCompCode)))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', (CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
 	,CONVERT([binary](32), HASHBYTES('SHA2_256', (UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode])))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', (CONCAT(TRIM([Company]), '#', TRIM([OrderNum]))))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', (CONCAT(TRIM([Company]), '#', TRIM([OrderNum]))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', (CONCAT(TRIM([Company]), '#', TRIM([InvoiceNum]))))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', (CONCAT(TRIM([Company]), '#', TRIM([InvoiceNum]))))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', (UPPER(CONCAT(TRIM([Company]), '#', TRIM(ISSUERRECEIVERCODE), '#', TRIM(SKSCompCode)))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', (CONCAT(TRIM([Company]), '#', TRIM(ISSUERRECEIVERCODE), '#', SKSCompCode )))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', (CONCAT(TRIM([Company]), '#', TRIM(ISSUERRECEIVERCODE), '#', SKSCompCode )))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', (TRIM('')))) AS CurrencyID
	,[PartitionKey]

    --,CASE WHEN COMPANY = 'SKSSWE' THEN 'JSESKSSW' ELSE COMPANY END AS Company
	,Company
	,TRIM(WAREHOUSECODE) AS WarehouseCode
	,iif(CAST([TRANSACTIONDATE] AS date) = '2018-11-22' and TRANSTYPEDESC = 'Initial stock entry','OB',TRANSTYPE) AS TransactionCode
	,iif(CAST([TRANSACTIONDATE] AS date) = '2018-11-22' and TRANSTYPEDESC = 'Initial stock entry','Opening balance',TRANSTYPEDESC) AS TransactionDescription
	,ISSUERRECEIVERCODE AS IssuerReceiverNum
    ,OrderNum
	--,'' AS OrderLine
	,InvoiceNum
	--,'' AS InvoiceLine
	,IIF(ISNUMERIC([PARTNUM]) = 1,CAST(CAST(trim([PARTNUM]) AS int)as nvarchar(50)),(trim([PARTNUM]))) AS PartNum
    ,TRIM(BINNUM) AS BinNum
    ,TRIM(BARTCHNUM) AS BatchNum
	,IIF([TRANSACTIONDATE] = '' OR [TRANSACTIONDATE] is null, '1900-01-01', CAST([TRANSACTIONDATE] AS date)) AS TransactionDate
	,TRANSACTIONTIME AS TransactionTime --CAST(TRANSACTIONTIME AS Time) --failed ??? --didn't take in, shall be done later
	--,IIF(TRANQTY = '' OR TRANQTY is NULL, Null, CONVERT(decimal(18,4), TRIM(TRANQTY))) AS [TransactionQty]
	,TRY_CONVERT(decimal(18,4), IIF(CHARINDEX('-',TRANQTY) > 0, '-' + REPLACE(TRIM(TranQty), '-',''), TRIM(TRANQTY))) AS [TransactionQty]
	--,IIF(TRANVALUE = '' OR TRANVALUE is NULL, Null, CONVERT(decimal(18,4), TRIM(TRANVALUE))) AS TransactionValue
	,TRY_CONVERT(decimal(18,4), IIF(CHARINDEX('-',TRANVALUE) > 0, '-' + REPLACE(TRIM(TRANVALUE), '-',''), TRIM(TRANVALUE))) AS TransactionValue
	,IIF(COSTPRICE = '', Null, CONVERT(decimal(18,4), TRIM(COSTPRICE))) AS [CostPrice]
	,IIF(SELLINGPRICE = '', Null, CONVERT(decimal(18,4), TRIM(SELLINGPRICE))) AS [SalesUnitPrice]
	,CURRENCY AS [Currency]
	,IIF(mapTrancode.Internal_External = 'External', 'E', 'I') AS Reference
	--,IIF(CREATEDATE = '' OR CREATEDATE is null, '1900-01-01', CAST(CREATEDATE AS date)) AS AdjustmentDate -CreateDate is equivalent to GETDATE(), meaning that it's not very useful at all
	,'1900-01-01'  AS AdjustmentDate
	,IIF(mapTrancode.Internal_External = 'External', 'External', 'Internal') AS InternalExternal
	,TRIM(SYSROWID) AS STRes1
	,Reference AS STRes2
	,SRES3 AS STRes3
FROM 
	CTE
LEFT JOIN stage.SKS_FI_mapStockTranCode as mapTrancode ON CTE.TRANSTYPE = mapTrancode.TransactionCode

/*
GROUP BY [PartitionKey],[MANDT],[COMPANY],[WAREHOUSECODE],[TRANSTYPE],[TRANSTYPEDESC],[PARTNUM],[BINNUM],[BARTCHNUM],[TRANSACTIONDATE],[CREATEDATE],[TRANSACTIONTIME]
      ,[ORDERNUM],[INVOICENUM],[CURRENCY],[ISSUERRECEIVERCODE],[TRANSOURCE],[REFERENCE],[SRES1],[SRES2],[SRES3], SKSCompCode, mapTrancode.Internal_External
--	   ,[TRANQTY]
      --,[TRANVALUE]
--	  ,[COSTPRICE]
--     ,[SELLINGPRICE]
*/
GO
