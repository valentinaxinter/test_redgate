IF OBJECT_ID('[audit].[TableCoverageLog]') IS NOT NULL
	DROP PROCEDURE [audit].[TableCoverageLog];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [audit].[TableCoverageLog]
	--@param1 int = 0,
	--@param2 int
AS

INSERT INTO audit.TableCoverage (DateRef,Company, DwTable, Field, PercentageNull)

SELECT cast(getdate() as date) as DateRef
,CovAud.Company
, CovAud.SMSSTable
, CovAud.Field
, cast(CovAud.PercentageNull as decimal(4,3)) as PercentageNull
FROM(


-- Account Table (finance) added 2023-03-03 SB
SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.Account' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
	   Company, 
	   
	   CAST(cast(count(NULLIF(AccountNum,'')) as decimal) /count(*) AS decimal(10,3)) as AccountNum,
	   CAST(cast(count(NULLIF(AccountName,'')) as decimal) /count(*) AS decimal(10,3)) as AccountName,
	   CAST(cast(count(NULLIF(Assets,'')) as decimal) /count(*) AS decimal(10,3)) as Assets,
	   CAST(cast(count(NULLIF(Amortization,'')) as decimal) /count(*) AS decimal(10,3)) as Amortization,
	   CAST(cast(count(NULLIF(Costs,'')) as decimal) /count(*) AS decimal(10,3)) as Costs,
	   CAST(cast(count(NULLIF(LiabilitiesAndEquity,'')) as decimal) /count(*) AS decimal(10,3)) as LiabilitiesAndEquity,
	   CAST(cast(count(NULLIF(Revenue,'')) as decimal) /count(*) AS decimal(10,3)) as Revenue,
	   CAST(cast(count(NULLIF(CurrentAssets,'')) as decimal) /count(*) AS decimal(10,3)) as CurrentAssets,
	   CAST(cast(count(NULLIF(CurrentLiabilities,'')) as decimal) /count(*) AS decimal(10,3)) as CurrentLiabilities,
	   CAST(cast(count(NULLIF(Deprecation,'')) as decimal) /count(*) AS decimal(10,3)) as Depreciation,  -- changed AS call to new name 2023-03-08 SB
	   CAST(cast(count(NULLIF(Equity,'')) as decimal) /count(*) AS decimal(10,3)) as Equity,
	   CAST(cast(count(NULLIF(Liability,'')) as decimal) /count(*) AS decimal(10,3)) as Liability,
	   CAST(cast(count(NULLIF(Interest,'')) as decimal) /count(*) AS decimal(10,3)) as Interest,
	   CAST(cast(count(NULLIF(Tax,'')) as decimal) /count(*) AS decimal(10,3)) as Tax,
	   CAST(cast(count(NULLIF(Materials,'')) as decimal) /count(*) AS decimal(10,3)) as Materials,
	   CAST(cast(count(NULLIF(Expenses,'')) as decimal) /count(*) AS decimal(10,3)) as Expenses,
	   CAST(cast(count(NULLIF(AccountReceivables,'')) as decimal) /count(*) AS decimal(10,3)) as AccountReceivables,
	   CAST(cast(count(NULLIF(CashAndEquivalents,'')) as decimal) /count(*) AS decimal(10,3)) as CashAndEquivalents,
	   CAST(cast(count(NULLIF(Inventory,'')) as decimal) /count(*) AS decimal(10,3)) as Inventory,
	   CAST(cast(count(NULLIF(AccountType,'')) as decimal) /count(*) AS decimal(10,3)) as AccountType,
	   CAST(cast(count(NULLIF(AccountType2,'')) as decimal) /count(*) AS decimal(10,3)) as AccountType2,
	   CAST(cast(count(NULLIF(AccountType3,'')) as decimal) /count(*) AS decimal(10,3)) as AccountType3,
	   CAST(cast(count(NULLIF(AccountType4,'')) as decimal) /count(*) AS decimal(10,3)) as AccountType4,
	   CAST(cast(count(NULLIF(AccountType5,'')) as decimal) /count(*) AS decimal(10,3)) as AccountType5,
	   CAST(cast(count(NULLIF(AccountType6,'')) as decimal) /count(*) AS decimal(10,3)) as AccountType6,
	   CAST(cast(count(NULLIF(AccountType7,'')) as decimal) /count(*) AS decimal(10,3)) as AccountType7,
	   CAST(cast(count(NULLIF(AccountType8,'')) as decimal) /count(*) AS decimal(10,3)) as AccountType8,
	   CAST(cast(count(NULLIF(AccountType9,'')) as decimal) /count(*) AS decimal(10,3)) as AccountType9,
	   CAST(cast(count(NULLIF(AccountType10,'')) as decimal) /count(*) AS decimal(10,3)) as AccountType10,
	   CAST(cast(count(NULLIF(AccountGroupNum,'')) as decimal) /count(*) AS decimal(10,3)) as AccountGroupNum,
	   CAST(cast(count(NULLIF(AccountGroupName,'')) as decimal) /count(*) AS decimal(10,3)) as AccountGroupName,
	   CAST(cast(count(NULLIF(Statement,'')) as decimal) /count(*) AS decimal(10,3)) as Statement,
	   CAST(cast(count(StatementNum) as decimal) /count(*) AS decimal(10,3)) as StatementOrder, -- needs to be changed to StatementOrder 2023-03-29 SB
	   CAST(cast(count(NULLIF([IsActiveRecord],'')) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord],
	   CAST(cast(count(NULLIF([AccountIsActive],'')) as decimal) /count(*) AS decimal(10,3)) as IsActiveAccount,
	   CAST(cast(count(AccountGroupOrder) as decimal) /count(*) AS decimal(10,3)) as AccountGroupOrder,
	   CAST(cast(count(NULLIF('','')) as decimal) /count(*) AS decimal(10,3)) as FinancialStatement, -- needs to be added 2023-03-29 SB
	   CAST(cast(count(NULLIF(AccRes1,'')) as decimal) /count(*) AS decimal(10,3)) as AccRes1,
	   CAST(cast(count(NULLIF(AccRes2,'')) as decimal) /count(*) AS decimal(10,3)) as AccRes2,
	   CAST(cast(count(NULLIF(AccRes3,'')) as decimal) /count(*) AS decimal(10,3)) as AccRes3


	 	   	   
from dw.Account 
where is_deleted != 1
group by Company 
     ) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ( AccountNum, AccountName, Assets,  Amortization, Costs, LiabilitiesAndEquity, Revenue, CurrentAssets, CurrentLiabilities, Depreciation, Equity, Liability, Interest, Tax, Materials, Expenses, AccountReceivables, CashAndEquivalents,Inventory, AccountType, AccountType2, AccountType3,  AccountType4, AccountType5, AccountType6, AccountType7, AccountType8 ,AccountType9, AccountType10, AccountGroupNum,AccountGroupName, AccountGroupOrder, FinancialStatement, Statement, StatementOrder,IsActiveRecord,IsActiveAccount, AccRes1, AccRes2, AccRes3
											  ) 
			  ) as Unpivoted
) as subq_unpivoted




UNION ALL



