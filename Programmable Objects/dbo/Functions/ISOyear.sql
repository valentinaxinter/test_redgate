IF OBJECT_ID('[dbo].[ISOyear]') IS NOT NULL
	DROP FUNCTION [dbo].[ISOyear];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[ISOyear](@date DATETIME)
returns SMALLINT
AS
BEGIN
     DECLARE @isoyear SMALLINT = CASE
         WHEN Datepart(isowk, @date)=1
             AND Month(@date)=12 THEN Year(@date)+1
         WHEN Datepart(isowk, @date)=53
             AND Month(@date)=1 THEN Year(@date)-1
         WHEN Datepart(isowk, @date)=52
             AND Month(@date)=1 THEN Year(@date)-1             
         ELSE Year(@date)
        END;
     RETURN @isoyear;
END;
GO
