IF OBJECT_ID('[prestage].[CYE_ES_Customer_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[CYE_ES_Customer_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/****** Object:  StoredProcedure [prestage].[CYE_ES_Customer_Load]    Script Date: 2020-04-07 11:43:49 ******/

CREATE PROCEDURE [prestage].[CYE_ES_Customer_Load] AS
BEGIN

Truncate table stage.[CYE_ES_Customer]

INSERT INTO 
	stage.CYE_ES_Customer(PartitionKey, Company, CustomerNum, CustomerName, AddressLine1, AddressLine2, AddressLine3, TelephoneNumber1, Email, CustomerScore, City, ZIP, [State], CountryCode, CountryName, CustomerGroup, CustomerSubGroup, VATRegNr)
SELECT 
	PartitionKey, Company, CustomerNum, CustomerName, AddressLine1, AddressLine2, AddressLine3, TelephoneNumber1, Email, CustomerScore, City, ZIP, [State], CountryCode, CountryName, CustomerGroup, CustomerSubGroup, VATRegNr 
FROM 
	[prestage].[vCYE_ES_Customer]

--Truncate table prestage.[CYE_ES_Customer]

End
GO
