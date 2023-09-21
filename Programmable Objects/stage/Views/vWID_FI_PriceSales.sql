IF OBJECT_ID('[stage].[vWID_FI_PriceSales]') IS NOT NULL
	DROP VIEW [stage].[vWID_FI_PriceSales];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vWID_FI_PriceSales] AS
--COMMENT EMPTY FIELDS / ADD UPPER()TRIM() INTO PartID,CustomerID 2022-12-15 VA
SELECT 
	CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([CustomerNum]), '#', TRIM([PartNum]), '#', 'Sales'))) AS PriceID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [Company])) AS CompanyID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([CustomerNum]))))) AS CustomerID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([CustomerNum])))) AS CustomerID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', ''))) AS SupplierID
	--,CONVERT([binary](32), HASHBYTES('SHA2_256', CONCAT([Company], '#', TRIM([PartNum])))) AS PartID
	,CONVERT([binary](32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM([Company]), '#', TRIM([PartNum]))))) AS PartID
	,CONCAT([Company], '#', TRIM([CustomerNum])) AS CustomerCode
	,CONCAT([Company], '#', '') AS SupplierCode
	,CONCAT([Company], '#', TRIM([PartNum])) AS PartCode
	,PartitionKey

	,[Company]
	,TRIM([CustomerNum]) AS [CustomerNum]
	--,'' AS SupplierNum --it is Widni
	,TRIM([PartNum]) AS [PartNum]
	,[TargetMargin]
	--,'' AS Currency
	,FORMAT(TRY_CONVERT(decimal(18,2), [Price]), '### ### ###.##') AS [Price]
	,FORMAT(TRY_CONVERT(decimal(18,2), [DiscountPercent]), '### ### ###.##') AS [DiscountPercent]
	,ValidFrom AS [ValidFrom]
	,ValidTo AS [ValidTo]
	--,'' AS DelivTime
	--,'' AS DelivTimeUnit
	,FORMAT(TRY_CONVERT(decimal(18,2), [Qty1]), '### ### ###.##') AS [Qty1]
	,FORMAT(TRY_CONVERT(decimal(18,2), [Discount1]), '### ### ###.##') AS [Discount1]
	,FORMAT(TRY_CONVERT(decimal(18,2), [Price1]), '### ### ###.##') AS [Price1]

	,FORMAT(TRY_CONVERT(decimal(18,2), [Qty2]), '### ### ###.##') AS [Qty2]
	,FORMAT(TRY_CONVERT(decimal(18,2), [Discount2]), '### ### ###.##') AS [Discount2]
	,FORMAT(TRY_CONVERT(decimal(18,2), [Price2]), '### ### ###.##') AS [Price2]

	,FORMAT(TRY_CONVERT(decimal(18,2), [Qty3]), '### ### ###.##') AS [Qty3]
	,FORMAT(TRY_CONVERT(decimal(18,2), [Discount3]), '### ### ###.##') AS [Discount3]
	,FORMAT(TRY_CONVERT(decimal(18,2), [Price3]), '### ### ###.##') AS [Price3]

	,FORMAT(TRY_CONVERT(decimal(18,2), [Qty4]), '### ### ###.##') AS [Qty4]
	,FORMAT(TRY_CONVERT(decimal(18,2), [Discount4]), '### ### ###.##') AS [Discount4]
	,FORMAT(TRY_CONVERT(decimal(18,2), [Price4]), '### ### ###.##') AS [Price4]

	,FORMAT(TRY_CONVERT(decimal(18,2), [Qty5]), '### ### ###.##') AS [Qty5]
	,FORMAT(TRY_CONVERT(decimal(18,2), [Discount5]), '### ### ###.##') AS [Discount5]
	,FORMAT(TRY_CONVERT(decimal(18,2), [Price5]), '### ### ###.##') AS [Price5]
	,'Sales' AS PriceType
	,GETDATE() AS CreatedDate
FROM [stage].[WID_FI_PriceSales]
GO
