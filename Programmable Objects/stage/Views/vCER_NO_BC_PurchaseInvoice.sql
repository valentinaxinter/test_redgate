IF OBJECT_ID('[stage].[vCER_NO_BC_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_BC_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [stage].[vCER_NO_BC_PurchaseInvoice] AS

SELECT 

	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#',TRIM(PartNum), '#', TRIM(WarehouseCode))))) AS PurchaseInvoiceID
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', PartNum)) AS PurchaseInvoiceCode
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum))) AS PurchaseOrderNumCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine))))) AS PurchaseOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT(int, replace(convert(date,PurchaseInvoiceDate),'-','')) AS PurchaseInvoiceDateID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseLedgerID 
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum),'#',TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
	,PartitionKey

	,UPPER(TRIM([Company])) AS [Company]
    ,UPPER(TRIM([PurchaseInvoiceNum])) as PurchaseInvoiceNum
    ,UPPER(TRIM([PurchaseInvoiceLine]))as PurchaseInvoiceLine
    ,UPPER(TRIM([PurchaseOrderNum]))as PurchaseOrderNum
    ,UPPER(TRIM([PurchaseOrderLine]))as PurchaseOrderLine
    ,cast([PurchaseInvoiceDate] as date )as PurchaseInvoiceDate
    ,cast([ActualDelivDate] as date ) as ActualDelivDate
    ,[IsInvoiceClosed]
    ,UPPER(TRIM([SupplierNum])) as [SupplierNum]
    ,UPPER(TRIM([PartNum])) as [PartNum]
    ,[PurchaseInvoiceQty]
    ,[UoM]
    ,[UnitPrice]
    ,[DiscountPercent]
    ,[DiscountAmount]
    ,[Currency]
	,[ExchangeRate]
    ,[PurchaserName]
    ,[WarehouseCode]
	,[PurchaseInvoiceType]
   -- ,[ActualShipDate]
    ,[IsActiveRecord]


FROM [stage].[CER_NO_BC_PurchaseInvoice]
GO
