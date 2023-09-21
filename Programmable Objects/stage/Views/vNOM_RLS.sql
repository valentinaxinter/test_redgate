IF OBJECT_ID('[stage].[vNOM_RLS]') IS NOT NULL
	DROP VIEW [stage].[vNOM_RLS];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vNOM_RLS] AS

SELECT  [EmailID]
		,CONVERT(varchar, GETDATE(), 20) AS PartitionKey
      ,[Company]
      ,[Name]
      ,[Email]
	  ,'To be defined'	AS RLSType
  FROM stage.NOM_RLS
GO
