IF OBJECT_ID('[dnb].[sp_DnBCustomerAndSupplier]') IS NOT NULL
	DROP PROCEDURE [dnb].[sp_DnBCustomerAndSupplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [dnb].[sp_DnBCustomerAndSupplier]
AS
-- Start of procedure

BEGIN TRY
	
	DECLARE @transaction_name nvarchar(500);

	--0) Truncate stage table

	SET @transaction_name = 'Truncate stage.DnBCustomerAndSupplier.'

	BEGIN TRAN @transaction_name;

	TRUNCATE TABLE stage.DnBCustomerAndSupplier;

	COMMIT TRAN @transaction_name;

	--1) Insert values into stage table stage.DnBCustomerAndSupplier

	SET @transaction_name = 'INSERT INTO stage.DnBCustomerAndSupplier.'

	BEGIN TRAN @transaction_name;

	with baseline as (

		select CustomerID as ID, max(SalesOrderDate) as lastDateDetected, 'salesOrder' as sourceTable, 1 as is_customer--, rank()over(partition by CustomerID order by salesorderdate desc) as rn
		from dw.SalesOrder
		group by CustomerID

		UNION 

		select CustomerID as ID, max(SalesInvoiceDate) as lastDateDetected, 'salesInvoice' as sourceTable, 1 as is_customer--, rank()over(partition by CustomerID order by salesorderdate desc) as rn
		from dw.SalesInvoice
		group by CustomerID

		UNION 
	
		select CustomerID as ID, max(SalesDueDate) as lastDateDetected, 'salesLedger' as sourceTable, 1 as is_customer--, rank()over(partition by CustomerID order by salesorderdate desc) as rn
		from dw.SalesLedger
		group by CustomerID

		UNION 
	
		select SupplierID as ID, max(PurchaseOrderDate) as lastDateDetected, 'purchaseOrder' as sourceTable, 0 as is_customer--, rank()over(partition by CustomerID order by salesorderdate desc) as rn
		from dw.PurchaseOrder
		group by SupplierID

		UNION 
	
		select SupplierID as ID, max(PurchaseInvoiceDate) as lastDateDetected, 'purchaseInvoice' as sourceTable, 0 as is_customer--, rank()over(partition by CustomerID order by salesorderdate desc) as rn
		from dw.PurchaseInvoice
		group by SupplierID

		UNION 
	
		select SupplierID as ID, max(PurchaseDueDate) as lastDateDetected, 'purchaseOrder' as sourceTable, 0 as is_customer--, rank()over(partition by CustomerID order by salesorderdate desc) as rn
		from dw.PurchaseLedger 

		group by SupplierID
	), grouped_ids as (
	select id, MAX(lastDateDetected) as lastDateDetected, is_customer
	from baseline
	group by id, is_customer )

		INSERT INTO stage.DnBCustomerAndSupplier (
		PartitionKey     ,
		dw_id                    ,
		BusinessName1            ,
		BusinessName2			 ,
		VisitStreetAddress		 ,
		MailStreetAddress		 ,
		VisitPostalCode			 ,
		ProvinceName			 ,
		CountryCode				 ,
		TelephoneNumber			 ,
		LocalRegistrationNumber	 ,
		Email					 ,
		is_customer              ,
		lastDateDetected		 ,
		--Num						 ,
		Company
		) 

	select 
		case when grouped_ids.is_customer = 1 then nullif(trim(customer.PartitionKey),'')
			 when grouped_ids.is_customer = 0 then nullif(trim(supplier.PartitionKey),'')
			 else null end as PartitionKey,
		grouped_ids.ID AS dw_id,
		case when grouped_ids.is_customer = 1 then nullif(trim(customer.CustomerName),'')
			 when grouped_ids.is_customer = 0 then nullif(trim(supplier.SupplierName),'')
			 else null end as BusinessName1,
		case when grouped_ids.is_customer = 1 then nullif(trim(customer.MainCustomerName),'') 
			 when grouped_ids.is_customer = 0 then nullif(trim(supplier.MainSupplierName),'')
			 else null end as BusinessName2,
		case when grouped_ids.is_customer = 1 then nullif(trim(isnull(nullif(trim(customer.AddressLine),''),customer.AddressLine1)),'')   -- I can change it to full address line
			 when grouped_ids.is_customer = 0 then nullif(trim(isnull(nullif(trim(supplier.AddressLine),''),supplier.AddressLine1)),'')	-- I can change it to full address line
			 else null end as VisitStreetAddress,
		case when grouped_ids.is_customer = 1 then nullif(trim(customer.AddressLine2),'')   
			 when grouped_ids.is_customer = 0 then nullif(trim(supplier.AddressLine2),'')
			 else null end as MailStreetAddress,
		case when grouped_ids.is_customer = 1 then nullif(trim(customer.ZipCode),'')   
			 when grouped_ids.is_customer = 0 then nullif(trim(supplier.ZipCode),'')
			 else null end as VisitPostalCode, -- Could be MailPostalCode as well
		--MailPostalCode
		--VisitCityName
		--MailCityName
		case when grouped_ids.is_customer = 1 then nullif(trim(customer.City),'')  
			 when grouped_ids.is_customer = 0 then nullif(trim(supplier.City),'')	
			 else null end as ProvinceName,
		case when grouped_ids.is_customer = 1 then nullif(trim(customer.CountryCode),'')
			 when grouped_ids.is_customer = 0 then nullif(trim(supplier.CountryCode),'')	
			 else null end as CountryCode,
		case when grouped_ids.is_customer = 1 then nullif(trim(customer.TelephoneNum1),'') 
			 when grouped_ids.is_customer = 0 then nullif(trim(supplier.TelephoneNum ),'')
			 else null end as TelephoneNumber,
		--Fax Number
		case when grouped_ids.is_customer = 1 then nullif(trim(isnull(nullif(trim(customer.OrganizationNum),''),customer.VATNum)),'')
			 when grouped_ids.is_customer = 0 then nullif(trim(isnull(nullif(trim(supplier.OrganizationNum),''),supplier.VATNum)),'')
			 else null end as LocalRegistrationNumber,
		case when grouped_ids.is_customer = 1 then nullif(trim(customer.Email),'')
			 when grouped_ids.is_customer = 0 then nullif(trim(supplier.Email),'')
			 else null end as Email,
		--Url
		--Revenue or Purchase amount
		--Must Match Indicator ? What's the meaning
		grouped_ids.is_customer,
		grouped_ids.lastDateDetected
		--,case when grouped_ids.is_customer = 1 then customer.CustomerNum
		--	else supplier.SupplierNum
		--end as Num
		,case when grouped_ids.is_customer = 1 then customer.Company
			else supplier.Company
		end as Company
		--,CAST(grouped_ids.id as bigint) as id_bigint
	from grouped_ids
	left join dw.Customer as customer on grouped_ids.ID = customer.CustomerID and grouped_ids.is_customer = 1
	left join dw.Supplier as supplier on grouped_ids.ID = supplier.SupplierID and grouped_ids.is_customer = 0
	--left join dw.DnBCustomerAndSupplier as dnb on grouped_ids.ID = dnb.dw_id
	-- We need to avoid inferred or deleted records
	where 
	((
		customer.is_inferred = 0 or customer.is_inferred is null 
		--and
		--customer.is_deleted = 0 or customer.is_deleted is null
	)
	or
	(
		supplier.is_inferred = 0 or supplier.is_inferred is null 
		--and
		--supplier.is_deleted = 0 or supplier.is_deleted is null
	)) and (customer.is_deleted = 0 or supplier.is_deleted = 0)
	and (customer.Company != 'DEMO' or supplier.Company != 'DEMO')
	;  -- Quiere decir que no es inferred

	COMMIT TRAN @transaction_name;

	--2) Merge with target table dnb.DnBCustomerAndSupplier

	SET @transaction_name = 'MERGE stage.DnBCustomerAndSupplier INTO dnb.DnBCustomerAndSupplier.'

	BEGIN TRAN @transaction_name;

	MERGE dnb.DnBCustomerAndSupplier as target
	using stage.[DnBCustomerAndSupplier] as source
		on target.dw_id = source.dw_id and target.is_customer = source.is_customer
	WHEN NOT MATCHED BY target THEN 
		INSERT (
		[PartitionKey]				,
		[dw_id]						,
		[BusinessName1]				,
		[BusinessName2]				,
		[VisitStreetAddress]		,
		[MailStreetAddress]			,
		[VisitPostalCode]			,
		[ProvinceName]				,
		[CountryCode]				,
		[TelephoneNumber]			,
		[LocalRegistrationNumber]	,
		[Email]						,
		[is_customer]				,
		[lastDateDetected]			,
		--Num						,
		Company
		)
		VALUES (
		source.[PartitionKey]				,	
		source.[dw_id]						,	
		source.[BusinessName1]				,	
		source.[BusinessName2]				,	
		source.[VisitStreetAddress]			,
		source.[MailStreetAddress]			,	
		source.[VisitPostalCode]			,
		source.[ProvinceName]				,	
		UPPER(source.[CountryCode])			,
		source.[TelephoneNumber]			,
		source.[LocalRegistrationNumber]	,
		source.[Email]						,	
		source.[is_customer]				,
		source.[lastDateDetected]			,
		--source.Num						,
		source.Company
		)
	WHEN MATCHED 
	AND (
			(source.PartitionKey > target.PartitionKey and target.duns is null) 
			OR
			(target.DUNS IS NULL AND NOT
				(
				isnull(cast(convert(VARCHAR(200),target.VisitStreetAddress) COLLATE SQL_Latin1_General_CP1_CI_AS as varchar(max)), '' ) = isnull(cast(convert(NVARCHAR(200),source.VisitStreetAddress) COLLATE SQL_Latin1_General_CP1_CI_AS as varchar(max)), '' )  And
				isnull(cast(convert(VARCHAR(100),target.LocalRegistrationNumber) COLLATE SQL_Latin1_General_CP1_CI_AS as varchar(max)), '' ) = isnull(cast(convert(NVARCHAR(50),source.LocalRegistrationNumber) COLLATE SQL_Latin1_General_CP1_CI_AS as varchar(max)), '' )
				)
			)
		)
	THEN
	/*
	Can add more conditions here in further time. For example to exclude those records
	that have duns and the confidence is over 10
	*/
		UPDATE SET
		PartitionKey = case when target.PartitionKey < source.PartitionKey then source.PartitionKey else CONVERT(varchar(19), GETDATE(), 120)  end,
		[BusinessName1]				= source.[BusinessName1]				  ,
		[BusinessName2]				= source.[BusinessName2]				  ,
		[VisitStreetAddress]		= source.[VisitStreetAddress]			  ,
		[MailStreetAddress]			= source.[MailStreetAddress]			  ,
		[VisitPostalCode]			= source.[VisitPostalCode]				  ,
		[ProvinceName]				= source.[ProvinceName]					  ,
		[CountryCode]				= UPPER(source.[CountryCode])			  ,
		[TelephoneNumber]			= source.[TelephoneNumber]				  ,
		[LocalRegistrationNumber]	= source.[LocalRegistrationNumber]		  ,
		[Email]						= source.[Email]						  ,
		Company						= source.Company
		
		;
		;

	COMMIT TRAN @transaction_name;
	
	/* 3) Update dnb.DnBCustomerAndSupplier
	There are some samples that are not coming in the stage, but are already in the dnb.dnbCustomerAndSupplier table
	We need then to check if those ones have had a change
	*/
	
	SET @transaction_name = 'Include not coming ones'

	BEGIN TRAN @transaction_name;

		with agregados_que_no_vienen as (
		select  target.dw_id, target.is_customer, target.PartitionKey, target.Company
		from dnb.DnBCustomerAndSupplier as target
		left join stage.DnBCustomerAndSupplier as source
			on target.dw_id = source.dw_id
				and target.is_customer = source.is_customer
		where source.dw_id is null and target.DUNS is null
		), stage as (

		select c.PartitionKey as new_pk
		, c.CustomerID as dw_id
		, c.CustomerName as BusinessName1
		, c.MainCustomerName as BusinessName2
		, nullif(trim(isnull(nullif(trim(c.AddressLine),''),c.AddressLine1)),'') as VisitStreetAddress
		, nullif(trim(c.AddressLine2),'') as MailStreetAddress
		, nullif(trim(c.ZipCode),'') as VisitPostalCode
		, nullif(trim(c.City),'') as ProvinceName
		, nullif(trim(c.CountryCode),'') as CountryCode
		, nullif(trim(c.TelephoneNum1),'') as TelephoneNumber
		, nullif(trim(isnull(nullif(trim(c.OrganizationNum),''),c.VATNum)),'') as LocalRegistrationNumber
		, nullif(trim(c.Email),'') as Email
		, anv.is_customer
		, c.Company
		from dw.Customer as c
		INNER JOIN agregados_que_no_vienen as anv
			on c.CustomerID = anv.dw_id
				and anv.is_customer = 1
				and c.Company = anv.Company
		WHERE c.is_deleted = 0

		union

		select s.PartitionKey as new_pk
		, s.SupplierID as dw_id
		, s.SupplierName as BusinessName1
		, s.MainSupplierName as BusinessName2
		, nullif(trim(isnull(nullif(trim(s.AddressLine),''),s.AddressLine1)),'') as VisitStreetAddress
		, nullif(trim(s.AddressLine2),'') as MailStreetAddress
		, nullif(trim(s.ZipCode),'') as VisitPostalCode
		, nullif(trim(s.City),'') as ProvinceName
		, nullif(trim(s.CountryCode),'') as CountryCode
		, nullif(trim(s.TelephoneNum),'') as TelephoneNumber
		, nullif(trim(isnull(nullif(trim(s.OrganizationNum),''),s.VATNum)),'') as LocalRegistrationNumber
		, nullif(trim(s.Email),'') as Email
		, anv.is_customer
		, s.Company
		from dw.Supplier as s
		INNER JOIN agregados_que_no_vienen as anv
			on s.SupplierID = anv.dw_id
			and anv.is_customer = 0
			and s.Company = anv.Company
		WHERE s.is_deleted = 0
		)
		MERGE dnb.DnBCustomerAndSupplier as target
		using stage as source
		on target.dw_id = source.dw_id and target.is_customer = source.is_customer and target.company = source.Company
		WHEN MATCHED AND source.new_pk > target.PartitionKey
		THEN
			UPDATE SET
				PartitionKey = source.new_pk,
				[BusinessName1]				= source.[BusinessName1]				  ,
				[BusinessName2]				= source.[BusinessName2]				  ,
				[VisitStreetAddress]		= source.[VisitStreetAddress]			  ,
				[MailStreetAddress]			= source.[MailStreetAddress]			  ,
				[VisitPostalCode]			= source.[VisitPostalCode]				  ,
				[ProvinceName]				= source.[ProvinceName]					  ,
				[CountryCode]				= UPPER(source.[CountryCode])			  ,
				[TelephoneNumber]			= source.[TelephoneNumber]				  ,
				[LocalRegistrationNumber]	= source.[LocalRegistrationNumber]		  ,
				[Email]						= source.[Email]						  ,
				Company						= source.Company
		;

	COMMIT TRAN @transaction_name;

	--4) Delete records that will never match since they are not coming anymore from source

	
	SET @transaction_name = 'Delete deleted unmatched records'

	BEGIN TRAN @transaction_name;

	with deleted as (
	select CustomerID as dw_id, 1 as is_customer
	from dw.Customer
	where is_deleted = 1
	union 
	select SupplierID as dw_id, 0 as is_customer
	from dw.Supplier
	where is_deleted = 1
	)
	delete dnb
	from dnb.DnBCustomerAndSupplier as dnb
		INNER JOIN deleted as d
			on dnb.dw_id = d.dw_id
				and dnb.is_customer = d.is_customer
	WHERE DUNS is null;

	COMMIT TRAN @transaction_name;


	--5) Update PartitionKey

	SET @transaction_name = 'Update PartitionKey'

	BEGIN TRAN @transaction_name;

	UPDATE dnb.DnBCustomerAndSupplier
		set PartitionKey = left(REPLACE(PartitionKey,'T',' '),CHARINDEX('.',PartitionKey)-1)
	where LEN(PartitionKey) > 19;

	COMMIT TRAN @transaction_name;
	-- Finish of procedure

END TRY

BEGIN CATCH

	IF @@TRANCOUNT > 0
		ROLLBACK;

	DECLARE @CompleteErrorMessage VARCHAR(MAX);
	SET @CompleteErrorMessage = CONCAT('Transaction: ',@transaction_name,' Error message: ',ERROR_MESSAGE())
	RAISERROR(@CompleteErrorMessage,16,1);

END CATCH
GO
