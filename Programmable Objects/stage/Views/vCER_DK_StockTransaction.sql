IF OBJECT_ID('[stage].[vCER_DK_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_DK_StockTransaction] AS 
--ADD TRIM() INTO PartID,WarehouseID 2022-12-14 VA
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#', IndexKey)))) AS StockTransactionID
	,UPPER(CONCAT([Company],'#',TRIM(IndexKey))) AS StockTransactionCode --StockTransactionCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(PartNum))))) AS PartID
    --,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM(PartNum))))) AS PartID
 	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(OrderNum)))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([InvoiceNum]))))) AS SalesInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([InvoiceNum]))))) AS PurchaseInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#', '')))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#','')))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Currency])))) AS CurrencyID
	,[PartitionKey]

    ,Company -- 
	,WarehouseCode
	,iif(TransactionDate = '2017-04-28' and LEFT(InvoiceNum,7) =  'ÅBNING','OB',TransactionCode) AS TransactionCode
    ,CASE	WHEN TRIM(TransactionDescription) = 'Sale' THEN 'Outgoing goods' 
			WHEN TRIM(TransactionDescription) = 'Purchase' THEN 'Incoming goods' 
			when  TransactionDate = '2017-04-28' and LEFT(TRIM(InvoiceNum),7) =  'ÅBNING' then 'Opening balance'
				END AS TransactionDescription
	--,'' AS IssuerReceiverNum
	,OrderNum 
	,OrderLine
	,InvoiceNum
	,InvoiceLine
    ,COALESCE(TRIM(UPPER([PartNum])),'') AS PartNum
    ,BinNum
    ,BatchNum
    ,TransactionDate
    ,TransactionTime
	,TransactionQty
    ,TransactionValue
	,[CostPrice]
    ,SalesUnitPrice
	,Currency
	,[Reference]
	,AdjustmentDate
	,CASE WHEN TransactionDescription IN ('Sale','Purchase') THEN 'External' ELSE 'Internal' END	AS InternalExternal
	,STRes1
	,STRes2
	,STRes3
    ,IndexKey
	
FROM 
	[stage].[CER_DK_StockTransaction]
GO
