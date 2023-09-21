IF OBJECT_ID('[prestage].[PIM_ALL_Product_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[PIM_ALL_Product_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [prestage].[PIM_ALL_Product_Load] AS
BEGIN

Truncate table stage.[PIM_ALL_Product]

INSERT INTO 
	stage.PIM_ALL_Product 
	(
	[ProductID]
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
	,[Item_No_KTT]
	,[Item_no_MAK]
	,[Item_no_NOMODK]
	,[Item_no_NOMOFI]
	,[Item_no_NOMONO]
	,[Item_no_NOMOSE]
	,[Item_no_Jens_SNB]
	,[Item_No_Passerotti]
	,[Item_no_SKS]
	,[Item_no_Jens_SSK]
	,[Item_No_Spruit]
	,[Item_No_Sverull]
	,[Item_no_TNXSI]
	,[Item_no_TPNNO]
	,[PartitionKey]
	)

SELECT 
	[ProductID]
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
	,[ItemNo_Acorn]
	,[ItemNo_Arkov]
	,[ItemNo_BELL]
	,[Itemno_GMM]
	,[ItemNo_JensSDK]
	,[ItemNo_JensSNO]
	,[ItemNo_JensSSE]
	,[Itemno_KTT]
	,[ItemNo_MAK]
	,[ItemNo_NOMODK]
	,[ItemNo_NOMOFI]
	,[ItemNo_NOMONO]
	,[ItemNo_NOMOSE]
	,[ItemNo_JensSNB]
	,[ItemNo_Passerotti]
	,[ItemNo_SKS]
	,[ItemNo_JensSSK]
	,[ItemNo_Spruit]
	,[ItemNo_Sverull]
	,[Itemno_Tinex]
	,[Itemno_TPNordic]
	,[PartitionKey]
FROM 
	[prestage].[vPIM_ALL_Product]

--Truncate table prestage.[TRA_FR_Part]

End
GO
