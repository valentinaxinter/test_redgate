IF OBJECT_ID('[stage].[vCER_DK_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO












CREATE VIEW [stage].[vCER_DK_PurchaseLedger] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', SupplierNum, '#', PurchaseInvoiceNum))) AS PurchaseLedgerID
	,CONCAT(Company,'#',SupplierNum, '#', PurchaseInvoiceNum) AS PurchaseLedgerCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',PurchaseInvoiceNum))) AS PurchaseInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(''))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM(Currency)))) AS CurrencyID --Redundant?
	,CONVERT(int, replace(convert(date,PurchaseInvoiceDate),'-','')) AS PurchaseInvoiceDateID  --Redundant?
	,PartitionKey

	,Company
	,COALESCE(SupplierNum, '') AS SupplierNum
	,PurchaseOrderNum
	,PurchaseInvoiceNum
	--,SupplierInvoiceNum
	,[PurchaseInvoiceDate]
	,DueDate	AS PurchaseDueDate
	,CONVERT(date, LastPaymentDate) AS PurchaseLastPaymentDate
	,[InvoiceAmount]	AS InvoiceAmount
	,[InvoiceAmount] - [RemainingInvoiceAmount] AS PaidInvoiceAmount
	,[RemainingInvoiceAmount]	AS RemainingInvoiceAmount
	,CASE WHEN [RemainingInvoiceAmount] ='0' THEN 'Settled'
	WHEN [RemainingInvoiceAmount] <>'0' AND DATEDIFF(DAY, DueDate, GETDATE())<'-7' THEN 'Not Due Yet'
	WHEN [RemainingInvoiceAmount] <>'0' AND DATEDIFF(DAY, DueDate, GETDATE())BETWEEN '-7' AND '0' THEN 'Due in (0-7)'
	WHEN [RemainingInvoiceAmount] <>'0' AND DATEDIFF(DAY, DueDate, GETDATE())BETWEEN '1' AND '14' THEN 'Overdue (1-14)'
	WHEN [RemainingInvoiceAmount] <>'0' AND DATEDIFF(DAY, DueDate, GETDATE())BETWEEN '15' AND '30' THEN 'Overdue (15-30)'
	WHEN [RemainingInvoiceAmount] <>'0' AND DATEDIFF(DAY, DueDate, GETDATE())BETWEEN '31' AND '60' THEN 'Overdue (31-60)'
	WHEN [RemainingInvoiceAmount] <>'0' AND DATEDIFF(DAY, DueDate, GETDATE())>'60' THEN 'Overdue (60>)'
	ELSE '' END AS [AgingPeriod]
	,CASE WHEN [RemainingInvoiceAmount] ='0' THEN 0
	WHEN [RemainingInvoiceAmount] <>'0' AND DATEDIFF(DAY, DueDate, GETDATE())<'-7' THEN 1
	WHEN [RemainingInvoiceAmount] <>'0' AND DATEDIFF(DAY, DueDate, GETDATE())BETWEEN '-7' AND '0' THEN 2
	WHEN [RemainingInvoiceAmount] <>'0' AND DATEDIFF(DAY, DueDate, GETDATE())BETWEEN '1' AND '14' THEN 3
	WHEN [RemainingInvoiceAmount] <>'0' AND DATEDIFF(DAY, DueDate, GETDATE())BETWEEN '15' AND '30' THEN 4
	WHEN [RemainingInvoiceAmount] <>'0' AND DATEDIFF(DAY, DueDate, GETDATE())BETWEEN '31' AND '60' THEN 5
	WHEN [RemainingInvoiceAmount] <>'0' AND DATEDIFF(DAY, DueDate, GETDATE())>'60' THEN 6
	ELSE 7 END AS [AgingSort]
	,COALESCE([Currency], 'DKK') AS Currency
	,ExchangeRate
	,VATAmount
	,[VATCode]
	,'' AS PayToName
	,'' AS PayToCity
	,'' AS PayToContact
	,'' AS PaymentTerms
	,'' AS PrePaymentNum
	,'' AS LastPaymentNum
	,''	AS [VATCodeDesc]
	,'' AS [LinkToOriginalInvoice]
	,PLRes1
	,PLRes2
	,PlRes3
	,'1900-01-01' AS AccountingDate
FROM 
	stage.CER_DK_PurchaseLedger
GO
