IF OBJECT_ID('[dw].[vALL_Supplier]') IS NOT NULL
	DROP VIEW [dw].[vALL_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dw].[vALL_Supplier] AS

SELECT
	UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	,TRIM(MainSupplierName) AS MainSupplierName
	,TRIM(SupplierName) AS SupplierName

FROM [dw].[Supplier]
GO
