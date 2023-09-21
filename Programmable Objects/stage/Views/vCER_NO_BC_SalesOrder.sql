IF OBJECT_ID('[stage].[vCER_NO_BC_SalesOrder]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_BC_SalesOrder];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [stage].[vCER_NO_BC_SalesOrder] AS 
SELECT 
	CONVERT(binary(32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', CustNum))) AS SalesOrderID,
	CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID,
	CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID,
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(OrderNum)))) AS SalesOrderNumID,
	CONVERT(binary(32), HASHBYTES('SHA2_256', TRIM(Company))) AS CompanyID,
	CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID, -- SB add 2022-11-15
	try_cast(convert(varchar, TRY_CAST(OrderDate as Date), 112) as int) AS SalesOrderDateID, -- SB added 2023-02-01, needed for CurrencySelection?
	CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', CustNum) as SalesOrderCode,
	PartitionKey,
	Company,
	nullif(trim(CustNum),'') as CustomerNum,
	nullif(trim(OrderNum),'') as SalesOrderNum,
	nullif(trim(OrderLine),'') as SalesOrderLine,
	cast(OrderDate as Date) as SalesOrderDate,
	cast(DelivDate as Date) as ExpDelivDate,
	cast(OrderQty as decimal(9,2)) AS SalesOrderQty,
	cast(DelivQty as decimal(9,2)) AS DelivQty,
	cast(RemainingQty as decimal(9,2)) AS RemainingQty,
	cast(UnitPrice as decimal(18,4)) AS UnitPrice,
	cast(UnitCost as decimal (18,4)) AS  UnitCost,
	--cast(SumUnitPrice as decimal(9,2)) AS SumUnitPrice,
	--cast(SumUnitCost as decimal(9,2)) AS  SumUnitCost,
	nullif(trim(Currency),'') as Currency,
	cast(CurrExchRate as decimal(9,6)) as ExchangeRate,
	nullif(trim(OpenRelease),'') as OpenRelease,
	nullif(trim(DiscountPercent),'') as DiscountPercent,
	cast(DiscountAmount as decimal(18,4)) AS  DiscountAmount,
	nullif(trim(PartNum),'') as PartNum,
	cast(NeedbyDate as date) as NeedbyDate,
	nullif(trim(SalesPersonName),'') as SalesPersonName,
	case when TRIM(Department) = '110584' then 'SERV'
		else nullif(trim(WarehouseCode),'') 
	end as WarehouseCode,
	Department,
	nullif(trim(WarehouseCodeLines),'') as SORes1
    --,systemCreatedAt
	--,systemModifiedAt
FROM 
	 stage.CER_NO_BC_SalesOrder
WHERE left(nullif(trim(OrderNum),''),1) != 'T'
GO
