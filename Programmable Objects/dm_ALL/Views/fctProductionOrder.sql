IF OBJECT_ID('[dm_ALL].[fctProductionOrder]') IS NOT NULL
	DROP VIEW [dm_ALL].[fctProductionOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dm_ALL].[fctProductionOrder]
	AS 
	
	SELECT 
	[ProductionOrderID]
      ,[CustomerID]
      ,[PartID]
      ,[WarehouseID]
      ,[SalesOrderNumID]
      ,[CostUnitID]
      ,[CompanyID]
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
	FROM dm.FactProductionOrder
GO
