IF OBJECT_ID('[stage].[vSKS_FI_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vSKS_FI_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vSKS_FI_SOLine] AS
--COMMENT EMPTY FIELDS // ADD UPPER() TRIM() INTO PartID,CustomerID,WarehouseID 2022-12-16 VA
WITH prepayUnitCost AS (
	SELECT ORDERNUM, ORDERLINE, INVOICENUM, UNITCOST from [stage].[SKS_FI_SOLine] WHERE unitprice !=0 and FAREG = '3' --AND ORDERNUM = '0000318063'
)
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(VKORG, '#', COMPANY, '#', TRIM(s.ORDERNUM), '#', TRIM(s.INVOICELINE), '#', TRIM(PARTNUM), '#', TRIM(s.INVOICENUM)))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(COMPANY, '#', s.ORDERNUM, '#', s.ORDERLINE, '#', ORDERREL, '#', s.INVOICENUM, '#', VKORG))) AS SalesOrderID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(COMPANY, '#', CUSTNUM, '#', INVOICENUM, '#', MANDT, '#', VKORG))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(COMPANY, '#', trim(CUSTNUM), '#', trim(s.INVOICENUM), '#', trim(MANDT), '#', trim(VKORG)))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(COMPANY, '#', TRIM(s.ORDERNUM)))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', COMPANY)) AS CompanyID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(COMPANY, '#', TRIM(CUSTNUM), '#', TRIM([VKORG])))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(COMPANY),'#',TRIM(CUSTNUM),'#',TRIM(VKORG))))) AS CustomerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(COMPANY),'#',TRIM(PARTNUM),'#',TRIM(VKORG))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(COMPANY, '#', PARTNUM, '#', VKORG))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(COMPANY), '#', TRIM(WAREHOUSECODE))))) AS WarehouseID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(COMPANY, '#', WAREHOUSECODE))) AS WarehouseID
	,CONCAT(COMPANY, '#', s.ORDERNUM, '#', s.ORDERLINE, '#', s.INVOICENUM) AS SalesOrderCode
	,CONVERT(int, INVOICEDATE) AS SalesInvoiceDateID  
	,CONCAT(Company, '#', TRIM(s.INVOICENUM), '#', TRIM(s.INVOICELINE)) AS SalesInvoiceCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT( Company, '#', PROJECTNUM) )) AS ProjectID
	,PartitionKey

	--,CASE WHEN COMPANY = 'SKSSWE' THEN 'JSESKSSW' ELSE COMPANY END AS Company
	,Company
    ,SALESPERSONORDER AS SalesPersonName -- was SALESPERSON before Fredrik made change on 20210515. /DZ
    ,IIF(ISNUMERIC([CUSTNUM]) = 1,CAST(CAST(trim([CUSTNUM]) AS int)as nvarchar(50)),(trim([CUSTNUM]))) AS [CustomerNum]
	,IIF(ISNUMERIC([PARTNUM]) = 1,CAST(CAST(trim([PARTNUM]) AS int)as nvarchar(50)),(trim([PARTNUM]))) AS [PartNum]
	,CASE WHEN MATKL = 'ZCONS' THEN 'Consumables'
		WHEN MATKL = 'ZDIEN' THEN 'Service'
		WHEN MATKL = 'ZDIEN_FRE' THEN 'Freight'
		WHEN MATKL = 'ZFERT' THEN 'Finished materials'
		WHEN MATKL = 'ZHALB' THEN 'Semifinished matr.'
		WHEN MATKL = 'ZHAWA' THEN 'Trading goods'
		WHEN MATKL = 'ZROH' THEN 'Raw materials'
		WHEN MATKL = 'ZVERP' THEN 'Packaging material'
		WHEN MATKL = 'ZZMAT' THEN 'SKS Config. material'
		END AS PartType
    ,TRIM(s.ORDERNUM) AS SalesOrderNum
    ,s.ORDERLINE AS SalesOrderLine
	,ORDERSUBLINE AS SalesOrderSubLine
	,CASE WHEN ORDERTYPE = 'G2' THEN 1 
		WHEN ORDERTYPE = 'L2' THEN 2
		WHEN ORDERTYPE = 'RE' THEN 3
		WHEN ORDERTYPE = 'SO' THEN 4
		WHEN ORDERTYPE = 'TA' THEN 5
		WHEN ORDERTYPE = 'YBFD' THEN 6
		WHEN ORDERTYPE = 'ZAO' THEN 7
		WHEN ORDERTYPE = 'ZCOD' THEN 8
		WHEN ORDERTYPE = 'ZDP' THEN 9
		WHEN ORDERTYPE = 'ZPO1' THEN 10
		WHEN ORDERTYPE = 'ZPO3' THEN 11
		WHEN ORDERTYPE = 'ZSOI' THEN 12
		WHEN ORDERTYPE = 'ZSV' THEN 13
		WHEN ORDERTYPE = 'ZSVD' THEN 14
		WHEN ORDERTYPE = 'ZSVW' THEN 15
		WHEN ORDERTYPE = 'ZWA' THEN 16
		ELSE 0 END AS SalesOrderType  -- all ORDERTYPE = 0 before 20210106
    ,s.INVOICENUM AS SalesInvoiceNum
    ,s.INVOICELINE AS SalesInvoiceLine
	--,INVOICETYPE AS SalesInvoiceType -- A, B, C, D ... This is actually BillingCategory
	,FKART AS SalesInvoiceType -- FKART = Billing type: F2 = invoice; RE = return; 
	,CASE WHEN [INVOICEDATE] = '00000000' THEN CAST('19010101' AS Date) ELSE CAST([INVOICEDATE] AS Date) END AS SalesInvoiceDate
	,CASE WHEN [ACTUALDELIVERYDATE] = '00000000' THEN CAST('19010101' AS Date) ELSE CAST([ACTUALDELIVERYDATE] AS Date) END AS ActualDelivDate --ACTUALDELIVERYDATE AS ActualDeliveryDate
    ,iif(ORDERTYPE IN ('RE','G2'), -1*abs(SELLINGSHIPQTY), SELLINGSHIPQTY)  AS SalesInvoiceQty --SELLINGSHIPQTY
	--,'' AS UoM
    ,UNITPRICE AS UnitPrice 
    ,IIF(s.UNITCOST = 0, p.UnitCost, s.UNITCOST) AS UnitCost 
	--,NULL AS DiscountPercent
    ,IIF(ORDERTYPE IN ('RE','G2'), -1*(-DISCOUNTAMOUNT), -DISCOUNTAMOUNT) AS DiscountAmount -- see ticket 85180 /DZ
	--,0 AS CashDiscountOffered
	--,0 AS CashDiscountUsed
