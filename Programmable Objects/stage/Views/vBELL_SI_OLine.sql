IF OBJECT_ID('[stage].[vBELL_SI_OLine]') IS NOT NULL
	DROP VIEW [stage].[vBELL_SI_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vBELL_SI_OLine] AS
-- This CTE contains a ROW_NUMBER() statement to get the live version of a order line (field Archived = 0) whenever there is one.
-- It does so by partitioning on the fields in salesOrderID and then ordering it by Archived field, meaning that the live version should always have RowNum = 1 when it exists.
-- Under the CTE we do a simple select [fields] FRom cte
-- Using the field UoM to store Archived values.
WITH cte as(
--COMMENT EMPTY FIELDS // ADD UPPER() INTO PartID,CustomerID,WarehouseID 2022-12-27 VA
SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#', CustNum,'#',OrderNum,'#',OrderLine,'#',OrderRelNum,'#',InvoiceNum,'#',IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum])),'#',OrderDate))) AS SalesOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustNum)))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum])))))) AS PartID 
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum]))))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',trim( WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#', WarehouseCode))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(OrderNum)))) AS SalesOrderNumID
	,CONCAT(Company, '#', OrderNum, '#', IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum]))) AS SalesOrderCode -- should be identical as in Invoice table
	,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,PartitionKey 
	,ROW_NUMBER() OVER (PARTITION BY Company, CustNum, OrderNum,OrderLine,OrderRelNum,InvoiceNum, PartNum, OrderDate Order BY Archived) AS RowNum

	,Company 
	,TRIM(CustNum) AS CustomerNum
	,OrderNum		AS SalesOrderNum
	,OrderLine		AS SalesOrderLine
	,OrderSubLine	AS SalesOrderSubLine
	--,'' AS SalesOrderType
	--,'' AS SalesOrderCategory
	,OrderDate		AS SalesOrderDate
	,NeedbyDate
	,DeliveDate AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,InvoiceNum		AS SalesInvoiceNum
	,OrderQty		AS SalesOrderQty
	,DelivQty		
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	,Archived AS UoM
	,UnitPrice
	,UnitCost
	,CurrencyCode AS Currency
	,IIF(CurrencyCode = 'EUR', 1, 0) AS ExchangeRate
	,OpenRelease
	,DiscountAmount
	,DiscountPercent
	,IIF(LEFT(TRIM([PartNum]), 1) = 'I', SUBSTRING(TRIM([PartNum]), 2, 50), TRIM([PartNum])) AS PartNum
	--,'' AS PartType
	,PartStatus
	,SalesPerson AS SalesPersonName
	,TRIM(WarehouseCode) AS WarehouseCode
	,SalesChannel
	,CASE WHEN SalesChannel = 'magento' THEN 'Webshop'
		ELSE 'Normal Order Handling' END AS AxInterSalesChannel
	--,'' AS Department
	--,'' AS [ProjectNum]
	--,'' AS [IndexKey]
	--,'0' AS Cancellation
	--,'' AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.BELL_SI_Oline
--where Archived = 1 -- Temporary added to avoid problems
)

-- Here we simply select the rows with RowNum = 1. 
SELECT [SalesOrderID]
      ,[CompanyID]
      ,[CustomerID]
      ,[PartID]
      ,[WarehouseID]
      ,[SalesOrderNumID]
      ,[SalesOrderCode]
      ,[SalesOrderDateID]
	  ,ProjectID
      ,[PartitionKey]
      ,[Company]
      ,[CustomerNum]
      ,[SalesOrderNum]
      ,[SalesOrderLine]
      ,[SalesOrderSubLine]
      --,[SalesOrderType]
      --,[SalesOrderCategory]
      ,[SalesOrderDate]
      ,[NeedbyDate]
      ,[ExpDelivDate]
      ,[ActualDelivDate]
	  ,ConfirmedDelivDate
      ,[SalesInvoiceNum]
      ,[SalesOrderQty]
      ,[DelivQty]
      ,[RemainingQty]
	  ,NULL AS SalesInvoiceQty
      ,[UoM]
      ,[UnitPrice]
      ,[UnitCost]
      ,[Currency]
      ,[ExchangeRate]
      ,[OpenRelease]
      ,[DiscountAmount]
      ,[DiscountPercent]
      ,[PartNum]
      --,[PartType]
      ,[PartStatus]
      ,[SalesPersonName]
      ,[WarehouseCode]
      ,[SalesChannel]
	  ,AxInterSalesChannel
      --,[Department]
      --,[ProjectNum]
      --,[IndexKey]
      --,[Cancellation]
      --,[SORes1]
      --,[SORes2]
      --,[SORes3]
	  ,NULL AS [TotalMiscChrg]
FROM cte
Where RowNum = 1
GO
