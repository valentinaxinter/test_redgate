IF OBJECT_ID('[stage].[vNOM_SE_OLine]') IS NOT NULL
	DROP VIEW [stage].[vNOM_SE_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vNOM_SE_OLine] AS
--COMMENT EMPTY FIELDS 2022-12-20 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#', TRIM(OrderNum),'#', TRIM(OrderLine),'#', TRIM(OrderRelNum))))) AS SalesOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(OrderNum))))) AS SalesOrderNumID  
	,UPPER(CONCAT(TRIM(Company),'#',TRIM(OrderNum),'#',TRIM(OrderLine))) AS SalesOrderCode 
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID --Redundant?  
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 

	,UPPER(TRIM(Company)) AS Company
	,UPPER(TRIM(CustNum)) AS CustomerNum 
	,UPPER(TRIM(OrderNum)) AS SalesOrderNum
	,UPPER(TRIM(OrderLine)) AS SalesOrderLine
	,OrderSubLine AS SalesOrderSubLine
	,IIF(SalesOrderType = '10 - Internal Order', 'Internal Order', SalesOrderType) AS SalesOrderType -- added 2022-08-26 LL/DZ
	--,'' AS SalesOrderCategory
	,CONVERT(date, IIF(OrderDate = '0--', '1900-01-01', OrderDate)) AS SalesOrderDate
	,CONVERT(date, IIF(NeedbyDate = '0--', '1900-01-01', NeedbyDate)) AS NeedbyDate
	,CONVERT(date, IIF(ExpDelivDate = '0--', '1900-01-01', ExpDelivDate)) AS ExpDelivDate
	,CONVERT(date, IIF(ActualDelivDate = '0--', '1900-01-01', ActualDelivDate)) AS ActualDelivDate
	,CONVERT(date, IIF(FirstConfirnedDate = '0--', '1900-01-01', FirstConfirnedDate)) AS ConfirmedDelivDate
	,UPPER(TRIM(InvoiceNum)) AS SalesInvoiceNum
	,IIF(SalesOrderType = '7 - Direct Credit Order' OR SalesOrderType = '8 - Credit Order', -1*OrderQty, OrderQty) AS SalesOrderQty
	,IIF(SalesOrderType = '7 - Direct Credit Order' OR SalesOrderType = '8 - Credit Order', -1*DelivQty, DelivQty) AS DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	,Currency  --CASE WHEN (Company = 'NomoSE' and CurrExChRate = 1) THEN 'SEK'  WHEN (Company = 'NomoDK' and CurrExChRate = 1) THEN 'DKK'  WHEN (Company = 'NomoFI' and CurrExChRate = 1) THEN 'EUR' ELSE CURRENCY END AS 
	,ExchangeRate
	,CASE WHEN OpenRelease = 'I' THEN '0' ELSE '1' END AS OpenRelease
	,IIF(SalesOrderType = '7 - Direct Credit Order' OR SalesOrderType = '8 - Credit Order', -1*DiscountAmount, DiscountAmount) AS DiscountAmount
	,IIF(SalesOrderType = '7 - Direct Credit Order' OR SalesOrderType = '8 - Credit Order', -1*DiscountPercent, DiscountPercent) AS DiscountPercent
	,PartNum
	,ItemClass AS PartType
	,PartStatus
	,SalesPersonName
	,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
	,SalesOrderChannel AS SalesChannel
	,SalesOrderChannel As AxInterSalesChannel
	,UpdateStock AS IsUpdatingStock
	--,'' AS Department
	--,'' AS ProjectNum
	--,'' AS IndexKey
	,ReturnComment
	,UPPER(TRIM(SalesReturnOrderNum)) AS SalesReturnOrderNum
	,UPPER(TRIM(SalesReturnInvoiceNum)) AS SalesReturnInvoiceNum
	--,'0' AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.NOM_SE_OLine
GROUP BY
	PartitionKey, Company, CustNum, OrderNum, OrderLine, OrderSubLine, SalesOrderType, OrderRelNum, InvoiceNum, OrderQty, DelivQty, RemainingQty, UnitPrice, UnitCost, Currency, ExchangeRate, OpenRelease, DiscountAmount, DiscountPercent, PartNum, PartStatus, SalesPersonName, ReturnComment, SalesReturnOrderNum, SalesReturnInvoiceNum, WarehouseCode, OrderDate, NeedbyDate, DelivDate, SalesOrderChannel, ItemClass, ExpDelivDate, ActualDelivDate, FirstConfirnedDate, UpdateStock
GO
