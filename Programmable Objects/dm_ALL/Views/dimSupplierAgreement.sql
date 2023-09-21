IF OBJECT_ID('[dm_ALL].[dimSupplierAgreement]') IS NOT NULL
	DROP VIEW [dm_ALL].[dimSupplierAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_ALL].[dimSupplierAgreement] AS

SELECT 
 [CompanyID]
,[SupplierID]
,[PartID]
,[CurrencyID]
,[Company]
,[PartNum]
,[SupplierNum]
,[DiscountPercent]
,[UnitPrice]
,[AgreementQty]
,[AgreementCode]
,[AgreementDescription]
,[AgreementStart]
,[AgreementEnd]
,[SupplierTerms]
,[FulfilledQty]
,[RemainingQty]
,[UoM]
,[Currency]
,[DelivTime]
,[PartitionKey]
,[ExchangeRate]
FROM [dm].[DimSupplierAgreement]
GO
