IF OBJECT_ID('[dbo].[update_dboCompany]') IS NOT NULL
	DROP PROCEDURE [dbo].[update_dboCompany];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[update_dboCompany] @sqlQuery nvarchar(500) as
begin try
	EXEC (@sqlQuery)
end try
begin catch
	IF @@TRANCOUNT > 0
		ROLLBACK;
	Raiserror('Error. Image might been named wrong',16,1);
end catch
GO
