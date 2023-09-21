IF OBJECT_ID('[prestage].[vTRA_FR_SalesLedger]') IS NOT NULL
	DROP VIEW [prestage].[vTRA_FR_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [prestage].[vTRA_FR_SalesLedger] AS

SELECT 
	CONCAT(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,Prop_0 AS [Company]
	,Prop_1 AS CustomerNum
	,Prop_2 AS SalesInvoiceNum
	,CONVERT(date, CONCAT(SUBSTRING(Prop_3, 7,4), SUBSTRING(Prop_3, 4,2), SUBSTRING(Prop_3, 1,2))) AS SalesInvoiceDate
	,CONVERT(date, CONCAT(SUBSTRING(Prop_4, 7,4), SUBSTRING(Prop_4, 4,2), SUBSTRING(Prop_4, 1,2))) AS DueDate
	,CONVERT(date, CONCAT(SUBSTRING(Prop_5, 7,4), SUBSTRING(Prop_5, 4,2), SUBSTRING(Prop_5, 1,2))) AS LastPaymentDate
	,TRY_CONVERT(decimal(18,4), Prop_6) AS InvoiceAmount
	,TRY_CONVERT(decimal(18,4), Prop_7) AS RemainingInvoiceAmount
	,TRY_CONVERT(decimal(18,4), Prop_8) AS ExchangeRate
	,Prop_9 AS Currency
	,TRY_CONVERT(decimal(18,4), Prop_10) AS VATAmount
	,Prop_11 AS VATCode
	,Prop_12 AS PayToName
	,Prop_13 AS PayToCity
	,Prop_14 AS PayToContact
	,Prop_15 AS PaymentTerms
FROM [prestage].[TRA_FR_SalesLedger]
GO
