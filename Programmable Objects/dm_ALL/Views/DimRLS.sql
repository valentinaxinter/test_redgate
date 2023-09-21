IF OBJECT_ID('[dm_ALL].[DimRLS]') IS NOT NULL
	DROP VIEW [dm_ALL].[DimRLS];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_ALL].[DimRLS] AS
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
FROM [dm].DimRLS
GO
