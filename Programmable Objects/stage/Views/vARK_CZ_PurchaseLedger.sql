IF OBJECT_ID('[stage].[vARK_CZ_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vARK_CZ_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vARK_CZ_PurchaseLedger] AS 
--ADD UPPER() TRIM() INTO SupplierID 23-01-23 VA // COMMENT EMPTY FIELDS 
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(InvoiceNum)))) AS PurchaseLedgerID
	,CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(InvoiceNum)) AS PurchaseLedgerCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(Company))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SupplierNum)))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(InvoiceNum)))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', ''))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', '')) AS CurrencyID
	,CONVERT(int, replace(convert(date,InvoiceDate), '-', '')) AS PurchaseInvoiceDateID 
	,[PartitionKey]

	,[Company]
	,TRIM(SupplierNum) AS SupplierNum
	,'' AS [PurchaseOrderNum]
	,InvoiceNum AS [PurchaseInvoiceNum]
	,CONVERT(date, [InvoiceDate]) AS [PurchaseInvoiceDate]
	,CONVERT(date, [DueDate]) AS PurchaseDueDate
	,CONVERT(date, [LastPaymentDate]) AS PurchaseLastPaymentDate
	--,NULL AS [InvoiceAmount]
	,1 AS [ExchangeRate]
	,'CZK' AS [Currency]
	--,NULL AS [VATAmount]
	--,'' AS [VATcode]
	--,'' AS [PayToName]
	--,'' AS [PayToCity]
	--,'' AS PayToContact
	--,'' AS [PaymentTerms]
	--,'' AS [PrepaymentNum]
	--,'' AS LastPaymentNum
	,PLRES1
	,PLRES2
	,PLRES3
	--,NULL AS PaidInvoiceAmount
	--,NULL AS RemainingInvoiceAmount
	--,NULL AS LinkToOriginalInvoice
	,CAST('1900-01-01'AS date) AS AccountingDate
	--,NULL AS AgingPeriod
	--,NULL AS AgingSort
	--,NULL AS VATCodeDesc
FROM 
	[stage].[ARK_CZ_PurchaseLedger]
--WHERE [InvoiceDate] >= DATEADD(year, -1, GETDATE()) --Added this where clause as semi-incremental load functinoality since it doesn't work easily on meta-param table. /SM 2021-10-01
--GROUP BY
--	[Company],[SupplierNum],[InvoiceNum],InvoiceDate,DueDate,LastPaymentDate,[PartitionKey],PLRES1,PLRES2,PLRES3
GO
