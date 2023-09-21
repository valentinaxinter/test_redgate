IF OBJECT_ID('[stage].[vABK_SE_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vABK_SE_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vABK_SE_PurchaseOrder] AS
--COMMENT EMPTY FIELD // ADD TRIM() 2022-12-21 VA
--ADD TRIM() INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(UPPER([PartNum])))))) AS PurchaseOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', '')))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', '')))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(UPPER(SupplierNum)))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(UPPER([PartNum])))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([PartNum]))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Currency])))) AS CurrencyID
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
	,PartitionKey

	,UPPER(Company) AS Company
	,UPPER(TRIM([PartNum])) AS PartNum
	,UPPER(TRIM(SupplierNum)) AS SupplierNum
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	--,'' AS PurchaseOrderSubLine
	--,'' AS PurchaseOrderType
	--,'' AS PurchaseOrderStatus
	,CONVERT(Date, IIF(PurchaseOrderDate = '0', '1900-01-01', PurchaseOrderDate)) AS PurchaseOrderDate
	,CONVERT(Date, IIF(OrgReqDelivDate = '0', '1900-01-01', OrgReqDelivDate)) AS OrgReqDelivDate
	,CONVERT(Date, IIF(OrgCommittedDelivDate = '0', '1900-01-01', OrgCommittedDelivDate)) AS CommittedDelivDate
	,CONVERT(Date, IIF(ActualDelivDate = '0', '1900-01-01', ActualDelivDate)) AS ActualDelivDate
	,CONVERT(Date, '1900-01-01') AS ReqDelivDate
	,CONVERT(Date, '1900-01-01') AS DelivDate
	--,'' AS PurchaseInvoiceNum
	--,'' AS SupplierPartNum
	--,'' AS SupplierInvoiceNum
	--,'' AS DelivCustomerNum
	--,'' AS PartStatus
	,PurchaseOrderQty
	,PurchaseReceiveQty AS ReceiveQty
	,PurchaseInvoiceQty AS InvoiceQty
	--,NULL AS MinOrderQty
	--,'' AS UoM
	,UnitPrice AS UnitPrice
	--,NULL AS DiscountPercent
	--,NULL AS DiscountAmount
	--,NULL AS TotalMiscChrg
	,LandedCost
	,IIF(Currency IN ('SEK', 'DKK', 'NOK'), (CONVERT(decimal(18,4), ExchangeRate))/100, (CONVERT(decimal(18,4), ExchangeRate)))ExchangeRate
	,TRIM(Currency) AS Currency
	,TRIM(PurchaserName) AS PurchaserName
	--,'' AS ReceivingNum
	--,'' AS DelivTime
	--,'' AS PurchaseChannel
	--,'' AS Documents
	--,'' AS Comments
	--,'' AS PORes1
	--,'' AS PORes2
	--,'' AS PORes3
	--,'' AS [LineType]
	--,'' AS ItemType
	--,'' AS DaysSincePOrder
FROM 
	[stage].[ABK_SE_PurchaseOrder]
	
--GROUP BY
--	PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine, SupplierCode, DelivCustCode, LineType, InvoiceNum, PartNum, OrderType, UnitPrice, DiscountPercent, OrderedQty, ReceivedQty, InvoicedQty, TotalMiscChrg, ExchangeRate, CurrencyCode, ItemType, OrderDate, OrgReqDelivDate, CommitedDelivDate, ActualDelivDate, DelivDate, ReqDelivDate, PurchaserName, RecievingNumber, LeadTime, Comments, WarehouseCode
GO
