IF OBJECT_ID('[stage].[vOCS_SE_ProductionOrder]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_ProductionOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vOCS_SE_ProductionOrder]
	AS SELECT
    	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(ProductionOrderNum), '#', TRIM(ProductionOrderLineNum), '#',TRIM(PartNum)))))  as [ProductionOrderID]
      ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) as CustomerID
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) as CompanyID
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID 
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SalesOrderNum))))) AS SalesOrderNumID  
	  ,[PartitionKey]                                  
      ,UPPER(TRIM([Company]))  AS     "Company"                                  
      ,UPPER(TRIM([ProductionOrderNum])) AS    "ProductionOrderNum"                    
      ,UPPER(TRIM([ProductionOrderLineNum]))  AS  "ProductionOrderLineNum"                 
      ,UPPER(TRIM([PartNum])) AS   "PartNum"                                 
      ,[Uom]                                        
      ,[PartType]
      ,CONVERT(decimal(18,4), Replace([OrderQuantity], ',', '.')) AS "OrderQuantity"
      --,CONVERT(decimal(18,4), Replace([ScrappedQty Assembled Item], ',', '.')) AS "ScrappedQty"
      ,CONVERT(decimal(18,4), Replace([CompletedQuantity], ',', '.')) AS "CompletedQuantity"
      ,CONVERT(decimal(18,4), Replace([RemainingQty], ',', '.')) AS "RemainingQty"                           
      ,[Status] 
      ,CASE WHEN [OrderCreateDate] = '' OR [OrderCreateDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [OrderCreateDate]) END AS "OrderCreateDate"
      ,CASE WHEN RequestedEndDate = '' OR RequestedEndDate is NULL or RequestedEndDate = '1201-06-28' or  RequestedEndDate = '0' THEN CONVERT(date,'1900-01-01')  ELSE CONVERT(date, RequestedEndDate) END AS "RequestedEndDate"
      --,CASE WHEN [StartDate] = '' OR [StartDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [StartDate]) END AS "StartDate"
      --,CASE WHEN [EndDate] = '' OR [EndDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [EndDate]) END AS "EndDate"                                
      --,[OrderType]                                  
      ,UPPER(TRIM([WarehouseCode]))   AS "WarehouseCode"                               
      ,UPPER(TRIM([SalesOrderNum])) AS "SalesOrderNum"                              
      ,UPPER(TRIM([CustomerNum]))  AS  "CustomerNum"                          
      ,[ProductionOrderCreaterName]  AS   "ProductionOrderCreaterName"
      --,[CurrentResourceGroup]
      ,[Currency]
      ,[BinNum]
      ,[CostUnitNum]
      ,[ExchangeRate]
      ,[MaterialCost]
      ,cast(TotalHoursPlanned	 as decimal(18,4))	as 		TotalHoursPlanned		
      ,cast(TotalHoursSpent as decimal(18,4)) as TotalHoursSpent
      ,cast(LabourCost as decimal(18,4))as LabourCost


      ,CASE WHEN CreatedTimeStamp = '' OR CreatedTimeStamp is NULL THEN CONVERT(datetime,'1900-01-01') ELSE CONVERT(datetime, left(CreatedTimeStamp,19 )) END AS CreatedTimeStamp
      ,CASE WHEN [ModifiedTimeStamp] = '' OR [ModifiedTimeStamp] is NULL THEN CONVERT(datetime,'1900-01-01') ELSE CONVERT(datetime, left(ModifiedTimeStamp,19 )) END AS ModifiedTimeStamp
	
	 FROM [stage].[OCS_SE_ProductionOrder]
GO
