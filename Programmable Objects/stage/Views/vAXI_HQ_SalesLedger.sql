IF OBJECT_ID('[stage].[vAXI_HQ_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vAXI_HQ_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[vAXI_HQ_SalesLedger] AS 
SELECT 
	  CONVERT(binary(32), HASHBYTES('SHA2_256', CONCAT(Company, '#', SalesInvoiceNum, '#', CustomerNum ))) AS SalesLedgerID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', CustomerNum ))) AS CustomerID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', '' ))) AS ProjectID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256', CONCAT(Company, '#', SalesInvoiceNum ))) AS SalesInvoiceID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256', CONCAT(Company, '#', '' ))) AS SalesOrderNumID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	  ,CONVERT([binary](32), HASHBYTES('SHA2_256', Currency)) AS CurrencyID
	  ,CONVERT(int, replace(convert(date, SalesInvoiceDate), '-', '')) AS SalesInvoiceDateID
	  ,CONCAT(Company, '#', SalesInvoiceNum, '#', CustomerNum ) AS SalesLedgerCode
	  ,CONVERT(varchar, GETDATE(), 23) AS PartitionKey

	  ,[Company]
      ,[CustomerNum]
      ,[SalesInvoiceNum]
      ,[SalesInvoiceDate]
      ,[SalesDueDate]
      ,[SalesLastPaymentDate]
      ,[InvoiceAmount]
      ,[PaidInvoiceAmount]
      ,[RemainingInvoiceAmount]
      ,CAST(COALESCE(InvoiceAmountLC/NULLIF([InvoiceAmount],0),[ExchangeRate]) AS decimal(18,8)) AS  [ExchangeRate]
      ,[Currency]
      ,[VATAmount]
      ,[VATCode]
      ,[VATCodeDesc]
      ,[PayToName]
      ,[PayToCity]
      ,[PayToContact]
      ,[PaymentTerms]
      ,[SLRes1]
      ,[SLRes2]
      ,[SLRes3]
      ,[AccountingDate]
--      ,[AgingPeriod]
--	  ,NULL AS AgingSort
	  	,CASE WHEN [RemainingInvoiceAmount] <>0 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())<-7 THEN 'Not Due Yet'
		WHEN [RemainingInvoiceAmount] <>0 AND DATEDIFF(DAY, [SalesDueDate], GETDATE()) BETWEEN -7 AND 0 THEN 'Due in (0-7)'
		WHEN [RemainingInvoiceAmount] <>0 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())BETWEEN 1 AND 14 THEN 'Overdue (1-14)'
		WHEN [RemainingInvoiceAmount] <>0 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())BETWEEN 15 AND 30 THEN 'Overdue (15-30)'
		WHEN [RemainingInvoiceAmount] <>0 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())BETWEEN 31 AND 60 THEN 'Overdue (31-60)'
		WHEN [RemainingInvoiceAmount] <>0 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())> 60 THEN 'Overdue (60>)'
		WHEN [RemainingInvoiceAmount] =0 THEN 'Settled'
		ELSE '' END AS [AgingPeriod]
	,CASE WHEN [RemainingInvoiceAmount] <>0 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())<-7 THEN 0
		WHEN [RemainingInvoiceAmount] <>0 AND DATEDIFF(DAY, [SalesDueDate], GETDATE()) BETWEEN -7 AND 0 THEN 1
		WHEN [RemainingInvoiceAmount] <>0 AND DATEDIFF(DAY, [SalesDueDate], GETDATE()) BETWEEN 1 AND 14 THEN 2
		WHEN [RemainingInvoiceAmount] <>0 AND DATEDIFF(DAY, [SalesDueDate], GETDATE()) BETWEEN 15 AND 30 THEN 3
		WHEN [RemainingInvoiceAmount] <>0 AND DATEDIFF(DAY, [SalesDueDate], GETDATE()) BETWEEN 31 AND 60 THEN 4
		WHEN [RemainingInvoiceAmount] <>0 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())>60 THEN 5
		WHEN [RemainingInvoiceAmount] =0 THEN 6
		ELSE '' END AS [AgingSort]
--	  ,SLLink.LinkToOriginalInvoice
  FROM [stage].[AXI_HQ_SalesLedger] AS SL
  where upper(SL.Company) = 'AXISE'
   -- LEFT JOIN ( SELECT DISTINCT 
			--SalesInvoiceNum AS SIM
			--,LinkToOriginalInvoice 
			--FROM [stage].[AXI_HQ_GeneralLedger]
			--where SalesInvoiceNum IS NOT NULL ) AS SLLink	ON SLLink.SIM = SL.SalesInvoiceNum
GO
