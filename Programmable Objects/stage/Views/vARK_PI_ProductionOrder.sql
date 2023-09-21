IF OBJECT_ID('[stage].[vARK_PI_ProductionOrder]') IS NOT NULL
	DROP VIEW [stage].[vARK_PI_ProductionOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vARK_PI_ProductionOrder] AS
 SELECT 
 
        CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(ProductionOrderNum), '#', TRIM(ProductionOrderLineNum), '#',TRIM(PartNum)))))  as [ProductionOrderID]
      ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) as CustomerID
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) as CompanyID
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID 
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM(WarehouseCode))))) AS WarehouseID
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SalesOrderNum))))) AS SalesOrderNumID  
	  ,[PartitionKey]                                  
      ,UPPER(TRIM([Company]))  AS     "Company"                                  
      ,UPPER(TRIM([ProductionOrderNum])) AS    "ProductionOrderNum"                    
      ,UPPER(TRIM([ProductionOrderLineNum]))  AS  "ProductionOrderLineNum"                 
      ,UPPER(TRIM([PartNum])) AS   "PartNum"                                 
      ,[Uom]                                        
      ,[PartType]
      ,IIF(PartType = 'Component',-1 * CONVERT(decimal(18,4), Replace(OrderQuantity, ',', '.')), CONVERT(decimal(18,4), Replace(OrderQuantity, ',', '.'))) AS "OrderQuantity"
      ,IIF(PartType = 'Component',-1* CONVERT(decimal(18,4), Replace(ScrappedQty, ',', '.')),CONVERT(decimal(18,4), Replace(ScrappedQty, ',', '.'))) AS "ScrappedQty"
      ,IIF(PartType = 'Component',-1* CONVERT(decimal(18,4), Replace(CompletedQuantity, ',', '.')),CONVERT(decimal(18,4), Replace(CompletedQuantity, ',', '.'))) AS "CompletedQuantity"
      ,IIF(PartType = 'Component',-1* CONVERT(decimal(18,4), Replace([RemainingQty], ',', '.')),CONVERT(decimal(18,4), Replace([RemainingQty], ',', '.'))) AS "RemainingQty"                          
      ,[Status]
      --,CASE 
      --  WHEN [CurrentOperationStage_Preparado]  = '.' AND [CurrentOperationStage_Preparado] = '.' AND [CurrentOpeartionStage_Empaquetado]  = '.'    THEN 'NotStarted'
      --  WHEN [CurrentOperationStage_Preparado]  = 'OK' AND [CurrentOperationStage_Preparado] = '.' AND [CurrentOpeartionStage_Empaquetado]  = '.'   THEN 'Prepared'
      --  WHEN [CurrentOperationStage_Preparado]  = 'OK' AND [CurrentOperationStage_Cosido] = '.' AND [CurrentOpeartionStage_Empaquetado]  = 'OK'     THEN 'Sewing'
      --  WHEN [CurrentOperationStage_Preparado]  = 'OK' AND [CurrentOperationStage_Cosido] = 'OK' AND [CurrentOpeartionStage_Empaquetado]  = '.'     THEN 'Packaging'
      --  WHEN [CurrentOperationStage_Preparado]  = 'OK' AND [CurrentOperationStage_Cosido] = 'OK' AND [CurrentOpeartionStage_Empaquetado]  = 'OK'    THEN 'ReadyToSend'
      --  ELSE NULL END AS "CurrentOperationStage"  
      ,CASE WHEN [OrderCreateDate] = '' OR [OrderCreateDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [OrderCreateDate]) END AS "OrderCreateDate"
      ,CASE WHEN [PlannedEndDate] = '' OR [PlannedEndDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [PlannedEndDate]) END AS "PlannedEndDate"
      ,CASE WHEN [StartDate] = '' OR [StartDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [StartDate]) END AS "StartDate"
      ,CASE WHEN [EndDate] = '' OR [EndDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [EndDate]) END AS "EndDate"
      ,CASE WHEN [EndDate] = '' OR RequestedEndDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, RequestedEndDate) END AS "RequestedEndDate"         
      ,[OrderType]                                  
      ,UPPER(TRIM(WarehouseCode))   AS "WarehouseCode"                               
      ,UPPER(TRIM([SalesOrderNum])) AS "SalesOrderNum"                              
      ,UPPER(TRIM([CustomerNum]))  AS  "CustomerNum"                          
      ,[ProductionOrderCreaterName]  AS   "ProductionOrderCreaterName"
      ,[CurrentResourceGroup]
      ,[Currency]
      ,[ExchangeRate]
      ,CASE WHEN CreatedTimeStamp = '' OR CreatedTimeStamp is NULL THEN CONVERT(datetime,'1900-01-01') ELSE CONVERT(datetime, left(CreatedTimeStamp,19 )) END AS CreatedTimeStamp
      ,CASE WHEN [ModifiedTimeStamp] = '' OR [ModifiedTimeStamp] is NULL THEN CONVERT(datetime,'1900-01-01') ELSE CONVERT(datetime, left(ModifiedTimeStamp,19 )) END AS ModifiedTimeStamp
      ,[TotalHoursPlanned]
      ,[TotalHoursSpent]
      ,[SetupHoursSpent]
      ,[MaterialCost]
      ,[LabourCost]
      ,[OtherCost]

	
	FROM [stage].[ARK_PI_ProductionOrder]
GO
