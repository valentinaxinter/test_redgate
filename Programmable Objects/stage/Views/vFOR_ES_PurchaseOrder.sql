IF OBJECT_ID('[stage].[vFOR_ES_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vFOR_ES_PurchaseOrder] AS 
SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#',TRIM(PurchaseOrderSubLine))))) AS PurchaseOrderID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(PurchaseOrderNum)))) AS PurchaseOrderNumID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(SupplierNum)))) AS SupplierID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID,
	UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine),'#',TRIM(PurchaseOrderSubLine))) as PurchaseOrderCode,
	PartitionKey,
	Company,
	PurchaseOrderNum		,
	PurchaseOrderLine		,
	PurchaseOrderSubLine ,
	PurchaseOrderDate	  ,
	IIF(OpenRelease = 'C', 'Closed', 'Open') AS  PurchaseOrderStatus, -- SB 2022-11-22
	OrgCommittedDelivDate ,
	cast(isnull(nullif(OrgCommittedDelivDate,''),'1900-01-01') as date) as CommittedDelivDate,
	PartNum               ,
	SupplierNum           ,
	SupplierPartNum       ,
	PurchaseOrderQty      ,
	--PurchaseRemainingQty,
	UnitPrice             ,
	DiscountPercent       ,
	Currency              ,
	PurchaserName         ,
	WarehouseCode         ,
	PORes1                , -- Its representing Supplier Name
	PORes2                , -- Its representing PartNum Description
	cast(ReqDelivDate as date) as ReqDelivDate,
	cast(ActualDelivDate as date) as ActualDelivDate,
	cast(PurchaseInvoiceNum as nvarchar(100)) as PurchaseInvoiceNum,
	cast(DiscountAmount as decimal(18,4)) as DiscountAmount,
	cast(ExchangeRate as decimal(18,4)) as ExchangeRate,
	ReceiveQty,
	IsClosed
	,SupplierInvoiceNum
	,PartStatus
	, InvoiceQty
	, UoM
	, LandedCost
	, Comments
	--cast(PurchaseOrderQty as decimal(18,4)) - cast(PurchaseRemainingQty as decimal(18,4)) as ReceiveQty
FROM 
	 [stage].[FOR_ES_PurchaseOrder]
	 where PartNum != '0' -- Special request to remove since there are payments in advance and not actually an article/part
GO
