IF OBJECT_ID('[prestage].[vCYE_ES_POLine]') IS NOT NULL
	DROP VIEW [prestage].[vCYE_ES_POLine];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [prestage].[vCYE_ES_POLine] AS
SELECT 
	concat(CONVERT (date, SYSDATETIME()), ' 00:00:00') AS [PartitionKey]
	,'CYESA' AS [Company]
	,TRIM(SupplierNum) AS SupplierNum
	,CONVERT(DATE, OrderDate, 120) AS OrderDate
	,TRIM(InvoiceNum) AS InvoiceNum
	,TRIM(InvoiceLine) AS InvoiceLine
	,TRIM(PONum) AS PONum
	,TRIM(POLine) AS POLine
	,TRIM(PORelNum) AS PORelNum
	,TRIM(PartNum) AS PartNum
	,TRY_CONVERT(Decimal(18,4), REPLACE(REPLACE(Qty,'.',''),',','.')) AS Qty
	,TRY_CONVERT(Decimal(18,4), REPLACE(REPLACE([UnitPrice],'.',''),',','.')) AS [UnitPrice]
	,Indexkey
FROM [prestage].[CYE_ES_POLine]
GO
