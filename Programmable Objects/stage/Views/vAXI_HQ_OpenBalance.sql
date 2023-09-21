IF OBJECT_ID('[stage].[vAXI_HQ_OpenBalance]') IS NOT NULL
	DROP VIEW [stage].[vAXI_HQ_OpenBalance];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[vAXI_HQ_OpenBalance] AS
/*SELECT distinct	--We use distinct because AccountNum = 8316 and 8317 have what looks like duplicate rows. But they all have opening balance 0 so it doesn't matter much /SM 2021-12-17
	
	  CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', JournalDate, '#', AccountNum, '#', CostUnitNum ))) AS OpenBalanceID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', AccountNum ))) AS AccountID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', RIGHT('000000' + [CostUnitNum], 6 ) ))) AS CostUnitID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', CostBearerNum ))) AS CostBearerID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(Company,'#', '' ))) AS ProjectID
	  ,CONVERT(binary(32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	  ,CONVERT(varchar, GETDATE(), 23) AS PartitionKey
      ,[Company]
      ,[AccountNum]
      ,RIGHT('000000'+ [CostUnitNum], 6 ) AS  [CostUnitNum]
      ,[CostBearerNum]
      ,[ProjectNum]
      ,[JournalType]
      ,[JournalDate]
	  ,[JournalDate] as AccountingDate
      ,[Description]
      ,[OpeningBalance]
      ,[Currency]
      ,[ExchangeRate]
      ,[OBRes1]
      ,[OBRes2]
      ,[OBRes3]
  FROM [stage].[AXI_HQ_OpenBalance]
  where upper(Company) = 'AXISE'*/
 with ctm as (
select  [PartitionKey], [Company], [AccountNum], [CostUnitNum], [CostBearerNum], [ProjectNum], [JournalType], [JournalDate], [Description], [OpeningBalance], [Currency], [ExchangeRate], [OBRes1], [OBRes2], [OBRes3] from stage.AXI_HQ_OpenBalance where Company = 'AXISE' 
)
select distinct


IIF(op.AccountNum is null,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(TRIM(op_cal.Company),'#', op_cal.JournalDate, '#',TRIM(op_cal.AccountNum), '#',TRIM(op_cal.CostUnitNum)))),CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(TRIM(op.Company),'#',op.JournalDate, '#',TRIM(op.AccountNum), '#',TRIM(op.CostUnitNum))))) as OpenBalanceID
,IIF(op.AccountNum is null,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(TRIM(op_cal.Company),'#',TRIM(op_cal.AccountNum)))),CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(TRIM(op.Company),'#',TRIM(op.AccountNum))))) AS AccountID
,IIF(op.[CostUnitNum] is null,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(TRIM(op_cal.Company),'#', RIGHT('000000' + op_cal.[CostUnitNum], 6 )))),CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(TRIM(op.Company),'#', RIGHT('000000' + op.[CostUnitNum], 6 ))))) AS CostUnitID
,IIF(op.[CostBearerNum] is null,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(TRIM(op_cal.Company),'#', TRIM(op_cal.CostBearerNum)))),CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(TRIM(op.Company),'#',TRIM(op.CostBearerNum))))) AS CostBearerID
,IIF(op.[Company] is null,CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(TRIM(op_cal.Company),'#', '' ))),CONVERT(binary(32),HASHBYTES('SHA2_256',CONCAT(TRIM(op.Company),'#', '' )))) AS ProjectID
,IIF(op.[Company] is null,CONVERT(binary(32), HASHBYTES('SHA2_256',op_cal.Company)),CONVERT(binary(32), HASHBYTES('SHA2_256',op.Company))) AS CompanyID
,CONVERT(varchar, GETDATE(), 23) AS PartitionKey
,IIF(op.AccountNum is null,op_cal.AccountNum,op.AccountNum) as AccountNum
,IIF(op.[Company] is null,op_cal.[Company],op.[Company]) as [Company]
,iif(op.[CostUnitNum] is null,RIGHT('000000'+ op_cal.[CostUnitNum], 6 ),RIGHT('000000'+ op.[CostUnitNum], 6 )) as [CostUnitNum]
,iif(op.[CostBearerNum] is null,op_cal.[CostBearerNum],op.[CostBearerNum]) as [CostBearerNum]
,iif(op.[ProjectNum] is null,op_cal.[ProjectNum],op.[ProjectNum]) as [ProjectNum]
,iif(op.[JournalType] is null,op_cal.[JournalType],op.[JournalType]) as [JournalType]
,iif(op.[JournalDate] is null,op_cal.[JournalDate],op.[JournalDate]) as [JournalDate]
,iif(op.[JournalDate] is null,op_cal.[JournalDate],op.[JournalDate]) as AccountingDate
,iif(op.[Description] is null,op_cal.[Description],op.[Description]) as [Description]
,iif(op.[OpeningBalance] is null,op_cal.[OpeningBalance],op.[OpeningBalance]) as [OpeningBalance]
,iif(op.[Currency] is null,op_cal.[Currency],op.[Currency]) as [Currency]
,iif(op.[ExchangeRate] is null,op_cal.[ExchangeRate],op.[ExchangeRate]) as [ExchangeRate]
,iif(op.[OBRes1] is null,op_cal.[OBRes1],op.[OBRes1]) as [OBRes1]
,iif(op.[OBRes2] is null,op_cal.[OBRes2],op.[OBRes2]) as [OBRes2]
,iif(op.[OBRes3] is null,op_cal.[OBRes3],op.[OBRes3]) as [OBRes3]
--,iif(op.AccountNum is null,'op_cal','op') as [origen]
FROM ctm as op
 full outer join [stage].[AXI_HQ_OpenBalance_Calc] as op_cal
	on op_cal.[AccountNum] = op.[AccountNum] and op_cal.[JournalDate] = op.[JournalDate] and op_cal.[CostUnitNum] = op.[CostUnitNum] and op.Company = op_cal.Company
GO
