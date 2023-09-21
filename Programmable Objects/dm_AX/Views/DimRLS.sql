IF OBJECT_ID('[dm_AX].[DimRLS]') IS NOT NULL
	DROP VIEW [dm_AX].[DimRLS];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dm_AX].[DimRLS] AS
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
WHERE [Company] in ('AXISE','AXHSE') -- HQ basket  SB 2023-02-07    -- previously WHERE BusinessArea = 'Finance'
GO
