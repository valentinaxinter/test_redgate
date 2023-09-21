IF OBJECT_ID('[stage].[vFOR_ES_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [stage].[vFOR_ES_PurchaseInvoice] AS 
SELECT 

	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine) )))) AS PurchaseInvoiceID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(PurchaseOrderNum)))) AS PurchaseOrderNumID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#',(PurchaseOrderSubLine))))) AS PurchaseOrderID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID,
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([SupplierNum]))))) AS SupplierID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum)))) AS PurchaseLedgerID,
	UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine),'#',TRIM(PurchaseOrderSubLine))) as PurchaseOrderCode,
	CONVERT(int, replace(CONVERT(date, left(PurchaseInvoiceDate,10)),'-','')) AS PurchaseInvoiceDateID,

	[PartitionKey]		,
	UPPER(TRIM(Company)) AS "Company",
	UPPER(TRIM(PurchaseOrderNum)) AS "PurchaseOrderNum",
	UPPER(TRIM(PurchaseOrderLine)) AS "PurchaseOrderLine",
	UPPER(TRIM(PurchaseOrderSubLine)) AS "PurchaseOrderSubLine",
	UPPER(TRIM(PurchaseInvoiceNum)) AS "PurchaseInvoiceNum",
	UPPER(TRIM(PurchaseInvoiceLine)) AS "PurchaseInvoiceLine",
	CONVERT(date, left(PurchaseInvoiceDate,10)) AS PurchaseInvoiceDate,
	ActualDelivDate		,
	UPPER(TRIM(SupplierNum)) AS "SupplierNum",
	UPPER(TRIM(PartNum)) AS "PartNum",
	PurchaseInvoiceQty	,
	UoM					,
	UnitPrice			,
	DiscountPercent		,
	DiscountAmount		,
	VATAmount			,
	ExchangeRate		,
	Currency			,
	CreditMemo			,
	PurchaserName		,
	UPPER(TRIM(WarehouseCode)) AS "WarehouseCode",
	Comment,
	UPPER(TRIM(PurchaseInvoiceType)) as PurchaseInvoiceType


FROM 
	 [stage].[FOR_ES_PurchaseInvoice]
GO
