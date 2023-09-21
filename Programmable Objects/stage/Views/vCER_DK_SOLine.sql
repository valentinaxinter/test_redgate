IF OBJECT_ID('[stage].[vCER_DK_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vCER_DK_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vCER_DK_SOLine] AS
-- COMMENT empty fields / Add TRIM(Company) into WarehouseID/CustomerID/PartID 12-12-2022 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company,  TRIM(InvoiceNum), '#', TRIM(InvoiceLine) )))) AS SalesInvoiceID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(OrderSubLine))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER((CONCAT(Company, '#', TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) ), '#', TRIM(InvoiceNum)))))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(OrderNum))))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#',  TRIM(WarehouseCode))))) AS WareHouseID
	,UPPER(CONCAT(Company, '#', TRIM(OrderNum), '#', TRIM(OrderLine), '#', TRIM(InvoiceNum))) AS SalesOrderCode -- the key for dm.FactSalesOrder
	,UPPER(CONCAT(Company, '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine), '#', TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) ))) AS SalesInvoiceCode
	,CONVERT(int, replace(convert(date,InvoiceDate), '-', '')) AS SalesInvoiceDateID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( upper(trim(Company)), '#', UPPER(trim(ProjectNum))) )) AS ProjectID
	,PartitionKey

	,UPPER(Company) AS Company
	,SalesPersonName AS SalesPersonName
	,UPPER(TRIM(IIF(CustNum IS NULL OR CustNum = '', 'MISSINGCUSTOMER', CustNum) )) AS CustomerNum
	,UPPER(TRIM(IIF(PartNum IS NULL OR PartNum = '', 'MISSINGPART',  PartNum) )) AS PartNum
	,CASE WHEN TRIM(OrderNum) = '0' THEN 'PrimaryPart' ELSE 'SubPart' END  AS PartType
	,UPPER(TRIM(OrderNum)) AS SalesOrderNum
	,UPPER(TRIM(OrderLine)) AS SalesOrderLine
	,UPPER(TRIM(OrderSubLine)) AS SalesOrderSubLine
	--,'' AS SalesOrderType
	,UPPER(TRIM(InvoiceNum)) AS SalesInvoiceNum
	,UPPER(TRIM(InvoiceLine)) AS SalesInvoiceLine
	--,'' AS SalesInvoiceType
	,CONVERT(date, InvoiceDate) AS SalesInvoiceDate
	,ActualDeliveryDate AS ActualDelivDate
	,SellingShipQty AS [SalesInvoiceQty]
	--,'' AS UoM
	,UnitPrice
	,UnitCost
	,IIF((SellingShipQty*UnitPrice) <> 0, DiscountAmount/(SellingShipQty*UnitPrice), 0) AS [DiscountPercent]
	,DiscountAmount
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
	,TotalMiscChrg
	--,NULL AS [VATAmount]
	,Currency
	,ExchangeRate
	,CreditMemo
	,CASE WHEN SalesChannel = 'WEB-RFQ' THEN 'RFQ'
		WHEN SalesChannel = 'WEB-ORDRE' THEN 'Webshop'
		WHEN SalesChannel = 'DC-ORDRE' THEN 'PDF'
		ELSE 'Normal Order Handling' END AS SalesChannel
	--,'' AS [Department]
	,TRIM(WarehouseCode) AS WarehouseCode
	--,NULL AS DeliveryAddress
	--,'' AS [CostBearerNum]
	--,'' AS [CostUnitNum]
	,[ReturnComment]
	,TRIM([ReturnNum]) AS [ReturnNum]
	,UPPER(trim(ProjectNum)) as [ProjectNum]
	,Indexkey
	--,'' AS SIRes1
	--,'' AS SIRes2
	--,'' AS SIRes3

FROM 
	stage.CER_DK_SOLine
GO
