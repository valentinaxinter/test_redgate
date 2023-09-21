IF OBJECT_ID('[prestage].[CYE_ES_SOLine_Load]') IS NOT NULL
	DROP PROCEDURE [prestage].[CYE_ES_SOLine_Load];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [prestage].[CYE_ES_SOLine_Load]
AS
BEGIN

Truncate table stage.[CYE_ES_SOLine]

insert into 
stage.CYE_ES_SOLine(
	PartitionKey
	,Company
	,InvoiceDate
	,SalesPerson
	,CustNum
	,OrderNum
	,OrderLine
	,OrderRel
	,InvoiceNum
	,InvoiceLine
	,InvoiceType -- bew field by Capgemani 20210622 /DZ
	,CreditMemo
	,PartNum
	,SellingShipQty
	,UnitPrice
	,UnitCost
	,DiscountAmount
	,TotalMiscChrg
	,WarehouseCode
	,Indexkey
	,[UnitCostEK02]
	,[DiscountPercent]
	,[SalesOfficeDescrip]
	,[SalesGroupCode]
	,[SalesGroupDescrip]
	,[ReturnNum]
	,[ReturnComment]
	,[ActualDeliveryDate]	
	)
select 
	PartitionKey
	,Company
	,InvoiceDate
	,SalesPerson
	,CustNum
	,OrderNum
	,OrderLine
	,OrderRel
	,InvoiceNum
	,InvoiceLine
	,InvoiceType -- bew field by Capgemani 20210622 /DZ
	,CreditMemo
	,PartNum
	,SellingShipQty
	,UnitPrice
	,UnitCost
	,DiscountAmount
	,TotalMiscChrg
	,WarehouseCode
	,Indexkey
	,[UnitCostEK02]
	,[DiscountPercent]
	,[SalesOfficeDescrip]
	,[SalesGroupCode]
	,[SalesGroupDescrip]
	,[ReturnNum]
	,[ReturnComment]
	,[ActualDeliveryDate]
from [prestage].[vCYE_ES_SOLine]

--Truncate table prestage.[CYE_ES_SOLine]

End
GO
