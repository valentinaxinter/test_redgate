IF OBJECT_ID('[dm_IN].[fctProductionOrder]') IS NOT NULL
	DROP VIEW [dm_IN].[fctProductionOrder];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dm_IN].[fctProductionOrder]
AS
SELECT ProductionOrderID
	  ,CustomerID
	  ,PartID
	  ,WarehouseID
	  ,SalesOrderNumID
	  ,CostUnitID
	  ,CompanyID
      ,dm.[Company]
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
FROM dm.FactProductionOrder as dm
INNER JOIN (
select distinct Company
from dbo.Company com
WHERE com.BusinessArea = 'Industrial Solutions' AND com.[Status] = 'Active'
) AS aux
	ON dm.Company = aux.Company;
GO
