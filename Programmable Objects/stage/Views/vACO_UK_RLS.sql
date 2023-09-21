IF OBJECT_ID('[stage].[vACO_UK_RLS]') IS NOT NULL
	DROP VIEW [stage].[vACO_UK_RLS];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/

create view [stage].[vACO_UK_RLS] AS

SELECT 
		CONCAT('ACORNUK', '-',[Email],'-',[Value],'-',RLSType) AS EmailID
		,FORMAT(GETDATE(),'yyyy-MM-dd hh:mm:ss') AS PartitionKey
		,'ACORNUK'	AS Company
	  ,[Value]	AS [Name]
      ,[Email]
      ,[RLSType]
  FROM [stage].[ACO_UK_RLS]
GO
