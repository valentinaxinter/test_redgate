IF OBJECT_ID('[stage].[vCER_DK_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_DK_PurchaseInvoice] AS
--ADD TRIM()INTO PartID,WarehouseID 2022-12-14 VA
--ADD TRIM() INTO SupplierID 23-01-23 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company,'#',PurchaseInvoiceNum, '#', PurchaseInvoiceLine))) AS PurchaseInvoiceID --'#', PurchaseOrderType 
	,CONCAT(TRIM(Company),'#',PurchaseInvoiceNum, '#', PurchaseInvoiceLine) AS PurchaseInvoiceCode
	,CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum)) AS PurchaseOrderNumCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))))) AS SupplierID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT(int, replace(PurchaseInvoiceDate,'-','')) AS PurchaseInvoiceDateID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum))))) AS PurchaseLedgerID 
	,UPPER(CONCAT(Company,'#',TRIM(SupplierNum),'#',PurchaseOrderNum,'#',TRIM(PurchaseInvoiceNum))) AS PurchaseOrderCode
	,PartitionKey
	,Company
	,PurchaseOrderNum
	,PurchaseOrderLine
	,PurchaseOrderSubLine
	,PurchaseOrderType
	,PurchaseInvoiceNum 
	,PurchaseInvoiceLine
	,PurchaseInvoiceType
	,PurchaseInvoiceDate
	,CASE WHEN ActualDelivDate <= '1900-01-01' or ActualDelivDate = '' or ActualDelivDate is null THEN '1900-01-01' 
	      ELSE ActualDelivDate END   AS  ActualDelivDate
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM(PartNum)) AS PartNum
	,PurchaseInvoiceQty
	,UoM
	,UnitPrice
	,DiscountPercent
	,DiscountAmount
	,TotalMiscChrg
	,VATAmount
	,Currency
	,ExchangeRate
	,CreditMemo
	,PurchaserName
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,PurchaseChannel
	--,'' AS Comment
	,PIRes1
	,PIRes2
	,PIRes3

FROM stage.CER_DK_PurchaseInvoice
/*GROUP BY
	PartitionKey, Company, PurchaseOrderNum, PurchaseInvoiceNum, SupplierNum, PartNum, PurchaseOrderLine, PurchaseOrderSubLine, PurchaseInvoiceQty,UoM, UnitPrice, WarehouseCode,PurchaserName, 
	PurchaseInvoiceLine, PurchaseInvoiceType, PurchaseInvoiceDate, ActualDelivDate, TotalMiscChrg, VATAmount, CreditMemo, PurchaseOrderType,DiscountAmount,Currency,ExchangeRate,PurchaseChannel, LastPaymentNum --, PurchaseOrderType, [Site], OrderDelivLineNum, , DiscountPercent, PurchaserName, PurchaseInvoiceLine, PurchaseInvoiceType, PurchaseInvoiceDate, ActualDelivDate, TotalMiscChrg, CreditMemo
*/
GO
