IF OBJECT_ID('[stage].[vAXI_HQ_GeneralLedger]') IS NOT NULL
	DROP VIEW [stage].[vAXI_HQ_GeneralLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [stage].[vAXI_HQ_GeneralLedger] AS
SELECT 
		CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', [TransactionNum], '#', JournalNum,'#', JournalLine,'#', JournalType ))) AS GeneralLedgerID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', AccountNum ))) AS AccountID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', RIGHT('000000' + CostUnitNum,6) ))) AS CostUnitID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', CostBearerNum ))) AS CostBearerID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', [SupplierNum] ))) AS SupplierID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', [CustomerNum] ))) AS CustomerID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', '' ))) AS ProjectID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	  ,CONVERT(varchar, GETDATE(), 23) AS PartitionKey

      ,[Company]
      ,[AccountNum]
      ,RIGHT('000000' + CostUnitNum,6)	AS [CostUnitNum]
      ,[CostBearerNum]
      ,[JournalType]
      ,[JournalDate]
      ,[JournalNum]
      ,[JournalLine]
      ,[AccountingDate]
      ,[Description]
      ,IIF([ExchangeRate] = 1, 'SEK', [Currency]) AS [Currency]
      ,[ExchangeRate]
      ,[InvoiceAmount]
	  ,[InvoiceAmountLC]
      ,[CustomerNum]
      ,[SupplierNum]
      ,[SalesInvoiceNum]
      ,[PurchaseInvoiceNum]
      ,[SupplierInvoiceNum]
      ,[LinkToOriginalInvoice]
      ,[DeliveryCountry]
      ,[TransactionNum]
      ,[VATCode]
      ,[VATCodeDesc]
      ,[GLRes1]
      ,[GLRes2]
      ,[GLRes3]
  FROM [stage].[AXI_HQ_GeneralLedger]
  where UPPER(Company) = 'AXISE'

 
  union 

  select 
     CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', [TransactionNum], '#', JournalNum,'#', JournalLine,'#', JournalType ))) AS GeneralLedgerID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', AccountNum ))) AS AccountID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', RIGHT('000000' + CostUnitNum,6) ))) AS CostUnitID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', CostBearerNum ))) AS CostBearerID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', [SupplierNum] ))) AS SupplierID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', [CustomerNum] ))) AS CustomerID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', '' ))) AS ProjectID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	  ,CONVERT(varchar, GETDATE(), 23) AS PartitionKey
      ,[Company]
      ,[AccountNum]
      ,RIGHT('000000' + CostUnitNum,6)	AS [CostUnitNum]
      ,[CostBearerNum]
      ,[JournalType]
      ,[JournalDate]
      ,[JournalNum]
      ,[JournalLine]
      ,[AccountingDate]
      ,[Description]
      ,IIF([ExchangeRate] = 1, 'SEK', [Currency]) AS [Currency]
      ,[ExchangeRate]
      ,[InvoiceAmount]
	  ,[InvoiceAmountLC]
      ,[CustomerNum]
      ,[SupplierNum]
      ,[SalesInvoiceNum]
      ,[PurchaseInvoiceNum]
      ,[SupplierInvoiceNum]
      ,[LinkToOriginalInvoice]
      ,[DeliveryCountry]
      ,[TransactionNum]
      ,[VATCode]
      ,[VATCodeDesc]
      ,[GLRes1]
      ,[GLRes2]
      ,[GLRes3]

from [stage].[AXI_HQ_GeneralLedger_Sharepoint]
GO
