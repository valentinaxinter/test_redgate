IF OBJECT_ID('[stage].[vSTE_SE_SOLine]') IS NOT NULL
	DROP VIEW [stage].[vSTE_SE_SOLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE view [stage].[vSTE_SE_SOLine] AS
SELECT
	 CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM("CustomerNum"), '#',TRIM("SalesOrderNum"), '#',TRIM("SalesOrderLine"), '#',TRIM(PartNum), '#',TRIM("SalesInvoiceNum"), '#',TRIM("SalesInvoiceLine"))))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM("SalesOrderNum"), '#',TRIM("SalesOrderLine"), '#',TRIM("SalesInvoiceNum"))))) AS SalesOrderID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM("CustomerNum"), '#', TRIM("SalesInvoiceNum"))))) AS SalesLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM("SalesOrderNum"))))) AS SalesOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM([Company])))) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company),'#','')))) AS ProjectID
	,CONVERT(int, replace(convert(date,InvoiceDate), '-', '')) AS SalesInvoiceDateID  
	,CONCAT(Company, '#', TRIM(SalesInvoiceNum), '#', TRIM(SalesInvoiceType)) AS SalesInvoiceCode 
	
	,[PartitionKey] 
	,UPPER(TRIM("Company")) AS "Company"
	,UPPER(TRIM("PartNum")) AS "PartNum"
	,UPPER(TRIM("CustomerNum")) AS "CustomerNum" 
	,UPPER(TRIM("SalesOrderNum")) AS "SalesOrderNum"
	,UPPER(TRIM("SalesInvoiceNum")) AS "SalesInvoiceNum"
	,"InvoiceDate" as	"SalesInvoiceDate"
	,"SalesPerson"  as  SalesPersonName
	,"SalesInvoiceLine" 
	,"SalesOrderLine" 
	,"DiscountAmount" 
	,"WarehouseCode" 
	,"SalesInvoiceType"					
	,"PartType"							
	,"SalesOrderType"		
	,"IsInvoiceClosed"		
	,"ActualDelivDate"		
	,"SalesInvoiceQty"		
	,"UoM"					
	,"UnitPrice"				
	,"PrePostUnitCost"		
	,"UnitCost"				
	,"DiscountPercent"			
	,"VATAmount"				
	,"Sales Channel"						
	,"ReturnNum"				
	,"ReturnComment"			
	,"CostUnitNum"			
	,IIF("IsCreditMemo" = 'False',0,1)	AS [CreditMemo]		
	,"SalesPerson"			
	,"DeliveryAddressLine"	
	,"DeliveryZipCode"		
	,"DeliveryCity"			
	,"DeliveryCountry"		
	,"Currency"
	,"CurrExchRate" as [ExchangeRate]

FROM 
	stage.STE_SE_SOLine
GO
