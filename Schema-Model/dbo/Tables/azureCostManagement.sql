﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [dbo].[azureCostManagement]
(
[InvoiceSectionName] [varchar] (50) NULL,
[AccountName] [varchar] (80) NULL,
[AccountOwnerId] [varchar] (80) NULL,
[SubscriptionId] [varchar] (100) NULL,
[SubscriptionName] [varchar] (50) NULL,
[ResourceGroup] [varchar] (50) NULL,
[ResourceLocation] [varchar] (30) NULL,
[Date] [date] NULL,
[ProductName] [varchar] (200) NULL,
[MeterCategory] [varchar] (50) NULL,
[MeterSubCategory] [nvarchar] (100) NULL,
[MeterId] [varchar] (100) NULL,
[MeterName] [varchar] (150) NULL,
[MeterRegion] [varchar] (40) NULL,
[UnitOfMeasure] [varchar] (50) NULL,
[Quantity] [decimal] (20, 15) NULL,
[EffectivePrice] [decimal] (20, 15) NULL,
[CostInBillingCurrency] [decimal] (20, 15) NULL,
[CostCenter] [varchar] (50) NULL,
[ConsumedService] [varchar] (80) NULL,
[ResourceId] [varchar] (200) NULL,
[Tags] [varchar] (200) NULL,
[OfferId] [varchar] (80) NULL,
[AdditionalInfo] [varchar] (200) NULL,
[ServiceInfo1] [varchar] (200) NULL,
[ServiceInfo2] [varchar] (200) NULL,
[ResourceName] [varchar] (80) NULL,
[ReservationId] [varchar] (200) NULL,
[ReservationName] [varchar] (200) NULL,
[UnitPrice] [decimal] (9, 2) NULL,
[ProductOrderId] [varchar] (200) NULL,
[ProductOrderName] [varchar] (200) NULL,
[Term] [varchar] (200) NULL,
[PublisherType] [varchar] (40) NULL,
[PublisherName] [varchar] (200) NULL,
[ChargeType] [varchar] (40) NULL,
[Frequency] [varchar] (40) NULL,
[PricingModel] [varchar] (40) NULL,
[AvailabilityZone] [varchar] (200) NULL,
[BillingAccountId] [int] NULL,
[BillingAccountName] [varchar] (100) NULL,
[BillingCurrencyCode] [varchar] (8) NULL,
[BillingPeriodStartDate] [date] NULL,
[BillingPeriodEndDate] [date] NULL,
[BillingProfileId] [int] NULL,
[BillingProfileName] [varchar] (80) NULL,
[InvoiceSectionId] [varchar] (200) NULL,
[IsAzureCreditEligible] [varchar] (15) NULL,
[PartNumber] [varchar] (12) NULL,
[PayGPrice] [varchar] (10) NULL,
[PlanName] [varchar] (200) NULL,
[ServiceFamily] [varchar] (60) NULL,
[CostAllocationRuleName] [varchar] (200) NULL,
[benefitId] [varchar] (200) NULL,
[benefitName] [varchar] (200) NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_BillingPeriodStartDate_BillingPeriodEndDate] ON [dbo].[azureCostManagement] ([BillingPeriodStartDate], [BillingPeriodEndDate])
GO
