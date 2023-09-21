IF OBJECT_ID('[dbo].[insertAzureCostManagement]') IS NOT NULL
	DROP PROCEDURE [dbo].[insertAzureCostManagement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[insertAzureCostManagement]  as

DECLARE @startDate DATE;
DECLARE @endDate DATE;

SELECT DISTINCT @startDate = BillingPeriodStartDate
	,@endDate = BillingPeriodEndDate
FROM stage.azureCostManagement;

DELETE
FROM dbo.azureCostManagement
WHERE BillingPeriodStartDate >= @startDate
	AND BillingPeriodEndDate <= @endDate;

INSERT INTO dbo.azureCostManagement (
	InvoiceSectionName
	,AccountName
	,AccountOwnerId
	,SubscriptionId
	,SubscriptionName
	,ResourceGroup
	,ResourceLocation
	,DATE
	,ProductName
	,MeterCategory
	,MeterSubCategory
	,MeterId
	,MeterName
	,MeterRegion
	,UnitOfMeasure
	,Quantity
	,EffectivePrice
	,CostInBillingCurrency
	,CostCenter
	,ConsumedService
	,ResourceId
	,Tags
	,OfferId
	,AdditionalInfo
	,ServiceInfo1
	,ServiceInfo2
	,ResourceName
	,ReservationId
	,ReservationName
	,UnitPrice
	,ProductOrderId
	,ProductOrderName
	,Term
	,PublisherType
	,PublisherName
	,ChargeType
	,Frequency
	,PricingModel
	,AvailabilityZone
	,BillingAccountId
	,BillingAccountName
	,BillingCurrencyCode
	,BillingPeriodStartDate
	,BillingPeriodEndDate
	,BillingProfileId
	,BillingProfileName
	,InvoiceSectionId
	,IsAzureCreditEligible
	,PartNumber
	,PayGPrice
	,PlanName
	,ServiceFamily
	,CostAllocationRuleName
	,benefitId
	,benefitName
	)
SELECT InvoiceSectionName
	,AccountName
	,AccountOwnerId
	,SubscriptionId
	,SubscriptionName
	,ResourceGroup
	,ResourceLocation
	,cast(DATE AS DATE) AS DATE
	,ProductName
	,MeterCategory
	,MeterSubCategory
	,MeterId
	,MeterName
	,MeterRegion
	,UnitOfMeasure
	,TRY_CAST(Quantity AS DECIMAL(20, 15)) AS Quantity
	,TRY_CAST(EffectivePrice AS DECIMAL(20, 15)) AS EffectivePrice
	,TRY_CAST(CostInBillingCurrency AS DECIMAL(20, 15)) AS CostInBillingCurrency
	,CostCenter
	,ConsumedService
	,ResourceId
	,Tags
	,OfferId
	,AdditionalInfo
	,ServiceInfo1
	,ServiceInfo2
	,ResourceName
	,ReservationId
	,ReservationName
	,TRY_CAST(UnitPrice AS DECIMAL(9, 2)) AS UnitPrice
	,ProductOrderId
	,ProductOrderName
	,Term
	,PublisherType
	,PublisherName
	,ChargeType
	,Frequency
	,PricingModel
	,AvailabilityZone
	,TRY_CAST(BillingAccountId AS INT) AS BillingAccountId
	,BillingAccountName
	,BillingCurrencyCode
	,cast(BillingPeriodStartDate AS DATE) AS BillingPeriodStartDate
	,cast(BillingPeriodEndDate AS DATE) AS BillingPeriodEndDate
	,TRY_CAST(BillingProfileId AS INT) AS BillingProfileId
	,BillingProfileName
	,InvoiceSectionId
	,IsAzureCreditEligible
	,PartNumber
	,PayGPrice
	,PlanName
	,ServiceFamily
	,CostAllocationRuleName
	,benefitId
	,benefitName
FROM stage.azureCostManagement;
GO
