IF OBJECT_ID('[dm].[FactSalesOrderLog]') IS NOT NULL
	DROP VIEW [dm].[FactSalesOrderLog];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
------------------------------------------------------------------------------------------
CREATE   VIEW [dm].[FactSalesOrderLog] AS

SELECT  CONVERT(bigint,[SalesOrderLogID]) AS [SalesOrderLogID]
      ,CONVERT(bigint,[CompanyID])			AS [CompanyID]
      ,CONVERT(bigint,[CustomerID])			AS [CustomerID]
      ,CONVERT(bigint,[PartID])				AS [PartID]
      ,CONVERT(bigint,[WarehouseID])		AS [WarehouseID]
	  ,CONVERT(BIGINT,HASHBYTES('SHA2_256',CONCAT(Company,'#',NULLIF(TRIM(SalesPersonName),'')))) AS SalesPersonNameID -- NEW
      ,[SalesOrderDateID]
      ,[PartitionKey]
      ,[Company]
      ,[CustomerNum]
      ,[SalesOrderNum]
      ,[SalesOrderLine]
      ,[SalesOrderSubLine]
      ,[SalesOrderType]
	  ,SalesOrderLogType
      ,[SalesOrderDate]
      ,[SalesOrderLogDate]
      ,[SalesInvoiceNum]
      ,[SalesOrderQty]
      ,[UoM]
      ,[UnitPrice]
      ,[UnitCost]
      ,[Currency]
      ,[ExchangeRate]
      ,[OpenRelease]
      ,[DiscountPercent]
      ,[DiscountAmount]
      ,[PartNum]
      ,[PartType]
      ,NULLIF(TRIM(SalesPersonName),'') AS SalesPersonName
      ,[Department]
     -- ,[ReturnComment]
    --  ,[SalesReturnInvoiceNum]
      ,[WarehouseCode]
   --   ,[CancellationCode]
   --   ,[IndexKey]
  FROM [dw].[SalesOrderLog]
GO
