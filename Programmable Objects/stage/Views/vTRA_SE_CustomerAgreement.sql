IF OBJECT_ID('[stage].[vTRA_SE_CustomerAgreement]') IS NOT NULL
	DROP VIEW [stage].[vTRA_SE_CustomerAgreement];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vTRA_SE_CustomerAgreement]
	AS select 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(AgreementCode),'#',TRIM([PartNum]),'#',TRIM(CustomerNum))))) AS CustomerAgreementID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) AS CustomerID  
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM([Currency])))) AS CurrencyID
	, PartitionKey
	, UPPER(Company) AS Company
	, nullif(trim(CustomerNum		  ),'') as CustomerNum
	, nullif(trim(PartNum			  ),'') as PartNum
	, nullif(trim(AgreementCode		  ),'') as AgreementCode
	, nullif(trim(AgreementDescription),'') as AgreementDescription
	, cast(nullif(trim(DiscountPercent),'') as decimal(18,4)) as DiscountPercent
	, cast(nullif(trim(UnitPrice),'') as decimal(18,4)) as UnitPrice
	, cast(nullif(trim(AgreementQty),'') as decimal(18,4)) as AgreementQty
	, cast(nullif(trim(FulfilledQty),'') as decimal(18,4)) as FulfilledQty
	, cast(nullif(trim(RemainingQty),'') as decimal(18,4)) as RemainingQty
	, nullif(trim(UoM	  ),'') as UoM
	, nullif(trim(Currency),'') as Currency
	, cast(DelivTime as smallint) as Delivtime
	, CAST(AgreementStart as date) as AgreementStart
	, CAST(AgreementEnd as date) as AgreementEnd
	, nullif(trim(AgreementResponsible),'') as AgreementResponsible
	,cast(RecordIsActive as bit) as IsActiveRecord
from stage.TRA_SE_CustomerAgreement
;
GO
