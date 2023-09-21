IF OBJECT_ID('[stage].[vCYE_ES_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vCYE_ES_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [stage].[vCYE_ES_PurchaseInvoice] AS
--ADD TRIM() INTO CustomerID,PartID 23-01-03 VA
--ADD TRIM() INTO SupplierID 23-01-23 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([PurchaseInvoiceNum]), '#', TRIM(SupplierNum), '#', TRIM(PartNum), '#', TRIM([PurchaseInvoiceNum]), '#', TRIM([PurchaseInvoiceLine]))))) AS PurchaseInvoiceID 
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([PurchaseInvoiceNum]), '#', TRIM(SupplierNum), '#', TRIM(PartNum), '#', TRIM([PurchaseOrderNum]),'#', TRIM([PurchaseOrderLine]))))) AS PurchaseOrderID
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM([PurchaseOrderNum]), '#', TRIM([PurchaseOrderLine]), '#', TRIM(PartNum))) AS PurchaseOrderCode
	,UPPER(CONCAT(Company, '#', TRIM(SupplierNum), '#', TRIM([PurchaseInvoiceNum]), '#', TRIM([PurchaseInvoiceLine]), '#', TRIM(PartNum))) AS [PurchaseInvoiceCode]
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([PurchaseOrderNum]))))) AS PurchaseOrderNumID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM([PurchaseInvoiceNum]))))) AS PurchaseLedgerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', 'EUR')) AS CurrencyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', '')))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(''))))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(SupplierNum))))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(SupplierNum))))) AS SupplierID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(Company), '#', TRIM(PartNum))))) AS PartID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(Company, '#', TRIM(PartNum))))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([WarehouseCode]))))) AS WarehouseID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER([Company]))) AS CompanyID
	,CONVERT(int, replace([PurchaseInvoiceDate],'-','')) AS PurchaseInvoiceDateID
	,[PartitionKey]

    ,UPPER([Company]) AS [Company]
    ,UPPER(TRIM([SupplierNum])) AS [SupplierNum]
    ,UPPER(TRIM([PartNum])) AS [PartNum]
    ,UPPER(TRIM([WarehouseCode])) AS [WarehouseCode]
	,[PurchaseOrderNum]
    ,[PurchaseOrderLine]
    ,[PurchaseOrderSubLine]
    ,[PurchaseOrderType]
    ,[PurchaseInvoiceNum]
    ,[PurchaseInvoiceLine]
    ,[PurchaseInvoiceType]
    ,[PurchaseInvoiceDate]
    ,[ActualDelivDate]
    ,IIF([PurchaseInvoiceType] = 'Credit Memo', -1*CAST(REPLACE([PurchaseInvoiceQty], ',', '.') AS decimal(18,2)), CAST(REPLACE([PurchaseInvoiceQty], ',', '.') AS decimal(18,2))) AS [PurchaseInvoiceQty]
    ,[UoM]
    ,IIF(CONVERT(decimal(18,2), REPLACE([TotalMiscChrg], ',', '.')) = CONVERT(decimal(18,2), REPLACE([UnitPrice], ',', '.')), 0, CONVERT(decimal(18,2), REPLACE([UnitPrice], ',', '.'))) AS [UnitPrice] -- miscchrg is at header lever, this way it doesn't calc twice in our measure when inklude miscchrg options
    ,REPLACE([DiscountPercent], ',', '.') AS [DiscountPercent]
    ,REPLACE([DiscountAmount], ',', '.') AS [DiscountAmount]
    ,REPLACE([TotalMiscChrg], ',', '.') AS [TotalMiscChrg]
    ,REPLACE([VATAmount], ',', '.') AS [VATAmount]
    ,REPLACE([ExchangeRate], ',', '.') [ExchangeRate]
	,[Currency]
    ,[CreditMemo]
    ,[PurchaserName]
    ,[PurchaseChannel]
    ,[PIRes1]
    ,[PIRes2]
    ,[PIRes3]
    ,[Comment]
FROM [stage].[CYE_ES_PurchaseInvoice]
GO
