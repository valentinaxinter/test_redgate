IF OBJECT_ID('[stage].[vSTE_SE_Salesledger]') IS NOT NULL
	DROP VIEW [stage].[vSTE_SE_Salesledger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [stage].[vSTE_SE_Salesledger] AS
SELECT
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(UPPER(TRIM(Company)), '#', UPPER(TRIM(CustNum)), '#', UPPER(TRIM(InvoiceNum)) ))) AS SalesLedgerID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(TRIM(Company)))) AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(CustNum))))) AS CustomerID
	,CONCAT(UPPER(TRIM(Company)), '#', UPPER(TRIM(CustNum)), '#', UPPER(TRIM(InvoiceNum))) AS SalesLedgerCode

	,[PartitionKey] 
	,UPPER(TRIM("Company")) AS "Company"
	,UPPER(TRIM("CustNum" )) AS "CustomerNum"
	,"InvoiceNum"  AS "SalesInvoiceNum"
	,"InvoiceDate" AS "SalesInvoiceDate"
	,"DueDate"  AS "SalesDueDate"
	,"LastPaymentDate"  AS "SalesLastPaymentDate"
	,[IsInvoiceClosed]		
	,[InvoiceAmount]			
	,[PaidInvoiceAmount]		
	,[RemainingInvoiceAmount]
	,[Currency]				
	,[ExchangeRate]			
	,[PaymentTerms]			
from
	stage.STE_SE_Salesledger
GO
