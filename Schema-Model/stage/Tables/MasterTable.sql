﻿/*
    This script was generated by SQL Change Automation to help provide object-level history. This script should never be edited manually.
    For more information see: https://www.red-gate.com/sca/dev/offline-schema-model
*/

CREATE TABLE [stage].[MasterTable]
(
[duns] [int] NULL,
[organization.controlOwnershipDate] [nvarchar] (100) NULL,
[organization.controlOwnershipType.description] [nvarchar] (100) NULL,
[organization.corporateLinkage.domesticUltimate.duns] [nvarchar] (100) NULL,
[organization.corporateLinkage.domesticUltimate.primaryName] [nvarchar] (250) NULL,
[organization.corporateLinkage.globalUltimate.duns] [nvarchar] (100) NULL,
[organization.corporateLinkage.globalUltimate.primaryName] [nvarchar] (250) NULL,
[organization.corporateLinkage.parent.duns] [nvarchar] (100) NULL,
[organization.corporateLinkage.parent.primaryName] [nvarchar] (250) NULL,
[organization.legalForm.description] [nvarchar] (100) NULL,
[organization.legalForm.startDate] [nvarchar] (100) NULL,
[organization.primaryName] [nvarchar] (250) NULL,
[organization.registeredDetails.legalForm.description] [nvarchar] (100) NULL,
[organization.registeredName] [nvarchar] (300) NULL,
[organization.corporateLinkage.headQuarter.duns] [nvarchar] (100) NULL,
[organization.corporateLinkage.headQuarter.primaryName] [nvarchar] (250) NULL,
[organization.legalForm.registrationLocation.addressRegion] [nvarchar] (100) NULL,
[organization.primaryAddress] [nvarchar] (200) NULL,
[organization.primaryAddress.addressCountry.name] [nvarchar] (100) NULL,
[organization.primaryAddress.addressCounty.name] [nvarchar] (100) NULL,
[organization.primaryAddress.addressLocality.name] [nvarchar] (100) NULL,
[organization.primaryAddress.addressRegion.name] [nvarchar] (100) NULL,
[organization.primaryAddress.continentalRegion.name] [nvarchar] (100) NULL,
[organization.primaryAddress.latitude] [nvarchar] (25) NULL,
[organization.primaryAddress.longitude] [nvarchar] (25) NULL,
[organization.primaryAddress.postalCode] [nvarchar] (30) NULL,
[organization.corporateLinkage.hierarchyLevel] [nvarchar] (10) NULL,
[organization.corporateLinkage.role] [nvarchar] (35) NULL,
[organization.isStandalone] [bit] NULL,
[organization.dunsControlStatus.operatingStatus.description] [nvarchar] (200) NULL
)
GO
