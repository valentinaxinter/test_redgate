IF OBJECT_ID('[stage].[vTRA_SE_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vTRA_SE_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vTRA_SE_PurchaseOrder]
	AS select 
CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#')))) AS PurchaseOrderID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',upper(CONCAT(Company,'#',TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',upper(CONCAT(Company,'#',TRIM(SupplierNum))))) AS SupplierID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',upper(TRIM([Company])))) AS CompanyID,
	UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine),'#')) as PurchaseOrderCode
	, PartitionKey
	,UPPER(COMPANY) AS Company
	, trim(PurchaseOrderNum	) as PurchaseOrderNum	
	, trim(PurchaseOrderLine) as PurchaseOrderLine
	,PurchaseOrderType
	,cast(PurchaseOrderDate as date) as PurchaseOrderDate
	,PurchaseOrderStatus
	, iif(trim(IsOrderClosed) = 'closed',1,0) as IsClosed
	, cast(OrgReqDelivDate as date) as OrgReqDelivDate
	, cast(ReqDelivDate as date) as ReqDelivDate
	, cast(OrgCommittedDelivDate as date) as OrgCommittedDelivDate
	, cast(CommittedDelivDate as date) as CommittedDelivDate
	, cast(ActualDelivDate as date) as ActualDelivDate
	, PartNum
	, SupplierNum
	, SupplierPartNum
	,SupplierInvoiceNum
	,cast(PurchaseOrderQty as decimal(18,4)) as PurchaseOrderQty
	,cast(PurchaseInvoiceQty as decimal(18,4)) as InvoiceQty
	,cast(PurchaseReceiveQty as decimal(18,4)) as ReceiveQty
	,UoM
	,cast(UnitPrice as decimal(18,4)) as UnitPrice
	,cast(DiscountPercent as decimal(18,4)) as DiscountPercent
	,cast(DiscountAmount as decimal(18,4)) as DiscountAmount
	, Currency -- Seems that is not the currency. Maybe is ExchangeRate
	,PurchaserName
	,WarehouseCode
	,cast(IsActiveRecord as bit) as IsActiveRecord
from stage.TRA_SE_PurchaseOrder
;
GO
