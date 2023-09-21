IF OBJECT_ID('[stage].[vACO_UK_OLine_Manual_Adjustment]') IS NOT NULL
	DROP VIEW [stage].[vACO_UK_OLine_Manual_Adjustment];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vACO_UK_OLine_Manual_Adjustment] AS 
--ADD UPPER() TRIM() INTO CustomerID PartID va
WITH Ord AS (
SELECT 
	  N'ACORNUK' AS Company
	  ,[SOPNUMBE]
      ,[SOPTYPE]
      ,TRY_CAST(CAST(GLPostingdate as int)-2 as smalldatetime) AS [GLPostingdate] --  it's minus 2 because excel is weird
      ,TRIM([ItemNumber])	AS ItemNumber
      ,[Brand]
      ,COALESCE(TRY_CONVERT(decimal(18,4), REPLACE(REPLACE([ExtendedPrice],',','.'),' ','')),0) AS [ExtendedPrice]
      ,COALESCE(TRY_CONVERT(decimal(18,4), REPLACE(REPLACE([ExtendedCost],',','.'),' ','')),0) AS [ExtendedCost]
      ,COALESCE(NULLIF(TRY_CONVERT(Decimal(18,4),[QUANTITY]),0)	,1) AS Quantity
      ,TRIM([CUSTNMBR])		AS [CUSTNMBR]
      ,[Item_Class]
      ,COALESCE(TRY_CONVERT(date,[DocDate], 23)
				,TRY_CONVERT(date,[DocDate], 103)) AS [DocDate]
      ,[Initmseq]
	  ,ROW_NUMBER() OVER (Partition BY  SOPNUMBE, ItemNumber, [Initmseq] ORDER BY QUANTITY, ExtendedPrice, ExtendedCost)	AS RowNum
  FROM [stage].[ACO_UK_OLine_Manual_Adjustment]
  WHERE SOPNUMBE IS NOT NULL
  )

  SELECT 
  CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', TRIM([SOPNUMBE]), '#', ItemNumber, '#', [Initmseq], '#', RowNum))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', Company)) AS CompanyID
	,COALESCE(Customer.CustomerID,  CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company), '#', TRIM([CUSTNMBR])))))) AS CustomerID
	--,COALESCE(Customer.CustomerID,  CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', [CUSTNMBR])))) AS CustomerID
	,COALESCE(Part.PartID, CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#',TRIM(ItemNumber)))))) AS PartID 
	--,COALESCE(Part.PartID, CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', ItemNumber)))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', '')))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#',[SOPNUMBE])))	AS SalesOrderNumID
	,CONCAT(Company, '#', TRIM([CUSTNMBR]), '#', TRIM([SOPNUMBE]), '#', [Initmseq]) AS SalesOrderCode
	,COALESCE( CONVERT(int, replace(try_convert(date, [DocDate]), '-', '')), CONVERT(int, replace(try_convert(date, [GLPostingdate]), '-', '')))  AS SalesOrderDateID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT( Company,'#','') ))	AS ProjectID
	,FORMAT(GETDATE(), 'yyyy-MM-dd hh:mm:ss') PartitionKey

	,Company 
	,TRIM([CUSTNMBR])	AS CustomerNum 
	,TRIM([SOPNUMBE])	AS SalesOrderNum
	,[Initmseq]			AS SalesOrderLine
	--,''					AS SalesOrderSubLine
	,SOPType			AS SalesOrderType
	--,''					AS SalesOrderCategory
	,CAST(COALESCE([DocDate], [GLPostingdate]) AS date)			AS SalesOrderDate
	,CAST('1900-01-01' AS date) AS NeedbyDate
	,CAST('1900-01-01' AS date) AS ExpDelivDate
	,CAST('1900-01-01' AS date) AS ActualDelivDate
	,CAST('1900-01-01' AS date) AS ConfirmedDelivDate
	,TRIM([SOPNUMBE])	AS SalesInvoiceNum
	,QUANTITY			AS SalesOrderQty
	,QUANTITY			AS DelivQty
	,0					AS RemainingQty
	--,NULL AS SalesInvoiceQty
	--,NULL				AS UoM
	,ExtendedPrice/QUANTITY AS UnitPrice
	,ExtendedCost/QUANTITY	AS UnitCost
	,'GBP'  AS Currency
	,1		AS ExchangeRate
	,'0'	AS OpenRelease
	,0		AS DiscountAmount
	,0		AS DiscountPercent
	,TRIM(ItemNumber) AS PartNum
	--,'' AS PartType
	--,'' AS PartStatus
	--,'' AS SalesPersonName
	--,'' AS WarehouseCode
	,CASE	--WHEN LEN(SalesChannel) = 8 THEN 'EXPRESS'	
			--WHEN LEN(SalesChannel) = 12 THEN 'ADVANCE'
			WHEN [CUSTNMBR] LIKE 'RSCOMP%' THEN 'EDI'
			--WHEN SalesPerson = '' THEN 'IMPORTED'
			ELSE '' END AS SalesChannel
	,CASE WHEN [CUSTNMBR] LIKE 'RSCOMP%' THEN 'EDI'
		--WHEN LEN(SalesChannel) = 12 THEN 'Webshop'
		--WHEN LEN(SalesChannel) = 8 THEN 'Webshop'
		ELSE 'Normal Order Handling' END AS AxInterSalesChannel
	--,'' AS Department
	,'Manual Order Adjustment' AS ProjectNum
	,'' AS IndexKey
	,'0' AS Cancellation
	--,''  AS SORes1
	--,NULL AS SORes2
	--,NULL AS SORes3
	--,NULL AS [TotalMiscChrg]
FROM Ord
LEFT JOIN (SELECT DISTINCT PartID
					, TRIM(PartNum) AS PartNum 
			FROM dw.Part 
			WHERE Company = 'ACORNUK' 
			AND PartDescription3 IS NULL) AS Part 
												ON Part.PartNum = Ord.ItemNumber
LEFT JOIN (SELECT DISTINCT CustomerID
					, TRIM(CustomerNum) AS CustomerNum 
			FROM dw.Customer 
			WHERE Company = 'ACORNUK' 
			AND CustomerName IS NOT NULL) AS Customer ON Customer.CustomerNum = Ord.CUSTNMBR
GO
