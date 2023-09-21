IF OBJECT_ID('[dm].[DimSupplier]') IS NOT NULL
	DROP VIEW [dm].[DimSupplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










CREATE VIEW [dm].[DimSupplier] AS

SELECT 
  	DISTINCT(CONVERT(bigint, [SupplierID])) AS SupplierID
	,CONVERT(bigint, [CompanyID]) AS CompanyID --CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(Company)))
	,s.[Company]
	,[SupplierNum]
	,[MainSupplierName]
	,[SupplierName]
	,CONCAT(TRIM(SupplierNum), '-', TRIM(SupplierName)) AS Supplier
	,[TelephoneNum]
	,s.[Email]
	,[ZipCode]
	,[City]
	,[District]
	,s.[CountryCode]
	,s.[CountryName]
	,[Region]
	,[SupplierCategory]
	,[SupplierResponsible]
	,[AddressLine]
	,[FullAddressLine]
	,[AccountNum]
	,[OrganizationNum]
	,[VATNum]
	,[InternalExternal]
	,CASE WHEN [CodeOfConduct] = '0' THEN 'No'
		  WHEN [CodeOfConduct] = '1' THEN  'Yes'
		  ELSE [CodeOfConduct] END AS CodeOfConduct
	,[CustomerNum]
	,[SupplierScore]
	,[MinOrderQty]
	,[MinOrderValue]
	,[Website]
	,s.[Comments]
	,[IsMaterialSupplier]
	,dnb.DUNS
	,dnb.confidence_code as DUNS_MatchScore
	,s.is_inferred
	,s.is_deleted
	,case
	when cc.[Alpha-2 code] is null then 'No' else 'Yes' 
	end as is_validCountryCode
	,case   when dnb.sent_date is not null and dnb.match_status is null and DATEDIFF(hh,sent_date,GETDATE()) > 16 then 'No Reference'
			when dnb.sent_date is not null and dnb.match_status is not null and DUNS is not null then 'Success'
			when	(dnb.sent_date is not null and dnb.match_status is not null and DUNS is null) 
				or 
				(dnb.sent_date is null and dnb.CountryCode is null)
			then 'Needs improvement'
			when dnb.sent_date is null and dnb.CountryCode is not null then 'Match in progress'
	end as DUNS_Status
FROM 
	[dw].[Supplier] as s
LEFT JOIN dnb.DnBCustomerAndSupplier as dnb
	ON dnb.dw_id = s.SupplierID and dnb.is_customer = 0
LEFT JOIN dbo.CountryCodes as cc
	on s.CountryCode = cc.[Alpha-2 code]
--Group by 
--	[SupplierID], [CompanyID], s.[Company], [SupplierNum], [SupplierName], [AddressLine], [TelephoneNum], s.[Email], [ZipCode], [City], [CountryName], [SupplierResponsible], [InternalExternal], [Region], [FullAddressLine], [SupplierCategory], [SupplierResponsible], [AccountNum], [VATNum], [SupplierScore],[CustomerNum], [MinOrderQty], [CodeOfConduct], [District], [MainSupplierName], [MinOrderValue], [Website], [Comments]
GO
