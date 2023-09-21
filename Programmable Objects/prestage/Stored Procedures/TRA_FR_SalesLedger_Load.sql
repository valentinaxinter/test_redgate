IF OBJECT_ID('[prestage].[TRA_FR_SalesLedger_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[TRA_FR_SalesLedger_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [prestage].[TRA_FR_SalesLedger_Load] AS
BEGIN

Truncate table stage.[TRA_FR_SalesLedger]

INSERT INTO 
	stage.TRA_FR_SalesLedger 
	(PartitionKey, Company, [CustomerNum], [SalesInvoiceNum],  [VATAmount], [Currency], [ExchangeRate], [SalesInvoiceDate], DueDate, LastPaymentDate, InvoiceAmount, RemainingInvoiceAmount, VATCode, PayToName, PayToCity, PayToContact, PaymentTerms)
SELECT 
	PartitionKey, Company, [CustomerNum],  [SalesInvoiceNum],  [VATAmount], [Currency], [ExchangeRate], SalesInvoiceDate, DueDate, LastPaymentDate, InvoiceAmount, RemainingInvoiceAmount, VATCode, PayToName, PayToCity, PayToContact, PaymentTerms
FROM 
	[prestage].[vTRA_FR_SalesLedger]

--Truncate table prestage.[TRA_FR_SalesLedger]

End
GO
