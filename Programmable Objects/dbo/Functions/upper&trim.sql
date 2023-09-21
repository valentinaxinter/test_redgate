IF OBJECT_ID('[dbo].[upper&trim]') IS NOT NULL
	DROP FUNCTION [dbo].[upper&trim];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[upper&trim]
(
    @oldValue varchar(100)
)
RETURNS varchar(100)
AS
BEGIN
    DECLARE @Result varchar(100)
    -- do your custom manipulation here. this is just an example
    SELECT @Result = nullif(TRIM(UPPER(@oldValue)), '')
    RETURN @Result
END
GO
