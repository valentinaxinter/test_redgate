IF OBJECT_ID('[prestage].[TRA_FR_Supplier_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[TRA_FR_Supplier_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [prestage].[TRA_FR_Supplier_Load] AS
BEGIN

Truncate table stage.[TRA_FR_Supplier]

INSERT INTO 
	stage.TRA_FR_Supplier(PartitionKey, Company,  [SupplierNum], [MainSupplierName], [SupplierName], [AddressLine1], [AddressLine2], [AddressLine3], [TelephoneNum], [Email], [ZipCode], [City], [District], [CountryName], [Region], [SupplierCategory], [SupplierResponsible], [AccountNum], [VATNum], [InternalExternal], [CodeOfConduct], [SupplierScore], [MinOrderQty], [MinOrderValue], [Website], [Comments], [SRes1], [SRes2], [SRes3])
SELECT 
	PartitionKey, Company,  [SupplierNum], [MainSupplierName], [SupplierName], [AddressLine1], [AddressLine2], [AddressLine3], [TelephoneNum], [Email], [ZipCode], [City], [District], [CountryName], [Region], [SupplierCategory], [SupplierResponsible], [AccountNum], [VATNum], [InternalExternal], [CodeOfConduct], [SupplierScore], [MinOrderQty], [MinOrderValue], [Website], [Comments], [SRes1], [SRes2], [SRes3]
FROM 
	[prestage].[vTRA_FR_Supplier]

--Truncate table prestage.[TRA_FR_Supplier]

End
GO
