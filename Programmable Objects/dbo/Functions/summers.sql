IF OBJECT_ID('[dbo].[summers]') IS NOT NULL
	DROP FUNCTION [dbo].[summers];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create FUNCTION [dbo].[summers]
()
RETURNS nvarchar(12) -- or whatever length you need
AS
BEGIN
    Declare @companyCode nvarchar(12);
    SELECT @companyCode = 'GSUGB'

    RETURN  @companyCode

END
GO
