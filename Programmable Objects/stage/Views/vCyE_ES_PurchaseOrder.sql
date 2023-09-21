IF OBJECT_ID('[stage].[vCyE_ES_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vCyE_ES_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCyE_ES_PurchaseOrder] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO CustomerID,WarehouseID,PartID 23-01-03 VA
--ADD UPPER() INTO SupplierID 23-01-23 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(InvoiceNum),'#',TRIM(SupplierNum),'#',TRIM(PartNum),'#',TRIM(PONum),'#',TRIM(POLine)))) AS PurchaseOrderID --, '#', OrderDate
	,CONCAT(Company,'#',TRIM(SupplierNum),'#',TRIM(PONum),'#',TRIM(POLine), '#', TRIM(PartNum), '#', TRIM(InvoiceNum)) AS PurchaseOrderCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(PONum)))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(InvoiceNum)))) AS PurchaseInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256','EUR')) AS CurrencyID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM('')))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#','')))) AS CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(SupplierNum)))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID	
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(PartNum)))) AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]), '#', '')))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM(''))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',TRIM([Company]))) AS CompanyID
	,PartitionKey

	,Company
	,TRIM(PONum) AS PurchaseOrderNum
	,TRIM(POLine) AS PurchaseOrderLine
	--,TRIM('') AS PurchaseOrderSubLine
	--,TRIM('') AS PurchaseOrderType
	,OrderDate AS PurchaseOrderDate
	,CASE WHEN InvoiceNum IS NULL or InvoiceNum = '' THEN 'Open' ELSE 'Closed' END AS PurchaseOrderStatus
	,CAST ('1900-01-01' AS date) AS OrgReqDelivDate
	,CAST ('1900-01-01' AS date) AS CommittedDelivDate
	,CAST ('1900-01-01' AS date) AS ActualDelivDate
	,CAST ('1900-01-01' AS date) AS ReqDelivDate
	,TRIM(InvoiceNum) AS PurchaseInvoiceNum
	,TRIM(PartNum) AS PartNum
	,TRIM(SupplierNum) AS SupplierNum
	,TRIM(PartNum) AS SupplierPartNum
	,TRIM(InvoiceNum) AS SupplierInvoiceNum
	--,TRIM('') AS DelivCustomerNum
	--,NULL AS PartStatus
	,Qty/1000 AS PurchaseOrderQty
	--,NULL AS ReceiveQty
	--,NULL AS InvoiceQty
	--,NULL AS MinOrderQty
	--,'' AS UoM
	,UnitPrice
	--,NULL AS DiscountPercent
	--,NULL AS DiscountAmount
	--,NULL AS LandedCost
	,1 ExchangeRate
	,'EUR' AS Currency
	--,TRIM('') AS PurchaserName
	--,TRIM('') AS WarehouseCode
	--,'' AS ReceivingNum
	--,'' AS DelivTime
	--,'' AS PurchaseChannel
	,CONVERT(NVARCHAR(50),'') AS Documents
	--,TRIM('') AS Comments
--	,DelivDate
--	,CASE WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '0' THEN 'Stock Item Line' WHEN CONVERT(NVARCHAR(50),TRIM([LineType])) like '1' THEN 'Non Stock Item Line' ELSE NULL END AS [LineType]
	--,'' AS PORes1
	--,'' AS PORes2
	--,'' AS PORes3
FROM 
	[stage].[CYE_ES_POLine]
	
GROUP BY
	PartitionKey, Company, PONum, POLine, SupplierNum, InvoiceNum, PartNum, UnitPrice, Qty, OrderDate
GO
