IF OBJECT_ID('[stage].[vSKS_FI_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vSKS_FI_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [stage].[vSKS_FI_Supplier] AS
--ADD UPPEER() TRIM() INTO SupplierID
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(BUKRS), '#', TRIM([SupplierNum]),'#', TRIM(EKORG))))) AS SupplierID
    ,CONCAT(BUKRS, '#', TRIM([SupplierNum]), EKORG ) AS SupplierCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',  BUKRS)) AS CompanyID
	,[PartitionKey]

--	,CASE WHEN BUKRS = 'SKSSWE' THEN 'JSESKSSW' WHEN [EKORG] = 'SE10'  THEN 'JSESKSSW' ELSE BUKRS END  AS Company
	,BUKRS AS Company
	,TRIM([SupplierNum]) AS [SupplierNum]
	,MainSupplierName
	,IIF(SupplierName = '', MainSupplierName, SupplierName) AS SupplierName
	,[AddressLine1]
    ,[AddressLine2]
    --,'' AS [AddressLine3]
	,[TelephoneNum]
	,[Email]
	,ZIP AS ZipCode
	,[City]
	,'' AS [District]
	,ADDRESSLINE3 AS CountryName
	,CUSTOMERNUM CustomerNum
	,[Region]
	,[SupplierCategory]
	,[SupplierResponsible]
	,TRIM(concat ([AddressLine1]+' '+ addressline2, null)) AS AddressLine
	,TRIM(concat_ws(',', [AddressLine3], ZIP, City, [AddressLine1])) AS FullAddressLine
	,CONVERT([binary](32), HASHBYTES('SHA2_256', BANKACCOUNTNUM)) AS [AccountNum] 
	,[VATNum]
	,'' AS OrganizationNum
	,[InternalExternal]
	,NULLIF(TRIM([CodeOfConduct]),'') AS [CodeOfConduct]
	,SUPPLIERABC AS [SupplierScore]
	,TRY_CONVERT(decimal(18,4), MINORDERQTY) AS [MinOrderQty]
	,NULL AS [MinOrderValue]
	,[Website]
	,[Comments]
	,SRES1 AS SRes1
	,SRES2 AS SRes2
	,MANDT AS SRes3
	,INTCA as CountryCode
FROM [stage].[SKS_FI_Supplier]
WHERE  EKORG NOT IN ('FI00','FI10','SE10','')
GO
