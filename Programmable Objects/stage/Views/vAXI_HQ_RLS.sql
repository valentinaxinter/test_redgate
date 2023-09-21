IF OBJECT_ID('[stage].[vAXI_HQ_RLS]') IS NOT NULL
	DROP VIEW [stage].[vAXI_HQ_RLS];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [stage].[vAXI_HQ_RLS] AS

SELECT
	CONCAT(N'AXISE', '-',Email, '-',CostUnitNum)	AS EmailID 
	,FORMAT(GETDATE(),'yyyy-MM-dd hh:mm:ss') AS PartitionKey
	,N'AXISE' AS Company
	,[Email]
	,CASE WHEN CostUnitNum = 'All' THEN 'All'
		 ELSE RIGHT('000000' + CostUnitNum, 6) END AS [Name]
	,'CostUnit'	AS [RLSType]
FROM [stage].[AXI_HQ_RLS]
WHERE Email IS NOT NULL
GO