-- updated according to Fredrik Nybergs 210102 epsot on 20210106. logic from Katri Hopeakoski 2020-11-27 email. 
-- MinOrdeValueFee is always [MINORDERVALUEFEE] (such as 8.5€) per order, not per quantity
-- Freight insurance is [FREIGHTINSURANCE] (such as 0,5%) of the total netvalue of the components and devided by the ordered quantity
--	,CASE WHEN [SELLINGSHIPQTY] = 0 THEN [MINORDERVALUEFEE] ELSE ([MINORDERVALUEFEE] + ([UNITPRICE]*[FREIGHTINSURANCE]/[SELLINGSHIPQTY])) END AS TotalMiscChrg
	,0 AS TotalMiscChrg --MINORDERVALUEFEE
	--,0 AS VATAmount
	,Currency
	,ExchangeRate
	,CREDITMEMO AS CreditMemo
	,CASE WHEN SALESPERSONORDER = 'PIUser' AND TRIM(CUSTNUM) = '0000167742' THEN 'EDI'
		ELSE 'Normal Order Handling' END AS SalesChannel
	,VBTYP AS Department
	,WAREHOUSECODE AS WarehouseCode
	--,NULL AS DeliveryAddress
    --,'' AS CostBearerNum
	--,'' AS CostUnitNum
	--,'' AS ReturnComment
	--,'' AS ReturnNum
	,PROJECTNUM AS ProjectNum
	,'' AS IndexKey -- temp use IndexKey for [PROJECTNUM]
	,FKART AS SIRes1	
	,SALESPERSONINVOICE AS SIRes2	-- added Fredrik  on 20210515. /DZ
	,WBS_ELEMENT AS SIRes3 /*CASE WHEN MATKL = 'ZCONS' THEN 'Consumables'
		WHEN MATKL = 'ZDIEN' THEN 'Service'
		WHEN MATKL = 'ZDIEN_FRE' THEN 'Freight'
		WHEN MATKL = 'ZFERT' THEN 'Finished materials'
		WHEN MATKL = 'ZHALB' THEN 'Semifinished matr.'
		WHEN MATKL = 'ZHAWA' THEN 'Trading goods'
		WHEN MATKL = 'ZROH' THEN 'Raw materials'
		WHEN MATKL = 'ZVERP' THEN 'Packaging material'
		WHEN MATKL = 'ZZMAT' THEN 'SKS Config. material'
		END AS SIRes3 */	-- Items type, such as Packaging material, Trading goods ...    -- Should be removed here and moved to Part table. ET 20210302
FROM [stage].[SKS_FI_SOLine] s
	 LEFT JOIN prepayUnitCost p ON s.ORDERNUM = p.ORDERNUM AND s.ORDERLINE = p.ORDERLINE AND s.INVOICENUM = p.INVOICENUM --AND s.INVOICELINE = p.INVOICELINE
WHERE FAREG <> '3' AND FKART NOT IN ('F5', 'F8', 'FAZ', 'ZFAZ') AND VBTYP != 'N' -- ticket #INC-116078
		AND VKORG NOT IN ('FI00','SE10')-- 3 = prepayment, it is called Billing Rule -- Not including some sales invoice typ (FKART) at request of Katri 2021-05-05
GO
