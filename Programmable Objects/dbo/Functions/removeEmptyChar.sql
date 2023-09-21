IF OBJECT_ID('[dbo].[removeEmptyChar]') IS NOT NULL
	DROP FUNCTION [dbo].[removeEmptyChar];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[removeEmptyChar] (@str nvarchar(2000))
RETURNS nvarchar(2000)
AS
BEGIN
     DECLARE @ShowWhiteSpace nvarchar(2000);
	   SET @ShowWhiteSpace = @str
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(32), '[?]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(13), '[CR]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(10), '[LF]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(9),  '[TAB]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(1),  '[SOH]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(2),  '[STX]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(3),  '[ETX]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(4),  '[EOT]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(5),  '[ENQ]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(6),  '[ACK]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(7),  '[BEL]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(8),  '[BS]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(11), '[VT]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(12), '[FF]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(14), '[SO]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(15), '[SI]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(16), '[DLE]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(17), '[DC1]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(18), '[DC2]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(19), '[DC3]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(20), '[DC4]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(21), '[NAK]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(22), '[SYN]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(23), '[ETB]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(24), '[CAN]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(25), '[EM]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(26), '[SUB]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(27), '[ESC]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(28), '[FS]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(29), '[GS]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(30), '[RS]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(31), '[US]	')
	   --SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(32), '') This is a normal space and there is no need to replace it

	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(13), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(10), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(9),  '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(1),  '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(2),  '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(3),  '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(4),  '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(5),  '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(6),  '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(7),  '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(8),  '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(11), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(12), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(14), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(15), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(16), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(17), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(18), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(19), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(20), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(21), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(22), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(23), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(24), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(25), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(26), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(27), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(28), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(29), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(30), '')
	   SET @ShowWhiteSpace = REPLACE( @ShowWhiteSpace, CHAR(31), '')
     RETURN(@ShowWhiteSpace)
END
GO
