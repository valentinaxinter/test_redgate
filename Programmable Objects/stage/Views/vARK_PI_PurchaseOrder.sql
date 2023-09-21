IF OBJECT_ID('[stage].[vARK_PI_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vARK_PI_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vARK_PI_PurchaseOrder] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID,PartID,WarehouseID 2022-12-16 VA
--ADD TRIM() INTO SupplierID 23-01-23
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))))) AS PurchaseOrderID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(PurchaseOrderNum))))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(PurchaseInvoiceNum))))) AS PurchaseInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(DelivCustomerNum))))) AS CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(DelivCustomerNum))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(UPPER(SupplierNum)))))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM([PartNum]))))) AS PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(UPPER([PartNum])))))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(Company,'#',TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM([Currency])))) AS CurrencyID
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum),'#',TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine))) AS PurchaseOrderCode
	,PartitionKey AS PartitionKey

	,Company AS Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,TRIM(PurchaseOrderType) AS PurchaseOrderType
	--,'' AS PurchaseOrderStatus
	,PurchaseOrderDate
	,OrgReqDelivDate
	,CommittedDelivDate
	--, '' AS ActualDelivDate
	,ExpDelivDate --
	,ReqDelivDate AS ReqDelivDate
	,TRIM(PurchaseInvoiceNum) AS PurchaseInvoiceNum
	,TRIM(UPPER([PartNum])) AS PartNum
	,TRIM(UPPER(SupplierNum)) AS SupplierNum
	--,'' AS SupplierPartNum
	--,'' AS [SupplierInvoiceNum] 
	,TRIM(DelivCustomerNum) AS DelivCustomerNum
	,PartStatus
	,OrderQty		AS PurchaseOrderQty
	,ReceiveQty
	,InvoiceQty
	--,NULL AS MinOrderQty
	,UoM
	,UnitPrice
	,DiscountPercent
	,DiscountAmount
	,0 AS LandedCost
	,ExchangeRate
	,CASE WHEN Currency = '15' THEN 'EUR' WHEN Currency = '2' THEN 'USD' ELSE Currency END AS Currency
	,TRIM(PurchaserName) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	,ReceivingNum
	,DelivTime
	,PurchaseChannel
	--,'' AS Documents
	--,'' AS Comments
	,PORes1
	,Res2 AS PORes2
	,Res3 AS PORes3

	--,CASE WHEN CONVERT(NVARCHAR(50), TRIM([LineType])) like '0' THEN 'Stock Item Line' WHEN CONVERT(NVARCHAR(50), TRIM([LineType])) like '1' THEN 'Non Stock Item Line' ELSE NULL END AS [LineType]
	--,NULL AS TotalMiscChrg
--	--,CONVERT(NVARCHAR(50), ItemType) AS ItemType
--	,'' AS DaysSincePOrder
FROM 
	[stage].[ARK_PI_PurchaseOrder]
--WHERE PurchaseOrderDate >= DATEADD(year, -1, GETDATE()) --Added this where clause as semi-incremental load functinoality since it doesn't work easily on meta-param table. /SM 2021-10-01	
--GROUP BY
--	PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine, SupplierNum, DelivCustomerNum, PurchaseInvoiceNum, PartNum, PurchaseOrderType, DiscountPercent, OrderQty, ReceiveQty, InvoiceQty, ExchangeRate, Currency, PurchaseOrderDate, OrgReqDelivDate, CommittedDelivDate, ExpDelivDate, ReqDelivDate, PurchaserName, ReceivingNum, DelivTime, WarehouseCode, DiscountPercent, DiscountAmount, PurchaseChannel, PORes1, Res2, Res3, PartStatus,  UnitPrice, UoM
GO
