IF OBJECT_ID('[dm].[FactProductionOrder]') IS NOT NULL
	DROP VIEW [dm].[FactProductionOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dm].[FactProductionOrder] AS
	 SELECT --[PartitionKey]
       CAST([ProductionOrderID] AS bigint) AS ProductionOrderID
	  ,CAST(CustomerID	   as bigint) as CustomerID
	  ,CAST(PartID		   as bigint) as PartID
	  ,CAST(WarehouseID	   as bigint) as WarehouseID
	  ,CAST(SalesOrderNumID as bigint) as SalesOrderNumID
	  ,CAST(CostUnitID	   as bigint) as CostUnitID
	  ,CAST(CompanyID	   as bigint) as CompanyID
      ,[Company]
      ,[ProductionOrderNum]
      ,[ProductionOrderLineNum]
      ,[ProductionOrderSubLineNum]
      ,[PartNum]
      ,[Version]
      ,[UoM]
      ,[PartType]
      ,[OrderQuantity]
      ,[ScrappedQty]
      ,[CompletedQuantity]
      ,[RemainingQty]
      ,[Status]
      ,[CurrentOperationStage]
      ,[CurrentResourceGroup]
      ,[OrderCreateDate]
      ,[RequestedEndDate]
      ,[PlannedStartDate]
      ,[PlannedEndDate]
      ,[StartDate]
      ,[EndDate]
      ,[OrderType]
      ,[TotalHoursPlanned]
      ,[TotalHoursSpent]
      ,[SetupHoursSpent]
      ,[MaterialCost]
      ,[LabourCost]
      ,[OtherCost]
      ,[Currency]
      ,[ExchangeRate]
      ,[WarehouseCode]
      ,[BinNum]
      ,[CostUnitNum]
      ,[SalesOrderNum]
      ,[CustomerNum]
      ,[ProductionOrderCreaterName]
      ,[BatchNum]
      --,[CreatedTimeStamp]
      --,[ModifiedTimeStamp]
      --,[is_deleted]
      --,[is_inferred]
  FROM [dw].[ProductionOrder]
  WHERE is_deleted = '0' or is_deleted IS NULL;
GO
