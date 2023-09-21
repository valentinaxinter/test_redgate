IF OBJECT_ID('[dbo].[removeNonNumbers]') IS NOT NULL
	DROP FUNCTION [dbo].[removeNonNumbers];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[removeNonNumbers](
	@inputString nvarchar(500))
returns nvarchar(500)
as
begin

	declare 
		@outputString nvarchar(500)

	SET @outputString = @inputString

	WHILE PATINDEX('%[^0-9]%', @outputString) > 0
	BEGIN
		SET @outputString = REPLACE(@outputString, SUBSTRING(@outputString, PATINDEX('%[^0-9]%', @outputString), 1), '')
	END

	return @outputString
END
;
GO
