IF OBJECT_ID('[dbo].[Split]') IS NOT NULL
	DROP FUNCTION [dbo].[Split];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- select dbo.Split('AOK4A#2012-06-14#1#AOK#ARN#XXX#EU#1','#',2)
-- select dbo.Split('CPHXXXEU_100418_100418','_',1)

CREATE  FUNCTION [dbo].[Split] 
(@fullString varchar(200), @separator char(1),@wordNo int) 
RETURNS VARCHAR(200) -- return_data_type. 
AS 
BEGIN 
    declare @wordPart varchar(200),@sepPos int=0, @wordCount int = 1
while @wordCount <= @wordNo
begin
 
   if @fullString = ''
return null
   set @sepPos = CHARINDEX(@separator, @fullString) 
   if @sepPos = 0
       set @sepPos = len(@fullString)
  
   set @wordPart = SUBSTRING(@fullString, 1, @sepPos)
   set @fullString = SUBSTRING(@fullString, @sepPos+1, LEN(@fullString))

   set @wordCount = @wordCount +1
end
 
    RETURN replace(@wordPart,@separator,'') 
END
GO
