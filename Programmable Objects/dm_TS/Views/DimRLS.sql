IF OBJECT_ID('[dm_TS].[DimRLS]') IS NOT NULL
	DROP VIEW [dm_TS].[DimRLS];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm_TS].[DimRLS] AS
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
WHERE BusinessArea = 'Transport Solutions' OR Company = 'CERPL'
GO
