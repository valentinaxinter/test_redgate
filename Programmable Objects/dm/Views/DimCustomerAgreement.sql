IF OBJECT_ID('[dm].[DimCustomerAgreement]') IS NOT NULL
	DROP VIEW [dm].[DimCustomerAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm].[DimCustomerAgreement] AS

----------------------------------- Customer Agreements File --------------------------------------
With DimCustomerAgreement AS 
(SELECT 
--	[StockControlID]
    CONVERT(bigint, [CompanyID]) AS CompanyID
    ,CONVERT(bigint, [CustomerID]) AS CustomerID
    ,CONVERT(bigint, [PartID]) AS PartID
	,CONVERT(bigint, [CurrencyID]) AS CurrencyID
	,Company
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
FROM 
	[dw].[CustomerAgreement]
),
------------------------------------------- Retrieveing latest Exchangerate for each Currency --------------------------------------------
-- All distinct rates per company and date
ExchangeRateTable as
(select distinct 
	Company,
	Currency, 
	ExchangeRate, 
	PurchaseInvoiceDate
from dm.FactPurchaseInvoice
group by Company, Currency, ExchangeRate, PurchaseInvoiceDate),

-- All currencies and there latest appearence
LatestCurrencyTable as
(select distinct 
	Company,
	Currency,  
	MAX(PurchaseInvoiceDate) as "InvoiceDate"
from dm.FactPurchaseInvoice
group by Company, Currency),

-- Mapping the exchangerates on the latest appearence
LatestCurrencyRateTable as
(Select 
	
	LatestCurrencyTable.Company, LatestCurrencyTable.Currency, LatestCurrencyTable.InvoiceDate, ExchangeRate
from LatestCurrencyTable 
	Right Outer Join ExchangeRateTable 
		on LatestCurrencyTable.Company = ExchangeRateTable.Company 
		and LatestCurrencyTable.Currency = ExchangeRateTable.Currency
		and LatestCurrencyTable.InvoiceDate = ExchangeRateTable.PurchaseInvoiceDate) select 
		DimCustomerAgreement.AgreementCode
		,DimCustomerAgreement.AgreementDescription
		,DimCustomerAgreement.AgreementEnd
		,DimCustomerAgreement.AgreementQty
		,DimCustomerAgreement.AgreementStart
		,DimCustomerAgreement.Company
		,DimCustomerAgreement.CompanyID
		,DimCustomerAgreement.Currency
		,DimCustomerAgreement.CurrencyID
		,DimCustomerAgreement.CustomerID
		,DimCustomerAgreement.CustomerNum
		,DimCustomerAgreement.CustomerTerms
		,DimCustomerAgreement.DelivTime
		,DimCustomerAgreement.DiscountPercent
		,DimCustomerAgreement.FulfilledQty
		,DimCustomerAgreement.PartID
		,DimCustomerAgreement.PartitionKey
		,DimCustomerAgreement.PartNum
		,DimCustomerAgreement.RemainingQty
		,DimCustomerAgreement.UnitPrice
		,DimCustomerAgreement.UoM
		
		, AVG(ExchangeRate) as ExchangeRate from DimCustomerAgreement
		Left Join LatestCurrencyRateTable 
		on LatestCurrencyRateTable.Company = DimCustomerAgreement.Company 
		and LatestCurrencyRateTable.Currency = DimCustomerAgreement.Currency
		GROUP BY CompanyID, CustomerID, PartID, CurrencyID, DimCustomerAgreement.Company, [CustomerNum], [PartNum], [AgreementCode], [AgreementDescription], [DiscountPercent], [UnitPrice], [AgreementQty], DimCustomerAgreement.[Currency], [DelivTime], [AgreementStart], [AgreementEnd], [CustomerTerms], [FulfilledQty], [RemainingQty], [UoM], [PartitionKey]
GO
