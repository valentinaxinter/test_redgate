IF OBJECT_ID('[stage].[vFOR_PL_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vFOR_PL_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vFOR_PL_PurchaseLedger]
	AS select 
 CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseLedgerID
 ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
 ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(PurchaseOrderNum)))) AS PurchaseOrderNumID
, PartitionKey
, Company
, SupplierNum
, PurchaseInvoiceNum
, cast( PurchaseInvoiceDate	    as date) as PurchaseInvoiceDate
, cast( PurchaseLastPaymentDate as date) as PurchaseLastPaymentDate
, cast( PurchaseDueDate		    as date) as PurchaseDueDate
, cast(InvoiceAmount			 as decimal(18,4)) as InvoiceAmount
, cast(ExchangeRate				 as decimal(18,4)) as ExchangeRate
, cast(PaidInvoiceAmount		 as decimal(18,4)) as PaidInvoiceAmount
, cast(RemainingInvoiceAmount	 as decimal(18,4)) as RemainingInvoiceAmount
, cast(VATAmount				 as decimal(18,4)) as VATAmount

, Currency

, SupplierInvoiceNum
, cast(PaymentTerms as smallint) as PaymentTerms
, iif(trim(IsInvoiceCLosed) = 'C',1,0) as IsInvoiceClosed
-- , CreatedTimeStamp
-- , ModifiedTimeStamp
from stage.FOR_PL_PurchaseLedger
GO
