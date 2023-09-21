IF OBJECT_ID('[stage].[vMEN_NL_OLine]') IS NOT NULL
	DROP VIEW [stage].[vMEN_NL_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [stage].[vMEN_NL_OLine] AS
WITH CTE AS (
SELECT CASE WHEN Company = '14' THEN  CONCAT(N'MENBE',Company) 
			ELSE  CONCAT(N'MENNL',Company)  END AS CompanyCode		--Doing this to have the company code in nvarchar and don't need to repeat CAST(CONCAT('MEN-',Company) AS nvarchar(50)) everywhere /SM
	  ,[PartitionKey], [Company], [CustomerNum], [SalesOrderNum], [SalesOrderLine], [SalesOrderSubLine], [SalesOrderType], [SalesOrderCategory], [SalesOrderStatus], [SalesOrderDate], [NeedbyDate], [ExpDelivDate], [ActualDelivDate], [SalesInvoiceNum], [SalesOrderQty], [DelivQty], [RemainingQTY], [UoM], [UnitPrice], [UnitCost], [Currency], [ExchangeRate], [DiscountPercent], [DiscountAmount], [PartNum], [PartType], [PartStatus], [SalesPersonName], [WarehouseCode], [SalesChanel], [Department], [ProjectNum], [Cancellation], [IndexKey], [SORes1], [SORes2], [SORes3], [DebiteurKey], [ProductKey], [DW_TimeStamp], [SalesAmount], [CustomerNumPayer], [SalesOrderQty_2], [InternalSalesIdentifier]
	  ,CASE WHEN SalesOrderQty <> 0 THEN SalesOrderQty
		 WHEN SalesOrderQty = 0 THEN SalesOrderQty_2
		ELSE 1 END												AS SalesOrderQty_calc
		,ROW_NUMBER() OVER (Partition by Company,SalesOrderNum,SalesOrderLine,PartNum ORDER BY SalesInvoiceNum) as rownum
  FROM [stage].[MEN_NL_OLine]
)
SELECT
	--ADD TRIM()UPPER() INTO WarehouseID 23-01-12 VA

	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',SalesOrderNum,'#',SalesOrderLine,'#', PartNum,'#', rownum ))) AS SalesOrderID
	,CONCAT(CompanyCode,'#',SalesOrderNum,'#',SalesOrderLine, '#',SalesInvoiceNum, '#', PartNum) as SalesOrderCode --'#',OrderSubLine,
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',CustomerNum))) as CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',(CompanyCode))) as CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CompanyCode, '#', PartNum))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(CompanyCode),'#',TRIM(WarehouseCode))))) AS WareHouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',UPPER(WarehouseCode)))) AS WareHouseID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',SalesOrderNum))) AS SalesOrderNumID
	,YEAR(SalesOrderDate)*10000+MONTH(SalesOrderDate)*100+DAY(SalesOrderDate) AS SalesOrderDateID  
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#','') ))	AS ProjectID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',trim(Department)))) AS DepartmentID
	,PartitionKey 

	,CompanyCode AS Company
	,TRIM(CustomerNum) AS CustomerNum 
	,SalesOrderNum
	,SalesOrderLine
	,rownum AS SalesOrderSubLine
	,SalesOrderType
	,InternalSalesIdentifier AS SalesOrderCategory --Putting an internal order flag here for now
	--,NULL AS SalesOrderRelNum
	,SalesOrderDate
	,CASE WHEN YEAR(NeedbyDate) > 9000 THEN '3000-01-01' ELSE NeedbyDate END AS NeedbyDate
	,CASE WHEN YEAR(ExpDelivDate) > 9000 THEN '3000-01-01' ELSE ExpDelivDate END AS ExpDelivDate
	,ActualDelivDate			AS ActualDelivDate
	,CAST('1900-01-01' AS date)		AS ConfirmedDelivDate
	,SalesInvoiceNum
	,SalesOrderQty_calc		AS SalesOrderQty
	,DelivQty					AS DelivQty
	,RemainingQty				AS RemainingQty
	--,NULL AS SalesInvoiceQty
	,UoM
	,IIF(SalesOrderQty_calc=0
		,SalesAmount+DiscountAmount
		,((SalesAmount+DiscountAmount)/SalesOrderQty_calc)) AS UnitPrice
	,IIF(SalesOrderQty_calc=0
		,UnitCost
		,(UnitCost*SalesOrderQty_calc/SalesOrderQty_calc)) AS UnitCost
	,COALESCE(UPPER(Currency), 'EUR') AS Currency
	,ExchangeRate
	,CASE WHEN SalesOrderStatus = 'False' THEN '1' ELSE '0' END AS OpenRelease
--	,COALESCE( UnitPrice/100.0 *  SalesOrderQty * DiscountPercent/100 ,0) AS DiscountAmount
	,DiscountAmount AS [DiscountAmount]
	,DiscountPercent
	--,CONCAT(TRIM(PartNum), '-', ProductKey)	AS PartNum
	,TRIM(PartNum) as PartNum -- TO 2023-02-06 changing for ticket
	,PartType
	,PartStatus
	,SalesPersonName
	,WarehouseCode
	,SalesChanel	AS SalesChannel
	--,NULL AS AxInterSalesChannel
	,Department
	,ProjectNum
	,IndexKey
	,[Cancellation]
	,InternalSalesIdentifier AS SORes1
	,SORes2
	,SORes3

	--,NULL AS ReturnComment
	--,NULL AS SalesReturnOrderNum
	--,NULL AS SalesReturnInvoiceNum
	--,NULL AS [TotalMiscChrg]
FROM CTE
GO
