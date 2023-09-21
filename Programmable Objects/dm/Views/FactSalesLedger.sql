IF OBJECT_ID('[dm].[FactSalesLedger]') IS NOT NULL
	DROP VIEW [dm].[FactSalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm].[FactSalesLedger] AS

SELECT 
	  CONVERT(bigint, [SalesLedgerID]) AS [SalesLedgerID]
	  ,CONVERT(BIGINT,HASHBYTES('SHA2_256',CONCAT(Company,'#',NULLIF(TRIM(SalesPersonName),'')))) AS SalesPersonNameID
      ,[Company]
      ,[CustomerNum]
      ,[SalesInvoiceNum]
      ,[SalesInvoiceDate]
      ,[SalesDueDate]
      ,[SalesLastPaymentDate]
      ,[InvoiceAmount]
      ,[RemainingInvoiceAmount]
      ,[ExchangeRate]
      ,[Currency]
      ,[VATAmount]
      ,[VATCode]
      ,[PayToName]
      ,[PayToCity]
      ,[PayToContact]
      ,[PaymentTerms]
      ,[SLRes1]
      ,[SLRes2]
      ,[SLRes3]
      ,[SalesLedgerCode]
      ,CONVERT(bigint,[CompanyID]) AS CompanyID
      ,[PartitionKey]
      ,[PaidInvoiceAmount]
      ,[AccountingDate]
      ,CASE WHEN ABS([RemainingInvoiceAmount]) > 0.1 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())<-7 THEN 'Not Due Yet'
		WHEN     ABS([RemainingInvoiceAmount]) > 0.1 AND DATEDIFF(DAY, [SalesDueDate], GETDATE()) BETWEEN -7 AND 0 THEN 'Due in (0-7)'
		WHEN     ABS([RemainingInvoiceAmount]) > 0.1 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())BETWEEN 1 AND 14 THEN 'Overdue (1-14)'
		WHEN     ABS([RemainingInvoiceAmount]) > 0.1 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())BETWEEN 15 AND 30 THEN 'Overdue (15-30)'
		WHEN     ABS([RemainingInvoiceAmount]) > 0.1 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())BETWEEN 31 AND 60 THEN 'Overdue (31-60)'
		WHEN     ABS([RemainingInvoiceAmount]) > 0.1 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())> 60 THEN 'Overdue (60>)'
		WHEN     ABS([RemainingInvoiceAmount]) <=  0.1 THEN 'Settled'
		ELSE NULL END AS [AgingPeriod]
	,CASE WHEN   ABS([RemainingInvoiceAmount]) > 0.1 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())<-7 THEN 0
		WHEN     ABS([RemainingInvoiceAmount]) > 0.1 AND DATEDIFF(DAY, [SalesDueDate], GETDATE()) BETWEEN -7 AND 0 THEN 1
		WHEN     ABS([RemainingInvoiceAmount]) > 0.1 AND DATEDIFF(DAY, [SalesDueDate], GETDATE()) BETWEEN 1 AND 14 THEN 2
		WHEN     ABS([RemainingInvoiceAmount]) > 0.1 AND DATEDIFF(DAY, [SalesDueDate], GETDATE()) BETWEEN 15 AND 30 THEN 3
		WHEN     ABS([RemainingInvoiceAmount]) > 0.1 AND DATEDIFF(DAY, [SalesDueDate], GETDATE()) BETWEEN 31 AND 60 THEN 4
		WHEN     ABS([RemainingInvoiceAmount]) > 0.1 AND DATEDIFF(DAY, [SalesDueDate], GETDATE())>60 THEN 5
		WHEN     ABS([RemainingInvoiceAmount]) <=  0.1 THEN 6
		ELSE NULL END AS [AgingSort]
      ,[VATCodeDesc]
      ,CONVERT(bigint,[CustomerID])	AS CustomerID
	  ,LinkToOriginalInvoice
	  ,COALESCE(YEAR([SalesInvoiceDate])*10000 + MONTH([SalesInvoiceDate])*100 + DAY([SalesInvoiceDate]), 19000101) AS SalesInvoiceDateID
	  ,CASE   
		WHEN ABS([RemainingInvoiceAmount]) <= 0.1
			THEN 'Paid'
        WHEN SalesLastPaymentDate <= '1900-01-01'
            OR SalesLastPaymentDate IS NULL
            OR SalesLastPaymentDate = ''
            THEN 'Not Paid'
        WHEN ABS([RemainingInvoiceAmount]) > 0.1
            THEN 'Partially Paid'
       ELSE 'check out!'
       END AS PaymentStatus
	   ,CONVERT(bigint, WarehouseID) AS WarehouseID
  FROM [dw].[SalesLedger]
GO
