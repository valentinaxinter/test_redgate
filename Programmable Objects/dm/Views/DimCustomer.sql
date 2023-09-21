IF OBJECT_ID('[dm].[DimCustomer]') IS NOT NULL
	DROP VIEW [dm].[DimCustomer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [dm].[DimCustomer] AS

SELECT 
  	CONVERT(bigint, c.[CustomerID]) AS CustomerID
	,CONVERT(bigint, [CompanyID]) AS CompanyID
	,c.[Company]
	,[CustomerNum]
	,[MainCustomerName]
	,[CustomerName]
	,CONCAT(TRIM(CustomerNum), '-', TRIM(CustomerName)) AS Customer
	,[AddressLine1]
	,[AddressLine2]
	,[AddressLine3]
	,[TelephoneNum1]
	,[TelephoneNum2]
	,c.[Email]
	,[ZipCode]
	,[City]
	,[State]
	,[SalesDistrict]
	,c.[CountryCode]
	,c.[CountryName]
	,[Division]
	,[CustomerIndustry]
	,[CustomerSubIndustry]
	,[AddressLine]
	,[FullAddressLine]
	,[CustomerGroup]
	,[CustomerSubGroup]
	,[SalesPersonCode]
	,[SalesPersonName]
	,[SalesPersonResponsible]
	,[VATNum]
	,[OrganizationNum] --test column in adding column in VS
	,[AccountNum]
	,[InternalExternal]
	,[CustomerScore]
	,[CustomerType]
	,[CustomerCode]
	,CASE WHEN DATEDIFF(day, so.SalesOrderDate, GETDATE()) <= 90 THEN 'Active 0-3 Month'
		  WHEN DATEDIFF(day, so.SalesOrderDate, GETDATE()) <= 180 THEN 'Active 3-6 Month'
		  WHEN DATEDIFF(day, so.SalesOrderDate, GETDATE()) <= 365 THEN 'Active 6-12 Month' 
		  ELSE 'Passive' END AS CustomerStatus 
	,dnb.DUNS
	,dnb.confidence_code as DUNS_MatchScore
	,CRes1
	,CRes2
	,CRes3
	,c.is_inferred
	,c.is_deleted
	,case
		when cc.[Alpha-2 code] is null then 'No' else 'Yes' 
	end as is_validCountryCode
	,case when dnb.sent_date is not null and dnb.match_status is null and DATEDIFF(hh,sent_date,GETDATE()) > 16 then 'No Reference'
		  when dnb.sent_date is not null and dnb.match_status is not null and DUNS is not null then 'Success'
		  when	(dnb.sent_date is not null and dnb.match_status is not null and DUNS is null) 
				or 
				(dnb.sent_date is null and dnb.CountryCode is null)
		  then 'Needs improvement'
		  when dnb.sent_date is null and dnb.CountryCode is not null then 'Match in progress'
	end as DUNS_Status
FROM [dw].[Customer] c
/* Added to enable filtering in Power BI /SM 2021-04-21 */
LEFT JOIN (SELECT CustomerID
				, MAX(SalesOrderDate) AS SalesOrderDate 
			FROM [dw].[SalesOrder] GROUP BY CustomerID ) SO on c.CustomerID = so.CustomerID
LEFT JOIN dnb.DnBCustomerAndSupplier as dnb
	ON dnb.dw_id = c.CustomerID and dnb.is_customer = 1
--WHERE c.is_deleted != 1 AND c.is_deleted IS NOT NULL --VA
LEFT JOIN dbo.CountryCodes as cc
	on c.CountryCode = cc.[Alpha-2 code]
GO
