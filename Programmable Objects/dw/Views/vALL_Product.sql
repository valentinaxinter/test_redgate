IF OBJECT_ID('[dw].[vALL_Product]') IS NOT NULL
	DROP VIEW [dw].[vALL_Product];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dw].[vALL_Product] AS

SELECT 
	UPPER(TRIM(Company)) AS Company
    ,UPPER(TRIM(PartNum)) AS PartNum
	,PartName AS ProductName
	,ProductGroup
FROM [dw].[Part]
GO
