IF OBJECT_ID('[dbo].[ProperCase]') IS NOT NULL
	DROP FUNCTION [dbo].[ProperCase];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[ProperCase](@Text as nvarchar(4000))
returns nvarchar(4000)
as
begin
  declare @Reset bit;
  declare @Ret nvarchar(4000);
  declare @i int;
  declare @c nchar(1);

  if @Text is null
    return null;

  select @Reset = 1, @i = 1, @Ret = '';

  while (@i <= len(@Text))
    select @c = substring(@Text, @i, 1),
      @Ret = @Ret + case when @Reset = 1 then UPPER(@c) else LOWER(@c) end,
      @Reset = case when @c like '[a-zA-Z]' then 0 else 1 end,
      @i = @i + 1
  return @Ret
end
GO
