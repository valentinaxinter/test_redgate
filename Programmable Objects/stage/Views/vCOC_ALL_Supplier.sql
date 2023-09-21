IF OBJECT_ID('[stage].[vCOC_ALL_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vCOC_ALL_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


  CREATE VIEW [stage].[vCOC_ALL_Supplier] AS
  SELECT
	CONCAT(getdate(),' 00:00:00') AS PartitionKey
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,Company
	,SupplierNum
	,CONCAT([Company],'#',TRIM([SupplierNum])) AS SupplierCode
	,CASE WHEN COMPANY in ('CYESA', 'MENNL03')
		THEN CONVERT([binary](32), HASHBYTES('SHA2_256',(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) 
		ELSE CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([SupplierNum]))))) END AS SupplierID
	,CodeOfConductIsSigned AS CoCfeedback
  FROM [stage].[COC_ALL_SupplierTest]
  WHERE [Company] IS NOT NULL
GO
