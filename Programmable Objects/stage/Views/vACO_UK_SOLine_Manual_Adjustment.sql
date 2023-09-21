IF OBJECT_ID('[stage].[vACO_UK_SOLine_Manual_Adjustment]') IS NOT NULL
	DROP VIEW [stage].[vACO_UK_SOLine_Manual_Adjustment];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vACO_UK_SOLine_Manual_Adjustment]	AS
--ADD TRIM()UPPER()INTO PartID/CustomerID VA
WITH CTE AS (
SELECT  
		[SopNumber]
      ,[SOPTYPE]
      ,COALESCE(TRY_CONVERT(date, [GLPostingdate]), TRY_CONVERT(date, [GLPostingDate], 103)) AS GLPostingDate
      ,[ItemNumber]
      ,[Brand]
      ,COALESCE(TRY_CONVERT(decimal(18,4), REPLACE(REPLACE([ExtendedPrice],',','.'),' ','')),0) AS [ExtendedPrice]
      ,COALESCE(TRY_CONVERT(decimal(18,4), REPLACE(REPLACE([ExtendedCost],',','.'),' ','')),0) AS [ExtendedCost]
      ,COALESCE(NULLIF(TRY_CONVERT(Decimal(18,4),[QUANTITY]),0)	,1) AS Quantity
      ,[CUSTNMBR]
      ,[Item_Class]
      ,[UserToEnter]
      ,COALESCE(TRY_CONVERT(Decimal(18,4),[Discount])	,0) AS Discount
	,ROW_NUMBER() OVER (Partition BY SOPNumber ORDER BY CUSTNMBR, ItemNumber, ExtendedPrice, ExtendedCost)	AS RowNum
	,N'ACORNUK' AS Company
  FROM [stage].[ACO_UK_SOLine_Manual_Adjustment]
  WHERE SOPNumber IS NOT NULL
)
SELECT 
CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CTE.Company,  '#', SOPNumber, '#', RowNum))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CTE.Company, '#', SOPNumber, '#', CUSTNMBR, '#', ItemNumber  ))) AS SalesOrderID --Not really relevant
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CTE.Company, '#', CUSTNMBR, '#', SOPNumber))) AS SalesLedgerID --Not really relevant
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CTE.Company, '#', SOPNumber))) AS SalesOrderNumID --Not really relevant
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CTE.Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(CTE.Company), '#', TRIM(CUSTNMBR))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CTE.Company, '#', CUSTNMBR))) AS CustomerID
	,COALESCE(P.PartID, CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(CTE.Company), '#',TRIM(ItemNumber)))))) AS PartID 
	--,COALESCE(P.PartID, CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(CTE.Company, '#',ItemNumber)))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CTE.Company, '#', ''))) AS WareHouseID --Not really relevant
	,CONCAT(CTE.Company, '#', SOPNumber,'' ) AS SalesOrderCode --Not really relevant
	,CONVERT(int, replace(convert(date,GLPostingDate), '-', '')) AS SalesInvoiceDateID  --Redundant?
	,CONCAT(CTE.Company, '#', SOPNumber) AS SalesInvoiceCode --Redundant??
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( CTE.Company,'#','') ))	AS ProjectID
	,FORMAT(GETDATE(), 'yyyy-MM-dd hh:mm:ss') PartitionKey

	,CTE.Company
	,[dbo].[ProperCase](UserToEnter) AS SalesPersonName
	,TRIM(CUSTNMBR) AS CustomerNum
	,TRIM(ItemNumber) AS PartNum
	,NULL  AS PartType
	,NULL AS SalesOrderNum
	,NULL AS SalesOrderLine
	,NULL AS SalesOrderSubLine
	,SOPTYPE AS SalesOrderType
	,SopNumber AS SalesInvoiceNum
	,'' AS SalesInvoiceLine
	,SOPTYPE AS SalesInvoiceType
	,CASE WHEN GLPostingDate = '' THEN '1900-01-01' ELSE CONVERT(date, GLPostingDate) END AS SalesInvoiceDate
	,'1900-01-01'	AS ActualDelivDate
	,QUANTITY	AS SalesInvoiceQty
	,'' AS UoM
	,ExtendedPrice/Quantity AS	UnitPrice
	,ExtendedCost/Quantity AS UnitCost
	,'0' AS DiscountPercent
	,Discount	AS DiscountAmount
	,0 AS CashDiscountOffered
	,0 AS CashDiscountUsed
	,0	AS TotalMiscChrg
	,0 AS VATAmount
	,'GBP' AS Currency
	,1 AS ExchangeRate
	--,CreditMemo
	,'0'	 AS  CreditMemo
	,NULL AS SalesChannel
	,'' AS Department
	,'' AS WarehouseCode
	,NULL AS DeliveryAddress
	,'' AS CostBearerNum
	,'' AS CostUnitNum
	,'' AS ReturnComment
	,'' AS ReturnNum
	,'Manual Adjustment' AS ProjectNum
	,RowNum AS [IndexKey]
	,NULL	AS SIRes1
	,NULL	AS SIRes2
	,NULL	AS SIRes3
FROM CTE
LEFT JOIN (SELECT [PartID], [PartCode], [Company], [PartNum], [PartName], [PartDescription], [PartDescription2], [PartDescription3], [ProductGroup], [ProductGroup2], [ProductGroup3], [ProductGroup4], [Brand], [CommodityCode], [PartReplacementNum], [PartStatus], [CountryOfOrigin], [NetWeight], [UoM], [Material], [Barcode], [ReOrderLevel], [PartResponsible], [StartDate], [EndDate], [CompanyID], [PartitionKey], [MainSupplier], [AlternativeSupplier], [is_deleted], [is_inferred], [PARes1], [PARes2], [PARes3], [IsActiveRecord] FROM dw.Part WHERE Company = 'ACORNUK' AND PartDescription3 IS NULL) P ON TRIM(CTE.ItemNumber) = TRIM(P.PartNum)
GO
