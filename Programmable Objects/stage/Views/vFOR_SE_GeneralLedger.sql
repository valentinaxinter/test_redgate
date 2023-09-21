IF OBJECT_ID('[stage].[vFOR_SE_GeneralLedger]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_GeneralLedger];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Good-to-know:
-- DESCRIBE (AND DATE) ANY CHANGES TO STANDARD SCRIPT HERE.
 -- Switched Accounding Date and JournalDate fields as they have been incorrectly mapped (2022-10-27 SB)

CREATE VIEW [stage].[vFOR_SE_GeneralLedger] AS
SELECT
--------------------------------------------- Keys/ IDs ---------------------------------------------
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', SysRowID))) AS GeneralLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',Company)) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company, '#', [AccountNum]))) AS AccountID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',Concat(Company, '#', SupplierNum))) AS SupplierID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#',TRIM(CustomerNum)))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company, ''))) AS ProjectID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company, '#', [CostUnitNum]))) AS CostUnitID
	,CONVERT([binary](32), HASHBYTES('SHA2_256',CONCAT(Company, '#', [CostBearerNum]))) AS CostBearerID
	,PartitionKey

--------------------------------------------- Regular Fields ---------------------------------------------
---Mandatory Fields ---
	,Company
	,[AccountNum]
	,[JournalNum]
	,CONVERT(date, [JournalDate]) AS AccountingDate --this must have been mapped incorrectly, because journal date = accounting date and viceversa. Made change 2022-10-27 (SB)
	,'SEK' AS [Currency]
	,1 AS ExchangeRate
	,[AmountSystemCurrency] AS InvoiceAmount
	,[AmountSystemCurrency] AS InvoiceAmountLC
---Valuable Fields ---
	,[CostUnitNum]
	,[CostBearerNum]
	,[JournalType]
	,[JournalLine]
	,[Description]
	,CONVERT(date, [AccountingDate]) AS JournalDate --this must have been mapped incorrectly, because journal date = accounting date and viceversa. Made change 2022-10-27 (SB)
	,CustomerNum
	,SupplierNum
	,ARInvoiceNum	AS SalesInvoiceNum
	,APInvoiceNum	AS PurchaseInvoiceNum
	,SupplierInvoiceNum
	,[LinktoOriginalInvoice] AS [LinkToOriginalInvoice]
	,'' AS DeliveryCountry
	,[TransactionNum]	
	,[VATCode]
	,[VATCodeDesc]
--- Good-to-have Fields ---
--UserIDApproved
--IsManual

--------------------------------------------- Meta Data ---------------------------------------------
--,CONVERT(date, ModifiedTimeStamp) AS ModifiedTimeStamp
--,CONVERT(date, CreatedTimeStamp) AS CreatedTimeStamp
--,TRIM(IsActiveRecord) AS IsActiveRecord

--------------------------------------------- Extra Fields ---------------------------------------------
	,'' AS GLRes1
	,'' AS GLRes2
	,'' AS GlRes3

FROM 
	stage.FOR_SE_GeneralLedger

/*GROUP BY
	PartitionKey, SysRowID, Company, [SupplierNum], [CustomerNum], [CostUnitNum], [CostBearerNum], [SupplierInvoiceNum], [JournalDate], [AccountingDate], [Currency], [AmountSystemCurrency], [AccountNum], [JournalType], [TransactionNum], [JournalNum], [JournalLine], [Description], [VATCode], [LinktoOriginalInvoice], [APInvoiceNum], [ARInvoiceNum], [FiscalPeriod], [VATCodeDesc],[FiscalYear]
	*/
GO
