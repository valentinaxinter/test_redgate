IF OBJECT_ID('[prestage].[vPIM_ALL_Product]') IS NOT NULL
	DROP VIEW [prestage].[vPIM_ALL_Product];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--PTS id|
--"Manufacturer Id"|
--Brand|Heading|
--"Original Description"|
--"Last category name"|
--"Category name"|
--"Category name"|
--"Category name"|
--"Category name"|
--"Category name"|
--"Category name"|
--"Item no (SKS)"|
--"Item no (Jens S)"|
--"Item no (Acorn)"|
--"Item no (Bell)"|
--"Item no (Arkov)"| 16
--"Item no (Nomo Denmark)"| 17
--"Item no (Nomo Finland)"| 18
--"Item no (Nomo Norway)"| 19
--"Item no (Nomo Sweden)"| 20
--"Item no (Spruit)"| 21
--"Item no (MAK)"| 22 
--"Item no (Sverull)"| 23
--"Item no (Passerotti)"| 24
--"Item no (KTT)" | 25

CREATE VIEW [prestage].[vPIM_ALL_Product] AS

SELECT
	Prop_0 AS [ProductID]
	,Prop_1 AS [Manufacturer_Id]
	,Prop_2 AS [Brand]
	,Prop_3 AS [Heading]
	,Prop_4 AS [Original_Description]
	,Prop_5 AS [Last_category_name]
	,Prop_6 AS [Category_name]
	,Prop_7 AS [Category_name2]
	,Prop_8 AS [Category_name3]
	,Prop_9 AS [Category_name4]
	,Prop_10 AS [Category_name5]
	,Prop_11 AS [Category_name6]
	,Prop_12 as [ItemNo_Acorn]
	,Prop_13 as [ItemNo_Arkov]
	,Prop_14 as [ItemNo_BELL]
	,Prop_15 as [ItemNo_GMM]
	,Prop_16 as [ItemNo_JensSDK]
	,Prop_17 as [ItemNo_JensSNO]
	,Prop_18 as [ItemNo_JensSSE]
	,Prop_19 as [ItemNo_KTT]
	,Prop_20 as [ItemNo_MAK]
	,Prop_21 as [ItemNo_NOMODK]
	,Prop_22 as [ItemNo_NOMOFI]
	,Prop_23 as [ItemNo_NOMONO]
	,Prop_24 as [ItemNo_NOMOSE]
	,Prop_25 as [ItemNo_JensSNB]
	,Prop_26 as [ItemNo_Passerotti]
	,Prop_27 as [ItemNo_SKS]
	,Prop_28 as [ItemNo_JensSSK]
	,Prop_29 as [ItemNo_Spruit]
	,Prop_30 as [ItemNo_Sverull]
	,Prop_31 as [ItemNo_Tinex]
	,Prop_32 as [ItemNo_TPNordic]
	,CONCAT(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
FROM [prestage].[PIM_ALL_Product]
GO
