IF OBJECT_ID('[dbo].[DimSupplierAgreement2nd]') IS NOT NULL
	DROP VIEW [dbo].[DimSupplierAgreement2nd];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[DimSupplierAgreement2nd] AS
-- dummy [dbo].[DimSupplierAgreement2nd] because of SPL model has and needs it!
----------------------------------- Supplier Agreements File --------------------------------------

SELECT 
    '' AS CompanyID -- dummy [dbo].[DimSupplierAgreement2nd] because of SPL model has and needs it!
	,'' AS [Company] -- dummy [dbo].[DimSupplierAgreement2nd] because of SPL model has and needs it!
    ,'' AS [PartNum] -- dummy [dbo].[DimSupplierAgreement2nd] because of SPL model has and needs it!
	,'' AS [Supplier] -- dummy [dbo].[DimSupplierAgreement2nd] because of SPL model has and needs it!
	,'' AS [SupplierNum] -- dummy [dbo].[DimSupplierAgreement2nd] because of SPL model has and needs it!
FROM 
	[dw].[SupplierAgreement]
WHERE Company = '' -- dummy [dbo].[DimSupplierAgreement2nd] because of SPL model has and needs it!
GO
