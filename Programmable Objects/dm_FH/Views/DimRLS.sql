IF OBJECT_ID('[dm_FH].[DimRLS]') IS NOT NULL
	DROP VIEW [dm_FH].[DimRLS];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_FH].[DimRLS] AS
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
WHERE BusinessArea = 'Fluid Handling Solutions'
GO
