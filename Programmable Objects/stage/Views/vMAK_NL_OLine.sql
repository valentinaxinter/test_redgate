IF OBJECT_ID('[stage].[vMAK_NL_OLine]') IS NOT NULL
	DROP VIEW [stage].[vMAK_NL_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vMAK_NL_OLine] AS
--COMMENT empty field / ADD UPPER() TRIM() INTO PartID/CustomerID 13-12-2022 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SalesOrderNum),'#',TRIM(SalesOrderLine), '#', TRIM(PartNum) )))) AS SalesOrderID
	,CONCAT(TRIM(Company),'#',TRIM(SalesOrderNum),'#',TRIM(SalesOrderLine)) as SalesOrderCode --'#',OrderSubLine,
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) as CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(TRIM(Company),'#',TRIM(CustomerNum)))) as CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) as CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company, '#', TRIM(PartNum)))) AS PartID 
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',WarehouseCode))) AS WareHouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',upper(CONCAT(trim(Company),'#',trim(WarehouseCode))))) AS WareHouseID -- TO 2022-12-13
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(SalesOrderNum)))) AS SalesOrderNumID
	,YEAR(SalesOrderDate)*10000+MONTH(SalesOrderDate)*100+DAY(SalesOrderDate) AS SalesOrderDateID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(CustomerNum)) AS CustomerNum 
	,TRIM(SalesOrderNum) AS SalesOrderNum
	,TRIM(SalesOrderLine) AS SalesOrderLine
	--,'' AS SalesOrderSubLine
	,SalesOrderType AS SalesOrderType
	--,'' SalesOrderCategory
	--,'' AS SalesOrderRelNum
	,SalesOrderDate	
	,NeedbyDate
	,ExpDelivDate
	,ActualDelivDate
	,CommittedDelivDate AS ConfirmedDelivDate
	,InvoiceNum AS SalesInvoiceNum
	,SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	,UoM
	,UnitPrice/100.0 AS UnitPrice
	,UnitCost/100.0 AS UnitCost
	,Currency
	,1 AS ExchangeRate
	,IIF(IsOrderClosed = 1, 0, 1) AS OpenRelease --original logica/values
	,IIF(IsOrderClosed = 1, 1, 0) AS IsOrderClosed --amended logica/values & naming
--	,COALESCE( UnitPrice/100.0 *  SalesOrderQty * DiscountPercent/100 ,0) AS DiscountAmount
	,DiscountAmountCalc/100 AS DiscountAmount
	,COALESCE(DiscountAmountCalc/100/NULLIF((UnitPrice/100.0 * SalesOrderQty),0),0)	AS DiscountPercent
	,UPPER(TRIM(PartNum)) AS PartNum
	,CASE WHEN TRIM(SalesOrderLine) = '0' THEN 'Main Part' ELSE 'Sub Part' END  AS PartType
	,PartStatus
	,[dbo].[ProperCase](SalesPersonName) AS SalesPersonName
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	--,'' AS SalesChannel
	,IIF(SalesOrderNum LIKE 'TNT%', 'EDI', 'Normal Order Handling') AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS IndexKey
	,[Cancellation]
	--,IIF([Cancellation] = '1', 1, 0) AS is_deleted
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3

	,ReturnComment
	--,'' AS SalesReturnOrderNum
	,SalesReturnInvoiceNum
	--,NULL AS [TotalMiscChrg]
FROM stage.MAK_NL_OLine
WHERE Cancellation != 1 --the SalesInvoiceQty = 0 and the OpenRelease(order)= “X” (Cancellation = 1) orders should not show at all -- ticket #116500
--Where DCPAGMP <> '*'
/*GROUP BY Company, SalesOrderNum, SalesOrderLine, PartNum, CustomerNum, SalesOrderDate, SalesOrderType, UoM,InvoiceNum, PartitionKey, NeedbyDate, ExpDelivDate	,SalesOrderQty, DelivQty	,UnitPrice
	,UnitCost, Currency, OpenRelease, DiscountPercent, PartStatus,SalesPersonName, ReturnComment, SalesReturnInvoiceNum, WarehouseCode*/
GO
