IF OBJECT_ID('[stage].[vTMT_FI_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vTMT_FI_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vTMT_FI_PurchaseOrder] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID 23-01-09 
--ADD TRIM() INTO SupplierID 23-01-04 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine) )))) AS PurchaseOrderID 
	,UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum), '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode --
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', '')))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Currency)))) AS CurrencyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(DelivCustomerNum))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(DelivCustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,getdate() AS PartitionKey -- 

	,UPPER(Company) AS Company
	,UPPER(TRIM(PartNum)) AS PartNum
	,UPPER(TRIM(SupplierNum)) AS [SupplierNum]
	,(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
	,(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine -- invoiceline
	,TRIM(PurchaseOrderType) AS PurchaseOrderType
	,CASE WHEN IsOrderClosed = '1' THEN '1'
			WHEN SUM(ReceiveQty) > PurchaseOrderQty THEN '0' -- after discusstion with Petri 20230316 /DZ
			WHEN SUM(ReceiveQty) < PurchaseOrderQty AND PurchaseOrderDate < '2022-10-01' THEN '0' -- after discusstion with Petri 20230316 /DZ
			ELSE '0' END AS PurchaseOrderStatus
	,CASE WHEN IsOrderClosed = '1' THEN '1'
			WHEN SUM(ReceiveQty) > PurchaseOrderQty THEN '0' -- after discusstion with Petri 20230316 /DZ
			WHEN SUM(ReceiveQty) < PurchaseOrderQty AND PurchaseOrderDate < '2022-10-01' THEN '0' -- after discusstion with Petri 20230316 /DZ
			ELSE '0' END AS IsClosed
	,IIF(PurchaseOrderDate IS NULL, '1900-01-01', PurchaseOrderDate) AS PurchaseOrderDate
	,IIF(OrgReqDelivDate IS NULL, '1900-01-01', OrgReqDelivDate) AS OrgReqDelivDate
--	,OrgCommittedDelivDate
	,IIF(CommittedDelivDate IS NULL, '1900-01-01', CommittedDelivDate) AS CommittedDelivDate
	,IIF(ActualDelivDate IS NULL, '1900-01-01', ActualDelivDate) AS ActualDelivDate
	,IIF(ActualDelivDate IS NULL, '1900-01-01', ReqDelivDate) AS ReqDelivDate
	--,'' AS PurchaseInvoiceNum  -- MIN(IIF(TRIM(PurchaseInvoiceNum) = '0',  Null, UPPER(TRIM(PurchaseInvoiceNum))))
	,TRIM(SupplierPartNum) AS SupplierPartNum
	,MIN(TRIM(SupplierInvoiceNum)) AS SupplierInvoiceNum
	,TRIM(DelivCustomerNum) AS [DelivCustomerNum]
	,PartStatus
	,PurchaseOrderQty
	,SUM(ReceiveQty) as ReceiveQty
	,SUM(PurchaseInvoiceQty) AS InvoiceQty
	,MinOrderQty
	,[UoM]
	,UnitPrice
	,DiscountPercent
	,DiscountAmount
	,LandedCost
	,IIF(ExchangeRate = 0, 0, 1/ExchangeRate) AS ExchangeRate -- 
	,Currency
	,UPPER(TRIM(PurchaserName)) AS PurchaserName
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,TRIM(ReceivingNum) AS ReceivingNum
	,datediff(day, LEFT(DelivTime, 10), getdate()) AS DelivTime
	,PurchaseChannel
	,Documents
	,TRIM(Comments) AS Comments
	,[Version] AS PORes1 
	--,'' AS PORes2 
	--,'' AS PORes3
FROM 
	[stage].[TMT_FI_PurchaseOrder]
	
GROUP BY
	PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine, SupplierNum, DelivCustomerNum, PurchaseOrderStatus, PartNum, PurchaseOrderType, UnitPrice, PurchaseOrderQty, MinOrderQty, UoM,  ExchangeRate, Currency, PurchaseOrderDate, ActualDelivDate, OrgReqDelivDate, CommittedDelivDate, ReqDelivDate, PurchaserName, WarehouseCode, DiscountPercent, DiscountAmount, DelivTime, PurchaseChannel, SupplierPartNum, PartStatus,Documents, Comments, LandedCost, ReceivingNum, [Version], IsOrderClosed--, SysRowID, LeadTime
GO
