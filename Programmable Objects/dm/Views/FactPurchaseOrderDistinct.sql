IF OBJECT_ID('[dm].[FactPurchaseOrderDistinct]') IS NOT NULL
	DROP VIEW [dm].[FactPurchaseOrderDistinct];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dm].[FactPurchaseOrderDistinct] AS
-- TO 2023-01-20 Making sure we will never bring two values and break all the AS models
with remove_duplicates as (
SELECT 
	convert(bigint, POL.[PurchaseOrderNumID]) AS [PurchaseOrderNumID]
	,convert(bigint, POL.[CompanyID]) AS [CompanyID]
	,MIN(convert(bigint, POL.[SupplierID])) AS [SupplierID]
	,MIN(POL.PurchaseOrderNum) AS PurchaseOrderNum
	,MIN(POL.Company) AS Company
	,MIN(CONCAT(S.SupplierNum, '-', S.SupplierName)) AS Supplier
	,row_number() over(Partition by convert(bigint, POL.[PurchaseOrderNumID]) order by convert(bigint, POL.[PurchaseOrderNumID])) as rn
FROM 
	[dw].[PurchaseOrder] AS POL
		LEFT JOIN dw.Supplier AS S 
		ON POL.CompanyID = S.CompanyID
		AND POL.SupplierID = S.SupplierID
where POL.is_deleted != 1 Or POL.is_deleted is null
GROUP BY 
	POL.PurchaseOrderNumID, POL.CompanyID
)
SELECT 
 [PurchaseOrderNumID]
 ,[CompanyID]
 ,[SupplierID]
 ,PurchaseOrderNum
 ,Company
 ,Supplier
 from remove_duplicates
 where rn = 1

	--,MIN(convert(bigint, POL.[CustomerID])) AS [CustomerID]
	--,MIN(convert(bigint, [WarehouseID])) AS [WarehouseID]
GO
