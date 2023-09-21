IF OBJECT_ID('[stage].[vMEN_NL_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vMEN_NL_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vMEN_NL_SOLine] AS
/*
This query is likely overengineered. Could likely be simplified a lot by sacrificing correct UnitPrice and base things on SalesAmount.
What we try to accomplish here is to handle logic related to assembled products. The assembled products should have their SalesAmount 
*/

WITH 
--SOLine but with Company Code and ProductIsAssembly from dim part
SOLine AS ( 
	SELECT [so].[PartitionKey], [so].[Company], [so].[InvoiceHandler], [so].[CustomerNum], [so].[PartNum], [so].[PartType], [so].[SalesOrderNum], [so].[SalesOrderLine], [so].[SalesOrderSubLine], [so].[SalesOrderType], [so].[SalesInvoiceNum], [so].[SalesInvoiceLine], [so].[SalesInvoiceType], [so].[SalesInvoiceDate], [so].[ActualDelivDate], [so].[SalesInvoiceQty], [so].[UoM], [so].[UnitPrice], [so].[UnitCost], [so].[DiscountPercent], [so].[DiscountAmount], [so].[CashDiscountOffered], [so].[CashDiscountUsed], [so].[TotalMiscChrg], [so].[VATAmount], [so].[Currency], [so].[ExchangeRate], [so].[CreditMemo], [so].[SalesChanel], [so].[Department], [so].[WarehouseCode], [so].[CostBearerNum], [so].[CostUnitNum], [so].[ReturnComment], [so].[ReturnNum], [so].[ProjectNum], [so].[Indexkey], [so].[SIRes1], [so].[SIRes2], [so].[SIRes3], [so].[DebiteurKey], [so].[ProductKey], [so].[DW_TimeStamp], [so].[SalesAmount], [so].[SalesInvoiceQty_2], [so].[CustomerNumPayer], [so].[InternalSalesIdentifier]
			,CASE WHEN so.Company = '14' THEN  CONCAT(N'MENBE',so.Company) 
				ELSE  CONCAT(N'MENNL',so.Company) END AS CompanyCode
			,ROW_NUMBER() OVER	(Partition BY Company, SalesInvoiceNum, SalesInvoiceLine, PartNum ORDER BY SalesAmount) AS rownum

	FROM [stage].[MEN_NL_SOLine] so
)
--COMMENT EMPTY FIELDS // ADD TRIM()UPPER() INTO WarehouseID 23-01-12 VA
--Invoice lines with no assembly products
SELECT  
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode, '#', SalesInvoiceNum, '#', SalesInvoiceLine, '#', PartNum, '#', Rownum ))) AS SalesInvoiceID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',SalesOrderNum,'#',SalesOrderLine,'#',SalesInvoiceNum))) AS SalesOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode, '#', TRIM(SalesInvoiceNum)))) AS SalesLedgerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',SalesOrderNum))) AS SalesOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',CustomerNum))) AS CustomerID
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',CompanyCode)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CompanyCode, '#', PartNum))) AS PartID 
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([CompanyCode]),'#',TRIM([WarehouseCode]))))) AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT([CompanyCode],'#',UPPER([WarehouseCode])))) AS WarehouseID
	,CONCAT(CompanyCode,'#',SalesOrderNum,'#',SalesOrderLine, '#',SalesInvoiceNum, '#' , PartNum) as SalesOrderCode 
	,CONVERT(int, replace(convert(date,SalesInvoiceDate),'-','')) AS SalesInvoiceDateID  --Redundant?
	,CONCAT(CompanyCode,'#',TRIM(SalesInvoiceNum),'#',TRIM(SalesInvoiceLine)) AS SalesInvoiceCode --Redundant?
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( CompanyCode,'#','') ))	AS ProjectID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',trim(Department)))) AS DepartmentID
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
	--,NULL AS DeliveryAddress
	,CostBearerNum
	,CostUnitNum
	,ReturnComment
	,ReturnNum
	,ProjectNum
	,IndexKey
	,SalesAmount  AS SIRes1
	--,''  AS SIRes2
	,InternalSalesIdentifier AS SIRes3
FROM SOLine
--where SalesOrderNum = 668536 and PartNum = '99874718' and SalesOrderLine = 290
--where CompanyCode = 'MENNL02'
GO
