IF OBJECT_ID('[stage].[vTRA_SE_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vTRA_SE_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vTRA_SE_PurchaseLedger]
	AS select 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum), '#', TRIM(journal))))) AS PurchaseLedgerID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,PartitionKey
	,UPPER(Company)				as Company
	, TRIM(SupplierNum)			as SupplierNum
	, trim(PurchaseInvoiceNum)	as PurchaseInvoiceNum
	, cast(PurchaseInvoiceDate as date) as PurchaseInvoiceDate
	,cast(InvoiceAmount as decimal(18,4)) as InvoiceAmount
	,cast(PaidInvoiceAmount as decimal(18,4)) as PaidInvoiceAmount
	,cast(RemainingInvoiceAmount as decimal(18,4)) as RemainingInvoiceAmount
	,cast(VATAmount as decimal(18,4)) as VATAmount
	, Currency
	, cast(ExchangeRate as decimal (18,4)) as ExchangeRate
	, PurchaseOrderNum
	, cast(PurchaseDueDate as date) as PurchaseDueDate
	, cast(PurchaseLastPaymentDate as date) as PurchaseLastPaymentDate
	, cast(AccountingDate as date) as AccountingDate
	,PaymentTerms
	,cast(IsInvoiceClosed as bit) as IsInvoiceClosed
	,cast(IsActiveRecord as bit) as IsActiveRecord
from stage.TRA_SE_PurchaseLedger
;
GO
