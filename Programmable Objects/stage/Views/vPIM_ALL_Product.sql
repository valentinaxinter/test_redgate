IF OBJECT_ID('[stage].[vPIM_ALL_Product]') IS NOT NULL
	DROP VIEW [stage].[vPIM_ALL_Product];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vPIM_ALL_Product] AS

SELECT	
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(COALESCE(C.Company, unp.CompanyGroup), '#', [ProductID], '#', PartID))) AS PimID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', COALESCE(C.Company, unp.CompanyGroup))) AS CompanyID
	,p1.PartID
	,unp.PartitionKey
	,[ProductID]
	,[Manufacturer_Id]
	,unp.[Brand]
	,SUBSTRING(unp.[Heading],1,49) AS [Heading]
	,[Original_Description]
	,[Last_category_name]
	,[Category_name]
	,[Category_name2]
	,[Category_name3]
	,[Category_name4]
	,[Category_name5]
	,[Category_name6]
	,unp.PartNum
	,COALESCE(C.Company, unp.CompanyGroup) AS Company
FROM 
(
	SELECT	
		[ProductID]
		,PartitionKey
		,[Manufacturer_Id]
		,[Brand]
		,[Heading]
		,[Original_Description]
		,[Last_category_name]
		,[Category_name]
		,[Category_name2]
		,[Category_name3]
		,[Category_name4]
		,[Category_name5]
		,[Category_name6]
		,[Item_no_Acorn]
		,[Item_no_Arkov]
		,[Item_no_Bell]
		,[Item_no_GMMIT]
		,[Item_no_Jens_SDK]
		,[Item_no_Jens_SNO]
		,[Item_no_Jens_SSE]
		,[Item_no_KTT]
		,[Item_no_MAK]
		,[Item_no_NOMODK]
		,[Item_no_NOMOFI]
		,[Item_no_NOMONO]
		,[Item_no_NOMOSE]
		,[Item_no_Jens_SNB]
		,[Item_no_Passerotti]
		,[Item_no_SKS]
		,[Item_no_Jens_SSK]
		,[Item_no_Spruit]
		,[Item_no_Sverull]
		,[Item_no_TNXSI]
		,[Item_no_TPNNO]
 -- Get a 'Missing' value for fully NULL products, for unpivot function
		,CAST(IIF(COALESCE([Item_no_Acorn], [Item_no_Arkov],  [Item_no_Bell], [Item_no_GMMIT], [Item_no_Jens_SDK], [Item_no_Jens_SNO], [Item_no_Jens_SSE], [Item_no_KTT], [Item_no_MAK], [Item_no_NomoDK], [Item_no_NomoFI], [Item_no_NomoNO], [Item_no_NomoSE], [Item_no_Jens_SNB], [Item_no_Passerotti], [Item_no_SKS], [Item_no_Jens_SSK], [Item_no_Spruit], [Item_no_Sverull], [Item_no_TNXSI], [Item_no_TPNNO], 'Missing') = 'Missing', 'Missing', NULL) AS nvarchar(50)) AS Missing
	FROM [Stage].[PIM_ALL_Product]
) as p
UNPIVOT (PartNum FOR CompanyGroup IN (
		[Item_no_Acorn]
		,[Item_no_Arkov]
		,[Item_no_Bell]
		,[Item_no_GMMIT]
		,[Item_no_Jens_SDK]
		,[Item_no_Jens_SNO]
		,[Item_no_Jens_SSE]
		,[Item_no_KTT]
		,[Item_no_MAK]
		,[Item_no_NOMODK]
		,[Item_no_NOMOFI]
		,[Item_no_NOMONO]
		,[Item_no_NOMOSE]
		,[Item_no_Jens_SNB]
		,[Item_no_Passerotti]
		,[Item_no_SKS]
		,[Item_no_Jens_SSK]
		,[Item_no_Spruit]
		,[Item_no_Sverull]
		,[Item_no_TNXSI]
		,[Item_no_TPNNO]
		,[Missing])
		 ) as unp
LEFT JOIN dbo.PIM_mapCompany AS C ON unp.CompanyGroup = C.CompanyGroup
LEFT JOIN dw.Part AS p1 ON unp.CompanyGroup <> 'Missing' AND trim(p1.PartNum) = trim(unp.PartNum) AND trim(p1.Company) = trim(C.Company)
GO
