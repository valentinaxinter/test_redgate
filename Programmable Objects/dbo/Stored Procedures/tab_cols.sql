IF OBJECT_ID('[dbo].[tab_cols]') IS NOT NULL
	DROP PROCEDURE [dbo].[tab_cols];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[tab_cols] (@tab nvarchar(255))
as
begin

    declare     @col_count  nvarchar(max) = ''
               ,@col        nvarchar(max) = ''

    select      @col_count += case ORDINAL_POSITION when 1 then '' else ',' end + 'count(' +  QUOTENAME(COLUMN_NAME,']') + ') as ' + QUOTENAME(COLUMN_NAME,']')
               ,@col       += case ORDINAL_POSITION when 1 then '' else ',' end + QUOTENAME(COLUMN_NAME,']')
    from        INFORMATION_SCHEMA.COLUMNS
    where       TABLE_NAME = @tab
    order by    ORDINAL_POSITION

    declare     @stmt nvarchar(max) = 'select * from (select ' + @col_count + ' from ' + @tab + ') t unpivot (val for col in (' + @col + ')) u'

    exec sp_executesql @stmt
end
GO
