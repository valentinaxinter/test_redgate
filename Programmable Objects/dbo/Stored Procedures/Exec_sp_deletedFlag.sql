IF OBJECT_ID('[dbo].[Exec_sp_deletedFlag]') IS NOT NULL
	DROP PROCEDURE [dbo].[Exec_sp_deletedFlag];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Exec_sp_deletedFlag] AS

execute sp.OLine_CYE_ES_deletedFlag
execute sp.OLine_ROR_SE_deletedFlag
execute sp.OLine_TMT_FI_deletedFlag
execute sp.OLine_TRA_FR_deletedFlag
execute sp.OLine_WID_EE_deletedFlag
execute sp.OLine_WID_FI_deletedFlag
execute sp.SOLine_WID_EE_deletedFlag
execute sp.SOLine_WID_FI_deletedFlag
GO
