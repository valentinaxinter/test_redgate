IF OBJECT_ID('[dm].[DimSupplierAgreement]') IS NOT NULL
	DROP VIEW [dm].[DimSupplierAgreement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dm].[DimSupplierAgreement] AS

----------------------------------- Supplier Agreements File --------------------------------------

With DimSupplierAgreement AS 
(SELECT 
--	[StockControlID]
    CONVERT(bigint, [CompanyID]) AS CompanyID
    ,CONVERT(bigint, [SupplierID]) AS SupplierID
    ,CONVERT(bigint, [PartID]) AS PartID
	,CONVERT(bigint, [CurrencyID]) AS CurrencyID
	,Company
    ,[PartNum]
	,[SupplierNum]
    ,[DiscountPercent]
    ,[UnitPrice]
	,[AgreementQty]
	,[AgreementCode]
	,[AgreementDescription]
	,[AgreementStart]
	,[AgreementEnd]
	,SupplierTerms
	,FulfilledQty
	,RemainingQty
	,UoM
	,[Currency]
	,[DelivTime]
	,[PartitionKey]
FROM 
	[dw].[SupplierAgreement]
),
------------------------------------------- Retrieveing latest Exchangerate for each Currency --------------------------------------------

-- All distinct rates per company and date
ExchangeRateTable AS
(select distinct 
	Company,
	Currency, 
	ExchangeRate, 
	PurchaseInvoiceDate
from dm.FactPurchaseInvoice
group by Company, Currency, ExchangeRate, PurchaseInvoiceDate),

-- All currencies and there latest appearence
LatestCurrencyTable AS
(select distinct 
	Company,
	Currency,  
	MAX(PurchaseInvoiceDate) AS "PurchaseInvoiceDate"
from dm.FactPurchaseInvoice
group by Company, Currency),

-- Mapping the exchangerates on the latest appearence
LatestCurrencyRateTable AS
(Select 
	LatestCurrencyTable.*,
	ExchangeRate
from LatestCurrencyTable 
	Right Outer Join ExchangeRateTable 
	on LatestCurrencyTable.Company = ExchangeRateTable.Company 
	and LatestCurrencyTable.Currency = ExchangeRateTable.Currency
	and LatestCurrencyTable.PurchaseInvoiceDate = ExchangeRateTable.PurchaseInvoiceDate)


------------------------------------ Specifing the view ---------------------------------------------
SELECT 
	DimSupplierAgreement.*
	,ExchangeRate as ExchangeRate
FROM DimSupplierAgreement
	Left Join LatestCurrencyRateTable 
		on LatestCurrencyRateTable.Company = DimSupplierAgreement.Company 
		and LatestCurrencyRateTable.Currency = DimSupplierAgreement.Currency
GO
