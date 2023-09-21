IF OBJECT_ID('[dm].[FactSalesInvoice]') IS NOT NULL
	DROP VIEW [dm].[FactSalesInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







-------------------------------------------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------


CREATE VIEW [dm].[FactSalesInvoice] AS

SELECT 
	CONVERT(BIGINT, SINV.SalesInvoiceID) AS SalesInvoiceID --
	,CONVERT(BIGINT, SINV.SalesOrderID) AS SalesOrderID --
	,CONVERT(BIGINT, SINV.SalesOrderNumID) AS SalesOrderNumID --
	,CONVERT(BIGINT, SINV.CustomerID) AS CustomerID --
	,CONVERT(BIGINT, SINV.CompanyID) AS CompanyID --
	,CONVERT(BIGINT, SINV.PartID) AS PartID --
	,CONVERT(BIGINT, SINV.WarehouseID) AS WarehouseID --
	,CONVERT(BIGINT,HASHBYTES('SHA2_256',CONCAT(SINV.Company,'#',NULLIF(TRIM(SINV.SalesPersonName),'')))) AS SalesPersonNameID -- -- NEW
	,CONVERT(bigint, SINV.DepartmentID) as DepartmentID
	,SINV.Company --
	,SINV.SalesInvoiceCode --   -- do we need code here?
	,SINV.SalesInvoiceDateID --
	,CONVERT(BIGINT, SINV.ProjectID) AS ProjectID --
	,NULLIF(TRIM(SINV.SalesPersonName),'') AS SalesPersonName --
	,SINV.CustomerNum --
	,SINV.PartNum --
	,SINV.PartType --
	,SINV.SalesOrderNum --
	,SINV.SalesOrderLine --
	,SINV.SalesOrderSubLine --
	,SINV.SalesOrderType --
	,SINV.SalesInvoiceNum --
	,SINV.SalesInvoiceLine --
	,SINV.SalesInvoiceType --
	,SINV.SalesInvoiceDate --
	,CONVERT(date, IIF(SINV.ActualDelivDate > '2025-01-01', '1900-01-01', SINV.ActualDelivDate)) AS ActualDelivDate --  --Take away the unreasonable dates /DZ 2021-10-25
	,SINV.SalesInvoiceQty --
	,SINV.UoM --
	,SINV.UnitPrice --
	,SINV.UnitCost --
	,SINV.DiscountPercent --
	,SINV.DiscountAmount --
	,SINV.TotalMiscChrg --
	,SINV.Currency --
	,SINV.ExchangeRate --
	,SINV.VATAmount --
	,SINV.CreditMemo --
	,SINV.Department --
	,SINV.ProjectNum --
	,SINV.WarehouseCode --
	,SINV.CostBearerNum --
	,SINV.CostUnitNum --
	,SINV.ReturnComment --
	,SINV.ReturnNum --
	,NULLIF(TRIM(SINV.SalesPersonName),'') AS OrderHandler -- 
	--,SINV.SalesPersonName AS OrderHandler -- replacement of the original one, with right rows
	,SINV.SalesChannel --COALESCE(SORD.SalesChannel, SINV.SalesChannel) AS SalesChannel is the original one which give less rows; -- differ test one as : SINV.SalesChannel /DZ 2022-10-24
	,IIF(SINV.Company = 'CNOCERT', MIN(SORD.NeedbyDate), COALESCE(MAX(SORD.NeedbyDate), '1900-01-01')) AS NeedbyDate --  -- 2021-06-18 /DZ
	,IIF(SINV.Company = 'CNOCERT', MIN(SORD.ExpDelivDate), COALESCE(MAX(SORD.ExpDelivDate), '1900-01-01')) AS ExpDelivDate --  -- 2021-06-18 /DZ
	,SORD.SalesOrderCode --differ test one
	,SORD.SalesOrderDateID --differ test one
	,SORD.SalesOrderDate --differ test one
	,SORD.ConfirmedDelivDate --differ test one  --added 2022-02-18 after TÖ /DZ
	,SORD.PartStatus --differ test one
	,SORD.AxInterSalesChannel --differ test one
	--,SINV.SalesPersonName
	--,CASE WHEN SINV.SalesOrderNum = '0' THEN 'PrimaryProduct' ELSE 'SubProduct' END AS ProductType   Removed and replaced by PartType /SM 2021-03-08
	,CASE WHEN SLED.SalesDueDate = ''	OR SLED.SalesDueDate IS NULL THEN '1900-01-01' ELSE SLED.SalesDueDate END AS DueDate --
	,CASE WHEN SLED.SalesLastPaymentDate = '' OR SLED.SalesLastPaymentDate IS NULL THEN '1900-01-01' ELSE SLED.SalesLastPaymentDate	END AS LastPaymentDate --
	,CASE 
		WHEN SLED.SalesLastPaymentDate <= '1900-01-01' OR SLED.SalesLastPaymentDate IS NULL OR SLED.SalesLastPaymentDate = '' THEN 'Not Paid'
		WHEN (		/* Maybe this logic for Partially Paid needs revision. The AND SalesLastPaymentDate conditions seems reduntant 
					as almost all cases are already catched in the previous condition for 'Not Paid'. And I'm positive there are
					partially paid invoices with real SalesLastPaymentDate values. Maybe change condition to 
					RemainingInvoiceAmount <> 0 AND InvoiceAmount > RemainingInvoiceAmount? And then add more logic depending on edge cases  /SM */
				SLED.RemainingInvoiceAmount <> 0 OR SLED.RemainingInvoiceAmount IS NOT NULL
				)
			AND (SLED.SalesLastPaymentDate <= '1901-01-01' OR SLED.SalesLastPaymentDate IS NULL OR SLED.SalesLastPaymentDate = ''
				) THEN 'Partially Paid'
		ELSE 'Paid'	END AS SalesInvoiceStatus -- /* Changed from InvoiceStatus to SalesInvoiceStatus /SM 2021-03-08 --added <= '1900-01-01' (CDKCERT) /DZ 20210920 */
	,CashDiscountOffered --
	,CashDiscountUsed --
	,IsUpdatingStock --
	, SINV.SIRes1
	, SINV.SIRes2 -- added 2022.12.06 /SB
	, SINV.SIRes3 -- added 2022.12.06 /SB
	, SINV.SIRes4 -- added 2022.12.06 /SB
	, SINV.SIRes5 -- added 2022.12.06 /SB
	, SINV.SIRes6 -- added 2022.12.06 /SB
FROM dw.SalesInvoice AS SINV
	LEFT JOIN (
		SELECT --Testing this to avoid duplicates. Might be process heavy /SM 2022-04-01
			SalesOrderCode
			,MIN(SalesOrderDate) AS SalesOrderDate
			,MIN(SalesOrderDateID) AS SalesOrderDateID
			,MAX(ConfirmedDelivDate) AS ConfirmedDelivDate
			,MAX(PartStatus) AS PartStatus
			,MAX(NeedbyDate) AS NeedbyDate
			,MAX(ExpDelivDate) AS ExpDelivDate
			,MAX(SalesChannel) AS SalesChannel
			,MAX(AxInterSalesChannel) AS AxInterSalesChannel
		FROM dw.SalesOrder
		GROUP BY SalesOrderCode
		) AS SORD ON SINV.SalesOrderCode = SORD.SalesOrderCode
	LEFT JOIN dw.SalesLedger AS SLED ON SINV.SalesLedgerID = SLED.SalesLedgerID
WHERE SINV.SalesInvoiceDate >= DATEADD(year, DATEDIFF(YEAR, 0, dateadd(year, - 4, GETDATE())), 0) --The entire basket. 
and (SINV.is_deleted != 1 OR SINV.is_deleted is null)
 GROUP BY --differ test one: no group by in test version. to be able to to dao so one has to all SORD. in the parent selections
	SINV.SalesOrderID
	,SINV.CompanyID
	,SINV.SalesOrderID
	,SINV.SalesOrderNumID
	,SINV.SalesOrderCode
	,SINV.SalesInvoiceID
	,SINV.ProjectID
	,SINV.SalesOrderID
	,SINV.CustomerID
	,SINV.PartID
	,SINV.WareHouseID
	,SINV.SalesInvoiceDateID
	,SINV.Company
	,SINV.SalesPersonName
	,SINV.CustomerNum
	,SINV.PartNum
	,SINV.SalesOrderNum
	,SINV.SalesOrderLine
	,SINV.SalesOrderSubLine
	,SINV.SalesOrderType
	,SINV.SalesInvoiceNum
	,SINV.SalesInvoiceLine
	,SINV.SalesInvoiceType
	,SINV.SalesInvoiceDate
	,SINV.ActualDelivDate
	,SINV.SalesInvoiceQty
	,SINV.UnitPrice
	,SINV.UnitCost
	,SINV.DiscountPercent
	,SINV.DiscountAmount
	,SINV.TotalMiscChrg
	,SINV.CreditMemo
	,SINV.WarehouseCode
	,SINV.ReturnComment
	,SINV.ReturnNum
	,SINV.Currency
	,SINV.ExchangeRate
	,SINV.PartType
	,SINV.UoM
	,SINV.VATAmount
	,SINV.SalesChannel
	,SINV.Department
	,SINV.ProjectNum
	,SINV.CostBearerNum
	,SINV.CostUnitNum
	,SINV.SalesInvoiceCode
	,SINV.CashDiscountOffered
	,SINV.CashDiscountUsed
	,SINV.IsUpdatingStock
	,SLED.SalesDueDate
	,SLED.SalesLastPaymentDate
	,SLED.RemainingInvoiceAmount
	,SORD.SalesOrderDateID
	,SORD.PartStatus
	,SORD.SalesOrderDate
	,SORD.ConfirmedDelivDate
	,SORD.SalesOrderCode
	,SORD.SalesChannel
	,SORD.AxInterSalesChannel
	,SINV.SIRes1
	,SINV.SIRes2
	,SINV.SIRes3
	,SINV.SIRes4
	,SINV.SIRes5
	,SINV.SIRes6
	,SINV.DepartmentID
GO
