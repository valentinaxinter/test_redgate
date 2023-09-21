IF OBJECT_ID('[dbo].[cleanStr]') IS NOT NULL
	DROP FUNCTION [dbo].[cleanStr];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cleanStr]
(
@textString varchar(100))
RETURNS varchar(100) AS
BEGIN
	-- Return the result of the function
	RETURN replace(
				replace(@textString, ' ', '') ,'–', '-') 
				
END
GO
