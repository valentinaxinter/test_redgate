IF OBJECT_ID('[stage].[vMEN_NL_SOLine_old]') IS NOT NULL
	DROP VIEW [stage].[vMEN_NL_SOLine_old];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [stage].[vMEN_NL_SOLine_old] AS
/*
This query is likely overengineered. Could likely be simplified a lot by sacrificing correct UnitPrice and base things on SalesAmount.
What we try to accomplish here is to handle logic related to assembled products. The assembled products should have their SalesAmount 
*/

WITH 
--SOLine but with Company Code and ProductIsAssembly from dim part
SOLine AS ( 
	SELECT [so].[PartitionKey], [so].[Company], [so].[InvoiceHandler], [so].[CustomerNum], [so].[PartNum], [so].[PartType], [so].[SalesOrderNum], [so].[SalesOrderLine], [so].[SalesOrderSubLine], [so].[SalesOrderType], [so].[SalesInvoiceNum], [so].[SalesInvoiceLine], [so].[SalesInvoiceType], [so].[SalesInvoiceDate], [so].[ActualDelivDate], [so].[SalesInvoiceQty], [so].[UoM], [so].[UnitPrice], [so].[UnitCost], [so].[DiscountPercent], [so].[DiscountAmount], [so].[CashDiscountOffered], [so].[CashDiscountUsed], [so].[TotalMiscChrg], [so].[VATAmount], [so].[Currency], [so].[ExchangeRate], [so].[CreditMemo], [so].[SalesChanel], [so].[Department], [so].[WarehouseCode], [so].[CostBearerNum], [so].[CostUnitNum], [so].[ReturnComment], [so].[ReturnNum], [so].[ProjectNum], [so].[Indexkey], [so].[SIRes1], [so].[SIRes2], [so].[SIRes3], [so].[DebiteurKey], [so].[ProductKey], [so].[DW_TimeStamp], [so].[SalesAmount], [so].[SalesInvoiceQty_2], [so].[CustomerNumPayer], [so].[InternalSalesIdentifier], p.ProductIsAssembly, CASE WHEN so.Company = '14' THEN  CONCAT(N'MENBE',so.Company) 
			ELSE  CONCAT(N'MENNL',so.Company) END AS CompanyCode
			,MAX(CAST(p.ProductIsAssembly as int)) OVER (Partition BY so.Company,SalesInvoiceNum, SalesInvoiceLine) AS HasAssembly
			,ROW_NUMBER() OVER (Partition BY so.Company, SalesInvoiceNum, SalesInvoiceLine, so.PartNum ORDER BY SalesAmount DESC, Indexkey) AS Rownum
	FROM [stage].[MEN_NL_SOLine] so
  LEFT JOIN [stage].[MEN_NL_Part] p ON p.ProductKey = so.ProductKey
),
-- All "distinct" InvoiceLines with assembly. Used in WHERE (NOT) Exists later
ProdIsAssem AS ( 
	SELECT SalesInvoiceNum, SalesInvoiceLine, Company, MAX(ProductKey) AS ProductKey
	FROM SOLine
	WHERE ProductIsAssembly = 1
	GROUP BY SalesInvoiceNum, SalesInvoiceLine, Company
),
-- All SOLines with assemlby product
SOLineIsAssemLine AS ( 
	SELECT [PartitionKey], [Company], [InvoiceHandler], [CustomerNum], [PartNum], [PartType], [SalesOrderNum], [SalesOrderLine], [SalesOrderSubLine], [SalesOrderType], [SalesInvoiceNum], [SalesInvoiceLine], [SalesInvoiceType], [SalesInvoiceDate], [ActualDelivDate], [SalesInvoiceQty], [UoM], [UnitPrice], [UnitCost], [DiscountPercent], [DiscountAmount], [CashDiscountOffered], [CashDiscountUsed], [TotalMiscChrg], [VATAmount], [Currency], [ExchangeRate], [CreditMemo], [SalesChanel], [Department], [WarehouseCode], [CostBearerNum], [CostUnitNum], [ReturnComment], [ReturnNum], [ProjectNum], [Indexkey], [SIRes1], [SIRes2], [SIRes3], [DebiteurKey], [ProductKey], [DW_TimeStamp], [SalesAmount], [SalesInvoiceQty_2], [CustomerNumPayer], [InternalSalesIdentifier], [ProductIsAssembly], [CompanyCode], [HasAssembly], [Rownum]
	FROM SOLine
	WHERE EXISTS (SELECT 1 FROM ProdIsAssem 
				WHERE SOLine.SalesInvoiceNum =  ProdIsAssem.SalesInvoiceNum
					AND SOLine.SalesInvoiceLine = ProdIsAssem.SalesInvoiceLine
					AND SOLine.Company = ProdIsAssem.Company
					AND SOLine.ProductKey = ProdIsAssem.ProductKey
				)
),
-- All SOLines with no assembly product
SOLineWithout AS (
	SELECT [PartitionKey], [Company], [InvoiceHandler], [CustomerNum], [PartNum], [PartType], [SalesOrderNum], [SalesOrderLine], [SalesOrderSubLine], [SalesOrderType], [SalesInvoiceNum], [SalesInvoiceLine], [SalesInvoiceType], [SalesInvoiceDate], [ActualDelivDate], [SalesInvoiceQty], [UoM], [UnitPrice], [UnitCost], [DiscountPercent], [DiscountAmount], [CashDiscountOffered], [CashDiscountUsed], [TotalMiscChrg], [VATAmount], [Currency], [ExchangeRate], [CreditMemo], [SalesChanel], [Department], [WarehouseCode], [CostBearerNum], [CostUnitNum], [ReturnComment], [ReturnNum], [ProjectNum], [Indexkey], [SIRes1], [SIRes2], [SIRes3], [DebiteurKey], [ProductKey], [DW_TimeStamp], [SalesAmount], [SalesInvoiceQty_2], [CustomerNumPayer], [InternalSalesIdentifier], [ProductIsAssembly], [CompanyCode], [HasAssembly], [Rownum]
	FROM SOLine
	WHERE NOT EXISTS (SELECT 1 FROM ProdIsAssem 
				WHERE SOLine.SalesInvoiceNum =  ProdIsAssem.SalesInvoiceNum
					AND SOLine.SalesInvoiceLine = ProdIsAssem.SalesInvoiceLine
					AND SOLine.Company = ProdIsAssem.Company
				)
)

