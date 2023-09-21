IF OBJECT_ID('[dm_DS].[DimRLS]') IS NOT NULL
	DROP VIEW [dm_DS].[DimRLS];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_DS].[DimRLS] AS
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
WHERE BusinessArea = 'Driveline Solutions'
GO
