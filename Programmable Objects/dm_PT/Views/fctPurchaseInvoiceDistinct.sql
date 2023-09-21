IF OBJECT_ID('[dm_PT].[fctPurchaseInvoiceDistinct]') IS NOT NULL
	DROP VIEW [dm_PT].[fctPurchaseInvoiceDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dm_PT].[fctPurchaseInvoiceDistinct] AS
--only for Arkov for test
SELECT 
	convert(bigint, PL.[PurchaseInvoiceID]) AS [PurchaseInvoiceID]
	,convert(bigint, PL.[CompanyID]) AS [CompanyID]
	,convert(bigint, PL.[SupplierID]) AS [SupplierID]
	,SupplierNum
	,MIn(PL.Company) AS Company
FROM 
	[dw].[PurchaseLedger] AS PL
WHERE Company = 'ACZARKOV'
GROUP BY 
	PL.[PurchaseInvoiceID], PL.CompanyID, PL.[SupplierID], SupplierNum
GO
