IF OBJECT_ID('[dbo].[removeAlphabetLetters]') IS NOT NULL
	DROP FUNCTION [dbo].[removeAlphabetLetters];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[removeAlphabetLetters](
	@inputString nvarchar(500))
returns nvarchar(500)
as
begin

	declare 
		@outputString nvarchar(500)

	SET @outputString = @inputString

	WHILE PATINDEX('%[a-zA-Z]%', @outputString) > 0
	BEGIN
	  SET @outputString = STUFF(@outputString, PATINDEX('%[a-zA-Z]%', @outputString), 1, '')
	END

	return @outputString
END
;
GO