--Invoice lines with no assembly products
SELECT  
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode, '#', SalesInvoiceNum, '#', SalesInvoiceLine, '#', PartNum, '#', Rownum ))) AS SalesInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',SalesOrderNum,'#',SalesOrderLine,'#',SalesInvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode, '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',SalesOrderNum))) AS SalesOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',CustomerNum))) AS CustomerID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',CompanyCode)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CompanyCode, '#', PartNum))) AS PartID  
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([CompanyCode],'#',UPPER([WarehouseCode])))) AS WarehouseID
	,CONCAT(CompanyCode,'#',SalesOrderNum,'#',SalesOrderLine, '#',SalesInvoiceNum, '#' , PartNum) as SalesOrderCode 
	,CONVERT(int, replace(convert(date,SalesInvoiceDate),'-','')) AS SalesInvoiceDateID  --Redundant?
	,CONCAT(CompanyCode,'#',TRIM(SalesInvoiceNum),'#',TRIM(SalesInvoiceLine)) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( CompanyCode,'#','') ))	AS ProjectID
	,PartitionKey

	,CompanyCode AS Company
	,InvoiceHandler AS SalesPersonName
	,TRIM(CustomerNum)	AS CustomerNum
	,TRIM(PartNum)		AS PartNum
	,PartType
	,SalesOrderNum
	,SalesOrderLine
	,SalesOrderSubLine
	,SalesOrderType
	,SalesInvoiceNum
	,SalesInvoiceLine
	,InternalSalesIdentifier AS SalesInvoiceType --Temporarily using SalesInvoiceType for this Internal flag
	,SalesInvoiceDate
	,ActualDelivDate
	,UoM
	,COALESCE(NULLIF(SalesInvoiceQty_2,0),1) AS SalesInvoiceQty
	,(SalesAmount+DiscountAmount)/COALESCE(NULLIF(SalesInvoiceQty_2,0),1) UnitPrice
	,UnitCost
	,DiscountPercent
	,DiscountAmount
	,CashDiscountOffered
	,CashDiscountUsed
	,TotalMiscChrg
	,VATAmount
	,COALESCE(UPPER(Currency),'EUR') AS Currency
	,COALESCE([ExchangeRate], 1) AS ExchangeRate
	,CreditMemo
	,SalesChanel	AS SalesChannel
	,Department
	,WarehouseCode
	,NULL AS DeliveryAddress
	,CostBearerNum
	,CostUnitNum
	,ReturnComment
	,ReturnNum
	,ProjectNum
	,IndexKey
	,ProductIsAssembly SIRes1
	,HasAssembly SIRes2
	,InternalSalesIdentifier AS SIRes3
