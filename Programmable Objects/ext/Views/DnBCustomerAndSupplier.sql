IF OBJECT_ID('[ext].[DnBCustomerAndSupplier]') IS NOT NULL
	DROP VIEW [ext].[DnBCustomerAndSupplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [ext].[DnBCustomerAndSupplier] AS

SELECT [PartitionKey], [dw_id], [is_customer], [DUNS], [BusinessName1], [BusinessName2], [VisitStreetAddress], [MailStreetAddress], [VisitPostalCode], [ProvinceName], [CountryCode], [TelephoneNumber], [LocalRegistrationNumber], [Email], [lastDateDetected], [sent_date], [match_date], [enrich_date], [last_modified_date], [confidence_code], [is_monitored], [monitor_date], [Company], [match_status], [enrich_status], [error_detail], [manual_date], [monitor_status]
FROM dnb.DnBCustomerAndSupplier
GO
