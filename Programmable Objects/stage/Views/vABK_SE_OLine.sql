IF OBJECT_ID('[stage].[vABK_SE_OLine]') IS NOT NULL
	DROP VIEW [stage].[vABK_SE_OLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vABK_SE_OLine] AS
--COMMENT EMPTY FIELDS // ADD TRIM() UPPER() 2022-12-21  VA
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum)))))AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', WarehouseCode))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM(OrderNum)))) AS SalesOrderNumID
	,CONVERT(int, replace(convert(date, OrderDate), '-', '')) AS SalesOrderDateID  --redundent?
	,CONCAT(Company, '#', OrderNum, '#', OrderLine) AS SalesOrderCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#','') )))	AS ProjectID
	,PartitionKey

	,Company
	,TRIM(CustNum) AS CustomerNum
	,OrderNum AS SalesOrderNum
	,OrderLine AS SalesOrderLine
	,OrderSubLine AS SalesOrderSubLine
	,CONVERT(nvarchar(50), OrderType) AS SalesOrderType
	,Res1_PriceGroup AS [SalesOrderCategory]
	,OrderDate AS SalesOrderDate
	,NeedByDate AS NeedbyDate
	,DelivDate AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,InvoiceNum AS SalesInvoiceNum
	,OrderQty AS SalesOrderQty
	,DelivQty
	,RemainingQty
	--,NULL AS SalesInvoiceQty
	,Unit AS UoM
	,UnitPriceSEK AS UnitPrice
	,UnitCost -- This is always in SEK
	--,ISOCode	AS Currency
	,'SEK'	AS Currency
	,1 ExchangeRate
	--,OpenRelease 
	,IIF(RemainingQty > 0, '1', '0') AS OpenRelease --Changed according to meeting discussion.
	,UnitPriceSEK*OrderQty*(1 - (1 - DiscountPercent/100)*(1 - DiscountPercent2/100)*(1 - DiscountPercent3/100))	AS DiscountAmount
	,1 - (1 - DiscountPercent/100)*(1 - DiscountPercent2/100)*(1 - DiscountPercent3/100) AS DiscountPercent
	,TRIM(PartNum) AS PartNum
	--,'' AS PartType
	,PartStatus
	,SalesPerson_Seller AS SalesPersonName
	,TRIM(WarehouseCode) AS WarehouseCode
	,CASE WHEN SalesChannel IN ('1') THEN 'Gm mail'
		WHEN SalesChannel IN ('2') THEN 'Gm telefon'
		WHEN SalesChannel IN ('3') THEN 'Gm säljare'
		WHEN SalesChannel IN ('4') THEN 'Gm webb'
		WHEN SalesChannel IN ('5') THEN 'Gm fax'
		WHEN SalesChannel IN ('6') THEN 'Gm mail säljare'
		WHEN SalesChannel IN ('7') THEN 'Gm telefon säljare'
		WHEN SalesChannel IN ('8') THEN 'Gm fax säjare'
		WHEN SalesChannel IN ('9') THEN 'Gm reklamation'
		WHEN SalesChannel IN ('10') THEN 'Gm kundbesök'
		WHEN SalesChannel IN ('11') THEN 'Gm Sveviaportalen'
		WHEN SalesChannel IN ('12') THEN 'Gm Telemarkering'
		WHEN SalesChannel IN ('3254') THEN 'Gm mail'
		ELSE SalesChannel END AS SalesChannel
	,CASE WHEN SalesChannel IN ('4') THEN 'Webshop'
		ELSE 'Normal Order Handling' END AS AxInterSalesChannel
	,BusinessChain AS Department
	,[ProjectNum]
	--,'' AS [IndexKey]
	--,'0' AS Cancellation
	,SalesPerson_Rsp AS SORes1
	--,'' AS SORes2
	--,'' AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM stage.ABK_SE_OLine
GO
