IF OBJECT_ID('[stage].[vJEN_SE_StockTransactionOB]') IS NOT NULL
	DROP VIEW [stage].[vJEN_SE_StockTransactionOB];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/


CREATE VIEW [stage].[vJEN_SE_StockTransactionOB] AS
SELECT 
		CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(N'JSEJENSS','#OB#20200101',Artikelnummer, '#', W.WarehouseCode))) AS StockTransactionID
		,CONCAT(N'JSEJENSS','#OB#20200101') AS StockTransactionCode
		,CONVERT([binary](32),HASHBYTES('SHA2_256',N'JSEJENSS')) AS CompanyID
		,P.PartID
		,W.WarehouseID
		,NULL AS SalesOrderNumID
		,NULL AS PurchaseOrderNumID
		,NULL AS SalesInvoiceID
		,NULL AS PurchaseInvoiceID
		,NULL AS CustomerID
		,NULL AS SupplierID
		,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM(N'SEK'))) AS CurrencyID
		,FORMAT(GETDATE(),'yyyy-MM-dd hh:00:00') AS PartitionKey
		,NULL AS IndexKey
		,N'JSEJENSS' AS Company
		,W.WarehouseCode
		,'OB' AS TransactionCode
		,'Opening Balance' AS TransactionDescription
		,NULL AS IssuerReceiverNum
		,NULL AS OrderNum
		,NULL AS OrderLine
		,NULL AS InvoiceNum
		,NULL AS InvoiceLine
		,COALESCE(P.PartNum, OB.[Artikelnummer]) AS PartNum
		,NULL AS BinNum
		,NULL AS BatchNum
		,CAST('2020-01-01' AS date) AS TransactionDate
		,'000000'	AS TransactionTime
		,Saldo AS TransactionQty
		,Belopp AS TransactionValue
		,NULL AS CostPrice
		,NULL AS SalesUnitPrice
		,'SEK' AS Currency
		,NULL AS Reference
		,cast(NULL as date) AS AdjustmentDate
		,NULL AS InternalExternal
		,NULL AS STRes1
		,NULL AS STRes2
		,NULL AS STRes3
		,NULL AS FIFOBatchID
		,NULL AS SupplierBatchID
		,NULL AS TranDT
		,'Manual opening balance excel' AS TranSource 
  FROM [stage].[JEN_SE_StockTransactionOB20200101] OB
  left join dw.Part P ON P.Company = 'JSEJENSS' AND OB.Artikelnummer = P.PartNum
  left join dw.Warehouse W ON W.Company = 'JSEJENSS' and warehousecode= '01'
GO
