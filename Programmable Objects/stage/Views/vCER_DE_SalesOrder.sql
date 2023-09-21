IF OBJECT_ID('[stage].[vCER_DE_SalesOrder]') IS NOT NULL
	DROP VIEW [stage].[vCER_DE_SalesOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vCER_DE_SalesOrder]
	AS SELECT 
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SalesOrderNum),'#',TRIM(SalesOrderLine))))) AS SalesOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) as CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) as CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SalesOrderNum))))) AS SalesOrderNumID 
	,CONVERT(int, replace(convert(date, SalesOrderDate),'-','')) AS SalesOrderDateID

	,[PartitionKey]			
	,[Company]				
	,[CustomerNum]			
	,[SalesOrderNum]		
	,[SalesOrderLine]		
	,[SalesOrderDate]		
	,[ReqDelivDate]			
	,[ExpShipDate]			
	,[ActualShipDate]		
	,[CommitedDelivDate]	
	,[IsOrderClosed]		
	,[OrderHandler]			
	,[SalesOrderQty]		
	,[DelivQty]				
	,[RemainingQty]			
	,[UnitPrice]			
	,[UoM]					
	,[WarehouseCode]		
	,[UnitCost]				
	,[Currency]				
	,[ExchangeRate]			
	,[DiscountPercent]		
	,[DiscountAmount]		
	,[PartNum]				
	,[SalesPersonName]		
	,[SalesOrderCategory]	
	,[SalesOrderType]		
	
	
	FROM stage.CER_DE_SalesOrder
GO
