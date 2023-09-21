IF OBJECT_ID('[audit].[AdfLog_test_dev]') IS NOT NULL
	DROP PROCEDURE [audit].[AdfLog_test_dev];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE procedure [audit].[AdfLog_test_dev] 
@PipelineRunID varchar(100),
@PipelineTriggerRunID varchar(100),
@PipelineName varchar(100),
@StartTime datetime,
@EndTime datetime,
@Status varchar(25),
@Stage varchar(25),
@TableName varchar(60),	
@ErrorMessage varchar(max),
@LogTable varchar(50),
@Company varchar(25),
@Triggered varchar(25),
@rowsCopied varchar(25) = null,
@timePeriod nvarchar(40) = null,
@PartitionKey varchar(50) = null

as

declare @date date;

set @date = CASE 
            WHEN DATEPART(HOUR, @StartTime) >= 21
                THEN cast(dateadd(dd,1,@StartTime ) as date)
            ELSE cast(@StartTime as date) 
			end


begin
	if @LogTable = 'CompanyHeaderPipelinesLog'
	
		INSERT INTO  audit.[CompanyHeaderPipelinesLog]
		(
		PipelineRunID
		,PipelineTriggerRunID
		,PipelineName
		,StartTime
		,EndTime
		,Status
		,Date
		,Triggered
		)
		VALUES (
		@PipelineRunID,
		@PipelineTriggerRunID,
		@PipelineName,
		@StartTime,
		@EndTime,
		@Status,
		@date,
		@Triggered
		);
		
	if @LogTable = 'CompanyLinePipelinesLog'
	
		INSERT INTO  audit.[CompanyLinePipelinesLog]
		(
		PipelineRunID
		,Company
		,StartTime
		,EndTime
		,Status
		,Date
		,Triggered
		)
		VALUES (
		@PipelineRunID,
		--@PipelineTriggerRunID,
		@Company,
		@StartTime,
		@EndTime,
		@Status,
		@date,
		@Triggered
		);
		
	if @LogTable = 'PipelinesActivitiesLog'
	
		INSERT INTO  audit.[PipelinesActivitiesLog]
		(
		PipelineRunID
		,PipelineTriggerRunID
		,Company
		,TableName
		,Stage
		,StartTime
		,EndTime
		,Status
		,ErrorMessage
		,rowsCopied
		,Date
		,Period
		,Triggered
		,PartitionKey
		)
		VALUES(
		@PipelineRunID,
		@PipelineTriggerRunID,
		@Company,
		@TableName,
		@Stage,
		@StartTime,
		@EndTime,
		@Status,
		@ErrorMessage,
		@rowsCopied,
		@date,
		nullif(replace(@timePeriod,'''',''),''),
		@Triggered,
		@PartitionKey
		)
		
	if @LogTable = 'ASModelLog'
	
		INSERT INTO  audit.[ASModelLog]
		(
		PipelineRunID
		,PipelineTriggerRunID
		,ASModelName
		,StartTime
		,EndTime
		,Status
		,ErrorMessage
		,Date
		,Triggered
		)
		VALUES(
		@PipelineRunID,
		@PipelineTriggerRunID,
		@TableName,
		@StartTime,
		@EndTime,
		@Status,
		@ErrorMessage,
		@date,
		@Triggered
		)
	
end
GO
