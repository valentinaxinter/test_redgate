IF OBJECT_ID('[dbo].[ReplaceExactWord]') IS NOT NULL
	DROP FUNCTION [dbo].[ReplaceExactWord];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[ReplaceExactWord](
	@text nvarchar(max), 
	@find nvarchar(max), 
	@replace nvarchar(max))
returns nvarchar(max)
as
begin

	declare 
		@newText nvarchar(max) = '',
		@index bigint = 0,
		@currentWord nvarchar(max),
		@finder char(1)

	while @text <> ''
	begin	
		set @index = patindex('%[ ,'+char(10)+'('+char(13)+')'+char(9)+'.;|]%',@text)

		if @index>0 
		begin
			set @finder = substring(@text,@index,1)
		
			set @currentWord = CASE WHEN @index > 0 THEN substring(@text, 0, @index) ELSE @text END;
	
			if replace(replace(@currentWord,'[',''),']','') = @find
				SET @newText = @newText + @replace + @finder;
			else
				SET @newText = @newText + @currentWord + @finder;
	
			if @index = 0
				begin
					set @text = ''
				end
			else
				begin
					set @text = substring(@text, @index+1, len(@text)+2)
				end
		end
	end

	set @newText = rtrim(@newText)

	return @newText
END
;
GO
