IF OBJECT_ID('[stage].[vCER_NO_BC_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_BC_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [stage].[vCER_NO_BC_PurchaseOrder] as 

select 
	CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum),'#',TRIM(PurchaseOrderLine),'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseOrderID
	,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID
	--,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(DelivCustomerNum))))) AS CustomerID
	,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
	,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(TRIM(Currency)))) AS CurrencyID
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum),'#',TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
	,PartitionKey AS PartitionKey

	---Mandatory Fields ---
	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
	,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
	,UPPER(TRIM(PartNum)) AS PartNum
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,CASE WHEN PurchaseOrderDate = '' OR PurchaseOrderDate is NULL THEN null ELSE CONVERT(date, PurchaseOrderDate) END AS PurchaseOrderDate
	,CONVERT(decimal(18,4), Replace(PurchaseOrderQty, ',', '.')) AS PurchaseOrderQty
	,CONVERT(decimal(18,4), Replace(PurchaseReceiveQty, ',', '.')) AS ReceiveQty
	,CONVERT(decimal(18,4), Replace(PurchaseInvoiceQty, ',', '.')) AS InvoiceQty
	,CONVERT(decimal(18,4), Replace(UnitPrice, ',', '.')) AS UnitPrice
	,CONVERT(decimal(18,4), Replace(ExchangeRate, ',', '.')) AS ExchangeRate
	,UPPER(TRIM(Currency)) AS Currency
	,TRIM(IsOrderClosed) AS IsClosed

	---Valuable Fields ---

	,UPPER(TRIM(PurchaseOrderType)) AS PurchaseOrderType
	,UPPER(TRIM(PurchaseOrderStatus)) AS PurchaseOrderStatus
	,CASE WHEN CommittedDelivDate = '' OR CommittedDelivDate is NULL THEN null ELSE CONVERT(date, CommittedDelivDate) END AS CommittedDelivDate
	,CASE WHEN ActualDelivDate = '' OR ActualDelivDate is NULL THEN null ELSE CONVERT(date, ActualDelivDate) END AS ActualDelivDate
	,CASE WHEN ReqDelivDate = '' OR ReqDelivDate is NULL THEN null ELSE CONVERT(date, ReqDelivDate) END AS ReqDelivDate
	,CONVERT(decimal(18,4), Replace(DiscountPercent, ',', '.')) AS DiscountPercent
	,CONVERT(decimal(18,4), Replace(DiscountAmount, ',', '.')) AS DiscountAmount
	,UPPER(TRIM(PurchaserName)) AS PurchaserName
	,TRIM(PartStatus) AS PartStatus

	--- Good-to-have Fields ---

	,UPPER(TRIM(PurchaseInvoiceNum)) AS PurchaseInvoiceNum
	,UPPER(TRIM(SupplierPartNum)) AS SupplierPartNum
	,UPPER(TRIM(UoM)) AS UoM
	,CONVERT(decimal(18,4), Replace(LandedCost, ',', '.')) AS LandedCost

	--------------------------------------------- Meta Data ---------------------------------------------

	,CONVERT(date, ModifiedTimeStamp) AS ModifiedTimeStamp
	,CONVERT(date, CreatedTimeStamp) AS CreatedTimeStamp
	,UPPER(TRIM(PORes1)) AS PORes1

from [stage].[CER_NO_BC_PurchaseOrder]
GO
