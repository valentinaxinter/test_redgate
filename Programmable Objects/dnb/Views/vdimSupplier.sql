IF OBJECT_ID('[dnb].[vdimSupplier]') IS NOT NULL
	DROP VIEW [dnb].[vdimSupplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [dnb].[vdimSupplier] as
select 
  convert(bigint,supplier.SupplierID) as SupplierID
, supplier.AccountNum
, supplier.AddressLine
, supplier.AddressLine1
, supplier.AddressLine2
, supplier.AddressLine3
, supplier.City
, supplier.CodeOfConduct
, supplier.Comments
, supplier.Company
, supplier.CompanyID
, supplier.CountryCode
, supplier.CountryName
, supplier.CustomerNum
, supplier.District
, supplier.Email
, supplier.FullAddressLine
, supplier.InternalExternal
, supplier.IsActiveRecord
, supplier.IsBusinessGroupInternal
, supplier.IsCompanyGroupInternal
, supplier.MainSupplierName
, supplier.MinOrderQty
, supplier.MinOrderValue
, supplier.OrganizationNum
, supplier.PartitionKey
, supplier.PurchaserPersonCode
, supplier.PurchaserPersonName
, supplier.Region
, supplier.SRes1
, supplier.SRes2
, supplier.SRes3
, supplier.State
, supplier.SupplierCategory
, supplier.SupplierCode
, supplier.SupplierGroup
, supplier.SupplierIndustry
, supplier.SupplierName
, supplier.SupplierNum
, supplier.SupplierResponsible
, supplier.SupplierScore
, supplier.SupplierStatus
, supplier.SupplierSubGroup
, supplier.SupplierSubIndustry
, supplier.TelephoneNum
, supplier.VATNum
, supplier.Website
, supplier.ZipCode
, cast(dnb.DUNS as nvarchar(30)) as DUNS
,dnb.confidence_code as ConfidenceCode
from dw.Supplier as supplier
INNER JOIN dnb.DnBCustomerAndSupplier as dnb
	on supplier.SupplierID = dnb.dw_id
		and is_customer = 0;
GO
