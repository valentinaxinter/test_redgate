IF OBJECT_ID('[stage].[vCER_DE_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vCER_DE_SalesLedger];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vCER_DE_SalesLedger]
	AS SELECT 
		
	 CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(Company, '#', CustomerNum, '#', SalesInvoiceNum))) AS SalesLedgerID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
	 ,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(CustomerNum)))) AS CustomerID

	 ,[PartitionKey]          
	 ,[Company]               
	 ,[Currency]              
	 ,[CustomerNum]           
	 ,[SalesInvoiceNum]       
	 ,[SalesInvoiceDate]      
	 ,[SalesDueDate]          
	 ,[SalesLastPaymentDate]  
	 ,[InvoiceAmount]         
	 ,[PaidInvoiceAmount]     
	 ,[RemainingInvoiceAmount]
	 ,[VATAmount]             
	 ,[VATCode]               
	 ,[VATCodeDesc]           
	 ,[ExchangeRate]          
	 ,[IsInvoiceClosed]       
	
	FROM stage.CER_DE_SalesLedger
GO
