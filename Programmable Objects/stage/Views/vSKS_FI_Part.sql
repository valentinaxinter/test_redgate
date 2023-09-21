IF OBJECT_ID('[stage].[vSKS_FI_Part]') IS NOT NULL
	DROP VIEW [stage].[vSKS_FI_Part];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [stage].[vSKS_FI_Part] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO PartID
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([COMPANY]),'#',TRIM([PARTNUM]),'#',TRIM([VKORG]))))) AS PartID
	--CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([COMPANY],'#',[PARTNUM],'#',[VKORG]))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,CONCAT([Company],'#',RIGHT([PARTNUM], 7)) AS PartCode
	,PartitionKey

	,CASE WHEN COMPANY = 'SKSSWE' THEN 'JSESKSSW' ELSE COMPANY END AS Company 
	,IIF(ISNUMERIC([PARTNUM]) = 1,CAST(CAST(trim([PARTNUM]) AS int)as nvarchar(50)),(trim([PARTNUM]))) AS [PartNum]
	,[PARTNAME] AS [PartName]
	,[PARTDESCRIPTION] AS [PartDescription]
	,[PARTDESCRIPTION2] AS [PartDescription2]
	--,'' AS [PartDescription3]
	,NULLIF(SUPPLIERCODE,'') AS MainSupplier
	,CASE
		WHEN NULLIF(NULLIF(SUPPLIERCODE,'') ,NULL) IS NULL THEN NULL
		ELSE CONCAT(SUPPLIERCODE, ' - ',SUPPLIERNAME)
		END AS AlternativeSupplier
	--,CONCAT(SUPPLIERCODE, ' - ',SUPPLIERNAME) AS AlternativeSupplier
	,CONCAT([PRODUCTGROUP] + ' - ', [PRODUCTGROUPTXT]) AS [ProductGroup]
	,CONCAT([PRODUCTGROUP2] + ' - ', [PRODUCTGROUP2TXT]) AS [ProductGroup2]
	,[PRODUCTGROUP] AS [ProductGroup3]  
	,[ProductGroup4] -- PRODUCTGROUP4 added by FN 20210416; --106 665 of 177 270 records have a value in PRODUCTGROUP4 (ABC Indicator).
	--,'' AS [Brand] 
	,[COMMODITYCODE] AS [CommodityCode]
	--,'' AS PartReplacementNum
	,PartStatus
	,[COUNTRYOFORIGIN] AS [CountryOfOrigin]
	,[NETWEIGHT] AS [NetWeight]
	--,'' AS UoM
	--,[VOLUME] AS [Volume]
	,CASE WHEN MATKL = 'ZCONS' THEN 'Consumables'
		WHEN MATKL = 'ZDIEN' THEN 'Service'
		WHEN MATKL = 'ZDIEN_FRE' THEN 'Freight'
		WHEN MATKL = 'ZFERT' THEN 'Finished materials'
		WHEN MATKL = 'ZHALB' THEN 'Semifinished matr.'
		WHEN MATKL = 'ZHAWA' THEN 'Trading goods'
		WHEN MATKL = 'ZROH' THEN 'Raw materials'
		WHEN MATKL = 'ZVERP' THEN 'Packaging material'
		WHEN MATKL = 'ZZMAT' THEN 'SKS Config. material'
		END AS [Material] -- this Material is not ment from the beginning for such as Plast, Metal etc; But rather now for Matreial Group in SKS, such as artichle for Consumables, Service, 'Trading goods' etc in DimPart 20210106
	--,'' AS Barcode
	,[REORDERLEVEL] AS [ReOrderLevel]
	,[PRCTR] AS PartResponsible
	,CASE WHEN trim([STARTDATE]) = '00000000' THEN CAST('19010101' AS date) ELSE CAST(trim([STARTDATE]) AS date) END AS [StartDate] --[STARTDATE] AS [StartDate]
	,CASE WHEN trim([ENDDATE]) = '00000000' THEN CAST('19010101' AS date) ELSE CAST(trim([ENDDATE]) AS date) END AS [EndDate] --[ENDDATE] AS [EndDate]
FROM 
	[stage].[SKS_FI_Part]
	--the filter about company is because in the same ERP is sending 3 records about another company. 2023-03-10 (other solution would be put this clause in the deltaloadstatemnt)
WHERE  [VKORG] NOT IN ('FI00','SE10') and Company != 'FI10'

/*
CASE WHEN MATKL = 'ZCONS' THEN 'Consumables'
		WHEN MATKL = 'ZDIEN' THEN 'Service'
		WHEN MATKL = 'ZDIEN_FRE' THEN 'Freight'
		WHEN MATKL = 'ZFERT' THEN 'Finished materials'
		WHEN MATKL = 'ZHALB' THEN 'Semifinished matr.'
		WHEN MATKL = 'ZHAWA' THEN 'Trading goods'
		WHEN MATKL = 'ZROH' THEN 'Raw materials'
		WHEN MATKL = 'ZVERP' THEN 'Packaging material'
		WHEN MATKL = 'ZZMAT' THEN 'SKS Config. material'
		END AS [Material]	-- Items type, such as Packaging material, Trading goods ...
*/
GO
