IF OBJECT_ID('[stage].[vCER_SE_SalesOrderLog]') IS NOT NULL
	DROP VIEW [stage].[vCER_SE_SalesOrderLog];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [stage].[vCER_SE_SalesOrderLog] As
SELECT 
		
	  CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', IndexKey)))) AS SalesOrderLogID
	  ,CONVERT([binary](32), HASHBYTES('SHA2_256', TRIM(Company))) AS CompanyID
	  ,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(CustNum))))) AS CustomerID
	  ,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(PartNum))))) AS PartID
	  ,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(UPPER(WarehouseCode))))) AS WarehouseID
	  --,UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(UPPER(PartNum)))) AS SalesOrderCode 
	  ,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID   --redundent
	  ,PartitionKey

	  ,[Company]
      ,[CustNum]	AS CustomerNum
      ,[OrderNum]	AS SalesOrderNum
      ,[OrderLine]	AS SalesOrderLine
      ,[OrderSubLine]	AS SalesOrderSubLine
      ,[OrderType]		AS SalesOrderType
      ,[OrderDate]		AS SalesOrderDate
	  ,[TransactionDate]	AS SalesOrderLogDate
	  ,'' AS SalesOrderLogType
--      ,[DelivDate]		AS ExpDelivDate
      ,[InvoiceNum]		AS SalesInvoiceNum
      ,[OrderQty]		AS SalesOrderQty
	  ,''				AS UoM
      ,[UnitPrice]
      ,[UnitCost]
      ,[Currency]
      ,[CurrExchRate]	AS ExchangeRate
      ,[OpenRelease]
      ,[DiscountPercent]
      ,[DiscountAmount]
      ,[PartNum]
	  ,IIF(OrderSubLine = '000000', 'Main', 'Sub' ) AS PartType
--      ,[NeedbyDate]
      ,[SalesPerson]	AS SalesPersonName
	  ,''				AS Department
      ,[ReturnComment]
      ,[SalesReturnInvoiceNum]
      ,[WarehouseCode]
      ,[CancellationCode]
      ,[IndexKey]
	  ,'' AS SORes1
	  ,'' AS SORes2
	  ,'' AS SORes3
	  
  FROM [stage].[CER_SE_SalesOrderLog]
GO
