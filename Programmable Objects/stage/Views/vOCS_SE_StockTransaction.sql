IF OBJECT_ID('[stage].[vOCS_SE_StockTransaction]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_StockTransaction];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vOCS_SE_StockTransaction] AS
	 SELECT 
--------------------------------------------- Keys/ IDs ---------------------------------------------
CONVERT(binary(32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(IndexKey)))) AS StockTransactionID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(Company))) AS CompanyID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(PartNum))))) AS PartID
,CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(SalesInvoiceNum))))) AS PurchaseInvoiceID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(SalesOrderNum))))) AS PurchaseOrderNumID
,CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company,'#',TRIM(SalesOrderNum))))) AS SalesOrderNumID
, CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(SalesInvoiceNum))))) AS SalesInvoiceID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(CustomerNum))))) AS CustomerID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(SupplierNum))))) AS SupplierID
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

,iif (SalesOrderNum = null or SalesOrderNum = '' ,upper(trim(PurchaseOrderNum)),upper(trim(SalesOrderNum))) as OrderNum
,iif (SalesOrderLine = null or SalesOrderLine = '' ,upper(trim(PurchaseOrderLine)),upper(trim(SalesOrderLine))) as OrderLine
,iif (SalesInvoiceNum = null or SalesInvoiceNum = '' ,upper(trim(PurchaseInvoiceNum)),upper(trim(SalesInvoiceNum))) as InvoiceNum
,iif (SalesInvoiceLine = null or SalesInvoiceLine = '' ,upper(trim(PurchaseInvoiceLine)),upper(trim(SalesInvoiceLine))) as InvoiceLine
,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
,UPPER(TRIM(TransactionCodeDescription)) AS TransactionDescription
,UPPER(TRIM(IsInternalTransaction)) AS IsInternalTransaction
,UPPER(TRIM(CustomerNum)) AS CustomerNum
,UPPER(TRIM(SupplierNum)) AS SupplierNum
,UPPER(TRIM(SalesOrderNum)) AS SalesOrderNum
,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
,UPPER(TRIM(SalesInvoiceNum)) AS SalesInvoiceNum
,UPPER(TRIM(PurchaseInvoiceNum)) AS PurchaseInvoiceNum
,UPPER(TRIM('SEK')) AS Currency
,1 AS ExchangeRate
--,UPPER(TRIM(Reference)) AS Reference
--,CASE WHEN AdjustmentDate = '' OR AdjustmentDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, AdjustmentDate) END AS AdjustmentDate
--,CASE WHEN AgreementEnd = '' OR AgreementEnd is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, AgreementEnd) END AS AgreementEnd

--- Good-to-have Fields ---
,UPPER(TRIM(SalesOrderLine)) AS SalesOrderLine
,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
,UPPER(TRIM(SalesInvoiceLine)) AS SalesInvoiceLine
,UPPER(TRIM(PurchaseInvoiceLine)) AS PurchaseInvoiceLine
,UPPER(TRIM(BinNum)) AS BinNum
,UPPER(TRIM(BatchNum)) AS BatchNum
--,UPPER(TRIM(TransactionTime)) AS TransactionTime

--------------------------------------------- Meta Data ---------------------------------------------
,CONVERT(date, CreatedTimeStamp) AS CreatedTimeStamp
,CONVERT(date, ModifiedTimeStamp) AS ModifiedTimeStamp
--,TRIM(IsActiveRecord) AS IsActiveRecord

--------------------------------------------- Extra Fields ---------------------------------------------
--,UPPER(TRIM(STRes1)) AS STRes1
--,UPPER(TRIM(STRes2)) AS STRes2
--,UPPER(TRIM(STRes3)) AS STRes3
 FROM [stage].[OCS_SE_StockTransaction]
GO
