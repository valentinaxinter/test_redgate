IF OBJECT_ID('[stage].[vCER_NO_BC_SalesLedger]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_BC_SalesLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vCER_NO_BC_SalesLedger] AS 


with auxiliar_table as (
select InvoiceNum, sum(cast(VAT as decimal(9,2))) as VatAmount
from [stage].[CER_NO_BC_SalesInvoice] 
group by InvoiceNum
)

SELECT 
	CONVERT(binary(32), HASHBYTES('SHA2_256', CONCAT(Company, '#', CustNum, '#', ledg.InvoiceNum))) AS SalesLedgerID,
	CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(CustNum))))) AS CustomerID,
	CONVERT(binary(32), HASHBYTES('SHA2_256', TRIM(Company))) AS CompanyID,
	CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(WarehouseCode))))) AS WarehouseID,
	
	PartitionKey,
	Company,
	nullif(trim(CustNum),'') as CustomerNum,
	nullif(trim(ledg.InvoiceNum),'') as SalesInvoiceNum,
	cast(InvoiceDate as Date) as SalesInvoiceDate,
	cast(DueDate as Date) as SalesDueDate,
	case when cast(LastPaymentDate as Date) < '1900-01-01' or cast(LastPaymentDate as Date) IS null then cast('1900-01-01' AS date)
		 else  cast(LastPaymentDate as Date) 
		 end  as SalesLastPaymentDate,
	cast(amount AS decimal(18,4)) AS InvoiceAmount,
	cast(remainingAmount AS decimal(18,4)) AS RemainingInvoiceAmount,
	cast(amount AS decimal(18,4)) - cast(remainingAmount as decimal(18,4)) as PaidInvoiceAmount,
	cast(adjustedCurrencyFactor as decimal(18,8)) AS ExchangeRate,
	--'' AS Currency,
	isnull(cast(auxiliar_table.VatAmount AS decimal(18,4)),0) AS VATAmount,
	--'' AS VATCode,
	--'' AS PayToName,
	--'' AS PayToCity,
	--'' AS PayToContact,
	--'' AS PaymentTerms,
	--'' AS SLRes1,
	--'' AS SLRes2,
	--'' AS SLRes3
	--NULL			AS PaidInvoiceAmount,
	'1900-01-01' AS AccountingDate
	--NULL AS AgingPeriod					,
	--NULL AS AgingSort					,
	--NULL AS VATCodeDesc					,
	--NULL AS LinkToOriginalInvoice		
    --,systemCreatedAt
	--,systemModifiedAt
FROM 
	 stage.CER_NO_BC_SalesLedger AS ledg
	LEFT JOIN auxiliar_table
		ON ledg.InvoiceNum = auxiliar_table.InvoiceNum
GO
