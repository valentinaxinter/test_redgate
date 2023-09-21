IF OBJECT_ID('[stage].[vAXHSE_HQ_PurchaseLedger]') IS NOT NULL
	DROP VIEW [stage].[vAXHSE_HQ_PurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [stage].[vAXHSE_HQ_PurchaseLedger] AS
SELECT 

	  CONVERT(binary(32), HASHBYTES('SHA2_256', CONCAT(Company, '#', PurchaseInvoiceNum, '#', SupplierNum ))) AS PurchaseLedgerID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', SupplierNum ))) AS SupplierID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', '' ))) AS ProjectID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256', CONCAT(Company, '#', PurchaseInvoiceNum ))) AS PurchaseInvoiceID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256', CONCAT(Company, '#', '' ))) AS PurchaseOrderNumID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	  ,CONVERT([binary](32), HASHBYTES('SHA2_256', Currency)) AS CurrencyID
	  ,CONVERT(int, replace(convert(date, PurchaseInvoiceDate), '-', '')) AS PurchaseInvoiceDateID
	  ,CONCAT(Company, '#', PurchaseInvoiceNum, '#', SupplierNum ) AS PurchaseLedgerCode
	  ,CONVERT(varchar, GETDATE(), 23) AS PartitionKey

      ,[Company]
      ,[SupplierNum]
      ,[PurchaseInvoiceNum]
      ,[PurchaseInvoiceDate]
	  ,'' AS PurchaseOrderNum
      ,[PurchaseDueDate]
      ,[PurchaseLastPaymentDate]
      ,[InvoiceAmount]
      ,CAST(COALESCE(InvoiceAmountLC/NULLIF([InvoiceAmount],0),[ExchangeRate]) AS decimal(18,8)) AS  [ExchangeRate]
      ,IIF([ExchangeRate] = 1, 'SEK', [Currency]) AS [Currency]
      ,[VATAmount]
      ,[VATCode]
      ,[PayToName]
      ,[PayToCity]
      ,[PayToContact]
      ,[PaymentTerms]
      ,[PrePaymentNum]
      ,[LastPaymentNum]
      ,-1*[PaidInvoiceAmount]	AS [PaidInvoiceAmount]
      ,[AccountingDate]
      ,CASE WHEN [InvoiceAmount] + [PaidInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())< -7 THEN 'Not Due Yet'
	WHEN [InvoiceAmount] + [PaidInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE()) BETWEEN -7 AND 0 THEN 'Due in (0-7)'
	WHEN [InvoiceAmount] + [PaidInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN 1 AND 14 THEN 'Overdue (1-14)'
	WHEN [InvoiceAmount] + [PaidInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN 15 AND 30 THEN 'Overdue (15-30)'
	WHEN [InvoiceAmount] + [PaidInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN 31 AND 60 THEN 'Overdue (31-60)'
	WHEN [InvoiceAmount] + [PaidInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())> 60 THEN 'Overdue (60>)'
	WHEN [InvoiceAmount] + [PaidInvoiceAmount] = 0 THEN 'Settled'
	ELSE '' END AS [AgingPeriod]
	,CASE WHEN [InvoiceAmount] + [PaidInvoiceAmount] = 0 THEN 0
	WHEN [InvoiceAmount] + [PaidInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())<-7 THEN 1
	WHEN [InvoiceAmount] + [PaidInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN -7 AND 0 THEN 2
	WHEN [InvoiceAmount] + [PaidInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN 1 AND 14 THEN 3
	WHEN [InvoiceAmount] + [PaidInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN 15 AND 30 THEN 4
	WHEN [InvoiceAmount] + [PaidInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN 31 AND 60 THEN 5
	WHEN [InvoiceAmount] + [PaidInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())>'60' THEN 6
	ELSE 7 END AS [AgingSort]
      ,[VATCodeDesc]
      ,[InvoiceAmount] + [PaidInvoiceAmount] AS [RemainingInvoiceAmount]
--	  ,PLLink.LinkToOriginalInvoice --don't un-comment this line before you have a solution for duplication.
      ,[PLRes1]
      ,[PLRes2]
      ,[PLRes3]
  FROM [stage].[AXI_HQ_PurchaseLedger] PL
  where UPPER(pl.company) = 'AXHSE'
  --LEFT JOIN ( SELECT DISTINCT		--don't un-comment this line before you have a solution for duplication.
		--	PurchaseInvoiceNum AS PIM
		--	,LinkToOriginalInvoice 
		--	FROM [stage].[AXI_HQ_GeneralLedger]
		--	where PurchaseInvoiceNum IS NOT NULL ) AS PLLink	ON PLLink.PIM = PL.PurchaseInvoiceNum
GO
