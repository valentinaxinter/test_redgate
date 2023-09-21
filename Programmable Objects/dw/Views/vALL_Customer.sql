IF OBJECT_ID('[dw].[vALL_Customer]') IS NOT NULL
	DROP VIEW [dw].[vALL_Customer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dw].[vALL_Customer] AS

SELECT 
	UPPER(TRIM(Company)) AS Company
    ,UPPER(TRIM(CustomerNum)) AS CustomerNum
	,MainCustomerName
    ,[dbo].[ProperCase](CustomerName) AS CustomerName
FROM [dw].[Customer]
GO
