IF OBJECT_ID('[dm_TS].[fctGeneralLedger]') IS NOT NULL
	DROP VIEW [dm_TS].[fctGeneralLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   VIEW [dm_TS].[fctGeneralLedger] AS 
SELECT 
 gl.[GeneralLedgerID]
,gl.[AccountID]
,gl.[CustomerID]
,gl.[SupplierID]
,gl.[CompanyID]
,gl.[ProjectID]
,gl.[CostUnitID]
,gl.[CostBearerID]
,gl.[PartitionKey]
,gl.[Company]
,gl.[AccountNum]
,gl.[CostUnitNum]
,gl.[CostBearerNum]
,gl.[JournalType]
,gl.[JournalDate]
,gl.[JournalNum]
,gl.[JournalLine]
,gl.[AccountingDate]
,gl.[Description]
,gl.[Currency]
,gl.[ExchangeRate]
,gl.[InvoiceAmount]
,gl.[InvoiceAmountLC]
,gl.[CustomerNum]
,gl.[SupplierNum]
,gl.[SalesInvoiceNum]
,gl.[PurchaseInvoiceNum]
,gl.[SupplierInvoiceNum]
,gl.[LinkToOriginalInvoice]
,gl.[DeliveryCountry]
,gl.[TransactionNum]
,gl.[VATCode]
,gl.[VATCodeDesc]
,gl.[GLRes1]
,gl.[GLRes2]
,gl.[GLRes3]
  FROM [dm].[FactGeneralLedger] as gl
WHERE Company  IN ('FESFORA', 'FSEFORA', 'FFRFORA', 'FORPL', 'CERPL', 'FFRGPI', 'FFRLEX', 'IFIWIDN', 'IEEWIDN', 'TMTFI', 'TMTEE', 'FITMT', 'EETMT', 'ABKSE', 'ROROSE','STESE')
GO
