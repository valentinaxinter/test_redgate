IF OBJECT_ID('[dw].[AllDates_Load]') IS NOT NULL
	DROP PROCEDURE [dw].[AllDates_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dw].[AllDates_Load] AS

/*
	Create Date: 2019-10-28
	Description: Inserts dates to the date table dw.Date. Should only be run once or if it needs to be refilled for some reason.
				Most of the Date attributes are added in the Date view (to create a more flexible solution) but some attributes needed to be created in the table for different reasons.

*/

BEGIN

	TRUNCATE TABLE [dbo].[AllDates]

	SET DATEFIRST 1 -- to Monday as first day of week

	DECLARE @StartDate DATE = '20050101', @NumberOfYears INT = 50;

	DECLARE @CutoffDate DATE = DATEADD(YEAR, @NumberOfYears, @StartDate);

	INSERT [dbo].[AllDates] (DateID, [Date], [WeekDayNo], DateCounter, YearMonthCounter, YearQuarterCounter)
	SELECT 
		CAST(CONVERT(VARCHAR(10), [Date], 112) AS int) AS DateID
		,[Date]
		,DATEPART(WEEKDAY, [Date]) AS [WeekDayNo] 
		,ROW_NUMBER() OVER (ORDER BY [Date]) AS DateCounter
		,DENSE_RANK() OVER (ORDER BY LEFT(CONVERT(varchar, [Date],112),6)) AS YearMonthCounter
		,DENSE_RANK() OVER (ORDER BY CONCAT(DATEPART(YEAR, [Date]),DATENAME(QUARTER, [Date]))) AS YearQuarterCounter
		
	FROM
	(
		SELECT [Date] = DATEADD(DAY, rn - 1, @StartDate)
		FROM 
		(
		SELECT TOP (DATEDIFF(DAY, @StartDate, @CutoffDate)) 
			rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
		FROM sys.all_objects AS s1
		CROSS JOIN sys.all_objects AS s2
		ORDER BY s1.[object_id]
		) AS x
	) AS y


END
GO
