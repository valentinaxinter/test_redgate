IF OBJECT_ID('[dm].[CurrencyRates_plusUSD]') IS NOT NULL
	DROP VIEW [dm].[CurrencyRates_plusUSD];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm].[CurrencyRates_plusUSD] AS

WITH distinctEUR AS
(
SELECT distinct [period]
      , [currency_code]
      , CONVERT(decimal(18,4), [currency_rate]) AS currency_rate_EUR
FROM [dw].[CurrencyRates]
WHERE currency_code = 'EUR'

),

distinctUSD AS
(
SELECT distinct [period]
      , [currency_code]
      , CONVERT(decimal(18,4), [currency_rate]) AS currency_rate_USD
FROM [dw].[CurrencyRates]
WHERE currency_code = 'USD'

),

AllCurrencies AS 
(
SELECT 
 period
,actuality
,currency_code
,currency_type
,unit
,currency_rate
FROM [dw].[CurrencyRates]),

EURperRow AS
(
SELECT 
	 AllCurrencies.period
	,AllCurrencies.actuality
	,AllCurrencies.currency_code
	,AllCurrencies.currency_type
	,AllCurrencies.unit
	,AllCurrencies.currency_rate
	, CONVERT(decimal(18,4), AllCurrencies.currency_rate/distinctEUR.currency_rate_EUR) AS currency_rate_eur 
	, CONVERT(decimal(18,4), AllCurrencies.currency_rate/distinctUSD.currency_rate_USD) AS currency_rate_USD 
FROM AllCurrencies 
	right outer join distinctEUR on AllCurrencies.[period] = distinctEUR.[period]
	right outer join distinctUSD on AllCurrencies.[period] = distinctUSD.[period]
)

SELECT 
period
,actuality
,currency_code
,unit
,currency_rate
,currency_rate_eur
,currency_rate_USD
FROM EURperRow
where [period] != '2309' -- temporarily, not know why there is a such 2309, shall investigate
GROUP BY [period], [currency_code], [currency_rate], actuality, currency_type, unit, currency_rate_eur, currency_rate_USD -- added because of the source gives duplication each code, not know why yet, shall investigate
GO
