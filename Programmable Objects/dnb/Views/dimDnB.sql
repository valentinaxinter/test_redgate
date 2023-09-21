IF OBJECT_ID('[dnb].[dimDnB]') IS NOT NULL
	DROP VIEW [dnb].[dimDnB];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE view [dnb].[dimDnB]  as

select 
  concat(cast(master.[duns] as nvarchar(30)),' | ',TRIM(master.[organization.primaryName])) as Entity,									-- Entity
  cast(master.[duns] as nvarchar(30))														as Entity_DUNS,										-- Entity_DUNS
  master.[organization.primaryName]															as Entity_Name,								-- Entity_Name
  master.[organization.registeredName]														as Entity_Name_Registered,							-- Entity_Name_Registered

  master.[organization.legalForm.description] 												as LegalFormDescription,						-- LegalFormDescription
  master.[organization.registeredDetails.legalForm.description]								as LegalFormDescription_Registered,	-- LegalFormDescription_Registered
  case when LEN(TRIM(master.[organization.legalForm.startDate])) = 7 
	then cast(isnull(CONCAT(TRIM(master.[organization.legalForm.startDate]),'-01') ,'1900-01-01') as date)
	else cast(isnull(TRIM(master.[organization.legalForm.startDate]),'1900-01-01') as date)
	end																						as LegalFormStartDate,						-- LegalFormStartDate
--, master.[organization.legalForm.startDate]
  master.[organization.controlOwnershipType.description]									as ControlOwnershipDescription,			-- ControlOwnershipDescription

  case when LEN(TRIM(master.[organization.controlOwnershipDate])) = 7 
	then cast(isnull(CONCAT(TRIM(master.[organization.controlOwnershipDate]),'-01') ,'1900-01-01') as date)
	else cast(isnull(TRIM(master.[organization.controlOwnershipDate]),'1900-01-01') as date)
	end																						as ControlOwnershipDate,						-- ControlOwnershipDate
--, master.[organization.controlOwnershipDate]

  case when LEN(TRIM(financials.[organization.financials.financialStatementToDate])) = 7 
    then cast(isnull(CONCAT(TRIM(financials.[organization.financials.financialStatementToDate]),'-01') ,'1900-01-01') as date)
	else cast(isnull(TRIM(financials.[organization.financials.financialStatementToDate]),'1900-01-01') as date)
    end as FinancialStatementDate,																							-- FinancialStatementDate
  financials.[organization.financials.yearlyRevenue.currency] as FinancialCurrency,										-- FinancialCurrency
  convert(decimal(18),financials.[organization.financials.yearlyRevenue.value]) as FinancialRevenueFY,						-- FinancialRevenueFY

  --master.[organization.legalForm.registrationLocation.addressRegion]						as [legalForm.registrationLocation.addressRegion], -- THIS CAN BE EXCLUDED OR REMOVED

  master.[organization.primaryAddress.continentalRegion.name]								as Continent,		-- Continent
  master.[organization.primaryAddress.addressCountry.name]									as Country,		-- Country
  master.[organization.primaryAddress.addressRegion.name]									as State,			-- State
  master.[organization.primaryAddress.addressCounty.name]									as City,			-- City
  master.[organization.primaryAddress.addressLocality.name]									as PostalArea,		-- PostalArea
  master.[organization.primaryAddress.postalCode]											as PostalCode,					-- PostalCode
  master.[organization.primaryAddress]														as Address,							-- Address
  master.[organization.primaryAddress.latitude]												as Address_Latitude,					-- Address_Latitude
  master.[organization.primaryAddress.longitude]											as Address_Longitude,					-- Address_Longitude


  aux_2.Level_1_Description							as IndustrySegment_Level_1,					-- IndustrySegment_Level_1
  aux_2.Level_2_Description							as IndustrySegment_Level_2,					-- IndustrySegment_Level_2
  aux_2.Level_3_Description							as IndustrySegment_Level_3,					-- IndustrySegment_Level_3
  aux_2.Level_4_Description							as IndustrySegment_Level_4,					-- IndustrySegment_Level_4
  aux_2.Level_5_Description							as IndustrySegment_Level_5,					-- IndustrySegment_Level_5
  aux_1.[organization.industryCodes.code]			as IndustryCode,							-- IndustryCode
 
  --unspsc.[organization.unspscCodes.code]			as unspscCode,								-- THIS CAN BE EXCLUDED 
  --unspscHierarchy.Level_1_Description				as unspsc_Level_1,							-- THIS CAN BE EXCLUDED 
  --unspscHierarchy.Level_2_Description				as unspsc_Level_2,							-- THIS CAN BE EXCLUDED 
  --unspscHierarchy.Level_3_Description				as unspsc_Level_3,							-- THIS CAN BE EXCLUDED 
  --unspscHierarchy.Level_4_Description				as unspsc_Level_4,							-- THIS CAN BE EXCLUDED 

  

