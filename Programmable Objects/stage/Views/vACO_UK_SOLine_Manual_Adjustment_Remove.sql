IF OBJECT_ID('[stage].[vACO_UK_SOLine_Manual_Adjustment_Remove]') IS NOT NULL
	DROP VIEW [stage].[vACO_UK_SOLine_Manual_Adjustment_Remove];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[vACO_UK_SOLine_Manual_Adjustment_Remove]	AS

SELECT  DISTINCT 
	  [SOPNUMBE]
	,CAST(N'ACORNUK' AS nvarchar(50)) AS Company
  FROM [stage].[ACO_UK_SOLine_Manual_Adjustment_Remove]
  WHERE [SOPNUMBE] IS NOT NULL
GO
