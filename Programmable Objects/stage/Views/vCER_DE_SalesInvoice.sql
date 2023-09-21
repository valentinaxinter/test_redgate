IF OBJECT_ID('[stage].[vCER_DE_SalesInvoice]') IS NOT NULL
	DROP VIEW [stage].[vCER_DE_SalesInvoice];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vCER_DE_SalesInvoice]
	AS SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(SalesInvoiceNum), '#', TRIM(SalesInvoiceLine))))) AS SalesInvoiceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustomerNum))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT([Company], '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([PartNum]))))) AS PartID
	--, SalesOrderID i miss the line level
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', CustomerNum, '#', SalesInvoiceNum))) AS SalesLedgerID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',SalesOrderNum)))) AS SalesOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID

	 ,PartitionKey      
	,[Company]         
	,[SalesInvoiceNum] 
	,[SalesInvoiceLine]
	,[SalesInvoiceDate]
	,[ActualDelivDate] 
	,[DeliveryAddress] 
	,[DeliveryCity]    
	,[DeliveryCountry] 
	,[DeliveryZipCode] 
	,[CustomerNum]     
	,[PartNum]         
	,[UnitPrice]       
	,[UnitCost]        
	,[VATAmount]       
	,[SalesInvoiceQty] 
	,[Currency]        
	,[ExchangeRate]    
	,[WarehouseCode]   
	,[DiscountAmount]  
	,[DiscountPercent] 
	,[IsCreditMemo]    
	,[SalesOrderNum]   
	,[SalesPersonName] 
	,[UoM]             
	,SalesOrderType
	FROM stage.CER_DE_SalesInvoice
GO
