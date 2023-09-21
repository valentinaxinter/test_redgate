IF OBJECT_ID('[stage].[vMEN_NL_PurchaseInvoice]') IS NOT NULL
	DROP VIEW [stage].[vMEN_NL_PurchaseInvoice];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vMEN_NL_PurchaseInvoice] AS
WITH CTE AS (
SELECT CASE WHEN Company = '14' THEN  CONCAT(N'MENBE',Company) 
			ELSE  CONCAT(N'MENNL',Company)  END AS CompanyCode		--Doing this to have the company code in nvarchar and don't need to repeat CAST(CONCAT('MEN-',Company) AS nvarchar(50)) everywhere /SM
	  ,[PartitionKey], [Company], [ID], [Period], [SysDate], [SysTime], [SupplierCode], [InvoiceNumber], [InvoiceLine], [InvoiceDate], [PurchaseOrderNumber], [PurchaseOrderLine], [PartNum], [Quantity], [CurrencyCode], [Price], [Amount], [CrediteurKey], [ProductKey], [DW_TimeStamp]
  FROM [stage].[MEN_NL_PurchaseInvoice] --where  [InvoiceNumber] IN ('221312703155771', '9675424')
  )


SELECT 
	--ADD TRIM() UPPER() INTO WarehouseID 23-01-12 VA
	--ADD TRIM() INTO SupplierID 23-01-24 VA
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CompanyCode, ID))) AS PurchaseInvoiceID --'#', PurchaseOrderType 
	,CONCAT(CompanyCode,'#',InvoiceNumber, '#',InvoiceLine) AS PurchaseInvoiceCode
	,CONCAT(CompanyCode,'#',PurchaseOrderNumber) AS PurchaseOrderNumCode
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode, '#', PurchaseOrderNumber))) AS PurchaseOrderNumID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',PurchaseOrderNumber,'#',PurchaseOrderLine))) AS PurchaseOrderID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(CompanyCode),'#',TRIM([SupplierCode]))))) AS SupplierID  --previous CONCAT(CompanyCode,'#',CrediteurKey)))
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',UPPER(TRIM([SupplierCode]))))) AS SupplierID  --previous CONCAT(CompanyCode,'#',CrediteurKey)))
    ,CONVERT([binary](32),HASHBYTES('SHA2_256',CompanyCode))	AS CompanyID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#',PartNum)))	AS PartID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(CompanyCode),'#',''))))					AS WarehouseID
	--,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#','')))					AS WarehouseID
--	,CONVERT(int, replace(InvoiceDate,'-','')) AS PurchaseInvoiceDateID
	,CONVERT(int, REPLACE([InvoiceDate],'-','')) AS PurchaseInvoiceDateID
	,CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(CompanyCode,'#', SupplierCode, '#', InvoiceNumber,'#',PurchaseOrderNumber))) AS PurchaseLedgerID --match PurchaseLedgerID in [vSCM_FI_PurchaseLedger]
	,CONCAT(CompanyCode,'#',SupplierCode,'#',PurchaseOrderNumber) AS PurchaseOrderCode
	  ,[PartitionKey]

      ,[CompanyCode]				AS Company	
	  ,[PurchaseOrderNumber]		AS PurchaseOrderNum
      ,[PurchaseOrderLine]			
	  ,NULL							AS PurchaseOrderSubLine
	  ,NULL							AS PurchaseOrderType	
      ,[InvoiceNumber]				AS PurchaseInvoiceNum
      ,[InvoiceLine]				AS PurchaseInvoiceLine
	  ,NULL							AS PurchaseInvoiceType
	  ,[InvoiceDate]				AS PurchaseInvoiceDate
--	  ,SysDate						AS PurchaseInvoiceDate
      ,'1900-01-01'					AS ActualDelivDate
	  ,UPPER([SupplierCode])		AS SupplierNum
      ,[PartNum]
      ,[Quantity]					AS PurchaseInvoiceQty
	  ,NULL							AS UoM
      ,[Price]						AS UnitPrice
	  ,NULL							AS DiscountPercent
	  ,0							AS DiscountAmount
	  ,NULL							AS TotalMiscChrg
	  ,NULL							AS VATAmount
	  ,COALESCE(UPPER([CurrencyCode]),'EUR')		AS Currency
      ,1							AS ExchangeRate
      ,NULL							AS CreditMemo
	  ,NULL							AS PurchaserName
	  ,NULL							AS WarehouseCode
	  ,NULL							AS PurchaseChannel
--    ,[Amount]
	  ,NULL							AS Comment
	  ,NULL							AS PIRes1
	  ,NULL							AS PIRes2
	  ,NULL							AS PIRes3
  FROM CTE
 --WHERE CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT(CompanyCode, ID))) NOT IN (0xFFCC77044BD9E4089468F961AF97EFF33DC5E2E9D3808BB4CC24657749E11FB1/*2020-01-17*/, 0x9F040B22308B210E1EB5D9C0342438E1C95B3A36962BC42EDCD8686CB8197B0F/*2022-04-29*/) 
  --ORDER BY PurchaseInvoiceDate
GO
