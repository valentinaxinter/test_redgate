IF OBJECT_ID('[stage].[vOCS_SE_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


CREATE VIEW [stage].[vOCS_SE_PurchaseInvoice] as
	SELECT

--------------------------------------------- Keys/ IDs ---------------------------------------------
CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#', TRIM(PurchaseOrderNum),'#', TRIM(PurchaseOrderLine),'#',TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', TRIM(IndexKey))))) AS PurchaseInvoiceID
,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseInvoiceNum), '#', TRIM(PurchaseInvoiceLine), '#', PartNum)) AS PurchaseInvoiceCode
,UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum))) AS PurchaseOrderNumCode
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseOrderID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
,CONVERT(int, replace(PurchaseInvoiceDate,'-','')) AS PurchaseInvoiceDateID
,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#', TRIM(SupplierNum), '#', TRIM(PurchaseInvoiceNum),'#',TRIM(PurchaseOrderNum))))) AS PurchaseLedgerID
,UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine) )) AS PurchaseOrderCode
,PartitionKey

----------------------------------------------- Regular Fields ---------------------------------------------
-----Mandatory Fields ---
,UPPER(TRIM(Company)) AS Company
,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
--,UPPER(TRIM(PurchaseOrderSubLine)) AS PurchaseOrderSubLine
,UPPER(TRIM(PurchaseInvoiceNum)) AS PurchaseInvoiceNum
,UPPER(TRIM(PurchaseInvoiceLine)) AS PurchaseInvoiceLine
,CASE WHEN PurchaseInvoiceDate = '' OR PurchaseInvoiceDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, PurchaseInvoiceDate) END AS PurchaseInvoiceDate
--,CASE WHEN ActualDelivDate = '' OR ActualDelivDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, ActualDelivDate) END AS ActualDelivDate
,UPPER(TRIM(PartNum)) AS PartNum
,CONVERT(decimal(18,4), Replace(PurchaseInvoiceQty, ',', '.')) AS PurchaseInvoiceQty
,CONVERT(decimal(18,4), Replace(UnitPrice, ',', '.')) AS UnitPrice
,CONVERT(decimal(18,4), Replace(ExchangeRate, ',', '.')) AS ExchangeRate
,UPPER(TRIM(Currency)) AS Currency
,UPPER(TRIM(IsCreditMemo)) AS CreditMemo
,UPPER(TRIM(SupplierNum)) AS SupplierNum
--
----Valuable Fields ---
,UPPER(TRIM(PurchaseOrderType)) AS PurchaseOrderType
--,UPPER(TRIM(PurchaseInvoiceType)) AS PurchaseInvoiceType
,CASE WHEN ActualRecieveDate = '' OR ActualRecieveDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, ActualRecieveDate) END AS ActualDelivDate
,CONVERT(decimal(18,4), Replace(DiscountPercent, ',', '.')) AS DiscountPercent
,CAST(((CAST(PurchaseInvoiceQty AS float) * (CAST(UnitPrice AS FLOAT)))*(CAST(DiscountPercent AS FLOAT))/100) AS DECIMAL(18,4)) AS DiscountAmount
--,CONVERT(decimal(18,4), Replace(TotalMiscChrg, ',', '.')) AS TotalMiscChrg
,[IsInvoiceClosed] as [IsInvoiceClosed]
,UPPER(TRIM(PurchaserName)) AS PurchaserName
,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
--
----- Good-to-have Fields ---
,CONVERT(decimal(18,4), Replace(VATAmount, ',', '.')) AS VATAmount
,UPPER(TRIM(UoM)) AS UoM
--,UPPER(TRIM(PurchaseChannel)) AS PurchaseChannel
--,UPPER(TRIM(Comment)) AS Comment
--
----------------------------------------------- Meta Data ---------------------------------------------
,CONVERT(date, CreatedTimeStamp) AS CreatedTimeStamp
,CONVERT(date, ModifiedTimeStamp) AS ModifiedTimeStamp
,'1' AS IsActiveRecord
--
----------------------------------------------- Extra Fields ---------------------------------------------
,UPPER(TRIM(IndexKey)) AS PIRes1
--,UPPER(TRIM(PIRes2)) AS PIRes2
--,UPPER(TRIM(PIRes3)) AS PIRes3

FROM
[stage].[OCS_SE_PurchaseInvoice]
GO
