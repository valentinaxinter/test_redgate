IF OBJECT_ID('[dm].[FactPurchaseLedger]') IS NOT NULL
	DROP VIEW [dm].[FactPurchaseLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dm].[FactPurchaseLedger] AS
SELECT CONVERT(bigint, [PurchaseLedgerID]) AS PurchaseLedgerID
      ,[Company]
      ,[SupplierNum]
      ,[PurchaseOrderNum]
      ,[PurchaseInvoiceNum]
      ,[PurchaseInvoiceDate]
      ,[PurchaseDueDate]
      ,[PurchaseLastPaymentDate]
      ,[InvoiceAmount]
      ,[ExchangeRate]
      ,[Currency]
      ,[VATAmount]
      ,[VATCode]
      ,[PayToName]
      ,[PayToCity]
      ,[PayToContact]
      ,[PaymentTerms]
      ,[PrePaymentNum]
      ,[LastPaymentNum]
      ,[PLRes1]
      ,[PLRes2]
      ,[PLRes3]
      ,[PurchaseLedgerCode]
      ,CONVERT(bigint, [CompanyID]) AS CompanyID
      ,CONVERT(bigint, [SupplierID])	AS SupplierID
      ,CONVERT(bigint, [PurchaseInvoiceID])	AS PurchaseInvoiceID
      ,CONVERT(bigint, [PurchaseOrderNumID])	AS PurchaseOrderNumID
      ,CONVERT(bigint, [CurrencyID])	AS CurrencyID
      ,[PurchaseInvoiceDateID]
      ,[PartitionKey]
      ,[PaidInvoiceAmount]
	  ,[RemainingInvoiceAmount]
      ,[AccountingDate]
      ,CASE WHEN [RemainingInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())< -7 THEN 'Not Due Yet'
	WHEN [RemainingInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE()) BETWEEN -7 AND 0 THEN 'Due in (0-7)'
	WHEN [RemainingInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN 1 AND 14 THEN 'Overdue (1-14)'
	WHEN [RemainingInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN 15 AND 30 THEN 'Overdue (15-30)'
	WHEN [RemainingInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN 31 AND 60 THEN 'Overdue (31-60)'
	WHEN [RemainingInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())> 60 THEN 'Overdue (60>)'
	WHEN [RemainingInvoiceAmount] = 0 THEN 'Settled'
	ELSE '' END AS [AgingPeriod]
	,CASE WHEN [RemainingInvoiceAmount] = 0 THEN 0
	WHEN [RemainingInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())<-7 THEN 1
	WHEN [RemainingInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN -7 AND 0 THEN 2
	WHEN [RemainingInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN 1 AND 14 THEN 3
	WHEN [RemainingInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN 15 AND 30 THEN 4
	WHEN [RemainingInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())BETWEEN 31 AND 60 THEN 5
	WHEN [RemainingInvoiceAmount] <> 0 AND DATEDIFF(DAY, [PurchaseDueDate], GETDATE())>'60' THEN 6
	ELSE 7 END AS [AgingSort]
      ,[VATCodeDesc]
	  ,LinkToOriginalInvoice
  FROM [dw].[PurchaseLedger]
GO