-- dw.CostBearer  (finance) added 2023-03-07 SB
SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.CostBearer' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
	  Company, 
	  CAST(cast(count(NULLIF([CostBearerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CostBearerNum],
	  CAST(cast(count(NULLIF([CostBearerName],'')) as decimal) /count(*) AS decimal(10,3)) as [CostBearerName],
	  CAST(cast(count(NULLIF([CostBearerStatus],'')) as decimal) /count(*) AS decimal(10,3)) as [CostBearerStatus],
	  CAST(cast(count(NULLIF([CostBearerGroup],'')) as decimal) /count(*) AS decimal(10,3)) as [CostBearerGroup],
	  CAST(cast(count(NULLIF([CostBearerGroup2],'')) as decimal) /count(*) AS decimal(10,3)) as [CostBearerGroup2],
	  CAST(cast(count(NULLIF([CostBearerGroup3],'')) as decimal) /count(*) AS decimal(10,3)) as [CostBearerGroup3],
	  CAST(cast(count(NULLIF([CBRes1],'')) as decimal) /count(*) AS decimal(10,3)) as [CBRes1],
	  CAST(cast(count(NULLIF([CBRes2],'')) as decimal) /count(*) AS decimal(10,3)) as [CBRes2],
	  CAST(cast(count(NULLIF([CBRes3],'')) as decimal) /count(*) AS decimal(10,3)) as [CBRes3],
	  CAST(cast(count(NULLIF(IsActiveRecord,'')) as decimal) /count(*) AS decimal(10,3)) as IsActiveRecord
	
	 	   	   
from dw.CostBearer 
where is_deleted != 1
group by Company 
     ) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ( [CostBearerNum], [CostBearerName], [CostBearerStatus], [CostBearerGroup], [CostBearerGroup2], [CostBearerGroup3], [CBRes1], [CBRes2], [CBRes3],[IsActiveRecord]
											  ) 
			  ) as Unpivoted
) as subq_unpivoted

UNION ALL



-- dw.CostUnit  (finance) added 2023-03-07 SB
SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.CostUnit' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
	   Company, 
	   CAST(cast(count(NULLIF([CostUnitNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CostUnitNum],
	   CAST(cast(count(NULLIF([CostUnitName],'')) as decimal) /count(*) AS decimal(10,3)) as [CostUnitName],
	   CAST(cast(count(NULLIF([CostUnitStatus],'')) as decimal) /count(*) AS decimal(10,3)) as [CostUnitStatus],
	   CAST(cast(count(NULLIF([CostUnitGroup],'')) as decimal) /count(*) AS decimal(10,3)) as [CostUnitGroup],
	   CAST(cast(count(NULLIF([CostUnitGroup2],'')) as decimal) /count(*) AS decimal(10,3)) as [CostUnitGroup2],
	   CAST(cast(count(NULLIF([CostUnitGroup3],'')) as decimal) /count(*) AS decimal(10,3)) as [CostUnitGroup3],
	   CAST(cast(count(NULLIF([CURes1],'')) as decimal) /count(*) AS decimal(10,3)) as [CURes1],
	   CAST(cast(count(NULLIF([CURes2],'')) as decimal) /count(*) AS decimal(10,3)) as [CURes2],
	   CAST(cast(count(NULLIF([CURes3],'')) as decimal) /count(*) AS decimal(10,3)) as [CURes3],
	   CAST(cast(count(NULLIF(IsActiveRecord,'')) as decimal) /count(*) AS decimal(10,3)) as IsActiveRecord

	 	   	   
from dw.CostUnit 
where is_deleted != 1
group by Company 
     ) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ( [CostUnitNum], [CostUnitName], [CostUnitStatus], [CostUnitGroup], [CostUnitGroup2], [CostUnitGroup3], [CURes1], [CURes2], [CURes3],[IsActiveRecord]
											  ) 
			  ) as Unpivoted
) as subq_unpivoted

UNION ALL


-- dw.Claim added 2023-03-07 SB
SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.Claim' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
	   Company, 
	   CAST(cast(count(NULLIF([CustomerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CustomerNum],
	   CAST(cast(count(NULLIF([SalesOrderNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderNum],
	   CAST(cast(count(NULLIF([SalesOrderLine],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderLine],
	   CAST(cast(count(NULLIF([SupplierNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierNum],
	   CAST(cast(count(NULLIF([PurchaseOrderNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderNum],
	   CAST(cast(count(NULLIF([PurchaseOrderLine],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderLine],
	   CAST(cast(count(NULLIF([ClaimNum],'')) as decimal) /count(*) AS decimal(10,3)) as [ClaimNum],
	   CAST(cast(count(NULLIF([ClaimDescription],'')) as decimal) /count(*) AS decimal(10,3)) as [ClaimDescription],
	    CAST(cast(count(NULLIF([ClaimType],'')) as decimal) /count(*) AS decimal(10,3)) as [ClaimType],
	   CAST(cast(count(NULLIF([ClaimGroup],'')) as decimal) /count(*) AS decimal(10,3)) as [ClaimGroup],
	   CAST(cast(count(NULLIF([ClaimPriority],'')) as decimal) /count(*) AS decimal(10,3)) as [ClaimPriority],
	   CAST(cast(count(NULLIF([PartNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PartNum],
	   CAST(cast(count(NULLIF([ClaimHandler],'')) as decimal) /count(*) AS decimal(10,3)) as [ClaimHandler],
	   CAST(cast(count(NULLIF([WarehouseCode],'')) as decimal) /count(*) AS decimal(10,3)) as [WarehouseCode],
	   CAST(cast(count(NULLIF([Comment],'')) as decimal) /count(*) AS decimal(10,3)) as [Comment],
	   CAST(cast(count(NULLIF([CreateDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [CreateDate],
	   CAST(cast(count(NULLIF([StartDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as  [StartDate],
	   CAST(cast(count(NULLIF([StartTime],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as  [StartTime],
	   CAST(cast(count(NULLIF([EndDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [EndDate],
	   CAST(cast(count(NULLIF([EndTime],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [EndTime],
	   CAST(cast(count(NULLIF([ClaimResponsible],'')) as decimal) /count(*) AS decimal(10,3)) as [ClaimResponsible],
	   CAST(cast(count(NULLIF(CLRes1,'')) as decimal) /count(*) AS decimal(10,3)) as CLRes1,
	   CAST(cast(count(NULLIF(CLRes2,'')) as decimal) /count(*) AS decimal(10,3)) as CLRes2,
	   CAST(cast(count(NULLIF(CLRes3,'')) as decimal) /count(*) AS decimal(10,3)) as CLRes3,
	   CAST(cast(count(NULLIF([IsActiveRecord],'')) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord],
	    CAST(cast(count(NULLIF([CreateTime],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [CreateTime]
	   
from dw.Claim 
where is_deleted != 1
group by Company 
     ) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([CustomerNum], [SalesOrderNum], [SalesOrderLine], [SupplierNum], [PurchaseOrderNum], [PurchaseOrderLine], [ClaimNum], [ClaimDescription], [ClaimType], [ClaimGroup], [ClaimPriority], [PartNum], [ClaimHandler], [CreateDate], [StartDate], [StartTime], [EndDate], [EndTime], [WarehouseCode], [Comment],[ClaimResponsible], CLRes1, CLRes2, CLRes3, [IsActiveRecord],[CreateTime]
											  ) 
			  ) as Unpivoted
) as subq_unpivoted

UNION ALL



-- Customer Table
SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.Customer' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
	   Company, 
	   CAST(cast(count(NULLIF(MainCustomerName,'')) as decimal) /count(*) AS decimal(10,3)) as ParentCustomerName,  --Changed 2023-03-03 MainCustomerName
	   CAST(cast(count(NULLIF(CustomerName,'')) as decimal) /count(*) AS decimal(10,3)) as CustomerName,
	   CAST(cast(count(NULLIF(CustomerNum,'')) as decimal) /count(*) AS decimal(10,3)) as CustomerNum, -- Added 2023-03-03
	   CAST(cast(count(NULLIF(AddressLine1,'')) as decimal) /count(*) AS decimal(10,3)) as AddressLine1, 
	   CAST(cast(count(NULLIF(AddressLine2,'')) as decimal) /count(*) AS decimal(10,3)) as AddressLine2, 
	   CAST(cast(count(NULLIF(AddressLine3,'')) as decimal) /count(*) AS decimal(10,3)) as AddressLine3, 
	   CAST(cast(count(NULLIF(TelephoneNum1,'')) as decimal) /count(*) AS decimal(10,3)) as TelephoneNum1, 
	   CAST(cast(count(NULLIF(TelephoneNum2,'')) as decimal) /count(*) AS decimal(10,3)) as TelephoneNum2, 
	   CAST(cast(count(NULLIF(Email,'')) as decimal) /count(*) AS decimal(10,3)) as Email, 
	   CAST(cast(count(NULLIF(ZipCode,'')) as decimal) /count(*) AS decimal(10,3)) as ZipCode, 
	   CAST(cast(count(NULLIF(City,'')) as decimal) /count(*) AS decimal(10,3)) as City, 
	   CAST(cast(count(NULLIF(State,'')) as decimal) /count(*) AS decimal(10,3)) as State, 
	   CAST(cast(count(NULLIF(SalesDistrict,'')) as decimal) /count(*) AS decimal(10,3)) as SalesDistrict, 
	   CAST(cast(count(NULLIF(CountryCode,'')) as decimal) /count(*) AS decimal(10,3)) as CountryCode, 
	   CAST(cast(count(NULLIF(CountryName,'')) as decimal) /count(*) AS decimal(10,3)) as CountryName, 
	   CAST(cast(count(NULLIF(Division,'')) as decimal) /count(*) AS decimal(10,3)) as Division, 
	   CAST(cast(count(NULLIF(CustomerIndustry,'')) as decimal) /count(*) AS decimal(10,3)) as CustomerIndustry, 
	   CAST(cast(count(NULLIF(CustomerSubIndustry,'')) as decimal) /count(*) AS decimal(10,3)) as CustomerSubIndustry, 
	   CAST(cast(count(NULLIF(CustomerGroup,'')) as decimal) /count(*) AS decimal(10,3)) as CustomerGroup, 
	   CAST(cast(count(NULLIF(CustomerSubGroup,'')) as decimal) /count(*) AS decimal(10,3)) as CustomerSubGroup, 
	  -- CAST(cast(count(NULLIF(SalesPersonCode,'')) as decimal) /count(*) AS decimal(10,3)) as SalesPersonCode, removed from SC
	   CAST(cast(count(NULLIF(SalesPersonName,'')) as decimal) /count(*) AS decimal(10,3)) as SalesPerson,  -- changed as statement 2023-03-08 salesperon SB
	   CAST(cast(count(NULLIF(SalesPersonResponsible,'')) as decimal) /count(*) AS decimal(10,3)) as SalesPersonResponsible, 
	   CAST(cast(count(NULLIF(VATNum,'')) as decimal) /count(*) AS decimal(10,3)) as VATNum, 
	   CAST(cast(count(NULLIF(OrganizationNum,'')) as decimal) /count(*) AS decimal(10,3)) as OrganisationNum, -- Changed 2023-03-03 OrganizationNum
	   CAST(cast(count(NULLIF(AccountNum,'')) as decimal) /count(*) AS decimal(10,3)) as AccountNum, 
	   CAST(cast(count(NULLIF(InternalExternal,'')) as decimal) /count(*) AS decimal(10,3)) as IsAxInterInternal, --Changed 2023-03-03 InternalExternal
	   CAST(cast(count(NULLIF(CustomerScore,'')) as decimal) /count(*) AS decimal(10,3)) as CustomerScore, 
	   CAST(cast(count(NULLIF(CustomerType,'')) as decimal) /count(*) AS decimal(10,3)) as CustomerType,
	   CAST(cast(count(NULLIF(Comments,'')) as decimal) /count(*) AS decimal(10,3)) as Comments,
	   CAST(cast(count(CreditLimit) as decimal) /count(*) AS decimal(10,3)) as CreditLimit,
	   CAST(cast(count(NULLIF(CRes1,'')) as decimal) /count(*) AS decimal(10,3)) as CRes1,
	   CAST(cast(count(NULLIF(CRes2,'')) as decimal) /count(*) AS decimal(10,3)) as CRes2,
	   CAST(cast(count(NULLIF(CRes3,'')) as decimal) /count(*) AS decimal(10,3)) as CRes3,
	   CAST(cast(count(NULLIF(IsActiveRecord,'')) as decimal) /count(*) AS decimal(10,3)) as IsActiveRecord,
	   CAST(cast(count(NULLIF(IsBusinessAreaInternal,'')) as decimal) /count(*) AS decimal(10,3)) as IsBusinessAreaInternal,
	   CAST(cast(count(NULLIF(IsCompanyGroupInternal,'')) as decimal) /count(*) AS decimal(10,3)) as IsCompanyGroupInternal,
	   CAST(cast(count(NULLIF(PaymentTerms,'')) as decimal) /count(*) AS decimal(10,3)) as PaymentTerms
	 	   	   
from dw.Customer
where is_deleted != 1
group by Company 
     ) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN (ParentCustomerName, CustomerName, CustomerNum, AddressLine1, AddressLine2, AddressLine3, TelephoneNum1, 
	 TelephoneNum2, Email, ZipCode, City, State, SalesDistrict, CountryCode, CountryName, Division, CustomerIndustry, CustomerSubIndustry, CustomerGroup, 
	 CustomerSubGroup, SalesPerson, SalesPersonResponsible, VATNum, OrganisationNum, AccountNum, IsAxInterInternal, CustomerScore, CustomerType, 
	 Comments,CreditLimit, CRes1, CRes2, CRes3, IsActiveRecord, IsBusinessAreaInternal, IsCompanyGroupInternal, PaymentTerms 
											  ) 
			  ) as Unpivoted
) as subq_unpivoted




UNION ALL


-- dwCustomerAgreement


SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.CustomerAgreement' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
	     Company,
	   CAST(cast(count(NULLIF([CustomerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CustomerNum],
	   CAST(cast(count(NULLIF([PartNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PartNum],
	   CAST(cast(count(NULLIF([AgreementCode],'')) as decimal) /count(*) AS decimal(10,3)) as [AgreementCode],
	   CAST(cast(count(NULLIF([AgreementDescription],'')) as decimal) /count(*) AS decimal(10,3)) as [AgreementDescription],
	   CAST(cast(count([DiscountPercent]) as decimal) /count(*) AS decimal(10,3)) as [DiscountPercent],
	   CAST(cast(count([UnitPrice]) as decimal) /count(*) AS decimal(10,3)) as [UnitPrice],
	   CAST(cast(count([FulfilledQty]) as decimal) /count(*) AS decimal(10,3)) as [FulfilledQty],
	    CAST(cast(count([RemainingQty]) as decimal) /count(*) AS decimal(10,3)) as [RemainingQty], -- Added 2023-03-03 SB
	   CAST(cast(count([AgreementQty]) as decimal) /count(*) AS decimal(10,3)) as [AgreementQty],
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count(NULLIF([DelivTime],'')) as decimal) /count(*) AS decimal(10,3)) as [DelivTime],
	   CAST(cast(count(NULLIF([AgreementStart],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [AgreementStart],
	   CAST(cast(count(NULLIF([AgreementEnd],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [AgreementEnd],
	   CAST(cast(count(NULLIF([CustomerTerms],'')) as decimal) /count(*) AS decimal(10,3)) as [CustomerTerms],
	   CAST(cast(count(NULLIF([UoM],'')) as decimal) /count(*) AS decimal(10,3)) as [UoM],
	   CAST(cast(count(NULLIF([CARes1],'')) as decimal) /count(*) AS decimal(10,3)) as [CARes1], -- Added 2023-03-03 SB
	   CAST(cast(count(NULLIF([CARes2],'')) as decimal) /count(*) AS decimal(10,3)) as [CARes2], -- Added 2023-03-03 SB
	   CAST(cast(count(NULLIF([CARes3],'')) as decimal) /count(*) AS decimal(10,3)) as [CARes3], -- Added 2023-03-03 SB
	   CAST(cast(count(NULLIF(IsActiveRecord,'')) as decimal) /count(*) AS decimal(10,3)) as IsActiveRecord,
	   CAST(cast(count(NULLIF(AgreementResponsible,'')) as decimal) /count(*) AS decimal(10,3)) as AgreementResponsible


from dw.CustomerAgreement
where is_deleted != 1
group by Company 
 ) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([CustomerNum], [PartNum], [AgreementCode], [AgreementDescription], [DiscountPercent], [UnitPrice], [FulfilledQty],[RemainingQty], [AgreementQty],
	 [Currency], [DelivTime], [AgreementStart], [AgreementEnd], [CustomerTerms], [UoM], [CARes1], [CARes2], [CARes3], IsActiveRecord, AgreementResponsible
											  ) 
			  ) as Unpivoted
) as subq_unpivoted

UNION ALL

-- dwDepartment  added 2023-03-03 SB

SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.Department' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
	     Company,
	   CAST(cast(count(NULLIF([DepartmentCode],'')) as decimal) /count(*) AS decimal(10,3)) as [DepartmentCode],
	   CAST(cast(count(NULLIF([DepartmentName],'')) as decimal) /count(*) AS decimal(10,3)) as [DepartmentName],
	   CAST(cast(count(NULLIF([DepartmentSite],'')) as decimal) /count(*) AS decimal(10,3)) as [DepartmentSite],
	   CAST(cast(count(NULLIF([Address],'')) as decimal) /count(*) AS decimal(10,3)) as [Address],
	   CAST(cast(count(NULLIF([ZipCode],'')) as decimal) /count(*) AS decimal(10,3)) as [ZipCode],
	   CAST(cast(count(NULLIF([City],'')) as decimal) /count(*) AS decimal(10,3)) as [City],
	   CAST(cast(count(NULLIF([State],'')) as decimal) /count(*) AS decimal(10,3)) as [State],
	   CAST(cast(count(NULLIF([CountryCode],'')) as decimal) /count(*) AS decimal(10,3)) as [CountryCode],
	   CAST(cast(count(NULLIF([CountryName],'')) as decimal) /count(*) AS decimal(10,3)) as [CountryName],
	   CAST(cast(count(NULLIF([DepartmentType],'')) as decimal) /count(*) AS decimal(10,3)) as [DepartmentType],
	   CAST(cast(count(NULLIF([DepartmentDescription],'')) as decimal) /count(*) AS decimal(10,3)) as [DepartmentDescription],
	   CAST(cast(count([IsActiveRecord]) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord],
	   CAST(cast(count(NULLIF([DptRes1],'')) as decimal) /count(*) AS decimal(10,3)) as [DptRes1],
	   CAST(cast(count(NULLIF([DptRes2],'')) as decimal) /count(*) AS decimal(10,3)) as [DptRes2],
	   CAST(cast(count(NULLIF([DptRes3],'')) as decimal) /count(*) AS decimal(10,3)) as [DptRes3]

from dw.Department
where is_deleted != 1
group by Company 
 ) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([DepartmentCode], [DepartmentName], [DepartmentSite], [Address], [ZipCode], [City], [State], [CountryCode], [CountryName], [DepartmentType], [DepartmentDescription], [IsActiveRecord], [DptRes1], [DptRes2], [DptRes3]
											  ) 
			  ) as Unpivoted
) as subq_unpivoted

UNION ALL


--DwFinanceBudget

SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.FinanceBudget' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
        Company,
	   CAST(cast(count(NULLIF([BudgetType],'')) as decimal) /count(*) AS decimal(10,3)) as [BudgetType],
	   CAST(cast(count(NULLIF([BudgetName],'')) as decimal) /count(*) AS decimal(10,3)) as [BudgetName],
	   CAST(cast(count(NULLIF([BudgetDescription],'')) as decimal) /count(*) AS decimal(10,3)) as [BudgetDescription],
	   CAST(cast(count(NULLIF([BudgetPeriod],'')) as decimal) /count(*) AS decimal(10,3)) as [BudgetPeriod],
	   CAST(cast(count(NULLIF([BudgetPeriodDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as  [BudgetPeriodDate],
	   CAST(cast(count(NULLIF([PeriodType],'')) as decimal) /count(*) AS decimal(10,3)) as [PeriodType],
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count([BudgetFinance]) as decimal) /count(*) AS decimal(10,3)) as [BudgetFinance],
	   CAST(cast(count(NULLIF([CostBearerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CostBearerNum],
	   CAST(cast(count(NULLIF([CostUnitNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CostUnitNum],
	   CAST(cast(count(NULLIF([AccountNum],'')) as decimal) /count(*) AS decimal(10,3)) as [AccountNum],
	   CAST(cast(count(NULLIF([AccountGroupNum],'')) as decimal) /count(*) AS decimal(10,3)) as [AccountGroupNum],
	   CAST(cast(count(ExchangeRate) as decimal) /count(*) AS decimal(10,3)) as [ExchangeRate],
	   CAST(cast(count(NULLIF([IsActiveRecord],'')) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord],
	   CAST(cast(count(NULLIF([BRes1],'')) as decimal) /count(*) AS decimal(10,3)) as [BRes1],
	   CAST(cast(count(NULLIF([BRes2],'')) as decimal) /count(*) AS decimal(10,3)) as [BRes2],
	   CAST(cast(count(NULLIF([BRes3],'')) as decimal) /count(*) AS decimal(10,3)) as [BRes3]

from dw.FinanceBudget

group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([BudgetType], [BudgetName], [BudgetDescription], [BudgetPeriod], [BudgetPeriodDate], [PeriodType], [Currency], [BudgetFinance], 
	 [CostBearerNum], [CostUnitNum],[AccountNum],[AccountGroupNum],[ExchangeRate],[IsActiveRecord],[BRes1],[BRes2],[BRes3]
											  ) 
			  ) as Unpivoted
) as subq_unpivoted


UNION ALL
 

--dw.GeneralLedger

SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.GeneralLedger' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
        Company,
	   CAST(cast(count(NULLIF([AccountNum],'')) as decimal) /count(*) AS decimal(10,3)) as [AccountNum],
	   CAST(cast(count(NULLIF([CostUnitNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CostUnitNum],
	   CAST(cast(count(NULLIF([CostBearerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CostBearerNum],
	   CAST(cast(count(NULLIF([JournalType],'')) as decimal) /count(*) AS decimal(10,3)) as [JournalType],
	   CAST(cast(count(NULLIF([JournalDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [JournalDate],
	   CAST(cast(count(NULLIF([JournalNum],'')) as decimal) /count(*) AS decimal(10,3)) as [JournalNum],
	   CAST(cast(count(NULLIF([JournalLine],'')) as decimal) /count(*) AS decimal(10,3)) as [JournalLine],
	   CAST(cast(count(NULLIF([AccountingDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [AccountingDate],
	   CAST(cast(count(NULLIF([Description],'')) as decimal) /count(*) AS decimal(10,3)) as [Description],
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count([ExchangeRate]) as decimal) /count(*) AS decimal(10,3)) as [ExchangeRate],
	   CAST(cast(count([InvoiceAmount]) as decimal) /count(*) AS decimal(10,3)) as [TransactionAmount], --changed from InvoiceAmount 2023-08-04
	   CAST(cast(count(NULLIF([CustomerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CustomerNum],
	   CAST(cast(count(NULLIF([SupplierNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierNum],
	   CAST(cast(count(NULLIF([SalesInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceNum],
	   CAST(cast(count(NULLIF([PurchaseInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseInvoiceNum],
	   CAST(cast(count(NULLIF([SupplierInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierInvoiceNum],
	   CAST(cast(count(NULLIF([LinkToOriginalInvoice],'')) as decimal) /count(*) AS decimal(10,3)) as [LinkToOriginalInvoice],
	   CAST(cast(count(NULLIF([TransactionNum],'')) as decimal) /count(*) AS decimal(10,3)) as [TransactionNum],
	   CAST(cast(count(NULLIF([GLRes1],'')) as decimal) /count(*) AS decimal(10,3)) as [GLRes1],
	   CAST(cast(count(NULLIF([GLRes2],'')) as decimal) /count(*) AS decimal(10,3)) as [GLRes2],
	   CAST(cast(count(NULLIF([GLRes3],'')) as decimal) /count(*) AS decimal(10,3)) as [GLRes3],
       CAST(cast(count([InvoiceAmountLC]) as decimal) /count(*) AS decimal(10,3)) as [TransactionAmountLC],--changed from InvoiceAmountLC 
	   CAST(cast(count(NULLIF(IndexKey,'')) as decimal) /count(*) AS decimal(10,3)) as [IndexKey],
	   CAST(cast(count(NULLIF([IsActiveRecord],'')) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord],
	   CAST(cast(count(NULLIF(IsManual,'')) as decimal) /count(*) AS decimal(10,3)) as [IsManual],
	   CAST(cast(count(NULLIF([ProjectNum],'')) as decimal) /count(*) AS decimal(10,3)) as [ProjectNum],
	   CAST(cast(count(NULLIF(UserIDApproved,'')) as decimal) /count(*) AS decimal(10,3)) as [UserIDApproved],
	   CAST(cast(count(NULLIF(UserIDBooked,'')) as decimal) /count(*) AS decimal(10,3)) as [UserIDBooked]

	   


from dw.GeneralLedger
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([AccountNum], [CostUnitNum], [CostBearerNum], [JournalType], [JournalDate], [JournalNum], [JournalLine], [AccountingDate], [Description], 	 [Currency], [ExchangeRate], [TransactionAmount], [CustomerNum], [SupplierNum], [SalesInvoiceNum], [PurchaseInvoiceNum],[SupplierInvoiceNum], [LinkToOriginalInvoice], [TransactionNum], [GLRes1], [GLRes2], [GLRes3], [TransactionAmountLC], [IndexKey],[IsActiveRecord],[IsManual], [ProjectNum],[UserIDApproved],[UserIDBooked] 
											  ) 
			  ) as Unpivoted
) as subq_unpivoted


UNION ALL

--dw.OpenBalance

SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.OpenBalance' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
        Company,
		CAST(cast(count(NULLIF([AccountNum],'')) as decimal) /count(*) AS decimal(10,3)) as [AccountNum],
		CAST(cast(count(NULLIF([CostUnitNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CostUnitNum],
		CAST(cast(count(NULLIF([CostBearerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CostBearerNum],
		CAST(cast(count(NULLIF([ProjectNum],'')) as decimal) /count(*) AS decimal(10,3)) as [ProjectNum],
		CAST(cast(count(NULLIF([AccountingDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [AccountingDate],
	    CAST(cast(count(NULLIF([Description],'')) as decimal) /count(*) AS decimal(10,3)) as [Description],
		CAST(cast(count([OpeningBalance]) as decimal) /count(*) AS decimal(10,3)) as [OpeningBalance],
		CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
		CAST(cast(count([ExchangeRate]) as decimal) /count(*) AS decimal(10,3)) as [ExchangeRate],
		CAST(cast(count(NULLIF([OBRes1],'')) as decimal) /count(*) AS decimal(10,3)) as [OBRes1],
		CAST(cast(count(NULLIF([OBRes2],'')) as decimal) /count(*) AS decimal(10,3)) as [OBRes2],
		CAST(cast(count(NULLIF([OBRes3],'')) as decimal) /count(*) AS decimal(10,3)) as [OBRes3],
		CAST(cast(count(NULLIF([IsActiveRecord],'')) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord]

	 --   CAST(cast(count(NULLIF(,'')) as decimal) /count(*) AS decimal(10,3)) as ,
	 --   CAST(cast(count(NULLIF(,'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as ,
	--    CAST(cast(count() as decimal) /count(*) AS decimal(10,3)) as ,


from dw.OpenBalance
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([AccountNum], [CostUnitNum], [CostBearerNum], [ProjectNum],  [AccountingDate], [Description], [OpeningBalance], [Currency],  [ExchangeRate], [OBRes1], [OBRes2], [OBRes3],[IsActiveRecord]
											  ) 
			  ) as Unpivoted
) as subq_unpivoted


UNION ALL

-- DwPart

SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.Part' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
        Company,
       CAST(cast(count(NULLIF(PartNum,'')) as decimal) /count(*) AS decimal(10,3)) as PartNum,
	   CAST(cast(count(NULLIF(PartName,'')) as decimal) /count(*) AS decimal(10,3)) as PartName,
	   CAST(cast(count(NULLIF(PartDescription,'')) as decimal) /count(*) AS decimal(10,3)) as PartDescription,
	   CAST(cast(count(NULLIF(PartDescription2,'')) as decimal) /count(*) AS decimal(10,3)) as PartDescription2,
	   CAST(cast(count(NULLIF(PartDescription3,'')) as decimal) /count(*) AS decimal(10,3)) as PartDescription3,
	   CAST(cast(count(NULLIF(ProductGroup,'')) as decimal) /count(*) AS decimal(10,3)) as ProductGroup,
	   CAST(cast(count(NULLIF(ProductGroup2,'')) as decimal) /count(*) AS decimal(10,3)) as ProductGroup2,
	   CAST(cast(count(NULLIF(ProductGroup3,'')) as decimal) /count(*) AS decimal(10,3)) as ProductGroup3,
	   CAST(cast(count(NULLIF(ProductGroup4,'')) as decimal) /count(*) AS decimal(10,3)) as ProductGroup4,
	   CAST(cast(count(NULLIF(Brand,'')) as decimal) /count(*) AS decimal(10,3)) as Brand,
	   CAST(cast(count(CommodityCode) as decimal) /count(*) AS decimal(10,3)) as CommodityCode,
	   CAST(cast(count(NULLIF(PartReplacementNum,'')) as decimal) /count(*) AS decimal(10,3)) as PartReplacementNum,
	   CAST(cast(count(NULLIF(PartStatus,'')) as decimal) /count(*) AS decimal(10,3)) as PartStatus,
	   CAST(cast(count(NULLIF(CountryOfOrigin,'')) as decimal) /count(*) AS decimal(10,3)) as CountryOfOriginCode, -- Changed AS statement due to name change 2023-03-08 SB
	   CAST(CAST(COUNT(NULLIF(NetWeight, 0)) AS DECIMAL) / COUNT(*) AS DECIMAL(10, 3)) as NetWeight, -- changed 2023-05-10 SB to exclude both null and 0 weight CAST(cast(count(NetWeight) as decimal) /count(*) AS decimal(10,3)) ,
	   CAST(cast(count(NULLIF(UoM,'')) as decimal) /count(*) AS decimal(10,3)) as UoM,
	   CAST(cast(count(NULLIF(Material,'')) as decimal) /count(*) AS decimal(10,3)) as Material,
	   CAST(cast(count(NULLIF(Barcode,'')) as decimal) /count(*) AS decimal(10,3)) as Barcode,
	   CAST(cast(count(ReOrderLevel) as decimal) /count(*) AS decimal(10,3)) as ReOrderLevel,
	   CAST(cast(count(NULLIF(PartResponsible,'')) as decimal) /count(*) AS decimal(10,3)) as PartResponsible,
	   CAST(cast(count(NULLIF(MainSupplier,'')) as decimal) /count(*) AS decimal(10,3)) as PrimarySupplier, -- changed from MainSupplier
	   CAST(cast(count(NULLIF(AlternativeSupplier,'')) as decimal) /count(*) AS decimal(10,3)) as AlternativeSupplier,
	   CAST(cast(count(NULLIF(StartDate,'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as StartDate,
	   CAST(cast(count(NULLIF(EndDate,'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as EndDate,
	   CAST(cast(count(NULLIF([PARes1],'')) as decimal) /count(*) AS decimal(10,3)) as [PARes1],
	   CAST(cast(count(NULLIF([PARes2],'')) as decimal) /count(*) AS decimal(10,3)) as [PARes2],
	   CAST(cast(count(NULLIF([PARes3],'')) as decimal) /count(*) AS decimal(10,3)) as [PARes3],
	   CAST(cast(count([IsActiveRecord]) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord]



from dw.Part
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN (PartNum, PartName, PartDescription, PartDescription2, PartDescription3, ProductGroup, ProductGroup2, ProductGroup3, ProductGroup4, Brand,
	                                         CommodityCode, PartReplacementNum,  PartStatus, CountryOfOriginCode, NetWeight, UoM, Material, Barcode, ReOrderLevel, PartResponsible, PrimarySupplier, AlternativeSupplier, StartDate, EndDate, [PARes1], [PARes2], [PARes3], [IsActiveRecord] 
											  ) 
			  ) as Unpivoted
) as subq_unpivoted


UNION ALL


--dw.Project


SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company,  'dw.Project' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
       Company,
       CAST(cast(count(NULLIF([MainProjectNum],'')) as decimal) /count(*) AS decimal(10,3)) as [MainProjectNum],
	   CAST(cast(count(NULLIF([ProjectNum],'')) as decimal) /count(*) AS decimal(10,3)) as [ProjectNum],
	   CAST(cast(count(NULLIF([ProjectDescription],'')) as decimal) /count(*) AS decimal(10,3)) as [ProjectDescription],
	   CAST(cast(count(NULLIF([Organisation],'')) as decimal) /count(*) AS decimal(10,3)) as [Organisation],
	   CAST(cast(count(NULLIF([ProjectStatus],'')) as decimal) /count(*) AS decimal(10,3)) as [ProjectStatus],
	   CAST(cast(count(NULLIF([ProjectCategory],'')) as decimal) /count(*) AS decimal(10,3)) as [ProjectCategory],
	   --CAST(cast(count(NULLIF([WBSElement],'')) as decimal) /count(*) AS decimal(10,3)) as [WBSElement], not in SC anymore
	   --CAST(cast(count(NULLIF([ObjectNum],'')) as decimal) /count(*) AS decimal(10,3)) as [ObjectNum], not in SC anymore
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count(NULLIF([WarehouseCode],'')) as decimal) /count(*) AS decimal(10,3)) as [WarehouseCode],
	   CAST(cast(count(NULLIF([ProjectResponsible],'')) as decimal) /count(*) AS decimal(10,3)) as [ProjectResponsible],
	   CAST(cast(count(NULLIF([Comments],'')) as decimal) /count(*) AS decimal(10,3)) as [Comments],
	   CAST(cast(count(NULLIF([StartDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [StartDate],
	   CAST(cast(count(NULLIF([EndDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [EndDate],
	   CAST(cast(count(NULLIF([EstEndDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [EstEndDate],
	   CAST(cast(count([ProjectCompletion]) as decimal) /count(*) AS decimal(10,3)) as [ProjectCompletion],
	   CAST(cast(count([ActualCost]) as decimal) /count(*) AS decimal(10,3)) as [ActualCost],
	   CAST(cast(count(NULLIF([IsActiveRecord],'')) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord],
	   CAST(cast(count(NULLIF(ProjectNumLine,'')) as decimal) /count(*) AS decimal(10,3)) as ProjectNumLine,
	   CAST(cast(count(NULLIF('','')) as decimal) /count(*) AS decimal(10,3)) as ProjectNumSubLine, -- missing from DW, empty
	   CAST(cast(count(NULLIF(PJRes1,'')) as decimal) /count(*) AS decimal(10,3)) as PJRes1,
	   CAST(cast(count(NULLIF(PJRes2,'')) as decimal) /count(*) AS decimal(10,3)) as PJRes2,
	   CAST(cast(count(NULLIF(PJRes3,'')) as decimal) /count(*) AS decimal(10,3)) as PJRes3
	   
from dw.Project
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([MainProjectNum], [ProjectNum], [ProjectDescription], [Organisation], [ProjectStatus], [ProjectCategory], 
	 [Currency], [WarehouseCode], [ProjectResponsible], [Comments],  [StartDate], [EndDate], [EstEndDate], [ProjectCompletion], [ActualCost],[IsActiveRecord], [ProjectNumLine],ProjectNumSubLine, PJRes1, PJRes2, PJRes3
											  ) 
			  ) as Unpivoted
) as subq_unpivoted

UNION ALL


--dw.PurchaseInvoice

SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.PurchaseInvoice' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
       Company,
       CAST(cast(count(NULLIF([PurchaseOrderNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderNum],
	   CAST(cast(count(NULLIF([PurchaseOrderLine],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderLine],
	   CAST(cast(count(NULLIF([PurchaseOrderSubLine],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderSubLine],
	   CAST(cast(count(NULLIF([PurchaseOrderType],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderType],
	   CAST(cast(count(NULLIF([PurchaseInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseInvoiceNum],
	   CAST(cast(count(NULLIF([PurchaseInvoiceLine],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseInvoiceLine],
	   CAST(cast(count(NULLIF([PurchaseInvoiceType],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseInvoiceType],
	   CAST(cast(count(NULLIF([PurchaseInvoiceDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseInvoiceDate],
	   CAST(cast(count(NULLIF([ActualDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [ActualReceiveDate], -- was [ActualDelivDate]
	   CAST(cast(count(NULLIF([SupplierNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierNum],
	   CAST(cast(count(NULLIF([PartNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PartNum],
	   CAST(cast(count([PurchaseInvoiceQty]) as decimal) /count(*) AS decimal(10,3)) as [PurchaseInvoiceQty],
	   CAST(cast(count(NULLIF([UoM],'')) as decimal) /count(*) AS decimal(10,3)) as [UoM],
	   CAST(cast(count([UnitPrice]) as decimal) /count(*) AS decimal(10,3)) as [UnitPrice],
	   CAST(cast(count([DiscountPercent]) as decimal) /count(*) AS decimal(10,3)) as [DiscountPercent],
	   CAST(cast(count([DiscountAmount]) as decimal) /count(*) AS decimal(10,3)) as [DiscountAmount],
	   CAST(cast(count([TotalMiscChrg]) as decimal) /count(*) AS decimal(10,3)) as [TotalMiscChrg],
	   CAST(cast(count([VATAmount]) as decimal) /count(*) AS decimal(10,3)) as [VATAmount],
	   CAST(cast(count([ExchangeRate]) as decimal) /count(*) AS decimal(10,3)) as [ExchangeRate],
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count(NULLIF([CreditMemo],'')) as decimal) /count(*) AS decimal(10,3)) as [IsCreditMemo], -- Changed AS statement due to name change 2023-03-08 SB
	   CAST(cast(count(NULLIF([PurchaserName],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaserName],
	   CAST(cast(count(NULLIF([WarehouseCode],'')) as decimal) /count(*) AS decimal(10,3)) as [WarehouseCode],
	   CAST(cast(count(NULLIF([PurchaseChannel],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseChannel],
	   CAST(cast(count(NULLIF([ActualShipDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [ActualShipDate],
	   CAST(cast(count(NULLIF([Comment],'')) as decimal) /count(*) AS decimal(10,3)) as [Comment],
	   CAST(cast(count(NULLIF([IsActiveRecord],'')) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord],
	   CAST(cast(count(NULLIF([IsInvoiceClosed],'')) as decimal) /count(*) AS decimal(10,3)) as [IsInvoiceClosed],
	   CAST(cast(count(NULLIF([PIRes1],'')) as decimal) /count(*) AS decimal(10,3)) as [PIRes1],
	   CAST(cast(count(NULLIF([PIRes2],'')) as decimal) /count(*) AS decimal(10,3)) as [PIRes2],
	   CAST(cast(count(NULLIF([PIRes3],'')) as decimal) /count(*) AS decimal(10,3)) as [PIRes3],
	   CAST(cast(count(NULLIF([PurchaseInvoiceSubLine],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseInvoiceSubline]

from dw.PurchaseInvoice
where is_deleted != 1
group by Company
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([PurchaseOrderNum], [PurchaseOrderLine], [PurchaseOrderSubLine], [PurchaseOrderType], [PurchaseInvoiceNum], [PurchaseInvoiceLine], [PurchaseInvoiceType], 
	 [PurchaseInvoiceDate], [ActualReceiveDate], [SupplierNum],
	 [PartNum], [PurchaseInvoiceQty],  [UoM], [UnitPrice], [DiscountPercent], [DiscountAmount], [TotalMiscChrg],[VATAmount] ,[ExchangeRate] , [Currency],
	 [IsCreditMemo], [PurchaserName], [WarehouseCode], [PurchaseChannel],[ActualShipDate],[Comment],[IsActiveRecord], [IsInvoiceClosed],[PIRes1],[PIRes2],[PIRes3],[PurchaseInvoiceSubline] 
											  ) 
			  ) as Unpivoted
) as subq_unpivoted

UNION ALL

--dw.PurchaseLedger

SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.PurchaseLedger' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
       Company,
       CAST(cast(count(NULLIF([SupplierNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierNum],
	   CAST(cast(count(NULLIF([PurchaseOrderNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderNum],
	   CAST(cast(count(NULLIF([PurchaseInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseInvoiceNum],
	   CAST(cast(count(NULLIF([PurchaseInvoiceDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseInvoiceDate],
	   CAST(cast(count(NULLIF([PurchaseDueDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseDueDate],
	   CAST(cast(count(NULLIF([PurchaseLastPaymentDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseLastPaymentDate],
	   CAST(cast(count([InvoiceAmount]) as decimal) /count(*) AS decimal(10,3)) as [InvoiceAmount],
	   CAST(cast(count([ExchangeRate]) as decimal) /count(*) AS decimal(10,3)) as [ExchangeRate],
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count([VATAmount]) as decimal) /count(*) AS decimal(10,3)) as [VATAmount],
	   CAST(cast(count(NULLIF([VATCode],'')) as decimal) /count(*) AS decimal(10,3)) as [VATCode],
	   CAST(cast(count(NULLIF([PayToName],'')) as decimal) /count(*) AS decimal(10,3)) as [PayToName],
	   CAST(cast(count(NULLIF([PayToCity],'')) as decimal) /count(*) AS decimal(10,3)) as [PayToCity],
	   CAST(cast(count(NULLIF([PayToContact],'')) as decimal) /count(*) AS decimal(10,3)) as [PayToContact],
	   CAST(cast(count(NULLIF([PaymentTerms],'')) as decimal) /count(*) AS decimal(10,3)) as [PaymentTerms],
	   --CAST(cast(count(NULLIF([PrePaymentNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PrePaymentNum],  NOT REQUESTED IN SC any longer
	   --CAST(cast(count(NULLIF([LastPaymentNum],'')) as decimal) /count(*) AS decimal(10,3)) as [LastPaymentNum], NOT REQUESTED IN SC any longer
	   CAST(cast(count([PaidInvoiceAmount]) as decimal) /count(*) AS decimal(10,3)) as [PaidInvoiceAmount],
	   CAST(cast(count(NULLIF([AccountingDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [AccountingDate],
	  CAST(cast(count(NULLIF([VATCodeDesc],'')) as decimal) /count(*) AS decimal(10,3)) as [VATCodeDesc],
	   CAST(cast(count([RemainingInvoiceAmount]) as decimal) /count(*) AS decimal(10,3)) as [RemainingInvoiceAmount],
	   CAST(cast(count(NULLIF([LinkToOriginalInvoice],'')) as decimal) /count(*) AS decimal(10,3)) as [LinkToOriginalInvoice],
	   CAST(cast(count(NULLIF([IsActiveRecord],'')) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord],
	   CAST(cast(count(NULLIF([IsInvoiceClosed],'')) as decimal) /count(*) AS decimal(10,3)) as [IsInvoiceClosed],
	   CAST(cast(count([PaymentEvents]) as decimal) /count(*) AS decimal(10,3)) as [PaymentEvents],
	   CAST(cast(count(NULLIF([SupplierInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierInvoiceNum],
	   CAST(cast(count(NULLIF([CostUnitNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CostUnitNum],
	     CAST(cast(count(NULLIF([PLRes1],'')) as decimal) /count(*) AS decimal(10,3)) as [PLRes1],
	   CAST(cast(count(NULLIF([PLRes2],'')) as decimal) /count(*) AS decimal(10,3)) as [PLRes2],
	   CAST(cast(count(NULLIF([PLRes3],'')) as decimal) /count(*) AS decimal(10,3)) as [PLRes3]
	  

from dw.PurchaseLedger
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([SupplierNum], [PurchaseOrderNum], [PurchaseInvoiceNum], [PurchaseInvoiceDate], [PurchaseDueDate], [PurchaseLastPaymentDate], [InvoiceAmount], [ExchangeRate], [Currency], [VATAmount],
	                                         [VATCode], [PayToName],  [PayToCity], [PayToContact], [PaymentTerms], [PaidInvoiceAmount] , [AccountingDate], 
											 [VATCodeDesc], [RemainingInvoiceAmount],[LinkToOriginalInvoice],[IsActiveRecord],[IsInvoiceClosed], [PaymentEvents], [SupplierInvoiceNum], [CostUnitNum],[PLRes1],[PLRes2],[PLRes3]
											  ) 
			  ) as Unpivoted
) as subq_unpivoted

UNION ALL

   

--dw.PurchaseOrder

SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.PurchaseOrder' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
       Company,
       CAST(cast(count(NULLIF([PurchaseOrderNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderNum],
	   CAST(cast(count(NULLIF([PurchaseOrderLine],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderLine],
	   CAST(cast(count(NULLIF([PurchaseOrderSubLine],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderSubLine],
	   CAST(cast(count(NULLIF([PurchaseOrderType],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderType],
	   CAST(cast(count(NULLIF([PurchaseOrderDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderDate],
	   CAST(cast(count(NULLIF([PurchaseOrderStatus],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderStatus],
	   CAST(cast(count(NULLIF([OrgReqDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [OrgReqDelivDate],
	   CAST(cast(count(NULLIF([CommittedDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [CommittedDelivDate],
	   CAST(cast(count(NULLIF([ActualDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [ActualDelivDate],
	   CAST(cast(count(NULLIF([ReqDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [ReqDelivDate],
	   CAST(cast(count(NULLIF([PurchaseInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseInvoiceNum],
	   CAST(cast(count(NULLIF([PartNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PartNum],
	   CAST(cast(count(NULLIF([SupplierNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierNum],
	   CAST(cast(count(NULLIF([SupplierPartNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierPartNum],
	   CAST(cast(count(NULLIF([SupplierInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierInvoiceNum],
	   CAST(cast(count(NULLIF([DelivCustomerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [DelivCustomerNum],
	   CAST(cast(count(NULLIF([PartStatus],'')) as decimal) /count(*) AS decimal(10,3)) as [PartStatus],
	   CAST(cast(count([PurchaseOrderQty]) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderQty],
	   CAST(cast(count([ReceiveQty]) as decimal) /count(*) AS decimal(10,3)) as [PurchaseReceiveQty],
	   CAST(cast(count([InvoiceQty]) as decimal) /count(*) AS decimal(10,3)) as [PurchaseInvoiceQty],
	   CAST(cast(count([MinOrderQty]) as decimal) /count(*) AS decimal(10,3)) as [MinOrderQty],
	   CAST(cast(count(NULLIF([UoM],'')) as decimal) /count(*) AS decimal(10,3)) as [UoM],
	   CAST(cast(count([UnitPrice]) as decimal) /count(*) AS decimal(10,3)) as [UnitPrice],
	   CAST(cast(count([DiscountPercent]) as decimal) /count(*) AS decimal(10,3)) as [DiscountPercent],
	   CAST(cast(count([DiscountAmount]) as decimal) /count(*) AS decimal(10,3)) as [DiscountAmount],
	   CAST(cast(count([LandedCost]) as decimal) /count(*) AS decimal(10,3)) as [LandedCost],
	   CAST(cast(count([ExchangeRate]) as decimal) /count(*) AS decimal(10,3)) as [ExchangeRate],
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count(NULLIF([PurchaserName],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaserName],
	   CAST(cast(count(NULLIF([WarehouseCode],'')) as decimal) /count(*) AS decimal(10,3)) as [WarehouseCode],
	   CAST(cast(count(NULLIF([ReceivingNum],'')) as decimal) /count(*) AS decimal(10,3)) as [ReceivingNum],
	   CAST(cast(count(NULLIF([DelivTime],'')) as decimal) /count(*) AS decimal(10,3)) as [DelivTime],
	   CAST(cast(count(NULLIF([PurchaseChannel],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseChannel],
	   CAST(cast(count(NULLIF([Documents],'')) as decimal) /count(*) AS decimal(10,3)) as [Documents],
	   CAST(cast(count(NULLIF([Comments],'')) as decimal) /count(*) AS decimal(10,3)) as [Comments],
	   CAST(cast(count(NULLIF([PORes1],'')) as decimal) /count(*) AS decimal(10,3)) as [PORes1],
	   CAST(cast(count(NULLIF([PORes2],'')) as decimal) /count(*) AS decimal(10,3)) as [PORes2],
	   CAST(cast(count(NULLIF([PORes3],'')) as decimal) /count(*) AS decimal(10,3)) as [PORes3],
	   CAST(cast(count(NULLIF([OrgCommittedDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [OrgCommittedDelivDate],
	   CAST(cast(count(NULLIF([OrgCommittedShipDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [OrgCommittedShipDate],
	   CAST(cast(count(NULLIF([ActualShipDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [ActualShipDate],
	   CAST(cast(count([IsClosed]) as decimal) /count(*) AS decimal(10,3)) as [IsOrderClosed], -- changed from IsClosed
	   CAST(cast(count([IsActiveRecord]) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord],
	   CAST(cast(count(NULLIF([CommittedShipDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [CommittedShipDate]
	 

		 


from dw.PurchaseOrder
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([PurchaseOrderNum], [PurchaseOrderLine], [PurchaseOrderSubLine], [PurchaseOrderType], [PurchaseOrderDate], [PurchaseOrderStatus], [OrgReqDelivDate], [CommittedDelivDate], [ActualDelivDate], [ReqDelivDate],
	                                         [PurchaseInvoiceNum], [PartNum],  [SupplierNum], [SupplierPartNum], [SupplierInvoiceNum], [DelivCustomerNum], [PartStatus],[PurchaseOrderQty] ,[PurchaseReceiveQty] , [PurchaseInvoiceQty], [MinOrderQty], 
											 [UoM], [UnitPrice], [DiscountPercent],[DiscountAmount], [LandedCost],[ExchangeRate] ,[Currency] , [PurchaserName], [WarehouseCode], [ReceivingNum], [DelivTime], [PurchaseChannel], [Documents], [Comments], [PORes1], [PORes2], [PORes3], [OrgCommittedDelivDate], [OrgCommittedShipDate], [ActualShipDate], [IsOrderClosed], [IsActiveRecord],[CommittedShipDate]
											  ) 
			  ) as Unpivoted
) as subq_unpivoted


UNION ALL




-- dw.Budget
SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company,   'dw.Budget' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
       Company,
       CAST(cast(count(NULLIF([BudgetPeriod],'')) as decimal) /count(*) AS decimal(10,3)) as [BudgetPeriod],
	   CAST(cast(count(NULLIF([BudgetPeriodDate],'')) as decimal) /count(*) AS decimal(10,3)) as [BudgetPeriodDate],
	   CAST(cast(count(NULLIF([BudgetType],'')) as decimal) /count(*) AS decimal(10,3)) as [BudgetType],
	   CAST(cast(count(NULLIF([PeriodType],'')) as decimal) /count(*) AS decimal(10,3)) as [PeriodType],
	   CAST(cast(count(NULLIF([CustomerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CustomerNum],
	   CAST(cast(count(NULLIF([ProjectNum],'')) as decimal) /count(*) AS decimal(10,3)) as [ProjectNum],
	   --CAST(cast(count(NULLIF([AccountNum],'')) as decimal) /count(*) AS decimal(10,3)) as [AccountNum], removed from SC
	   CAST(cast(count(NULLIF([Department],'')) as decimal) /count(*) AS decimal(10,3)) as [Department], -- Added 2023-03-03 SB
	   CAST(cast(count(NULLIF([CustomerGroup],'')) as decimal) /count(*) AS decimal(10,3)) as [CustomerGroup],
	   CAST(cast(count(NULLIF([ProductGroup],'')) as decimal) /count(*) AS decimal(10,3)) as [ProductGroup],
	   --CAST(cast(count(NULLIF([SalesPersonCode],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesPersonCode], removed from SC
	   CAST(cast(count(NULLIF([SalesPersonName],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesPerson], -- Changed AS statement due to name change 2023-03-08 SB
	   CAST(cast(count(NULLIF([BudgetDescription],'')) as decimal) /count(*) AS decimal(10,3)) as [BudgetDescription],
	   CAST(cast(count([BudgetSales]) as decimal) /count(*) AS decimal(10,3)) as [BudgetSales],
	   CAST(cast(count([BudgetCost]) as decimal) /count(*) AS decimal(10,3)) as [BudgetCost],
	   CAST(cast(count([GrossProfitInvoiced]) as decimal) /count(*) AS decimal(10,3)) as [BudgetGrossProfit], --Changed  2023-03-03 [GrossProfitInvoiced]
	   CAST(cast(count([GrossMarginInvoicedPercent]) as decimal) /count(*) AS decimal(10,3)) as [BudgetGrossMargin], -- [GrossMarginInvoicedPercent]
	   CAST(cast(count([ExchangeRate]) as decimal) /count(*) AS decimal(10,3)) as [ExchangeRate], -- Add when in DW table 
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count(NULLIF(BRes1,'')) as decimal) /count(*) AS decimal(10,3)) as BRes1,
	   CAST(cast(count(NULLIF(BRes2,'')) as decimal) /count(*) AS decimal(10,3)) as BRes2,
	   CAST(cast(count(NULLIF(BRes3,'')) as decimal) /count(*) AS decimal(10,3)) as BRes3


from dw.Budget
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([BudgetPeriod], [BudgetPeriodDate],[BudgetType], [PeriodType], [CustomerNum], [ProjectNum],  [Department], [CustomerGroup], [ProductGroup], [SalesPerson],  [BudgetDescription], [BudgetSales], [BudgetCost], [BudgetGrossProfit], [BudgetGrossMargin], [ExchangeRate], [Currency], BRes1, BRes2, BRes3 
											  ) 
			  ) as Unpivoted
) as subq_unpivoted


UNION ALL


--dw.SalesInvoice
SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.SalesInvoice' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
       Company,
       CAST(cast(count(NULLIF([SalesPersonName],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesPerson], -- Changed AS statement due to name change 2023-03-08 SB
	   CAST(cast(count(NULLIF([CustomerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CustomerNum],
	   CAST(cast(count(NULLIF([PartNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PartNum],
	   CAST(cast(count(NULLIF([PartType],'')) as decimal) /count(*) AS decimal(10,3)) as [PartType],
	   CAST(cast(count(NULLIF([SalesOrderNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderNum],
	   CAST(cast(count(NULLIF([SalesOrderLine],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderLine],
	   CAST(cast(count(NULLIF([SalesOrderSubLine],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderSubLine],
	   CAST(cast(count(NULLIF([SalesOrderType],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderType],
	   CAST(cast(count(NULLIF([SalesInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceNum],
	   CAST(cast(count(NULLIF([SalesInvoiceLine],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceLine],
	   CAST(cast(count(NULLIF([SalesInvoiceType],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceType],
	   CAST(cast(count(NULLIF([SalesInvoiceDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceDate],
	   CAST(cast(count(NULLIF([ActualDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [ActualDelivDate],
	   CAST(cast(count([SalesInvoiceQty]) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceQty],
	   CAST(cast(count(NULLIF([UoM],'')) as decimal) /count(*) AS decimal(10,3)) as [UoM],
	   CAST(cast(count([UnitPrice]) as decimal) /count(*) AS decimal(10,3)) as [UnitPrice],
	   CAST(cast(count([UnitCost]) as decimal) /count(*) AS decimal(10,3)) as [UnitCost],
	   CAST(cast(count([DiscountPercent]) as decimal) /count(*) AS decimal(10,3)) as [DiscountPercent],
	   CAST(cast(count([DiscountAmount]) as decimal) /count(*) AS decimal(10,3)) as [DiscountAmount],
	   CAST(cast(count([TotalMiscChrg]) as decimal) /count(*) AS decimal(10,3)) as [TotalMiscChrg],
	   CAST(cast(count([VATAmount]) as decimal) /count(*) AS decimal(10,3)) as [VATAmount],
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count([ExchangeRate]) as decimal) /count(*) AS decimal(10,3)) as [ExchangeRate],
	   CAST(cast(count(NULLIF([CreditMemo],'')) as decimal) /count(*) AS decimal(10,3)) as [IsCreditMemo], -- Changed AS statement due to name change 2023-03-08 SB
	   CAST(cast(count(NULLIF([SalesChannel],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesChannel],
	   CAST(cast(count(NULLIF([Department],'')) as decimal) /count(*) AS decimal(10,3)) as [DepartmentCode],
	   CAST(cast(count(NULLIF([WarehouseCode],'')) as decimal) /count(*) AS decimal(10,3)) as [WarehouseCode],
	   CAST(cast(count(NULLIF([CostBearerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CostBearerNum],
	   CAST(cast(count(NULLIF([CostUnitNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CostUnitNum],
	   CAST(cast(count(NULLIF([ReturnComment],'')) as decimal) /count(*) AS decimal(10,3)) as [ReturnComment],
	   CAST(cast(count(NULLIF([ReturnNum],'')) as decimal) /count(*) AS decimal(10,3)) as [ReturnNum],
	   CAST(cast(count(NULLIF([ProjectNum],'')) as decimal) /count(*) AS decimal(10,3)) as [ProjectNum],
	   CAST(cast(count(NULLIF([IndexKey],'')) as decimal) /count(*) AS decimal(10,3)) as [IndexKey],
	   CAST(cast(count(NULLIF([SIRes1],'')) as decimal) /count(*) AS decimal(10,3)) as [SIRes1],
	   CAST(cast(count(NULLIF([SIRes2],'')) as decimal) /count(*) AS decimal(10,3)) as [SIRes2],
	   CAST(cast(count(NULLIF([SIRes3],'')) as decimal) /count(*) AS decimal(10,3)) as [SIRes3],
	   CAST(cast(count([IsUpdatingStock]) as decimal) /count(*) AS decimal(10,3)) as [IsUpdatingStock],
	   CAST(cast(count([SIRes4]) as decimal) /count(*) AS decimal(10,3)) as [SIRes4],
	   CAST(cast(count([SIRes5]) as decimal) /count(*) AS decimal(10,3)) as [SIRes5],
	   CAST(cast(count([SIRes6]) as decimal) /count(*) AS decimal(10,3)) as [SIRes6],
	   CAST(cast(count([CashDiscountOffered]) as decimal) /count(*) AS decimal(10,3)) as [CashDiscountOffered],
	   CAST(cast(count([CashDiscountUsed]) as decimal) /count(*) AS decimal(10,3)) as [CashDiscountUsed],
	   CAST(cast(count(NULLIF([DeliveryAddress],'')) as decimal) /count(*) AS decimal(10,3)) as [DeliveryAddressLine], --DeliverAddressLine in SC
	   CAST(cast(count([DeliveryCity]) as decimal) /count(*) AS decimal(10,3)) as [DeliveryCity], 
	   CAST(cast(count([DeliveryCountry]) as decimal) /count(*) AS decimal(10,3)) as [DeliveryCountry],
	   CAST(cast(count([DeliveryZipCode]) as decimal) /count(*) AS decimal(10,3)) as [DeliveryZipCode],
	   CAST(cast(count([InvoiceHandler]) as decimal) /count(*) AS decimal(10,3)) as [InvoiceHandler],
	   CAST(cast(count([IsActiveRecord]) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord],
	   CAST(cast(count([IsInvoiceClosed]) as decimal) /count(*) AS decimal(10,3)) as [IsInvoiceClosed],
	   CAST(cast(count([SalesInvoiceSubLine]) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceSubLine]
	

from dw.SalesInvoice
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([SalesPerson], [CustomerNum], [PartNum], [PartType], [SalesOrderNum], [SalesOrderLine], [SalesOrderSubLine], [SalesOrderType], [SalesInvoiceNum], [SalesInvoiceLine], [SalesInvoiceType], [SalesInvoiceDate],  [ActualDelivDate], [SalesInvoiceQty], [UoM], [UnitPrice], [UnitCost],[DiscountPercent] ,[DiscountAmount] , [TotalMiscChrg], [VATAmount], [Currency], [ExchangeRate], [IsCreditMemo],[SalesChannel], [DepartmentCode], [WarehouseCode], [CostBearerNum], [CostUnitNum],[ReturnComment] , [ReturnNum], [ProjectNum], [IndexKey], [SIRes1], [SIRes2], [SIRes3], [DeliveryAddressLine], [IsUpdatingStock], [SIRes4], [SIRes5], [SIRes6],[CashDiscountOffered],[CashDiscountUsed],[DeliveryCity],[DeliveryCountry],[DeliveryZipCode],[InvoiceHandler],[IsActiveRecord],[IsInvoiceClosed],[SalesInvoiceSubLine]
											  ) 
			  ) as Unpivoted
) as subq_unpivoted


UNION ALL


--dw.SalesLedger -
SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.SalesLedger' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
       Company,
       CAST(cast(count(NULLIF([CustomerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CustomerNum],
       CAST(cast(count(NULLIF([SalesInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceNum],
	   CAST(cast(count(NULLIF([SalesInvoiceDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceDate],
	   CAST(cast(count(NULLIF([SalesDueDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceDueDate], -- Changed AS statement due to name change 2023-03-08 SB
	   CAST(cast(count(NULLIF([SalesLastPaymentDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceLastPaymentDate], --Changed AS statement due to name change 2023-03-08 SB
	   CAST(cast(count([InvoiceAmount]) as decimal) /count(*) AS decimal(10,3)) as [InvoiceAmount],
	   CAST(cast(count([RemainingInvoiceAmount]) as decimal) /count(*) AS decimal(10,3)) as [RemainingInvoiceAmount],
	   CAST(cast(count([ExchangeRate]) as decimal) /count(*) AS decimal(10,3)) as [ExchangeRate],
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count([VATAmount]) as decimal) /count(*) AS decimal(10,3)) as [VATAmount],
	   CAST(cast(count(NULLIF([VATCode],'')) as decimal) /count(*) AS decimal(10,3)) as [VATCode],
	   CAST(cast(count(NULLIF([PayToName],'')) as decimal) /count(*) AS decimal(10,3)) as [PayToName],
	   CAST(cast(count(NULLIF([PayToCity],'')) as decimal) /count(*) AS decimal(10,3)) as [PayToCity],
	   CAST(cast(count(NULLIF([PayToContact],'')) as decimal) /count(*) AS decimal(10,3)) as [PayToContact],
	   CAST(cast(count(NULLIF([PaymentTerms],'')) as decimal) /count(*) AS decimal(10,3)) as [PaymentTerms],
	   CAST(cast(count([PaidInvoiceAmount]) as decimal) /count(*) AS decimal(10,3)) as [PaidInvoiceAmount],
	   CAST(cast(count(NULLIF([AccountingDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [AccountingDate],
	   CAST(cast(count(NULLIF([VATCodeDesc],'')) as decimal) /count(*) AS decimal(10,3)) as [VATCodeDesc],
	   CAST(cast(count(NULLIF([LinkToOriginalInvoice],'')) as decimal) /count(*) AS decimal(10,3)) as [LinkToOriginalInvoice],
	   CAST(cast(count(NULLIF([SLRes1],'')) as decimal) /count(*) AS decimal(10,3)) as [SLRes1],
	   CAST(cast(count(NULLIF([SLRes2],'')) as decimal) /count(*) AS decimal(10,3)) as [SLRes2],
	   CAST(cast(count(NULLIF([SLRes3],'')) as decimal) /count(*) AS decimal(10,3)) as [SLRes3],
	   CAST(cast(count(NULLIF([SalesPersonName],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesPerson],
	   CAST(cast(count(NULLIF([IsActiveRecord],'')) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord],
	   CAST(cast(count(NULLIF([IsInvoiceClosed],'')) as decimal) /count(*) AS decimal(10,3)) as [IsInvoiceClosed],
	   CAST(cast(count(NULLIF([PaymentEvents],'')) as decimal) /count(*) AS decimal(10,3)) as [PaymentEvents],
	   CAST(cast(count(NULLIF([SalesOrderNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderNum]

from dw.SalesLedger
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([CustomerNum], [SalesInvoiceNum], [SalesInvoiceDate],[SalesInvoiceDueDate], [SalesInvoiceLastPaymentDate], [InvoiceAmount], 
	 [RemainingInvoiceAmount], [ExchangeRate],[Currency], [VATAmount], [VATCode], [PayToName], [PayToCity], [PayToContact], [PaymentTerms], [PaidInvoiceAmount], [AccountingDate], [VATCodeDesc],[LinkToOriginalInvoice], [SLRes1], [SLRes2], [SLRes3],  [SalesPerson], [IsActiveRecord],[IsInvoiceClosed],[PaymentEvents],[SalesOrderNum]
											  ) 
			  ) as Unpivoted
) as subq_unpivoted


UNION ALL

--dw.SalesOrder
SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.SalesOrder' as SMSSTable, Field, [PercentageNull]
   FROM ( SELECT
       Company,
       CAST(cast(count(NULLIF([CustomerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CustomerNum],
	   CAST(cast(count(NULLIF([SalesOrderNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderNum],
	   CAST(cast(count(NULLIF([SalesOrderLine],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderLine],
	   CAST(cast(count(NULLIF([SalesOrderSubLine],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderSubLine],
	   CAST(cast(count(NULLIF([SalesOrderType],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderType],
	   CAST(cast(count(NULLIF([SalesOrderCategory],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderCategory],
	   CAST(cast(count(NULLIF([SalesOrderDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderDate],
	   --CAST(cast(count(NULLIF([NeedbyDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [NeedbyDate], --changed to ReqDelivDate in SC
	   CAST(cast(count(NULLIF([ExpDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [ExpDelivDate],
	   CAST(cast(count(NULLIF([ActualDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [ActualDelivDate],
	   CAST(cast(count(nullif([SalesInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceNum],
	   CAST(cast(count([SalesOrderQty]) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderQty],
	   CAST(cast(count([DelivQty]) as decimal) /count(*) AS decimal(10,3)) as [SalesDelivQty], -- Changed AS statement due to name change 2023-03-08 SB
	   CAST(cast(count([RemainingQty]) as decimal) /count(*) AS decimal(10,3)) as [SalesRemainingQty],  -- Changed AS statement due to name change 2023-03-08 SB
	   CAST(cast(count(NULLIF([UoM],'')) as decimal) /count(*) AS decimal(10,3)) as [UoM],
	   CAST(cast(count([UnitPrice]) as decimal) /count(*) AS decimal(10,3)) as [UnitPrice],
	   CAST(cast(count([UnitCost]) as decimal) /count(*) AS decimal(10,3)) as [UnitCost],
	   CAST(cast(count([ExchangeRate]) as decimal) /count(*) AS decimal(10,3)) as [ExchangeRate],
	  -- CAST(cast(count(Nullif([OpenRelease],'')) as decimal) /count(*) AS decimal(10,3)) as [OpenRelease], changed to IsOrderClosed in SC
	   CAST(cast(count([DiscountAmount]) as decimal) /count(*) AS decimal(10,3)) as [DiscountAmount],
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count([DiscountPercent]) as decimal) /count(*) AS decimal(10,3)) as [DiscountPercent],
	   CAST(cast(count(NULLIF([PartNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PartNum],
	   CAST(cast(count(NULLIF([PartType],'')) as decimal) /count(*) AS decimal(10,3)) as [PartType],
	   CAST(cast(count(NULLIF([PartStatus],'')) as decimal) /count(*) AS decimal(10,3)) as [PartStatus],
	   CAST(cast(count(NULLIF([SalesPersonName],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesPerson], -- Changed AS statement due to name change 2023-03-08 SB
	   CAST(cast(count(NULLIF([WarehouseCode],'')) as decimal) /count(*) AS decimal(10,3)) as [WarehouseCode],
	   CAST(cast(count(NULLIF([SalesChannel],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesChannel],
	   CAST(cast(count(NULLIF([Department],'')) as decimal) /count(*) AS decimal(10,3)) as [DepartmentCode],
	   CAST(cast(count(NULLIF([ProjectNum],'')) as decimal) /count(*) AS decimal(10,3)) as [ProjectNum],
	   CAST(cast(count(NULLIF([IndexKey],'')) as decimal) /count(*) AS decimal(10,3)) as [IndexKey],
	   CAST(cast(count(NULLIF([SORes1],'')) as decimal) /count(*) AS decimal(10,3)) as [SORes1],
	   CAST(cast(count(NULLIF([Cancellation],'')) as decimal) /count(*) AS decimal(10,3)) as [Cancellation],
	   CAST(cast(count(NULLIF([SORes2],'')) as decimal) /count(*) AS decimal(10,3)) as [SORes2],
	   CAST(cast(count(NULLIF([SORes3],'')) as decimal) /count(*) AS decimal(10,3)) as [SORes3],
	   --CAST(cast(count(NULLIF([ConfirmedDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [ConfirmedDelivDate], changed to CommittedDelivDate in SC
	   CAST(cast(count([SalesInvoiceQty]) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceQty],
	   --CAST(cast(count([TotalMiscChrg]) as decimal) /count(*) AS decimal(10,3)) as [TotalMiscChrg], -- not in SC anymore
	   CAST(cast(count([IsUpdatingStock]) as decimal) /count(*) AS decimal(10,3)) as [IsUpdatingStock],
	   CAST(cast(count([SORes4]) as decimal) /count(*) AS decimal(10,3)) as [SORes4],
	   CAST(cast(count([SORes5]) as decimal) /count(*) AS decimal(10,3)) as [SORes5],
	   CAST(cast(count([SORes6]) as decimal) /count(*) AS decimal(10,3)) as [SORes6],
	   CAST(cast(count(NULLIF([ActualShipDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [ActualShipDate],
	   CAST(cast(count(NULLIF([CommittedDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [CommittedDelivDate],
	   CAST(cast(count(NULLIF([ExpShipDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [ExpShipDate],
	   CAST(cast(count([IsActiveRecord]) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord],
	   CAST(cast(count([IsOrderClosed]) as decimal) /count(*) AS decimal(10,3)) as [IsOrderClosed],
	   CAST(cast(count(NULLIF([OrderHandler],'')) as decimal) /count(*) AS decimal(10,3)) as [OrderHandler],
	   CAST(cast(count(NULLIF([OrgCommittedDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [OrgCommittedDelivDate],
	   CAST(cast(count(NULLIF([OrgExpDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [OrgExpDelivDate],
	   CAST(cast(count(NULLIF([OrgExpShipDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [OrgExpShipDate],
	   CAST(cast(count(NULLIF([OrgReqDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [OrgReqDelivDate],
	   CAST(cast(count(NULLIF([ReqDelivDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [ReqDelivDate]

from dw.SalesOrder
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ( [CustomerNum],[SalesOrderNum],[SalesOrderLine],[SalesOrderSubLine],[SalesOrderType],[SalesOrderCategory],[SalesOrderDate],[ExpDelivDate],[ActualDelivDate],[SalesInvoiceNum], [SalesOrderQty],[SalesDelivQty],[SalesRemainingQty],[UoM],[UnitPrice],[UnitCost],[Currency],[ExchangeRate],[DiscountAmount],[DiscountPercent],[PartNum],[PartType],[PartStatus],[SalesPerson],[WarehouseCode],[SalesChannel],[DepartmentCode],[ProjectNum],[IndexKey],[Cancellation],[SORes1],[SORes2],[SORes3],[SalesInvoiceQty], [IsUpdatingStock], [SORes4], [SORes5], [SORes6],[ActualShipDate],[CommittedDelivDate],[ExpShipDate],[IsActiveRecord],[IsOrderClosed], [OrderHandler],[OrgCommittedDelivDate],[OrgExpDelivDate],[OrgExpShipDate],[OrgReqDelivDate],[ReqDelivDate] 
											 )
			  ) as Unpivoted
) as subq_unpivoted


UNION ALL



--dw.SalesOrderLog

--SELECT *
--FROM( 
--   select Company, 'dw.SalesOrderLog' as SMSSTable, Field,  [PercentageNull]
--   FROM ( SELECT
--       Company,
--       CAST(cast(count(NULLIF([CustomerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CustomerNum],
--	   CAST(cast(count(NULLIF([SalesOrderNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderNum],
--	   CAST(cast(count(NULLIF([SalesOrderLine],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderLine],
--	   CAST(cast(count(NULLIF([SalesOrderSubLine],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderSubLine],
--	   CAST(cast(count(NULLIF([SalesOrderType],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderType],
--	   CAST(cast(count(NULLIF([SalesOrderLogType],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderLogType],
--	   CAST(cast(count(NULLIF([SalesOrderDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderDate],
--	   CAST(cast(count(NULLIF([SalesOrderLogDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderLogDate],
--	   CAST(cast(count([SalesInvoiceNum]) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceNum],
--	   CAST(cast(count([SalesOrderQty]) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderQty],
--	   CAST(cast(count([UoM]) as decimal) /count(*) AS decimal(10,3)) as [UoM],
--	   CAST(cast(count([UnitPrice]) as decimal) /count(*) AS decimal(10,3)) as [UnitPrice],
--	   CAST(cast(count([UnitCost]) as decimal) /count(*) AS decimal(10,3)) as [UnitCost],
--	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
--	   CAST(cast(count([ExchangeRate]) as decimal) /count(*) AS decimal(10,3)) as [ExchangeRate],
--	   CAST(cast(count(NULLIF([OpenRelease],'')) as decimal) /count(*) AS decimal(10,3)) as [OpenRelease],
--	   CAST(cast(count([DiscountPercent]) as decimal) /count(*) AS decimal(10,3)) as [DiscountPercent],
--	   CAST(cast(count([DiscountAmount]) as decimal) /count(*) AS decimal(10,3)) as [DiscountAmount],
--	   CAST(cast(count(NULLIF([PartNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PartNum],
--	   CAST(cast(count(NULLIF([PartType],'')) as decimal) /count(*) AS decimal(10,3)) as [PartType],
--	   CAST(cast(count(NULLIF([SalesPersonName],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesPersonName],
--	   CAST(cast(count(NULLIF([Department],'')) as decimal) /count(*) AS decimal(10,3)) as [Department],
--	   CAST(cast(count(NULLIF([ReturnComment],'')) as decimal) /count(*) AS decimal(10,3)) as [ReturnComment],
--	   CAST(cast(count(NULLIF([SalesReturnInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesReturnInvoiceNum],
--	   CAST(cast(count(NULLIF([CancellationCode],'')) as decimal) /count(*) AS decimal(10,3)) as [CancellationCode],
--	   CAST(cast(count(NULLIF([WarehouseCode],'')) as decimal) /count(*) AS decimal(10,3)) as [WarehouseCode],
--	   CAST(cast(count(NULLIF([IndexKey],'')) as decimal) /count(*) AS decimal(10,3)) as [IndexKey]

--from dw.SalesOrderLog
--where is_deleted != 1
--group by Company 
--) AS Grouped_Table
--	 UNPIVOT ([PercentageNull] FOR Field IN ([CustomerNum], [SalesOrderNum], [SalesOrderLine], [SalesOrderSubLine], [SalesOrderType], [SalesOrderLogType], [SalesOrderDate], [SalesOrderLogDate], [SalesInvoiceNum], [SalesOrderQty], [UoM], [UnitPrice],  [UnitCost], [Currency], [ExchangeRate], [OpenRelease], [DiscountPercent],[DiscountAmount] ,[PartNum] , [PartType], [SalesPersonName], [Department], [ReturnComment], [SalesReturnInvoiceNum],[CancellationCode], [WarehouseCode], [IndexKey]											 
--	                                         ) 
--			  ) as Unpivoted
--) as subq_unpivoted


--UNION ALL   


--dw.StockBalance
SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.StockBalance' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
       Company,
       CAST(cast(count(NULLIF([WarehouseCode],'')) as decimal) /count(*) AS decimal(10,3)) as [WarehouseCode],
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count(NULLIF([BinNum],'')) as decimal) /count(*) AS decimal(10,3)) as [BinNum],
	   --CAST(cast(count(NULLIF([BatchNum],'')) as decimal) /count(*) AS decimal(10,3)) as [BatchNum], not in SC any more
	   CAST(cast(count(NULLIF([SupplierNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierNum],
	   CAST(cast(count(NULLIF([PartNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PartNum],
	   CAST(cast(count(NULLIF([DelivTime],'')) as decimal) /count(*) AS decimal(10,3)) as [DelivTime],
	   CAST(cast(count(NULLIF([LastStockTakeDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [LastStockTakeDate],
	   CAST(cast(count(NULLIF([LastStdCostCalDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [LastStdCostCalDate],
	   CAST(cast(count([SafetyStock]) as decimal) /count(*) AS decimal(10,3)) as [SafetyStock],
	   CAST(cast(count([MaxStockQty]) as decimal) /count(*) AS decimal(10,3)) as [MaxStockQty],
	   CAST(cast(count([StockBalance]) as decimal) /count(*) AS decimal(10,3)) as [StockBalance],
	   CAST(cast(count([StockValue]) as decimal) /count(*) AS decimal(10,3)) as [StockValue],
	   --CAST(cast(count([ReserveQty]) as decimal) /count(*) AS decimal(10,3)) as [ReserveQty], not in SC anymore
	  -- CAST(cast(count([BackOrderQty]) as decimal) /count(*) AS decimal(10,3)) as [BackOrderQty], switched to SalesRemainingQty in SC
	   --CAST(cast(count([OrderQty]) as decimal) /count(*) AS decimal(10,3)) as [OrderQty], not in SC any more
	   CAST(cast(count([StockTakeDiff]) as decimal) /count(*) AS decimal(10,3)) as [StockTakeDiff],
	   CAST(cast(count([ReOrderLevel]) as decimal) /count(*) AS decimal(10,3)) as [ReOrderLevel],
	   CAST(cast(count([OptimalOrderQty]) as decimal) /count(*) AS decimal(10,3)) as [OptimalOrderQty],
	   CAST(cast(count([AvgCost]) as decimal) /count(*) AS decimal(10,3)) as [AvgCost],
	   CAST(cast(count(ExchangeRate) as decimal) /count(*) AS decimal(10,3)) as [ExchangeRate],
	   CAST(cast(count(IsActiveRecord) as decimal) /count(*) AS decimal(10,3)) as IsActiveRecord,
	   CAST(cast(count(PurchaseRemainingQty) as decimal) /count(*) AS decimal(10,3)) as PurchaseRemainingQty,
	   CAST(cast(count(SalesRemainingQty) as decimal) /count(*) AS decimal(10,3)) as SalesRemainingQty,
	   CAST(cast(count(NULLIF([SBRes1],'')) as decimal) /count(*) AS decimal(10,3)) as [SBRes1],
	   CAST(cast(count(NULLIF([SBRes2],'')) as decimal) /count(*) AS decimal(10,3)) as [SBRes2],
	   CAST(cast(count(NULLIF([SBRes3],'')) as decimal) /count(*) AS decimal(10,3)) as [SBRes3]
	
	
from dw.StockBalance
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([WarehouseCode], [Currency], [BinNum], [SupplierNum], [PartNum], [DelivTime], [LastStockTakeDate], [LastStdCostCalDate], [SafetyStock],
	                                         [MaxStockQty], [StockBalance],  [StockValue],  [StockTakeDiff],[ReOrderLevel] ,[OptimalOrderQty] , [AvgCost],[ExchangeRate],IsActiveRecord, PurchaseRemainingQty,SalesRemainingQty,[SBRes1],[SBRes2],[SBRes3]	  
											 ) 
			  ) as Unpivoted
) as subq_unpivoted


UNION ALL   


--dw.StockTransaction

SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company,   'dw.StockTransaction' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
       Company,
	   CAST(cast(count(NULLIF([WarehouseCode],'')) as decimal) /count(*) AS decimal(10,3)) as [WarehouseCode],
	   CAST(cast(count(NULLIF([TransactionCode],'')) as decimal) /count(*) AS decimal(10,3)) as [TransactionCode],
	   CAST(cast(count(NULLIF([IndexKey],'')) as decimal) /count(*) AS decimal(10,3)) as [IndexKey],
	   CAST(cast(count(NULLIF([TransactionDescription],'')) as decimal) /count(*) AS decimal(10,3)) as [TransactionCodeDescription], -- Changed AS statement due to name change 2023-03-08 SB
	  -- CAST(cast(count(NULLIF([IssuerReceiverNum],'')) as decimal) /count(*) AS decimal(10,3)) as [IssuerReceiverNum], not in SC anymore
	  -- CAST(cast(count(NULLIF([OrderNum],'')) as decimal) /count(*) AS decimal(10,3)) as [OrderNum], not in SC anymore
	  -- CAST(cast(count(NULLIF([OrderLine],'')) as decimal) /count(*) AS decimal(10,3)) as [OrderLine], not in SC anymore
	  -- CAST(cast(count(NULLIF([InvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [InvoiceNum], not in SC anymore
	  -- CAST(cast(count(NULLIF([InvoiceLine],'')) as decimal) /count(*) AS decimal(10,3)) as [InvoiceLine], not in SC anymore
	   CAST(cast(count(NULLIF([PartNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PartNum],
	   CAST(cast(count(NULLIF([BinNum],'')) as decimal) /count(*) AS decimal(10,3)) as [BinNum],
	   CAST(cast(count(NULLIF([BatchNum],'')) as decimal) /count(*) AS decimal(10,3)) as [BatchNum],
	   CAST(cast(count(NULLIF([TransactionDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [TransactionDate],
	   CAST(cast(count(NULLIF([TransactionTime],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [TransactionTime],
	   CAST(cast(count([TransactionQty]) as decimal) /count(*) AS decimal(10,3)) as [TransactionQty],
	   CAST(cast(count([TransactionValue]) as decimal) /count(*) AS decimal(10,3)) as [TransactionValue],
	   --CAST(cast(count([CostPrice]) as decimal) /count(*) AS decimal(10,3)) as [CostPrice], not in SC anymore
	   --CAST(cast(count([SalesUnitPrice]) as decimal) /count(*) AS decimal(10,3)) as [SalesUnitPrice], not in SC anymore
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count(NULLIF([Reference],'')) as decimal) /count(*) AS decimal(10,3)) as [Reference],
	  -- CAST(cast(count(NULLIF([AdjustmentDate],'1900-01-01')) as decimal) /count(*) AS decimal(10,3)) as [AdjustmentDate], not in SC anymore
	   CAST(cast(count(NULLIF([CustomerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CustomerNum],
	   CAST(cast(count(ExchangeRate) as decimal) /count(*) AS decimal(10,3)) as ExchangeRate,
	   CAST(cast(count(IsActiveRecord) as decimal) /count(*) AS decimal(10,3)) as IsActiveRecord,
	   CAST(cast(count(IsInternalTransaction) as decimal) /count(*) AS decimal(10,3)) as IsInternalTransaction,
	   CAST(cast(count(NULLIF([PurchaseInvoiceLine],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseInvoiceLine],
	   CAST(cast(count(NULLIF([PurchaseInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseInvoiceNum],
	   CAST(cast(count(NULLIF([PurchaseOrderLine],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderLine],
	   CAST(cast(count(NULLIF([PurchaseOrderNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PurchaseOrderNum],
	   CAST(cast(count(NULLIF([SalesInvoiceLine],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceLine],
	   CAST(cast(count(NULLIF([SalesInvoiceNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesInvoiceNum],
	   CAST(cast(count(NULLIF([SalesOrderLine],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderLine],
	   CAST(cast(count(NULLIF([SalesOrderNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SalesOrderNum],
	   CAST(cast(count(NULLIF([STRes1],'')) as decimal) /count(*) AS decimal(10,3)) as [STRes1],
	   CAST(cast(count(NULLIF([STRes2],'')) as decimal) /count(*) AS decimal(10,3)) as [STRes2],
	   CAST(cast(count(NULLIF([STRes3],'')) as decimal) /count(*) AS decimal(10,3)) as [STRes3],
	   CAST(cast(count(NULLIF([SupplierNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierNum]

from dw.StockTransaction
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([WarehouseCode], [TransactionCode],[IndexKey], [TransactionCodeDescription], [PartNum], [BinNum], [BatchNum], [TransactionDate],  [TransactionTime], [TransactionQty], [TransactionValue],[Currency] ,[Reference] ,[CustomerNum],ExchangeRate,	IsActiveRecord,	IsInternalTransaction,	[PurchaseInvoiceLine],[PurchaseInvoiceNum], [PurchaseOrderLine], [PurchaseOrderNum],[SalesInvoiceLine],[SalesInvoiceNum],[SalesOrderLine],[SalesOrderNum],[STRes1],[STRes2],[STRes3],[SupplierNum]
											 ) 
			  ) as Unpivoted
) as subq_unpivoted


UNION ALL   
    

--dw.Supplier
SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.Supplier' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
       Company,
       CAST(cast(count(NULLIF([SupplierNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierNum],
	   CAST(cast(count(NULLIF([MainSupplierName],'')) as decimal) /count(*) AS decimal(10,3)) as [ParentSupplierName],--Was MainSupplierName
	   CAST(cast(count(NULLIF([SupplierName],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierName],
	   CAST(cast(count(NULLIF([AddressLine1],'')) as decimal) /count(*) AS decimal(10,3)) as [AddressLine1],
	   CAST(cast(count(NULLIF([AddressLine2],'')) as decimal) /count(*) AS decimal(10,3)) as [AddressLine2],
	   CAST(cast(count(NULLIF([AddressLine3],'')) as decimal) /count(*) AS decimal(10,3)) as [AddressLine3],
	   CAST(cast(count(NULLIF([TelephoneNum],'')) as decimal) /count(*) AS decimal(10,3)) as [TelephoneNum1], --refers to old telephonenum field 2023-03-22 SB
	   CAST(cast(count(NULLIF([TelephoneNum2],'')) as decimal) /count(*) AS decimal(10,3)) as [TelephoneNum2],
	   CAST(cast(count(NULLIF([Email],'')) as decimal) /count(*) AS decimal(10,3)) as [Email],
	   CAST(cast(count(NULLIF([ZipCode],'')) as decimal) /count(*) AS decimal(10,3)) as [ZipCode],
	   CAST(cast(count(NULLIF([City],'')) as decimal) /count(*) AS decimal(10,3)) as [City],
	   CAST(cast(count(NULLIF([CountryCode],'')) as decimal) /count(*) AS decimal(10,3)) as [CountryCode],
	   CAST(cast(count(NULLIF([CountryName],'')) as decimal) /count(*) AS decimal(10,3)) as [CountryName],
	   CAST(cast(count(NULLIF([Region],'')) as decimal) /count(*) AS decimal(10,3)) as [State],
	  -- CAST(cast(count(NULLIF([SupplierCategory],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierCategory], not in SC anymore
	   CAST(cast(count(NULLIF([SupplierResponsible],'')) as decimal) /count(*) AS decimal(10,3)) as [PrimaryPurchaser], --was SupplierResponsible
	   --CAST(cast(count(NULLIF([AddressLine],'')) as decimal) /count(*) AS decimal(10,3)) as [AddressLine], not requested in SC
	   --CAST(cast(count(NULLIF([FullAddressLine],'')) as decimal) /count(*) AS decimal(10,3)) as [FullAddressLine], not in source
	   CAST(cast(count(NULLIF([AccountNum],'')) as decimal) /count(*) AS decimal(10,3)) as [AccountNum], 
	   CAST(cast(count(NULLIF([VATNum],'')) as decimal) /count(*) AS decimal(10,3)) as [VATNum],
	   CAST(cast(count(NULLIF([OrganizationNum],'')) as decimal) /count(*) AS decimal(10,3)) as [OrgNum],
	   CAST(cast(count(NULLIF([InternalExternal],'')) as decimal) /count(*) AS decimal(10,3)) as [IsAxInterInternal], -- InternalExternal
	   CAST(cast(count(NULLIF([IsCompanyGroupInternal],'')) as decimal) /count(*) AS decimal(10,3)) as [IsCompanyGroupInternal],
	   CAST(cast(count(NULLIF([CodeOfConduct],'')) as decimal) /count(*) AS decimal(10,3)) as [CodeOfConduct],
	   --CAST(cast(count(NULLIF([CustomerNum],'')) as decimal) /count(*) AS decimal(10,3)) as [CustomerNum], not in SC anymore
	   CAST(cast(count(NULLIF([SupplierScore],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierScore],
	   CAST(cast(count([MinOrderQty]) as decimal) /count(*) AS decimal(10,3)) as [MinOrderQty],
	   CAST(cast(count([MinOrderValue]) as decimal) /count(*) AS decimal(10,3)) as [MinOrderValue],
	   CAST(cast(count(NULLIF([Website],'')) as decimal) /count(*) AS decimal(10,3)) as [Website],
	   CAST(cast(count(NULLIF([Comments],'')) as decimal) /count(*) AS decimal(10,3)) as [Comments],
	   CAST(cast(count(NULLIF([SupplierGroup],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierGroup],
	   CAST(cast(count(NULLIF([SupplierSubGroup],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierSubGroup],
	   CAST(cast(count(NULLIF([SupplierIndustry],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierIndustry],
	   CAST(cast(count(NULLIF([SupplierSubIndustry],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierSubIndustry],
	   CAST(cast(count(NULLIF([SupplierType],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierType],
	   CAST(cast(count(NULLIF([MinOrderValueCurrency],'')) as decimal) /count(*) AS decimal(10,3)) as [MinOrderValueCurrency],
	   CAST(cast(count([IsActiveRecord]) as decimal) /count(*) AS decimal(10,3)) as [IsActiveRecord],
	   CAST(cast(count([IsBusinessGroupInternal]) as decimal) /count(*) AS decimal(10,3)) as [IsBusinessAreaInternal],--mistakenly IsBusinessGROUPInternal in DW?
	   CAST(cast(count(NULLIF([SRes1],'')) as decimal) /count(*) AS decimal(10,3)) as [SRes1],
	   CAST(cast(count(NULLIF([SRes2],'')) as decimal) /count(*) AS decimal(10,3)) as [SRes2],
	   CAST(cast(count(NULLIF([SRes3],'')) as decimal) /count(*) AS decimal(10,3)) as [SRes3]


from dw.Supplier
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([SupplierNum], [ParentSupplierName], [SupplierName], [AddressLine1], [AddressLine2], [AddressLine3], [TelephoneNum1], [TelephoneNum2], [Email], [ZipCode], [City], [State], [CountryCode], [CountryName], [PrimaryPurchaser], [AccountNum],[OrgNum],[VATNum] ,[IsAxInterInternal],[IsCompanyGroupInternal], [CodeOfConduct], [SupplierScore] ,[MinOrderQty], [MinOrderValue], [Website], [Comments],[SupplierGroup], [SupplierSubGroup], [SupplierIndustry], [SupplierSubIndustry], [SupplierType], [MinOrderValueCurrency],[IsActiveRecord],[IsBusinessAreaInternal], [SRes1], [SRes2], [SRes3]
	 ) 
			  ) as Unpivoted
) as subq_unpivoted


UNION ALL  

--dw.SupplierAgreement

SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company, 'dw.SupplierAgreement' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
       Company,
       CAST(cast(count(NULLIF([SupplierNum],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierNum],
	   CAST(cast(count(NULLIF([PartNum],'')) as decimal) /count(*) AS decimal(10,3)) as [PartNum],
	   CAST(cast(count(NULLIF([AgreementCode],'')) as decimal) /count(*) AS decimal(10,3)) as [AgreementCode],
	   CAST(cast(count(NULLIF([AgreementDescription],'')) as decimal) /count(*) AS decimal(10,3)) as [AgreementDescription],
	   CAST(cast(count([DiscountPercent]) as decimal) /count(*) AS decimal(10,3)) as [DiscountPercent],
	   CAST(cast(count([UnitPrice]) as decimal) /count(*) AS decimal(10,3)) as [UnitPrice],
	   CAST(cast(count(NULLIF([UoM],'')) as decimal) /count(*) AS decimal(10,3)) as [UoM],
	   CAST(cast(count([AgreementQty]) as decimal) /count(*) AS decimal(10,3)) as [AgreementQty],
	   CAST(cast(count([FulfilledQty]) as decimal) /count(*) AS decimal(10,3)) as [FulfilledQty],
	   CAST(cast(count([RemainingQty]) as decimal) /count(*) AS decimal(10,3)) as [RemainingQty],
	   CAST(cast(count(NULLIF([Currency],'')) as decimal) /count(*) AS decimal(10,3)) as [Currency],
	   CAST(cast(count(NULLIF([DelivTime],'')) as decimal) /count(*) AS decimal(10,3)) as [DelivTime],
	   CAST(cast(count(NULLIF([AgreementStart],'')) as decimal) /count(*) AS decimal(10,3)) as [AgreementStart],
	   CAST(cast(count(NULLIF([AgreementEnd],'')) as decimal) /count(*) AS decimal(10,3)) as [AgreementEnd],
	   CAST(cast(count(NULLIF([SupplierTerms],'')) as decimal) /count(*) AS decimal(10,3)) as [SupplierTerms],
	   CAST(cast(count(NULLIF(AgreementResponsible,'')) as decimal) /count(*) AS decimal(10,3)) as [AgreementResponsible],
	   CAST(cast(count(IsActiveRecord) as decimal) /count(*) AS decimal(10,3)) as IsActiveRecord,
	   CAST(cast(count(NULLIF(SARes1,'')) as decimal) /count(*) AS decimal(10,3)) as [SARes1],
	   CAST(cast(count(NULLIF(SARes2,'')) as decimal) /count(*) AS decimal(10,3)) as [SARes2],
	   CAST(cast(count(NULLIF(SARes3,'')) as decimal) /count(*) AS decimal(10,3)) as [SARes3]

from dw.SupplierAgreement
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN ([SupplierNum], [PartNum], [AgreementCode], [AgreementDescription], [DiscountPercent], [UnitPrice], [UoM], [AgreementQty], [FulfilledQty], [RemainingQty], [Currency], [DelivTime],  [AgreementStart], [AgreementEnd], [SupplierTerms],AgreementResponsible,IsActiveRecord,[SARes1],[SARes2],[SARes3]
											 ) 
			  ) as Unpivoted
) as subq_unpivoted

UNION ALL  
   

-- dimWarehouse
SELECT [Company], [PercentageNull], [Field], [SMSSTable]
FROM( 
   select Company,  'dw.Warehouse' as SMSSTable, Field,  [PercentageNull]
   FROM ( SELECT
       Company,
       CAST(cast(count(NULLIF(WarehouseCode,'')) as decimal) /count(*) AS decimal(10,3)) as WarehouseCode,
	   CAST(cast(count(NULLIF(WarehouseName,'')) as decimal) /count(*) AS decimal(10,3)) as WarehouseName,
	   --CAST(cast(count(NULLIF(WarehouseDistrict,'')) as decimal) /count(*) AS decimal(10,3)) as WarehouseDistrict,
	   CAST(cast(count(NULLIF(WarehouseAddress,'')) as decimal) /count(*) AS decimal(10,3)) as [Address], -- Changed AS statement due to name change 2023-03-08 SB
	   CAST(cast(count(NULLIF(WarehouseDescription,'')) as decimal) /count(*) AS decimal(10,3)) as WarehouseDescription,
	   CAST(cast(count(NULLIF(WarehouseType,'')) as decimal) /count(*) AS decimal(10,3)) as WarehouseType,
	   CAST(cast(count(NULLIF(WarehouseCountry,'')) as decimal) /count(*) AS decimal(10,3)) as CountryName, -- Changed AS statement due to name change 2023-03-08 SB
	   CAST(cast(count(NULLIF(WarehouseSite,'')) as decimal) /count(*) AS decimal(10,3)) as Site, -- Changed AS statement due to name change 2023-03-08 SB
	   CAST(cast(count(NULLIF(City,'')) as decimal) /count(*) AS decimal(10,3)) as City, 
	   CAST(cast(count(NULLIF(CountryCode,'')) as decimal) /count(*) AS decimal(10,3)) as CountryCode, 
	   CAST(cast(count(IsActiveRecord) as decimal) /count(*) AS decimal(10,3)) as IsActiveRecord,
	   CAST(cast(count(NULLIF(State,'')) as decimal) /count(*) AS decimal(10,3)) as State, 
	   CAST(cast(count(NULLIF(WhRes1,'')) as decimal) /count(*) AS decimal(10,3)) as WhRes1, 
	   CAST(cast(count(NULLIF(WhRes2,'')) as decimal) /count(*) AS decimal(10,3)) as WhRes2, 
	   CAST(cast(count(NULLIF(WhRes3,'')) as decimal) /count(*) AS decimal(10,3)) as WhRes3, 
	   CAST(cast(count(NULLIF(ZipCode,'')) as decimal) /count(*) AS decimal(10,3)) as ZipCode 

from dw.Warehouse
where is_deleted != 1
group by Company 
) AS Grouped_Table
	 UNPIVOT ([PercentageNull] FOR Field IN (WarehouseCode, WarehouseName,  Address, WarehouseDescription, WarehouseType, CountryName, Site,
	 City, CountryCode,  IsActiveRecord,State,  WhRes1,  WhRes2,  WhRes3, ZipCode 
											 ) 
			  ) as Unpivoted
) as subq_unpivoted



-- Join to get columns from Company table
) as CovAud
GO
