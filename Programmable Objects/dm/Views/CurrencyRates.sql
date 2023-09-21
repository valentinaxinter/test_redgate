IF OBJECT_ID('[dm].[CurrencyRates]') IS NOT NULL
	DROP VIEW [dm].[CurrencyRates];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dm].[CurrencyRates] AS

WITH distinctEUR AS
(
SELECT distinct [period]
      , [currency_code]
      , CONVERT(decimal(18,4), [currency_rate]) AS currency_rate_EUR
FROM [dw].[CurrencyRates]
WHERE currency_code = 'EUR'

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
	, CONVERT(decimal(18,4)
	, AllCurrencies.currency_rate/distinctEUR.currency_rate_EUR) AS currency_rate_eur 
FROM AllCurrencies 
	right outer join distinctEUR on AllCurrencies.[period] = distinctEUR.[period]
)

SELECT 
period
,actuality
,currency_code
,currency_type
,unit
,currency_rate
,currency_rate_eur
FROM EURperRow
where [period] != '2309'
GROUP BY [period], [currency_code], [currency_rate], actuality, currency_type, unit, currency_rate_eur -- added because of the source gives duplication each code, not know why yet, shall investigate
GO
