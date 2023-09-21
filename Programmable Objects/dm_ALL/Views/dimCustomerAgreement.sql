IF OBJECT_ID('[dm_ALL].[dimCustomerAgreement]') IS NOT NULL
	DROP VIEW [dm_ALL].[dimCustomerAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_ALL].[dimCustomerAgreement] AS
SELECT [CompanyID]
,[CustomerID]
,[PartID]
,[CurrencyID]
,[Company]
,[CustomerNum]
,[PartNum]
,[AgreementCode]
,[AgreementDescription]
,[DiscountPercent]
,[UnitPrice]
,[AgreementQty]
,[Currency]
,[DelivTime]
,[AgreementStart]
,[AgreementEnd]
,[CustomerTerms]
,[FulfilledQty]
,[RemainingQty]
,[UoM]
,[PartitionKey]
,[ExchangeRate]
FROM [dm].[DimCustomerAgreement]
GO
