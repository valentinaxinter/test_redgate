IF OBJECT_ID('[prestage].[CYE_ES_Part_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[CYE_ES_Part_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [prestage].[CYE_ES_Part_Load]
AS
BEGIN

Truncate table stage.CYE_ES_Part

insert into [stage].[CYE_ES_Part](
	PartitionKey, Company, PartNum, PartDescription, PartDescription2, ProductGroup, ProductGroup2, CommodityCode, [CountryOfOrigin], NetWeight)
select PartitionKey, Company, PartNum, PartDescription, PartDescription2, ProductGroup, ProductGroup2, CommodityCode, [CountryOfOrigin], NetWeight from [prestage].[vCYE_ES_Part]

--Truncate table [prestage].[CYE_ES_Part]

End
GO
