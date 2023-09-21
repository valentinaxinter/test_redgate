IF OBJECT_ID('[stage].[vFOR_PL_OLine]') IS NOT NULL
	DROP VIEW [stage].[vFOR_PL_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vFOR_PL_OLine] AS
--COMMENT EMPTY FIELDS // ADD UPPER()TRIM() INTO CustomerID,WarehouseID,PartID 23-01-11 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',SalesOrderNum,'#',SalesOrderLine))) AS SalesOrderID
	,CONCAT(Company,'#',SalesOrderNum,'#',SalesOrderLine) as SalesOrderCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) as CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustomerNum)))) as CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) as CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]) ,'#', TRIM(PartNum))))) as PartID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(PartNum)))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([Company],'#',TRIM([WarehouseCode])))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(SalesOrderNum)))) AS SalesOrderNumID  
	,CONVERT(int, REPLACE(CONVERT(date, SalesOrderDate),'-','')) AS SalesOrderDateID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#',TRIM(ProjectNum))))	AS ProjectID

	,PartitionKey 
	,Company 
	,TRIM(CustomerNum) as CustomerNum 
	,SalesOrderNum
	,SalesOrderLine
	--,'' AS SalesOrderSubLine
	,CASE	WHEN IsCancelled = 'Y' THEN 'Cancelled'
			WHEN [SalesOrderLineStatus] = 'C' AND [TargetType] ='-1' THEN 'Error'
			ELSE 'Show'	END		AS SalesOrderType			-- Some order lines are not necessary to show in report and we are using this field to distinguish it and filter in Power BI /SM 2022-07-12
	--,'' AS SalesOrderCategory
	--,'' AS SalesOrderRelNum
	,SalesOrderDate
	,NeedbyDate
	,ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	--,'' AS SalesInvoiceNum
	,SalesOrderQty
	,DelivQty
	,RemainingQty
	,NULL AS SalesInvoiceQty
	,UoM
	,UnitPrice
	,UnitCost
	,Currency 
	,ExchangeRate  
	,CASE WHEN [SalesOrderLineStatus] = 'C' THEN '0'
		  WHEN [SalesOrderLineStatus] = 'O' THEN '1'
		  ELSE [SalesOrderStatus]				END	AS	OpenRelease
	,DiscountAmount
	,DiscountPercent
	,TRIM(PartNum) AS PartNum
	,PartType
	--,''	AS PartStatus
	,SalesPersonName AS SalesPersonName
	,TRIM(WarehouseCode) as WarehouseCode
	--,'' AS SalesChannel
	--,'' AS AxInterSalesChannel
	--,'' AS Department
	,ProjectNum
	--,'' AS IndexKey
	,IsCancelled AS Cancellation
	,[SalesOrderStatus] AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
--	,ReturnComment
--	,SalesReturnOrderNum
--	,SalesReturnInvoiceNum
	,NULL AS [TotalMiscChrg]
FROM stage.FOR_PL_OLine
--GROUP BY PartitionKey,Company, CustomerNum, SalesOrderNum, SalesOrderLine, OrderSubLine, OrderRelNum, SalesOrderDate, NeedbyDate, ExpDelivDate, SalesInvoiceNum, OrderQty, DelivQty, RemainingQty, UnitPrice, UnitCost, SumUnitCost, SumUnitPrice, CurrExChRate, OpenRelease, OpenRelease, DiscountAmount, DiscountPercent, PartNum, PartStatus, SalesPerson, WarehouseCode, SalesChannel
GO
