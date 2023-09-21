IF OBJECT_ID('[stage].[vCER_NO_BC_SalesInvoice]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_BC_SalesInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [stage].[vCER_NO_BC_SalesInvoice] AS 
SELECT 
	CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(InvoiceNum), '#', TRIM(InvoiceLine), '#', TRIM(PartNum),'#',UPPER(type))))) AS SalesInvoiceID,
	CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID,
	CONVERT(binary(32), HASHBYTES('SHA2_256', CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', CustNum))) AS SalesOrderID, -- SB add 2022-12-08
	CONVERT(int, replace(convert(date,InvoiceDate),'-','')) AS SalesInvoiceDateID,  -- SB added 2023-02-01
	CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID, -- SB add 2022-11-15
	CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID, -- SB add 2022-11-15
	CONVERT(binary(32), HASHBYTES('SHA2_256', TRIM(Company))) AS CompanyID,
	CONCAT(Company, '#', OrderNum, '#', OrderLine, '#', CustNum) as SalesOrderCode,
	
	PartitionKey,
	Company,
	cast(InvoiceDate as Date) as SalesInvoiceDate,
	cast(ActualDeliveryDate as Date) as ActualDelivDate,
	nullif(TRIM(SalesPersonName),'') AS SalesPersonName,
	nullif(trim(CustNum),'') as CustomerNum,
	nullif(trim(OrderNum),'') as SalesOrderNum,
	nullif(trim(OrderLine),'') as SalesOrderLine,
	nullif(trim(InvoiceNum),'') as SalesInvoiceNum,
	nullif(trim(InvoiceLine),'') as SalesInvoiceLine,
	nullif(trim(PartNum),'') as PartNum,
	cast(SalesInvoiceQty as decimal(9,2)) as SalesInvoiceQty,
	cast(UnitPrice as decimal(9,2)) as UnitPrice,
	cast(UnitCost as decimal(9,2)) as UnitCost,
	cast(VAT as decimal(9,2)) as VATAmount,
	nullif(trim(Currency),'') as Currency,
	cast(ExchangeRate as decimal(9,6)) as ExchangeRate,
	--nullif(trim(WarehouseCode),'') as WarehouseCode,
	case when TRIM(Department) = '110584' then 'SERV'
		else nullif(trim(WarehouseCode),'') 
	end as WarehouseCode,
	nullif(trim(ReturnNum),'') as ReturnNum,
	nullif(trim(ReturnComment),'') as ReturnComment,
	case when trim(Type) = 'Credit invoice' then 1 else 0 end as CreditMemo,
	trim(type) as SalesInvoiceType,
	Department,
	CAST(DiscountAmount as decimal(18,4)) as DiscountAmount,
	WarehouseCodeLines as SIRes1
    --,systemCreatedAt
	--,systemModifiedAt
FROM 
	 stage.CER_NO_BC_SalesInvoice
where Cancelled != 'True'
	--where InvoiceNum = '5000674' and InvoiceLine = '60000'
GO
