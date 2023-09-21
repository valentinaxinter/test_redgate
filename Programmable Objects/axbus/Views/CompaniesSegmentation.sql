IF OBJECT_ID('[axbus].[CompaniesSegmentation]') IS NOT NULL
	DROP VIEW [axbus].[CompaniesSegmentation];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [axbus].[CompaniesSegmentation]
	AS 
	
with baseline as (
select Company,CustomerNum as ERP_Num,CustomerID as dw_id, 1 as is_customer 
from dw.Customer

union

select Company,SupplierNum as ERP_Num,SupplierID as dw_id, 0 as is_customer
from dw.Supplier
)
select b.Company, b.ERP_Num, b.is_customer, dnb.DUNS,
  ic.[organization.industryCodes.code]					as IndustryCode,							-- IndustryCode
  indSeg.Level_1_Description							as IndustrySegment_Level_1,					-- IndustrySegment_Level_1
  indSeg.Level_2_Description							as IndustrySegment_Level_2,					-- IndustrySegment_Level_2
  indSeg.Level_3_Description							as IndustrySegment_Level_3,					-- IndustrySegment_Level_3
  indSeg.Level_4_Description							as IndustrySegment_Level_4,					-- IndustrySegment_Level_4
  indSeg.Level_5_Description							as IndustrySegment_Level_5					-- IndustrySegment_Level_5
  
from baseline as b
left join dnb.DnBCustomerAndSupplier as dnb
	on b.Company = dnb.Company
	and b.dw_id = dnb.dw_id
	and b.is_customer = dnb.is_customer
inner join dnb.MasterTable as m
	on dnb.DUNS = m.duns
LEFT JOIN (
	select 
	duns,
	[organization.industryCodes.code]
	from dnb.IndustryCodes
	where [organization.industryCodes.typeDnBCode] is not null
	and [organization.industryCodes.typeDnBCode] = '3599'
	and [organization.industryCodes.priority] = '1'
) AS ic 
LEFT JOIN dnb.dimIndustryCode_3599_Hierarchy AS indSeg
	on ic.[organization.industryCodes.code] = indSeg.Level_5_Code
	on m.duns = ic.duns
where dnb.DUNS is not null
--order by 1
;
GO