FROM SOLineWithout
WHERE RowNum = 1

UNION ALL

SELECT CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode, '#', SalesInvoiceNum, '#', SalesInvoiceLine, '#', PartNum, '#', Rownum ))) AS SalesInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',SalesOrderNum,'#',SalesOrderLine,'#',SalesInvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode, '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',SalesOrderNum))) AS SalesOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',CustomerNum))) AS CustomerID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',CompanyCode)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CompanyCode, '#', PartNum))) AS PartID  
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([CompanyCode],'#',UPPER([WarehouseCode])))) AS WarehouseID
	,CONCAT(CompanyCode,'#',SalesOrderNum,'#',SalesOrderLine, '#',SalesInvoiceNum, '#' , PartNum) as SalesOrderCode 
	,CONVERT(int, replace(convert(date,SalesInvoiceDate),'-','')) AS SalesInvoiceDateID  --Redundant?
	,CONCAT(CompanyCode,'#',TRIM(SalesInvoiceNum),'#',TRIM(SalesInvoiceLine)) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( CompanyCode,'#','') ))	AS ProjectID
	,PartitionKey

	,CompanyCode AS Company
	,InvoiceHandler AS SalesPersonName
	,TRIM(CustomerNum) AS CustomerNum
	,TRIM(PartNum) AS PartNum
	,PartType
	,SalesOrderNum
	,SalesOrderLine
	,SalesOrderSubLine
	,SalesOrderType
	,SalesInvoiceNum
	,SalesInvoiceLine
	,InternalSalesIdentifier AS SalesInvoiceType --Temporarily using SalesInvoiceType for this Internal flag
	,SalesInvoiceDate
	,ActualDelivDate
	,UoM
	,SalesInvoiceQty_2 AS SalesInvoiceQty
	,(S_Amount + D_Amount)/NULLIF(SalesInvoiceQty_2,0) AS UnitPrice
	,(C_Amount)/NULLIF(SalesInvoiceQty_2,0) AS UnitCost
	,DiscountPercent
	,DiscountAmount
	,CashDiscountOffered
	,CashDiscountUsed
	,TotalMiscChrg
	,VATAmount
	,COALESCE(UPPER(Currency),'EUR') AS Currency
	,COALESCE([ExchangeRate], 1) AS ExchangeRate
	,CreditMemo
	,SalesChanel	AS SalesChannel
	,Department
	,WarehouseCode
	,NULL AS DeliveryAddress
	,CostBearerNum
	,CostUnitNum
	,ReturnComment
	,ReturnNum
	,ProjectNum
	,IndexKey
	,ProductIsAssembly SIRes1
	,HasAssembly SIRes2
	,InternalSalesIdentifier AS  SIRes3
FROM SOLineIsAssemLine
LEFT JOIN (
	SELECT Company as c
		, SalesInvoiceNum as [sin]
		, SalesInvoiceLine as sil
		, SUM(SalesAmount) AS S_Amount
		, SUM(DiscountAmount) AS D_Amount
		, SUM(SalesInvoiceQty*UnitCost) AS C_Amount
	FROM SOLine
	GROUP BY Company, SalesInvoiceNum, SalesInvoiceLine
) SOLineAggr ON SOLineIsAssemLine.Company = SOLineAggr.c
			AND SOLineIsAssemLine.SalesInvoiceNum = SOLineAggr.[sin]
			AND SOLineIsAssemLine.SalesInvoiceLine = SOLineAggr.sil
WHERE SOLineIsAssemLine.Rownum = 1
GO
