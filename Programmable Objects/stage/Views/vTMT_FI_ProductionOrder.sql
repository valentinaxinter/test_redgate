IF OBJECT_ID('[stage].[vTMT_FI_ProductionOrder]') IS NOT NULL
	DROP VIEW [stage].[vTMT_FI_ProductionOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vTMT_FI_ProductionOrder] AS
	 
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(ProductionOrderNum), '#', TRIM(ProductionOrderLineNum), '#',TRIM(PartNum))))) AS [ProductionOrderID]
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SalesOrderNum))))) AS SalesOrderNumID 
	,getdate() AS [PartitionKey]   
	
	,UPPER(TRIM([Company])) AS Company                                  
	,UPPER(TRIM([ProductionOrderNum])) AS ProductionOrderNum                    
	,UPPER(TRIM([ProductionOrderLineNum])) AS ProductionOrderLineNum                 
	,UPPER(TRIM([PartNum])) AS PartNum                                 
	,[UOM]                                        
	,[PartType]
	,IIF([PartType] = 'Component', -1*ABS(CONVERT(decimal(18,4), Replace(ProductionOrderQty, ',', '.'))), ABS(CONVERT(decimal(18,4), Replace(ProductionOrderQty, ',', '.')))) AS OrderQuantity
	,NULL AS ScrappedQty
	,CONVERT(decimal(18,4), Replace(CompletedQuantity, ',', '.')) AS CompletedQuantity
	,IIF([Status] = 'Completed', 0, CONVERT(decimal(18,4), Replace([RemainingQty], ',', '.'))) AS RemainingQty 
	,CASE WHEN [Status] = 'Completed' THEN 'Completed'
		WHEN [Status] = 'Accepted' THEN 'Approved'
		WHEN [Status] = 'Started' THEN 'Processing'
		ELSE 'Missing Cateogory'
		 END AS [Status]
	,'' AS CurrentOperationStage
	,'' AS CurrentResourceGroup
	,CASE WHEN ProductionOrderCreateDate = '' OR ProductionOrderCreateDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, ProductionOrderCreateDate) END AS OrderCreateDate
	,'1900-01-01' AS RequestDate
	,'1900-01-01' AS PlannedStartDate
	,CONVERT(date, ProductionEndDate) AS PlannedEndDate
	,CASE WHEN ProductionStartDate = '' OR ProductionStartDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, ProductionStartDate) END AS StartDate
	,CASE WHEN [Status] = 'Completed' THEN ModifiedTimeStamp	ELSE '1900-01-01' END AS EndDate  
	,IIF(ProductionOrderType = 'Stock Filling', 'Made-to-stock', 'Made-to-order') AS [OrderType]  
	,NULL AS TotalHoursSpent 
	,NULL AS TotalHoursPlanned 
	,NULL AS SetupHoursSpent 
	,NULL AS MaterialCost 
	,NULL AS LabourCost 
	,NULL AS OtherCost 
	,'EUR' AS [Currency]
	,1 AS [ExchangeRate]
	,UPPER(TRIM([WarehouseCode])) AS WarehouseCode
	,UPPER(TRIM(BinNum)) AS BinNum
	,UPPER(TRIM(BatchNum)) AS BatchNum
	,UPPER(TRIM(CostUnitNum)) AS CostUnitNum
	,UPPER(TRIM([SalesOrderNum])) AS SalesOrderNum                              
	,UPPER(TRIM([CustomerNum])) AS CustomerNum                          
	,ProductionOrderCreaterName AS ProductionOrderCreaterName
FROM [stage].[TMT_FI_ProductionOrder]
GO
