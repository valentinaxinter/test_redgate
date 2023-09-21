IF OBJECT_ID('[stage].[vMEN_NL_Warehouse]') IS NOT NULL
	DROP VIEW [stage].[vMEN_NL_Warehouse];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vMEN_NL_Warehouse] AS
WITH CTE AS (
SELECT	
		CASE WHEN Company = '14' THEN  CONCAT(N'MENBE',Company) 
			ELSE  CONCAT(N'MENNL',Company)  END AS CompanyCode		
	  ,[PartitionKey], [Company], [WarehouseCode], [WarehouseName], [WarehouseDistrict], [WarehouseAddress], [WarehouseDescription], [WarehouseType], [WarehouseCountry], [WarehouseSite], [WarehouseKey], [DW_TimeStamp], [WarehouseActive]
  FROM [stage].[MEN_NL_Warehouse]
)
SELECT  
--ADD TRIM() UPPER() INTCO WarehouseID 23-01-12 VA
	  --CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([CompanyCode],'#',UPPER([WarehouseCode])))) AS WarehouseID
	  CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(trim(Company),'#',TRIM([WarehouseCode])))))  AS WarehouseID
	  ,[PartitionKey]
      ,CompanyCode									AS Company
      ,UPPER([WarehouseCode])						AS WarehouseCode
      ,[WarehouseName]
      ,[WarehouseDistrict]
      ,[WarehouseAddress]
      ,[WarehouseDescription]
      ,[WarehouseType]
      ,[WarehouseCountry]
      ,[WarehouseSite]
  FROM CTE
GO
