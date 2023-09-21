IF OBJECT_ID('[dm_LS].[DimRLS]') IS NOT NULL
	DROP VIEW [dm_LS].[DimRLS];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_LS].[DimRLS] AS
SELECT 
	 [id]
,[Company]
,[Email]
,[RLSTable]
,[RLSField]
,[RLSValue]
,[AccessType]
,[SourceList]
,[Modified_at]
,[Author]
,[BusinessArea]
FROM [dm].DimRLS AS RLS
WHERE BusinessArea = 'Lifting Solutions'
GO
