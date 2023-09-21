IF OBJECT_ID('[dm_LS].[DimSalesPersonName]') IS NOT NULL
	DROP VIEW [dm_LS].[DimSalesPersonName];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm_LS].[DimSalesPersonName] AS

SELECT sp.[SalesPersonNameID]
,sp.[Company]
,sp.[SalesPersonName]
FROM dm.DimSalesPersonName as sp
LEFT JOIN dbo.Company com ON sp.Company = com.Company
WHERE com.BusinessArea = 'Lifting Solutions' AND com.[Status] = 'Active'

--WHERE Company IN ('AFISCM', 'CDKCERT', 'CEECERT', 'CFICERT', 'CLTCERT', 'CLVCERT', 'CSECERT', 'CUKCERT', 'CNOEHAU', 'CERPL', 'CNOCERT', 'CyESA', 'HFIHAKL', 'TRACLEV'
--			,'MENBE14','MENNL01','MENNL02','MENNL03','MENNL04','MENNL07','MENNL11');
GO
