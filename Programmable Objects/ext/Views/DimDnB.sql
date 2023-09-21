IF OBJECT_ID('[ext].[DimDnB]') IS NOT NULL
	DROP VIEW [ext].[DimDnB];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ext].[DimDnB] AS

SELECT 
 Entity
,Entity_DUNS
,Entity_Name
,Entity_Name_Registered
,LegalFormDescription
,LegalFormDescription_Registered
,LegalFormStartDate
,ControlOwnershipDescription
,ControlOwnershipDate
,FinancialStatementDate
,FinancialCurrency
,FinancialRevenueFY
,Continent
,Country
,State
,City
,PostalArea
,PostalCode
,Address
,Address_Latitude
,Address_Longitude
,IndustrySegment_Level_1
,IndustrySegment_Level_2
,IndustrySegment_Level_3
,IndustrySegment_Level_4
,IndustrySegment_Level_5
,IndustryCode
,is_AxInterInternal
,GlobalOwner_DUNS
,GlobalOwner_Name
,DomesticOwner_DUNS
,DomesticOwner_Name
,ParentEntity_DUNS
,ParentEntity_Name
,Headquarter_DUNS
,Headquarter_Name
,CorporateHierarchyRole
,CorporateHierarchyLevel
,is_HoldingCompany
,is_Standalone
,OperatingStatus
,NumberOfEmployees
FROM dnb.dimDnB
GO
