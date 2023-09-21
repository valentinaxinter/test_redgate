IF OBJECT_ID('[dm].[DimCountry]') IS NOT NULL
	DROP VIEW [dm].[DimCountry];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm].[DimCountry] AS

select 
b.CountryName
,b.[Alpha-2 code] as Alpha_2_Code
,b.[Alpha-3 code] as Alpha_3_Code
,a.Continent
,a.Region 
,a.Region2 AS RegionSubLevel
,a.RiskLevel as AxInterRiskLevel
,a.EUMember as is_EUMember
,a.CurrencyDescription
 
,a.CurencyCode as [CurrencyCode]
,a.CurrencyDescription2
,a.CurrencyCode2
from dbo.Country as a
left join dbo.CountryCodes as b
	on a.ISOAlpha2Code = b.[Alpha-2 code]
where b.[Alpha-2 code] is not null

union

select 
COALESCE(b.CountryName,a.CountryName) as CountryName
,COALESCE(b.[Alpha-2 code],a.ISOalpha2code) as Alpha_2_Code
,COALESCE(b.[Alpha-3 code],a.ISOalpha3code) as Alpha_3_Code
,a.Continent
,a.Region
,a.Region2 AS RegionSubLevel
,a.RiskLevel as AxInterRiskLevel
,a.EUMember as is_EUMember
,a.CurrencyDescription
,a.CurencyCode as [CurrencyCode]
,a.CurrencyDescription2
,a.CurrencyCode2
from dbo.Country as a
left join dbo.CountryCodes as b
	on a.ISOAlpha2Code = b.[Alpha-2 code]
where b.[Alpha-2 code] is null

;
GO
