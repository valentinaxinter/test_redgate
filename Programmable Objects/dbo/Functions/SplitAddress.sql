IF OBJECT_ID('[dbo].[SplitAddress]') IS NOT NULL
	DROP FUNCTION [dbo].[SplitAddress];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[SplitAddress] (
    @Address NVARCHAR(1000)
)
RETURNS NVARCHAR(1000)
AS
BEGIN
    DECLARE @Output NVARCHAR(1000) = ''
    DECLARE @SplitAddress TABLE (
        Id INT IDENTITY(1,1),
        Value NVARCHAR(500)
    )

    INSERT INTO @SplitAddress (Value)
    SELECT value FROM STRING_SPLIT(@Address, ' ')

    DECLARE @StreetAddress NVARCHAR(500)
    DECLARE @ZipCode NVARCHAR(10)
    DECLARE @City NVARCHAR(500)

    SET @StreetAddress = ''
    SET @ZipCode = ''
    SET @City = ''

    SELECT @StreetAddress = @StreetAddress + Value + ' '
    FROM @SplitAddress
    WHERE Id <= (SELECT MAX(Id) - 2 FROM @SplitAddress)

    SELECT @ZipCode = Value
    FROM @SplitAddress
    WHERE Id = (SELECT MAX(Id) - 1 FROM @SplitAddress)

    SELECT @City = Value
    FROM @SplitAddress
    WHERE Id = (SELECT MAX(Id) FROM @SplitAddress)

    SET @Output = LTRIM(RTRIM(@StreetAddress)) + '^' + LTRIM(RTRIM(@ZipCode)) + '^' + LTRIM(RTRIM(@City))

    RETURN @Output
END
GO
