IF OBJECT_ID('[prestage].[TRA_FR_Part_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[TRA_FR_Part_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [prestage].[TRA_FR_Part_Load] AS
BEGIN

Truncate table stage.[TRA_FR_Part]

INSERT INTO 
	stage.TRA_FR_Part 
	(PartitionKey, Company, PartNum, PartName, PartDescription, PartDescription2, PartDescription3, ProductGroup, ProductGroup2, ProductGroup3, ProductGroup4, Brand, CommodityCode, PartReplacementNum, PartStatus, CountryOfOrigin, NetWeight, UoM, MainSupplier, AlternativeSupplier)
SELECT 
	PartitionKey, Company, PartNum, PartName, PartDescription, PartDescription2, PartDescription3, ProductGroup, ProductGroup2, ProductGroup3, ProductGroup4, Brand, CommodityCode, PartReplacementNum, PartStatus, CountryOfOrigin, NetWeight, UoM, MainSupplier, AlternativeSupplier
FROM 
	[prestage].[vTRA_FR_Part]

--Truncate table prestage.[TRA_FR_Part]

End
GO
