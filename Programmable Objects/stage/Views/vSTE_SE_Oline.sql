IF OBJECT_ID('[stage].[vSTE_SE_Oline]') IS NOT NULL
	DROP VIEW [stage].[vSTE_SE_Oline];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE View [stage].[vSTE_SE_Oline] AS
SELECT
	 CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(InvoiceNum))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company))))	 AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum)))))	 AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company) ,'#', TRIM(PartNum)))))	AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM([WarehouseCode])))))	 AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#',''))))	 AS ProjectID
	,UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum), '#', TRIM(OrderNum), '#', TRIM(OrderLine))) AS SalesOrderCode
    ,CONVERT(int, replace(convert(date, OrderDate),'-','')) AS SalesOrderDateID
	

	,[PartitionKey] 
	,UPPER(TRIM("Company")) AS "Company"
	,UPPER(TRIM([CustNum])) AS "CustomerNum"	
	,UPPER(TRIM([PartNum])) AS "PartNum"	
	,UPPER(TRIM([OrderNum])) AS "SalesOrderNum"	
	,[OrderLine] AS "SalesOrderLine"
	,[OrderDate] AS "SalesOrderDate"
	,[InvoiceNum] AS "SalesInvoiceNum"
	,[SalesOrderType]		
	,iif([IsOrderClosed]='True',0,1) as OpenRelease
	,[IsOrderClosed]
	,[ReqDelivDate]		
	,[ExpDelivDate]		
	,[ExpShipDate]		
	,[ActualShipDate]		
	,[ActualDelivDate]
	,[OrderQty]		AS "SalesOrderQty"	
	,[SalesDelivQty]
	,[SalesInvoiceQty]	
	,[SalesRemainingQty] AS	"RemainingQty"
	,[UoM]				
	,[UnitPrice]			
	,[UnitCost]			
	,[Currency]			
	,[CurrExchRate]	 AS "ExchangeRate"	
	,[DiscountPercent]	
	,[DiscountAmount]		
	,[PartType]			
	,[PartStatus]			
	,[SalesPersonName]	
	,[WarehouseCode]		
	,[IndexKey]			
	,[Sales Channel]	AS "SalesChannel"
	,SORes1

FROM
	stage.STE_SE_OLine
GO
