IF OBJECT_ID('[stage].[vFOR_PL_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vFOR_PL_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vFOR_PL_PurchaseInvoice]
	AS 
	
SELECT 
------------- ID's -------------

CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', TRIM(PIRes1))))) AS PurchaseInvoiceID
,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine))) AS PurchaseInvoiceCode
,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum))) AS PurchaseOrderNumCode
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#',TRIM(PurchaseOrderSubLine))))) AS PurchaseOrderID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
,CONVERT(int, replace(cast(PurchaseInvoiceDate as date),'-','')) AS PurchaseInvoiceDateID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum),'#',TRIM(PurchaseOrderNum))))) AS PurchaseLedgerID
,UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine) )) AS PurchaseOrderCode
,PartitionKey

------------- Mandatory fields -------------
,Company
,trim([PurchaseInvoiceNum]) as [PurchaseInvoiceNum]
,trim(PurchaseInvoiceLine ) as PurchaseInvoiceLine
--PurchaseInvoiceSubLine
,trim([PurchaseOrderNum]  ) as [PurchaseOrderNum]
,trim([PurchaseOrderLine] ) as [PurchaseOrderLine]
,trim(PurchaseOrderSubLine) as PurchaseOrderSubLine
,cast(PurchaseInvoiceDate as date) as PurchaseInvoiceDate
,cast([ActualShipDate]    as date) as ActualShipDate
,nullif(trim([PartNum]           ),'') as PartNum
,cast([PurchaseInvoiceQty] as decimal(18,4)) as [PurchaseInvoiceQty] 
,cast(UnitPrice as decimal(18,4)) as UnitPrice       
,iif(cast(ExchangeRate as decimal(18,4)) = 0,1,cast(ExchangeRate as decimal(18,4))) as ExchangeRate
,nullif(trim([Currency]),'') as Currency
-- IsCreditMemo
--CreatedTimeStamp
--ModifiedTimeStamp
--IsActiveRecord
,nullif(trim([SupplierNum] ),'') As SupplierNum

------------- Other fields -------------
           
--,[DocType]
,PurchaseInvoiceType
,cast([ActualRecieveDate]  as date) as ActualRecieveDate
,cast([IsInvoiceClosed]   as bit) as IsInvoiceClosed 
,nullif(trim([UoM]               ),'') as UoM
,cast([DiscountPercent] as decimal(18,4)) as [DiscountPercent]       
,cast([DiscountAmount] as decimal(18,4)) as [DiscountAmount]          
,cast([TotalMiscChrg] as decimal(18,4)) as [TotalMiscChrg]          
,cast([IsCreditMemo]   as bit) as [CreditMemo] 
,nullif(trim([PurchaserName]),'') as PurchaserName
,nullif(trim([WarehouseCode]),'') as [WarehouseCode]
,nullif(trim([Comment]),'') as Comment
FROM stage.FOR_PL_PurchaseInvoice
GO
