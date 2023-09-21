IF OBJECT_ID('[dm].[FactSalesOrder]') IS NOT NULL
	DROP VIEW [dm].[FactSalesOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dm].[FactSalesOrder]
AS
SELECT CONVERT(BIGINT, SalesOrderID) AS SalesOrderID
	,CONVERT(BIGINT, SalesOrderNumID) AS SalesOrderNumID
	,CONVERT(BIGINT, CustomerID) AS CustomerID
	,CONVERT(BIGINT, CompanyID) AS CompanyID
	,CONVERT(BIGINT, PartID) AS PartID
	,CONVERT(BIGINT, WarehouseID) AS WarehouseID
	,CONVERT(BIGINT, ProjectID) AS ProjectID
	,CONVERT(BIGINT,HASHBYTES('SHA2_256',CONCAT(Company,'#',NULLIF(TRIM(SalesPersonName),'')))) AS SalesPersonNameID -- NEW
	,CONVERT(bigint,DepartmentID) AS DepartmentID
	,SalesOrderDateID
	,Company
	,CustomerNum
	,SalesOrderNum
	,SalesOrderLine
	,SalesOrderSubLine
	,SalesOrderType
	,SalesOrderCategory
	,SalesOrderDate
	,CASE WHEN NeedbyDate < '1900-01-01' OR NeedbyDate IS NULL THEN '1900-01-01'
			WHEN NeedbyDate > '2099-12-31' THEN '2099-12-31'
			ELSE NeedbyDate END AS NeedbyDate
	,CASE WHEN ExpDelivDate < '1900-01-01' OR ExpDelivDate IS NULL THEN '1900-01-01'
			WHEN ExpDelivDate > '2099-12-31' THEN '2099-12-31'
			ELSE ExpDelivDate END AS ExpDelivDate
	,CASE WHEN ConfirmedDelivDate < '1900-01-01' OR ConfirmedDelivDate IS NULL THEN '1900-01-01'
			WHEN ConfirmedDelivDate > '2099-12-31' THEN '2099-12-31'
			ELSE ConfirmedDelivDate END AS ConfirmedDelivDate
	,SalesInvoiceNum
	,SalesOrderQty
	,DelivQty
	,CASE WHEN OpenRelease IN ('0','Close','Closed')  THEN 0
		  ELSE RemainingQty
		  END AS RemainingQty --  RemainingQty. Changed 2023-05-16 SB to hardcode remainingqty to 0 if the order is closed.
	,UoM
	,UnitPrice
	,UnitCost
	,Currency
	,ExchangeRate
	,OpenRelease
	,CASE 
		WHEN OpenRelease = '1'
			OR OpenRelease = 'Open'
			THEN 'Open'
		WHEN OpenRelease = '0'
			OR OpenRelease = 'Close'
			THEN 'Closed'
		ELSE OpenRelease
		END AS OrderStatus
	,DiscountAmount
	,DiscountPercent
	,PartNum
	,PartType
	,PartStatus
	,NULLIF(TRIM(SalesPersonName),'') AS SalesPersonName
	,WarehouseCode
	,SalesChannel
	,AxInterSalesChannel
	,Department
	,ProjectNum --In FITMT, Widni% & Rorose, it means deleted in the source when ProjectNum = '1'
	,ActualDelivDate
	,SalesInvoiceQty
	--	,Cancellation -- temp
	,TotalMiscChrg
	,IsUpdatingStock
	,SORes1
	,SORes2
	,SORes3
	,SORes4
	,SORes5
	,SORes6


FROM dw.SalesOrder
WHERE SalesOrderDate >= DATEADD(year, DATEDIFF(YEAR, 0, dateadd(year, - 4, GETDATE())), 0) --AND Cancellation <> '1'
and (is_deleted != 1 OR is_deleted is null)
GROUP BY SalesOrderID
	,CustomerID
	,CompanyID
	,PartID
	,WarehouseID
	,SalesOrderNumID
	,SalesOrderDateID
	,ProjectID
	,Company
	,CustomerNum
	,SalesOrderNum
	,SalesOrderLine
	,SalesOrderSubLine
	,ConfirmedDelivDate
	,SalesOrderType
	,SalesOrderCategory
	,SalesOrderDate
	,NeedbyDate
	,ExpDelivDate
	,SalesInvoiceNum
	,SalesOrderQty
	,DelivQty
	,RemainingQty
	,UoM
	,UnitPrice
	,UnitCost
	,Currency
	,ExchangeRate
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,PartNum
	,PartType
	,PartStatus
	,SalesPersonName
	,WarehouseCode
	,SalesChannel
	,Department
	,ProjectNum
	,ActualDelivDate
	,AxInterSalesChannel
	,SalesInvoiceQty
	,TotalMiscChrg
	,IsUpdatingStock
	,SORes1
	,SORes2
	,SORes3
	,SORes4
	,SORes5
	,SORes6
	,DepartmentID


	--	,Cancellation -- temp
GO
