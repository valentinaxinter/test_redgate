IF OBJECT_ID('[stage].[vROR_SE_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vROR_SE_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vROR_SE_PurchaseOrder] AS

SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(po.Company, '#', TRIM(po.PurchaseOrderNum), '#', TRIM(po.PurchaseOrderLine), '#', TRIM(UPPER(po.[PartNum])))))) AS PurchaseOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(po.Company, '#', TRIM(po.PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(po.Company, '#', '')))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(po.Company, '#', '')))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(po.Company), '#', TRIM(po.SupplierNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(po.Company), '#', TRIM(po.[PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(po.Company, '#', TRIM(po.WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(po.[Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(po.[Currency])))) AS CurrencyID
	,UPPER(CONCAT(po.Company, '#', TRIM(po.SupplierNum), '#', TRIM(po.PurchaseOrderNum), '#', TRIM(po.PurchaseOrderLine))) AS PurchaseOrderCode
	,po.PartitionKey

	,UPPER(po.Company) AS Company
	,UPPER(TRIM(po.[PartNum])) AS PartNum
	,UPPER(TRIM(po.SupplierNum)) AS SupplierNum
	,UPPER(TRIM(po.WarehouseCode)) AS WarehouseCode
	,TRIM(po.PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(po.PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,TRIM(PurchaseOrderType) AS PurchaseOrderType
	,IIF(IsOrderClosed = 1, 'Closed','Open') AS PurchaseOrderStatus
	,IsOrderClosed AS IsClosed
	,PurchaseOrderDate
	,'1900-01-01' AS OrgReqDelivDate  --
	,MAX(CONVERT(Date, IIF(CommittedShipDate is null OR CommittedShipDate = '', '1900-01-01', CommittedShipDate))) AS CommittedShipDate
	,MAX(CONVERT(Date, IIF(st.[TransactionDate] is null OR st.[TransactionDate] = '', '1900-01-01', st.[TransactionDate]))) AS ActualDelivDate
	,MAX(CONVERT(Date, IIF(ReqDelivDate = '''' or ReqDelivDate = ',', '1900-01-01', ReqDelivDate))) AS ReqDelivDate
	,'1900-01-01' AS DelivDate
	,TRIM(po.PurchaseInvoiceNum) AS PurchaseInvoiceNum
	,TRIM(SupplierInvoiceNum) AS SupplierInvoiceNum
	,TRIM(SupplierPartNum) AS SupplierPartNum
	,TRIM(DelivCustomerNum) AS DelivCustomerNum
	,TRIM(PartStatus) AS PartStatus
	,MAX(PurchaseOrderQty) AS PurchaseOrderQty
	,MAX(PurchaseReceiveQty) AS ReceiveQty
	,MAX(PurchaseInvoiceQty) AS InvoiceQty
	,MAX(MinOrderQty) AS MinOrderQty
	,TRIM(UoM) AS UoM
--	,SUM(CONVERT(decimal(18,4),REPLACE(TransactionValue, ',', '.')))/SUM(CONVERT(decimal(18,4),REPLACE(TransactionQty, ',', '.'))) AS UnitPrice
	,UnitPrice AS UnitPrice
	,MAX(LandedCost) AS LandedCost
	,AVG(DiscountPercent) AS DiscountPercent
	,MAX(DiscountAmount) AS DiscountAmount
	--,NULL AS TotalMiscChrg
	,AVG(po.ExchangeRate) AS ExchangeRate
	,TRIM(po.Currency) AS Currency
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(ReceivingNum) AS ReceivingNum
	,MAX(DelivTime) AS DelivTime
	,TRIM(PurchaseChannel) AS PurchaseChannel
	,TRIM(Documents) AS Documents
	,TRIM(Comments) AS Comments
	,TRIM(po.CreatedTimeStamp) AS PORes1
	,TRIM(po.ModifiedTimeStamp) AS PORes2
	,TRIM(PORes1) AS PORes3
FROM 
	[stage].[ROR_SE_PurchaseOrder] po
	LEFT JOIN [stage].[ROR_SE_StockTransaction] st ON TRIM(po.PurchaseOrderNum) = TRIM(st.PurchaseOrderNum) AND TRIM(po.PurchaseOrderLine) = TRIM(st.PurchaseOrderLine)
WHERE ReqDelivDate != '''' and ReqDelivDate != ','
	
GROUP BY
	po.PartitionKey, po.Company, po.PurchaseOrderNum, po.PurchaseOrderLine, PurchaseOrderSubLine, po.SupplierNum, po.DelivCustomerNum, po.PartNum, PurchaseOrderType, UnitPrice,
	po.Currency, IsOrderClosed, PurchaseOrderDate, PurchaserName, PurchaseChannel, Documents, Comments, po.CreatedTimeStamp, po.ModifiedTimeStamp, PORes1, po.WarehouseCode ,po.PurchaseInvoiceNum, SupplierInvoiceNum, SupplierPartNum, PartStatus, UOM, ReceivingNum
GO
