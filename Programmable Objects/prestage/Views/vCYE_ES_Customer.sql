IF OBJECT_ID('[prestage].[vCYE_ES_Customer]') IS NOT NULL
	DROP VIEW [prestage].[vCYE_ES_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [prestage].[vCYE_ES_Customer]
as
SELECT 
	  concat(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	  ,'CYESA' AS [Company]
	  ,[CustomerNum]
	  ,[CustomerName]
	  ,[AddressLine1]
	  ,[AddressLine2]
	  ,[AddressLine3]
	  ,TelephoneNumber1
	  ,Email
	  ,[CustomerScore]
	  ,[City]
	  ,[ZIP]
	  ,[State]
	  ,CountryCode
	  ,[CountryName]
	  ,[CustomerGroup]
	  ,CustomerSubGroup
	  ,'' AS [SalesRepCode]
	  ,[VATRegNr]
FROM [prestage].[CYE_ES_Customer]
GO
