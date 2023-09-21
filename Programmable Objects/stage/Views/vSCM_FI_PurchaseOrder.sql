IF OBJECT_ID('[stage].[vSCM_FI_PurchaseOrder]') IS NOT NULL
	DROP VIEW [stage].[vSCM_FI_PurchaseOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSCM_FI_PurchaseOrder] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO PartID,CustomerID,WarehouseID 2022-12-21 VA
--ADD TRIM() UPPER() INTO SupplierID 23-01-24 VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PurchaseOrderNum), '#', TRIM(PurchaseOrderLine), '#', TRIM(PurchaseOrderSubLine)))) AS PurchaseOrderID -- tag bort , '#', DelivDate, men lägg till ActualDelivDate
	,CONCAT(Company, '#', TRIM(SupplierCode), '#', TRIM(PurchaseOrderNum), TRIM(PurchaseOrderLine), TRIM(PurchaseOrderSubLine), TRIM(InvoiceNum)) AS PurchaseOrderCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PurchaseOrderNum)))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(InvoiceNum)))) AS PurchaseInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM([CurrencyCode]))) AS CurrencyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(DelivCustCode))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(DelivCustCode)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierCode))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(SupplierCode)))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(PartNum)))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([WarehouseCode])))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,PartitionKey AS PartitionKey

	,Company
	,TRIM(PurchaseOrderNum) AS PurchaseOrderNum
	,TRIM(PurchaseOrderLine) AS PurchaseOrderLine
	,TRIM(PurchaseOrderSubLine) AS PurchaseOrderSubLine
	,TRIM(OrderType) AS [PurchaseOrderType]
	,CASE WHEN OpenLine = 'True' THEN 'Open' ELSE 'Closed' END AS PurchaseOrderStatus
	,OpenLine
	,OrderDate AS [PurchaseOrderDate]
	,CASE WHEN OrgReqDelivDate <= '1900-01-01' or OrgReqDelivDate = '' or OrgReqDelivDate is null THEN '1900-01-01' 
	      ELSE OrgReqDelivDate END  AS [OrgReqDelivDate] -- This is currently set as DueDate in Epicor server. Used in EDC Stock Report /SM 2021-09-10
	,CASE WHEN CommitedDelivDate <= '1900-01-01' or CommitedDelivDate = '' or CommitedDelivDate is null THEN '1900-01-01' 
	      ELSE CommitedDelivDate END AS [CommittedDelivDate]
	--,DelivDate AS ExpDelivDate
	,CASE WHEN ActualDelivDate <= '1900-01-01' or ActualDelivDate = '' or ActualDelivDate is null THEN '1900-01-01' 
	      ELSE ActualDelivDate END   AS [ActualDelivDate] -- It's either DelivDate or ActualDelivDate from stage table
	,CASE WHEN ReqDelivDate <= '1900-01-01' or ReqDelivDate = '' or ReqDelivDate is null THEN '1900-01-01' 
	      ELSE ReqDelivDate END  AS [ReqDelivDate]
	,TRIM(InvoiceNum) AS [PurchaseInvoiceNum]
	,TRIM(PartNum) AS PartNum
	,TRIM(SupplierCode) AS [SupplierNum]
	--,'' AS SupplierPartNum
	--,'' AS [SupplierInvoiceNum]
	,TRIM(DelivCustCode) AS [DelivCustomerNum]
	--,'' AS [PartStatus]
	,OrderedQty AS PurchaseOrderQty
	,ReceivedQty AS ReceiveQty
	,InvoicedQty AS InvoiceQty
	--,0 AS MinOrderQty
	--,'' AS [UoM]
	,UnitPrice AS UnitPrice
	,DiscountPercent AS DiscountPercent
	,UnitPrice*OrderedQty*DiscountPercent/100 AS [DiscountAmount]
	--,0 AS LandedCost
	,ExchangeRate
	,CurrencyCode AS [Currency]
	,[dbo].[ProperCase](TRIM(PurchaserName)) AS PurchaserName
	,TRIM(WarehouseCode) AS WarehouseCode
	--,'' AS ReceivingNum
	,LeadTime AS [DelivTime]
	--,'' AS [PurchaseChannel]
	--,'' Documents
	,TRIM(Comments) AS Comments
	,CASE WHEN CONVERT(NVARCHAR(50), TRIM([LineType])) like '0' THEN 'Stock Item Line' WHEN CONVERT(NVARCHAR(50), TRIM([LineType])) like '1' THEN 'Non Stock Item Line' ELSE NULL END AS PORes1 --[LineType] SCM requires
	,CONVERT(NVARCHAR(50), ItemType) AS PORes2 --ItemType SCM requires
	,TRIM(SysRowID) AS PORes3
FROM 
	[stage].[SCM_FI_PurchaseOrder]
/*	
GROUP BY
	PartitionKey, Company, PurchaseOrderNum, PurchaseOrderLine, PurchaseOrderSubLine, SupplierCode, DelivCustCode, LineType, InvoiceNum, PartNum, OpenLine, OrderType, UnitPrice, OrderedQty, ReceivedQty, InvoicedQty, TotalMiscChrg, ExchangeRate, CurrencyCode, ItemType, OrderDate, ActualDelivDate, OrgReqDelivDate, CommitedDelivDate, ReqDelivDate, PurchaserName, Comments, WarehouseCode, SysRowID, LeadTime

	*/
GO
