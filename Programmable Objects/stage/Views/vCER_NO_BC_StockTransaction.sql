IF OBJECT_ID('[stage].[vCER_NO_BC_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_BC_StockTransaction];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_NO_BC_StockTransaction] AS

SELECT 
--------------------------------------------- Keys/ IDs ---------------------------------------------
CONVERT(binary(32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(IndexKey))))) AS StockTransactionID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
,CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
--,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(InvoiceNum))))) AS PurchaseInvoiceID
--,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(OrderNum))))) AS PurchaseOrderNumID
--,CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company,'#',TRIM(OrderNum))))) AS SalesOrderNumID
--, CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(InvoiceNum))))) AS SalesInvoiceID
--,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(IssuerReceiverNum))))) AS CustomerID
--,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(IssuerReceiverNum))))) AS SupplierID
,CONVERT(binary(32),HASHBYTES('SHA2_256',TRIM(Currency))) AS CurrencyID
,PartitionKey
--------------------------------------------- Regular Fields ---------------------------------------------
---Mandatory Fields ---
,UPPER(TRIM(Company)) AS Company
,UPPER(TRIM(IndexKey)) AS IndexKey
,UPPER(TRIM(TransactionCode)) AS TransactionCode
,UPPER(TRIM(PartNum)) AS PartNum
,CASE WHEN TransactionDate = '' OR TransactionDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, TransactionDate) END AS TransactionDate
,CONVERT(decimal(18,4), Replace(TransactionQty, ',', '.')) AS TransactionQty
,CONVERT(decimal(18,4), Replace(TransactionValue, ',', '.')) AS TransactionValue
---Valuable Fields ---
,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
,UPPER(TRIM(TransactionCodeDescription)) AS TransactionDescription
,UPPER(TRIM(IsInternalTransaction)) AS IsInternalTransaction
,iif(IsInternalTransaction = 'True','Internal','External') as [InternalExternal]
,UPPER(TRIM(CustomerNum)) AS CustomerNum
,UPPER(TRIM(SupplierNum)) AS SupplierNum
--,UPPER(TRIM(SalesOrderNum)) AS SalesOrderNum
--,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
--,UPPER(TRIM(SalesInvoiceNum)) AS SalesInvoiceNum
--,UPPER(TRIM(PurchaseInvoiceNum)) AS PurchaseInvoiceNum
,UPPER(TRIM(Currency)) AS Currency
,CONVERT(decimal(18,4), Replace(ExchangeRate, ',', '.')) AS ExchangeRate
--,UPPER(TRIM(Reference)) AS Reference
--,CASE WHEN AdjustmentDate = '' OR AdjustmentDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, AdjustmentDate) END AS AdjustmentDate
--,CASE WHEN AgreementEnd = '' OR AgreementEnd is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, AgreementEnd) END AS AgreementEnd
--- Good-to-have Fields ---
--,UPPER(TRIM(SalesOrderLine)) AS SalesOrderLine
--,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
--,UPPER(TRIM(SalesInvoiceLine)) AS SalesInvoiceLine
--,UPPER(TRIM(PurchaseInvoiceLine)) AS PurchaseInvoiceLine
--,UPPER(TRIM(BinNum)) AS BinNum
--,UPPER(TRIM(BatchNum)) AS BatchNum
,UPPER(TRIM(TransactionTime)) AS TransactionTime
--------------------------------------------- Meta Data ---------------------------------------------
,CONVERT(date, CreatedTimeStamp) AS CreatedTimeStamp
,CONVERT(date, ModifiedTimeStamp) AS ModifiedTimeStamp
--,TRIM(IsActiveRecord) AS IsActiveRecord
--------------------------------------------- Extra Fields ---------------------------------------------
--,UPPER(TRIM(STRes1)) AS STRes1
--,UPPER(TRIM(STRes2)) AS STRes2
--,UPPER(TRIM(STRes3)) AS STRes3

FROM [stage].[CER_NO_BC_StockTransaction]
GO
