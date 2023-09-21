IF OBJECT_ID('[stage].[vCYE_ES_OLine]') IS NOT NULL
	DROP VIEW [stage].[vCYE_ES_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vCYE_ES_OLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() INTO CustomerID,WarehouseID,PartID 23-01-03 VA 
SELECT
    CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(InvoiceNum))))) AS SalesOrderID
    ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(Company))) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', TRIM(CustNum)) ) )))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
    --,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  TRIM(PartNum)) ))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SalesOfficeDescrip))))) AS WarehouseID 
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SalesOfficeDescrip))))) AS WarehouseID -- real one is WarehouseCode, use officedescrip for temp solution --/DZ + ET 2022-03-18
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine))) AS SalesOrderCode
    ,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT( Company, '#', '') ))) AS ProjectID
    ,PartitionKey 

    ,UPPER(Company) AS Company
    ,UPPER(TRIM(CustNum)) AS CustomerNum 
    ,UPPER(TRIM(PartNum)) AS PartNum
    ,TRIM(OrderNum) AS SalesOrderNum
    ,TRIM(OrderLine) AS SalesOrderLine
    ,LEFT(TRIM(OrderRelNum), 50) AS SalesOrderSubLine
	,TRIM(OrderType) AS SalesOrderType
	--,'' AS SalesOrderCategory
	,TRIM(OrderRelNum) AS SalesOrderRelNum
    ,OrderDate AS SalesOrderDate
    ,NeedbyDate
    ,IIF(NeedbyDate is null, '1900-01-01', NeedbyDate) AS ExpDelivDate	-- SAP field is ????? Eva will check;   NeedbyDate temporary solution, since it is this date connected to the 2nd.date dimention
	,IIF(DelivDate is null, '1900-01-01', DelivDate) AS ConfirmedDelivDate -- Jamue: 
	,DelivDate AS ActualDelivDate
    ,TRIM(InvoiceNum) AS SalesInvoiceNum
    ,OrderQty/1000 AS SalesOrderQty
    ,DelivQty/1000 AS DelivQty --(OrderQty-RemainingQty)/1000 --DelivQty/1000
    ,OrderQty/1000 - DelivQty/1000 AS RemainingQty -- real remaining qty --RemainingQty from erp is actually InvoiceQty
	--,NULL AS SalesInvoiceQty
    --,'' AS UoM
	,UnitPrice/10000 AS UnitPrice
    ,UnitCost/10000 AS UnitCost ---were /1000 --20210525 /DZ+ET
    ,1 AS ExchangeRate--20210525 /DZ+ET
	,'EUR' AS Currency
	,IIF(RemainingQty = 0, 0, 1) AS OpenRelease -- av Emil i möte med M Carmen osv 2021-11-18
    ,DiscountAmount AS DiscountAmount -- no Discountamount in CyESA, they need an extra numerical field called InvoiceQty /20220427 DZ
    ,DiscountPercent/100 AS DiscountPercent
	--,'' AS PartType
    --,'' AS PartStatus
    ,TRIM(SalesGroupDescrip) AS SalesPersonName--20210525 /DZ+ET
	,TRIM(SalesOfficeDescrip) AS WarehouseCode -- real one is WarehouseCode, use officedescrip for temp solution --/DZ + ET 2022-03-18
	--,'' AS CostBearerNum
	--,'' AS SalesChannel
	,'Normal Order Handling' AS AxInterSalesChannel
	,TRIM(SalesOfficeDescrip) AS Department --20210525 /DZ+ET
	--,'' AS ProjectNum
	--,'' AS IndexKey
	--,'0' AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM [stage].[CYE_ES_OLine]
GO