-- Special case to determine internal companies (SHOULD BE REMOVED AND THEN USE THE LEGAL COMPANY LIST OF OUR COMPANIES THAT IS JOINED IN AS INTERNAL)
 -- case when master.[organization.corporateLinkage.globalUltimate.duns] IN (416370278, 291803745, 260980537, 310094669) 
	--		  and [organization.corporateLinkage.parent.primaryName] IN ('Dagab Inköp & Logistik AB',
	--																	 'Axfood AB',
	--																	 'Novax Gym Holding AB',
	--																	 'Martin & Servera Logistik AB',
	--																	 'Datema AB') 
	--		  then  0
	--   when master.[organization.corporateLinkage.globalUltimate.duns] IN (416370278, 291803745, 260980537, 310094669) 
	--		  and [organization.primaryName] IN ('Martin & Servera AB') 
	--		  then  0	
	--   when master.[organization.corporateLinkage.globalUltimate.duns] IN (416370278, 291803745, 260980537, 310094669) 
	--		  then 1
	--else 0
 --  end as is_internal,
   CASE WHEN internal_companies.DUNS IS NULL THEN 0 ELSE 1 end as is_AxInterInternal,

  cast(master.[organization.corporateLinkage.globalUltimate.duns]	AS nvarchar(30))		as GlobalOwner_DUNS,				-- GlobalOwner_DUNS
  master.[organization.corporateLinkage.globalUltimate.primaryName] 						as GlobalOwner_Name,		-- GlobalOwner_Name
  cast(master.[organization.corporateLinkage.domesticUltimate.duns] AS nvarchar(30))		as DomesticOwner_DUNS,				-- DomesticOwner_DUNS
  master.[organization.corporateLinkage.domesticUltimate.primaryName] 						as DomesticOwner_Name,		-- DomesticOwner_Name

  cast(master.[organization.corporateLinkage.parent.duns] 		AS nvarchar(30))			as ParentEntity_DUNS,						-- ParentEntity_DUNS
  master.[organization.corporateLinkage.parent.primaryName] 								as ParentEntity_Name,				-- ParentEntity_Name
  cast(master.[organization.corporateLinkage.headQuarter.duns] AS nvarchar(30))				as Headquarter_DUNS,					-- Headquarter_DUNS
  master.[organization.corporateLinkage.headQuarter.primaryName]							as Headquarter_Name,			-- Headquarter_Name

  master.[organization.corporateLinkage.role] as CorporateHierarchyRole,															-- CorporateHierarchyRole
  try_CAST([organization.corporateLinkage.hierarchyLevel] as decimal(4,0)) as CorporateHierarchyLevel,					-- CorporateHierarchyLevel
  case when HoldingCompanies.duns IS not null then 1
	else 0
    end as is_HoldingCompany,																										-- is_HoldingCompany

  master.[organization.isStandalone] as is_Standalone																				-- is_Standalone
, cast(employees.[organization.numberOfEmployees.value] as int) as NumberOfEmployees
, case when master.[organization.dunsControlStatus.operatingStatus.description] IS NULL then 'Missing Status' 
	else [organization.dunsControlStatus.operatingStatus.description]
	end as OperatingStatus

from dnb.MasterTable as master

LEFT JOIN (
	select 
	duns,
	[organization.industryCodes.code]
	from dnb.IndustryCodes
	where [organization.industryCodes.typeDnBCode] is not null
	and [organization.industryCodes.typeDnBCode] = '3599'
	and [organization.industryCodes.priority] = '1'
) AS aux_1 
	on master.duns = aux_1.duns
LEFT JOIN dnb.dimIndustryCode_3599_Hierarchy AS aux_2
	on aux_1.[organization.industryCodes.code] = aux_2.Level_5_Code
LEFT JOIN dnb.UnspscCodes as unspsc
	on master.duns = unspsc.duns
	and cast(unspsc.[organization.unspscCodes.priority] as int) = 1
left join dnb.dimUnspscHierarchy as unspscHierarchy
	on unspsc.[organization.unspscCodes.code] = unspscHierarchy.Level_4_Code
left join dnb.Financials as financials
	on master.duns = financials.duns
	and financials.[organization.financials.yearlyRevenue.currency] = 'USD'
LEFT JOIN (
	select distinct duns
	from dnb.IndustryCodes
	where [organization.industryCodes.code] = '67120000' 
	or [organization.industryCodes.code] = '67190000'
) as HoldingCompanies
	on master.duns = HoldingCompanies.duns
LEFT JOIN (select distinct DUNS
from dnb.InternalExcelCompanies
where DUNS is not null)
as internal_companies
	on internal_companies.DUNS = master.duns
LEFT JOIN (
select 
  duns
, ROW_NUMBER() over (partition by duns order by [organization.numberOfEmployees.informationScopeDescription] desc) as rn
--, [organization.numberOfEmployees.informationScopeDescription]
, [organization.numberOfEmployees.value]
from dnb.numberOfEmployees
) as employees
	on master.duns = employees.duns and employees.rn = 1
--where internal_companies.DUNS is not null
;
GO
