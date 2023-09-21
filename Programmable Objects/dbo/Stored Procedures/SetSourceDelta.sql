IF OBJECT_ID('[dbo].[SetSourceDelta]') IS NOT NULL
	DROP PROCEDURE [dbo].[SetSourceDelta];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[SetSourceDelta] @ParamTable varchar(50), @LastModifiedtime varchar(20), @dwtablename varchar(50), @DeltaLoadGetNewValue varchar(250), @Partitionkey varchar(50)
AS
--DECLARE @LastModifiedtime datetime='2018-10-01 03:33:00'
--DECLARE @TableName nvarchar(50)='fh'
--DECLARE @partitionkey nvarchar(50)='20181002'
--DECLARE @SourceSystem nvarchar(50)='BIP_DE'
--DECLARE @DeltaLoadGetNewValue nvarchar(250)='case when max(rowcreateddt)<= coalesce(max(rowupdateddt),max(rowcreateddt)) then max(rowcreateddt) else max(rowupdateddt) end'

DECLARE @SQLString NVARCHAR(500) 
DECLARE @SQLString2 NVARCHAR(500) 

DECLARE @DWModifiedtime varchar(20)

BEGIN
SET NOCOUNT ON; 

--print charindex('_',@SourceSystem);

--SET @SourceSystem=substring(@SourceSystem,1,charindex('_',@SourceSystem)-1)

--print @SourceSystem;

--SET @SQLString = N'select @DWModifiedtime = ''' +  
--@DeltaLoadGetNewValue
--+ ' from stage.'+substring(@SourceSystem,1,charindex('_',@SourceSystem)-1)+'_'+ @TableName +' where sourcesystem='''+@SourceSystem+''''
--+ ''' from dw.'+ @dwtablename +' where  partitionkey='''+@partitionkey+''''
-- modify @dwtablename into {schema}.{dwtablename} - tomas comment

--print @SQLString;

--EXEC sp_executesql @SQLString 
--, N'@DWModifiedtime varchar(20) OUTPUT'
--, @DWModifiedtime OUTPUT;

--print @DWModifiedtime;
--print @LastModifiedtime;

--IF cast(@DWModifiedtime as datetime)>cast(@LastModifiedtime as datetime)
--begin
--print format(cast(@DWModifiedtime as datetime),'yyyy-MM-dd HH:mm:ss')
--UPDATE [dbo].[Sourcetables] SET [DeltaLoadValue] = format(cast(@DWModifiedtime as datetime),'yyyy-MM-dd HH:mm:ss') WHERE TableName = @dwTableName;
SET @SQLString2 = N'UPDATE dbo.' + @ParamTable 
+ ' SET [DeltaLoadValue] = format(cast(''' + @Partitionkey + ''' as datetime),''yyyy-MM-dd HH:mm:ss'') WHERE dwtablename =''' + @dwTableName+''''
--print @SQLString2
EXEC sp_executesql @SQLString2
--end 
--ELSE
--select 1;
--print convert(varchar(20),@DWModifiedtime, 120)
END
GO
