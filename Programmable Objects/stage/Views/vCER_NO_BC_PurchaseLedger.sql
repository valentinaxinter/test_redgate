IF OBJECT_ID('[stage].[vCER_NO_BC_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_BC_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vCER_NO_BC_PurchaseLedger] as
SELECT

--------------------------------------------- Keys/ IDs ---------------------------------------------
CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseLedgerID -- shall = in Invoice
,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))) AS PurchaseLedgerCode --Redundant?
,CONVERT(binary(32), HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
,CONVERT(binary(32), HASHBYTES('SHA2_256',UPPER(CONCAT(Company, '#', TRIM(SupplierNum))))) AS SupplierID
,CONVERT(binary(32), HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID --Redundant?
--,CONVERT(binary(32), HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID --Redundant?
,CONVERT(binary(32), HASHBYTES('SHA2_256',UPPER(TRIM(Currency)))) AS CurrencyID --Redundant?
,CONVERT(int, replace(convert(date,PurchaseInvoiceDate),'-','')) AS PurchaseInvoiceDateID --Redundant?
,PartitionKey

--------------------------------------------- Regular Fields ---------------------------------------------
---Mandatory Fields ---
,UPPER(TRIM(Company)) AS Company
,UPPER(TRIM(SupplierNum)) AS SupplierNum
,UPPER(TRIM(PurchaseInvoiceNum)) AS PurchaseInvoiceNum
,CASE WHEN PurchaseInvoiceDate = '' OR PurchaseInvoiceDate is NULL THEN NULL ELSE CONVERT(date, PurchaseInvoiceDate) END AS PurchaseInvoiceDate
,CONVERT(decimal(18,4), Replace(InvoiceAmount, ',', '.')) AS InvoiceAmount
--,CONVERT(decimal(18,4), Replace(PaidInvoiceAmount, ',', '.')) AS PaidInvoiceAmount
,CONVERT(decimal(18,4), Replace(RemainingInvoiceAmount, ',', '.')) AS RemainingInvoiceAmount
,UPPER(TRIM(Currency)) AS Currency
,CONVERT(decimal(18,4), Replace(ExchangeRate, ',', '.')) AS ExchangeRate

--Valuable Fields ---

--,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
,UPPER(TRIM(SupplierInvoiceNum)) AS SupplierInvoiceNum
,CASE WHEN PurchaseDueDate = '' OR PurchaseDueDate is NULL THEN NULL ELSE CONVERT(date, PurchaseDueDate) END AS PurchaseDueDate
--,CASE WHEN PurchaseLastPaymentDate = '' OR PurchaseLastPaymentDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, PurchaseLastPaymentDate) END AS PurchaseLastPaymentDate
--,CASE WHEN AccountingDate = '' OR AccountingDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, AccountingDate) END AS AccountingDate
,CONVERT(decimal(18,4), Replace(VATAmount, ',', '.')) AS VATAmount
,UPPER(TRIM(PaymentTerms)) AS PaymentTerms

--- Good-to-have Fields ---
--,UPPER(TRIM(LinktoOriginalInvoice)) AS LinktoOriginalInvoice
--,UPPER(TRIM(VATCode)) AS VATCode
--,UPPER(TRIM(VATCodeDesc)) AS VATCodeDesc
,UPPER(TRIM(PayToName)) AS PayToName
,UPPER(TRIM(PayToCity)) AS PayToCity
,UPPER(TRIM(PayToContact)) AS PayToContact
--,UPPER(TRIM(PrePaymentNum)) AS PrePaymentNum
--,UPPER(TRIM(LastPaymentNum)) AS LastPaymentNum

--------------------------------------------- Meta Data ---------------------------------------------
,CONVERT(date, CreatedTimeStamp) AS CreatedTimeStamp
,CONVERT(date, ModifiedTimeStamp) AS ModifiedTimeStamp
--,TRIM(IsActiveRecord) AS IsActiveRecord

--------------------------------------------- Extra Fields ---------------------------------------------
--,UPPER(TRIM(PLRes1)) AS PLRes1
--,UPPER(TRIM(PLRes2)) AS PLRes2
--,UPPER(TRIM(PLRes3)) AS PLRes3

FROM [stage].[CER_NO_BC_PurchaseLedger]
GO
