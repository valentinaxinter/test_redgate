IF OBJECT_ID('[stage].[StockAvailability_SCM_FI]') IS NOT NULL
	DROP VIEW [stage].[StockAvailability_SCM_FI];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--This is used in EDC Stock Availability report in Lifting Solution Group PBI Workspace
--The Analysis Service model BI_CentralSourcing_LS is reading this view (in GIT)
CREATE VIEW  [stage].[StockAvailability_SCM_FI] AS
-- Can likely be refactored to use CTE instead for better readability and slight performance improvement /SM

SELECT sb.PartNum
		,CONVERT(bigint,sb.PartID) AS PartID
		,sb.Company as Company
		,CONVERT(bigint,sb.CompanyID) AS CompanyID
		,p.partDescription
		,CONCAT(sb.PartNum , ' |  ' + NULLIF(p.PartDescription,'') , ' | ' + NULLIF(p.PartDescription2,'') , ' | ' + NULLIF(p.PartDescription3,'') )   AS [PartNum&Desc] 
		,sb.StockBalance AS Qty
		,ca.UnitPrice
		,sb.BatchNum as BatchNum
		,'Stock Balance' AS [QtyType]
		,CAST(GETDATE() AS date) AS GenericDate
		,'' AS DueDate 
		,w.WarehouseSite
		,CONVERT(bigint,sb.WarehouseID) AS WarehouseID
		,CONVERT(bigint,sb.SupplierID) AS SupplierID
FROM dw.StockBalance sb
LEFT JOIN dw.Part p ON  p.Company = 'AFISCM' AND  p.PartID = sb.PartID 
LEFT JOIN dw.Warehouse w ON w.WareHouseID = sb.WarehouseID
LEFT JOIN (SELECT PartID, MAX(UnitPrice) AS UnitPrice, Company FROM dw.CustomerAgreement 
		WHERE Company = 'AFISCM' and is_deleted != '1' GROUP BY PartID, Company) ca ON  ca.PartID = sb.PartID
WHERE sb.Company = 'AFISCM' and sb.is_deleted != '1'

UNION ALL

SELECT so.PartNum
		,CONVERT(bigint,so.PartID) AS PartID
		,so.Company
		,CONVERT(bigint,so.CompanyID) AS CompanyID
		,p.partDescription
		,CONCAT(so.PartNum , ' |  ' + NULLIF(p.PartDescription,'') , ' | ' + NULLIF(p.PartDescription2,'') , ' | ' + NULLIF(p.PartDescription3,'') )   AS [PartNum&Desc] 
		,so.RemainingQty AS Qty
		,ca.UnitPrice
		,NULL AS BatchNum
		,'Normal Order Sales Remaining Qty' AS [QtyType]
		,so.SalesOrderDate AS GenericDate
		,'' AS DueDate 
		,w.WarehouseSite
		,CONVERT(bigint,so.WarehouseID) AS WarehouseID
		,0 AS SupplierID
FROM dw.SalesOrder so
LEFT JOIN dw.Part p ON  p.Company = 'AFISCM'  AND  p.PartID = so.PartID 
LEFT JOIN dw.Warehouse w ON w.Company = 'AFISCM' AND w.WareHouseID = so.WarehouseID 
LEFT JOIN (SELECT PartID, MAX(UnitPrice)  AS UnitPrice, Company FROM dw.CustomerAgreement 
			WHERE Company = 'AFISCM' and is_deleted != '1' GROUP BY PartID, Company) ca ON ca.Company = 'AFISCM' AND ca.PartID = so.PartID
Where so.Company = 'AFISCM' AND so.SalesOrderType = 'Normal Order' AND so.OpenRelease = '1' AND so.is_deleted != '1'

UNION ALL

SELECT po.PartNum
		,po.PartID
		,po.Company
		,CONVERT(bigint,po.CompanyID) AS CompanyID
		,p.partDescription
		,CONCAT(po.PartNum , ' |  ' + NULLIF(p.PartDescription,'') , ' | ' + NULLIF(p.PartDescription2,'') , ' | ' + NULLIF(p.PartDescription3,'') )   AS [PartNum&Desc] 
		,po.PurchaseOrderQty - po.ReceiveQty AS Qty
		,ca.UnitPrice
		,NULL AS BatchNum
		,'Normal Order Purchase Incoming Qty' AS [QtyType]
		,po.PurchaseOrderDate AS GenericDate
		,CONCAT('Incoming Date: ', CONVERT(nvarchar, po.OrgReqDelivDate, 23),' - ', 'PO',po.PurchaseOrderNum ) AS DueDate 
		,w.WarehouseSite
		,CONVERT(bigint,po.WarehouseID) AS WarehouseID
		,CONVERT(bigint,po.SupplierID) AS SupplierID
FROM dw.PurchaseOrder po
LEFT JOIN dw.Part p ON  p.Company = 'AFISCM'  AND p.PartID = po.PartID 
LEFT JOIN dw.Warehouse w ON w.Company = 'AFISCM' AND w.WareHouseID = po.WarehouseID 
LEFT JOIN (SELECT PartID, MAX(UnitPrice) AS UnitPrice, Company FROM dw.CustomerAgreement 
		WHERE Company = 'AFISCM' and is_deleted != '1' GROUP BY PartID, Company) ca ON ca.PartID = po.PartID
Where po.Company = 'AFISCM' AND po.PurchaseOrderType = 'Stock Order' AND po.PurchaseOrderStatus = 'Open' AND po.is_deleted != '1'
GO
