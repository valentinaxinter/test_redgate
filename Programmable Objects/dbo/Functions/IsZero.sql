IF OBJECT_ID('[dbo].[IsZero]') IS NOT NULL
	DROP FUNCTION [dbo].[IsZero];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[IsZero] (
    @Number FLOAT,
    @IsZeroNumber FLOAT
)
RETURNS FLOAT
AS
BEGIN

    IF (@Number = 0)
    BEGIN
        SET @Number = @IsZeroNumber
    END

    RETURN (@Number)

END
GO
