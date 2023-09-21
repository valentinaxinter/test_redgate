IF OBJECT_ID('[dbo].[udf_EasterSundayByYear]') IS NOT NULL
	DROP FUNCTION [dbo].[udf_EasterSundayByYear];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Easter Sunday Calculator - Ian Fahlman-Morgan - Axinter 10th June 2020
CREATE FUNCTION [dbo].[udf_EasterSundayByYear] 
(@Year CHAR(4)) 
RETURNS SMALLDATETIME 
AS 
BEGIN 

   DECLARE 
       @c INT 
       , @n INT 
       , @k INT 
       , @i INT 
       , @j INT 
       , @l INT 
       , @m INT 
       , @d INT 
       , @Easter DATETIME 

   SET @c = (@Year / 100) 
   SET @n = @Year - 19 * (@Year / 19) 
   SET @k = (@c - 17) / 25 
   SET @i = @c - @c / 4 - ( @c - @k) / 3 + 19 * @n + 15 
   SET @i = @i - 30 * ( @i / 30 ) 
   SET @i = @i - (@i / 28) * (1 - (@i / 28) * (29 / (@i + 1)) * ((21 - @n) / 11)) 
   SET @j = @Year + @Year / 4 + @i + 2 - @c + @c / 4 
   SET @j = @j - 7 * (@j / 7) 
   SET @l = @i - @j 
   SET @m = 3 + (@l + 40) / 44 
   SET @d = @l + 28 - 31 * ( @m / 4 ) 

   SET @Easter = (SELECT RIGHT('0' + CONVERT(VARCHAR(2),@m),2) + '/' + RIGHT('0' + CONVERT(VARCHAR(2),@d),2) + '/' + CONVERT(CHAR(4),@Year)) 

   RETURN @Easter 
END
GO
