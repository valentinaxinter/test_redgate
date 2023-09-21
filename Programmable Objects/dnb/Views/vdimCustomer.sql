IF OBJECT_ID('[dnb].[vdimCustomer]') IS NOT NULL
	DROP VIEW [dnb].[vdimCustomer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [dnb].[vdimCustomer] as
select 
  convert(bigint,customer.CustomerID) as CustomerID
, customer.AccountNum
, customer.AddressLine
, customer.AddressLine1
, customer.AddressLine2
, customer.AddressLine3
, customer.City
, customer.Company
, customer.CompanyID
, customer.CountryCode
, customer.CountryName
, customer.CustomerCode
, customer.CustomerGroup
, customer.CustomerIndustry
, customer.CustomerName
, customer.CustomerNum
, customer.CustomerScore
, customer.CustomerSubGroup
, customer.CustomerSubIndustry
, customer.CustomerType
, customer.Division
, customer.Email
, customer.FullAddressLine
, customer.InternalExternal
, customer.MainCustomerName
, customer.OrganizationNum
, customer.PartitionKey
, customer.SalesDistrict
, customer.SalesPersonCode
, customer.SalesPersonName
, customer.SalesPersonResponsible
, customer.State
, customer.TelephoneNum1
, customer.TelephoneNum2
, customer.VATNum
, customer.ZipCode
,cast(dnb.DUNS as nvarchar(30)) as DUNS
,dnb.confidence_code as ConfidenceCode
from dw.Customer as customer
INNER JOIN dnb.DnBCustomerAndSupplier as dnb
	on customer.CustomerID = dnb.dw_id
		and is_customer = 1;
GO
