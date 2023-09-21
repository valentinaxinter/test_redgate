IF OBJECT_ID('[audit].[WriteLog]') IS NOT NULL
	DROP PROCEDURE [audit].[WriteLog];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Richard Lautmann
-- Create date: 2016-04-18
-- Description:	Execution logs from stored procedures within the database
-- =============================================
CREATE PROCEDURE [audit].[WriteLog] (
									@PartitionKey varchar(50), 
									@ProcName varchar(50), 
									@FromTable varchar(50), 
									@ToTable varchar(50), 
									@StartTime datetime, 
									@EndTime datetime,
									@rowsAffected int,
									@StatusName varchar(50), 
									@ErrorMessage varchar(max),
									@MergeExecuted varchar(50),
									@Date date)
AS
BEGIN
	SET NOCOUNT ON;

	insert into audit.RunLog ( PartitionKey, ProcName, FromTable, ToTable, StartTime, EndTime,rowsAffected, StatusName, ErrorMessage, MergeExecuted, Date)
	values ( @PartitionKey, @ProcName, @FromTable, @ToTable, @StartTime, @EndTime,@rowsAffected,@StatusName, @ErrorMessage, @MergeExecuted, @Date)

END
GO
