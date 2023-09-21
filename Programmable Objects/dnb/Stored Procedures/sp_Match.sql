IF OBJECT_ID('[dnb].[sp_Match]') IS NOT NULL
	DROP PROCEDURE [dnb].[sp_Match];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dnb].[sp_Match] @DUNS int, @confidence_code int, @dw_id_bigint bigint, @is_customer bit as


	UPDATE dnb.DnBCustomerAndSupplier
	SET DUNS = @DUNS,
	confidence_code = @confidence_code,
	sent_date = GETDATE(),
	match_date = GETDATE()
	WHERE CONVERT(bigint, dw_id) = @dw_id_bigint
	AND is_customer = @is_customer;
GO
