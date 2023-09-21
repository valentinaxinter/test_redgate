IF OBJECT_ID('[stage].[vFOR_ES_ProductionOrder]') IS NOT NULL
	DROP VIEW [stage].[vFOR_ES_ProductionOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vFOR_ES_ProductionOrder]
	AS SELECT
    	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(ProductionOrderNum), '#', TRIM(ProductionOrderLineNum), '#',TRIM(PartNum)))))  as [ProductionOrderID]
      ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustomerNum))))) as CustomerID
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) as CompanyID
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(PartNum))))) AS PartID 
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([Warehouse]))))) AS WarehouseID
	  ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SalesOrderNum))))) AS SalesOrderNumID  
	  ,[PartitionKey]                                  
      ,UPPER(TRIM([Company]))  AS     "Company"                                  
      ,UPPER(TRIM([ProductionOrderNum])) AS    "ProductionOrderNum"                    
      ,UPPER(TRIM([ProductionOrderLineNum]))  AS  "ProductionOrderLineNum"                 
      ,UPPER(TRIM([PartNum])) AS   "PartNum"                                 
      ,[Uom]                                        
      ,[PartType]
      ,IIF(PartType = 'Component',-1 * CONVERT(decimal(18,4), Replace([OrderQty], ',', '.')), CONVERT(decimal(18,4), Replace([OrderQty], ',', '.'))) AS "OrderQuantity"
      ,IIF(PartType = 'Component',-1* CONVERT(decimal(18,4), Replace([ScrappedQty Assembled Item], ',', '.')),CONVERT(decimal(18,4), Replace([ScrappedQty Assembled Item], ',', '.'))) AS "ScrappedQty"
      ,IIF(PartType = 'Component',-1* CONVERT(decimal(18,4), Replace([CompletedQty Assembled Item], ',', '.')),CONVERT(decimal(18,4), Replace([CompletedQty Assembled Item], ',', '.'))) AS "CompletedQuantity"
      ,IIF(PartType = 'Component',-1* CONVERT(decimal(18,4), Replace([RemainingQty], ',', '.')),CONVERT(decimal(18,4), Replace([RemainingQty], ',', '.'))) AS "RemainingQty"                          
      ,[Status]
      ,CASE 
        WHEN [CurrentOperationStage_Preparado]  = '.' AND [CurrentOperationStage_Preparado] = '.' AND [CurrentOpeartionStage_Empaquetado]  = '.'    THEN 'NotStarted'
        WHEN [CurrentOperationStage_Preparado]  = 'OK' AND [CurrentOperationStage_Preparado] = '.' AND [CurrentOpeartionStage_Empaquetado]  = '.'   THEN 'Prepared'
        WHEN [CurrentOperationStage_Preparado]  = 'OK' AND [CurrentOperationStage_Cosido] = '.' AND [CurrentOpeartionStage_Empaquetado]  = 'OK'     THEN 'Sewing'
        WHEN [CurrentOperationStage_Preparado]  = 'OK' AND [CurrentOperationStage_Cosido] = 'OK' AND [CurrentOpeartionStage_Empaquetado]  = '.'     THEN 'Packaging'
        WHEN [CurrentOperationStage_Preparado]  = 'OK' AND [CurrentOperationStage_Cosido] = 'OK' AND [CurrentOpeartionStage_Empaquetado]  = 'OK'    THEN 'ReadyToSend'
        ELSE NULL END AS "CurrentOperationStage"  
      ,CASE WHEN [OrderCreateDate] = '' OR [OrderCreateDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [OrderCreateDate]) END AS "OrderCreateDate"
      ,CASE WHEN [PlannedEndDate] = '' OR [PlannedEndDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [PlannedEndDate]) END AS "PlannedEndDate"
      ,CASE WHEN [StartDate] = '' OR [StartDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [StartDate]) END AS "StartDate"
      ,CASE WHEN [EndDate] = '' OR [EndDate] is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, [EndDate]) END AS "EndDate"                                
      ,[OrderType]                                  
      ,UPPER(TRIM([Warehouse]))   AS "WarehouseCode"                               
      ,UPPER(TRIM([SalesOrderNum])) AS "SalesOrderNum"                              
      ,UPPER(TRIM([CustomerNum]))  AS  "CustomerNum"                          
      ,[ ProductionOrderCreaterName]  AS   "ProductionOrderCreaterName"
      ,[CurrentResourceGroup]
      ,[Currency]
      ,[ExchangeRate]
      ,CASE WHEN CreatedTimeStamp = '' OR CreatedTimeStamp is NULL THEN CONVERT(datetime,'1900-01-01') ELSE CONVERT(datetime, left(CreatedTimeStamp,19 )) END AS CreatedTimeStamp
      ,CASE WHEN [ModifiedTimeStamp] = '' OR [ModifiedTimeStamp] is NULL THEN CONVERT(datetime,'1900-01-01') ELSE CONVERT(datetime, left(ModifiedTimeStamp,19 )) END AS ModifiedTimeStamp
	
	 FROM [stage].[FOR_ES_ProductionOrder]
GO
