IF OBJECT_ID('[stage].[vFOR_ES_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vFOR_ES_PurchaseLedger] AS 
SELECT 

	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum)))) AS PurchaseLedgerID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([Company]))) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(PurchaseOrderNum)))) AS PurchaseOrderNumID,
	-- CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine) )))) AS PurchaseInvoiceID, - cant create cause we dont have purchaseinvoiceline

	PartitionKey,
	Company,
	SupplierNum				,
	PurchaseOrderNum		,
	PurchaseInvoiceNum		,
	SupplierInvoiceNum		,
	PurchaseInvoiceDate		,
	PurchaseDueDate			,
	PurchaseLastPaymentDate	,
	InvoiceAmount			,
	PaidInvoiceAmount		,
	RemainingInvoiceAmount	,
	AccountingDate			,
	Currency				,
	VATAmount				,
	VATCode					,
	VATCodeDesc				,
	PayToName				,
	PayToCity				,
	PayToContact			,
	PaymentTerms			,
	PrePaymentNum			,
	LastPaymentNum			,
	ExchangeRate			,
	AgingPeriod				


FROM 
	 [stage].[FOR_ES_PurchaseLedger]
GO
