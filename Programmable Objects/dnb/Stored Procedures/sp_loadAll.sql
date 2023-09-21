IF OBJECT_ID('[dnb].[sp_loadAll]') IS NOT NULL
	DROP PROCEDURE [dnb].[sp_loadAll];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dnb].[sp_loadAll] 
	@process nvarchar(40) = NULL,
	@monitor_partitionKey nvarchar(14) = NULL
as

-- Relationship
begin try
	
	DECLARE @ds_bloque NVARCHAR(80);
    SET @ds_bloque = 'Refrescamos dnb.dnbCustomerAndSupplier';
	DECLARE @enrich_date datetime = getdate();

	BEGIN TRAN @ds_bloque;
		
		-- Updateamos los que tuvieron exito y su conf_code >= 9
		update dnb 
		set
			duns =				NULLIF(rel.duns							,''),	
			confidence_code =	NULLIF(rel.[organization.confidenceCode],''),
			match_status =		NULLIF(rel.match_status					,''),
			enrich_status =		NULLIF(rel.enrich_status				,''),
			error_detail =		NULLIF(rel.error_detail					,''),
			enrich_date =		@enrich_date						,
			match_date =		@enrich_date
		from dnb.DnBCustomerAndSupplier as dnb
		inner join stage.Relationship as rel
			on CAST(left(rel.customerReference,len(rel.customerReference)-2) as bigint) = CAST(dnb.dw_id as bigint)
			and dnb.is_customer = CAST(right(rel.customerReference,1) as bit)
		where rel.[organization.confidenceCode] >= 9 and rel.duns is not null ;

		-- All the ones without a match success, will have a match status and null in confidence code
		update dnb 
		set
			duns =					NULLIF(rel.duns							,''),
			confidence_code =		NULLIF(rel.[organization.confidenceCode],''),
			match_status =			NULLIF(rel.match_status					,''),
			enrich_status =			NULLIF(rel.enrich_status				,''),
			error_detail =			NULLIF(rel.error_detail					,'')
		from dnb.DnBCustomerAndSupplier as dnb
		inner join stage.Relationship as rel
			on CAST(left(rel.customerReference,len(rel.customerReference)-2) as bigint) = CAST(dnb.dw_id as bigint)
			and dnb.is_customer = CAST(right(rel.customerReference,1) as bit)
		where (rel.[organization.confidenceCode] is null);

		update dnb 
		set
			duns =				NULLIF(rel.duns							,''),
			confidence_code =	NULLIF(rel.[organization.confidenceCode],''),
			-- Here I'm not updating the status because i don't want to consider success when
			-- the code is below 9
			-- match_status = rel.match_status,   
			-- enrich_status = rel.enrich_status,
			error_detail = NULLIF(rel.error_detail,'')
		from dnb.DnBCustomerAndSupplier as dnb
		inner join stage.Relationship as rel
			on CAST(left(rel.customerReference,len(rel.customerReference)-2) as bigint) = CAST(dnb.dw_id as bigint)
			and dnb.is_customer = CAST(right(rel.customerReference,1) as bit)
		where (rel.[organization.confidenceCode] < 9);

		IF @process = 'monitor' and @process IS NOT NULL
		BEGIN
			UPDATE dnb
			SET dnb.last_modified_date = CONVERT(datetime, LEFT(@monitor_partitionKey, 8) + ' ' + SUBSTRING(@monitor_partitionKey, 9, 2) + ':' + SUBSTRING(@monitor_partitionKey, 11, 2) + ':' + SUBSTRING(@monitor_partitionKey, 13, 2), 120)
			, dnb.is_monitored = 1
			FROM dnb.DnBCustomerAndSupplier AS dnb 
			INNER JOIN stage.MasterTable as stage
				ON dnb.DUNS = stage.duns
			WHERE dnb.DUNS IS NOT NULL;
		END

	COMMIT TRAN @ds_bloque;

	-- MatchComponents
	SET @ds_bloque = 'Refrescamos dnb.MatchComponents';
	BEGIN TRAN @ds_bloque;

	WITH temporal AS 
	(
	select DISTINCT customerReference
	from stage.MatchComponents
	)
	delete matchComp
	from dnb.MatchComponents as matchComp
	inner join temporal as t
		on matchComp.customerReference = t.customerReference;

	INSERT INTO dnb.MatchComponents (
	  [customerReference]
	, [matchCandidates.matchQualityInformation.matchGradeComponents.componentType]  
	, [matchCandidates.matchQualityInformation.matchGradeComponents.componentRating]
	)
	SELECT 
	  NULLIF([customerReference]														   ,'')
	, NULLIF([matchCandidates.matchQualityInformation.matchGradeComponents.componentType]  ,'')
	, NULLIF([matchCandidates.matchQualityInformation.matchGradeComponents.componentRating],'')
	FROM stage.MatchComponents;

	COMMIT TRAN @ds_bloque;

	-- MasterTable
	SET @ds_bloque = 'Refrescamos dnb.MasterTable';
	BEGIN TRAN @ds_bloque;

		Merge dnb.MasterTable as target
		USING stage.MasterTable as source
		ON cast(target.duns as int) = cast(source.duns as int)
		WHEN NOT MATCHED BY target THEN
			INSERT (
			[duns],
			[organization.controlOwnershipDate],
			[organization.controlOwnershipType.description],
			[organization.corporateLinkage.domesticUltimate.duns] ,
			[organization.corporateLinkage.domesticUltimate.primaryName] ,
			[organization.corporateLinkage.globalUltimate.duns],
			[organization.corporateLinkage.globalUltimate.primaryName] ,
			[organization.corporateLinkage.parent.duns],
			[organization.corporateLinkage.parent.primaryName],
			[organization.legalForm.description],
			[organization.legalForm.startDate],
			[organization.primaryName],
			[organization.registeredDetails.legalForm.description],
			[organization.registeredName],
			[organization.corporateLinkage.headQuarter.duns],
			[organization.corporateLinkage.headQuarter.primaryName],
			[organization.legalForm.registrationLocation.addressRegion],
			[organization.primaryAddress] 								,
			[organization.primaryAddress.addressCountry.name] 			,
			[organization.primaryAddress.addressCounty.name] 			,
			[organization.primaryAddress.addressLocality.name]			,
			[organization.primaryAddress.addressRegion.name]			,
			[organization.primaryAddress.continentalRegion.name]		,
			[organization.primaryAddress.latitude] 						,
			[organization.primaryAddress.longitude] 					,
			[organization.primaryAddress.postalCode]					,
			[organization.corporateLinkage.hierarchyLevel]				,
			[organization.corporateLinkage.role]						,
			[organization.isStandalone]									,
			[organization.dunsControlStatus.operatingStatus.description]
			)
			VALUES(
			NULLIF(source.[duns]										 ,'')			,
			NULLIF(source.[organization.controlOwnershipDate]			 ,'')			,
			NULLIF(source.[organization.controlOwnershipType.description],'')			,
			case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.domesticUltimate.duns] is null			then nullif(source.[duns]					 ,'')	else nullif(source.[organization.corporateLinkage.domesticUltimate.duns]		,'')	end ,
			case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.domesticUltimate.primaryName] is null	then nullif(source.[organization.primaryName],'')	else nullif(source.[organization.corporateLinkage.domesticUltimate.primaryName]	,'')	end ,
			case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.globalUltimate.duns]			is null		then nullif(source.[duns]					,''	)	else nullif(source.[organization.corporateLinkage.globalUltimate.duns]			,'')	end,
			case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.globalUltimate.primaryName]	is null		then nullif(source.[organization.primaryName],'')	else nullif(source.[organization.corporateLinkage.globalUltimate.primaryName]	,'')	end ,
			case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.parent.duns]					is null		then nullif(source.[duns]					,''	)	else nullif(source.[organization.corporateLinkage.parent.duns]					,'')	end,
			case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.parent.primaryName]			is null		then nullif(source.[organization.primaryName],'')	else nullif(source.[organization.corporateLinkage.parent.primaryName]			,'')	end,
			nullif(source.[organization.legalForm.description]					,'')		,
			nullif(source.[organization.legalForm.startDate]					,'')		,
			nullif(source.[organization.primaryName]							,'')		,
			nullif(source.[organization.registeredDetails.legalForm.description],'')		,
			nullif(source.[organization.registeredName]							,'')	,
			case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.headQuarter.duns]		is null then nullif(source.[duns]					 ,'')	else nullif(source.[organization.corporateLinkage.headQuarter.duns]		  ,'')	end,
			case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.headQuarter.primaryName]	is null then nullif(source.[organization.primaryName],'')	else nullif(source.[organization.corporateLinkage.headQuarter.primaryName],'') end,
			nullif(source.[organization.legalForm.registrationLocation.addressRegion]		,''),
			nullif(source.[organization.primaryAddress] 									,''),
			nullif(source.[organization.primaryAddress.addressCountry.name] 				,''),
			nullif(source.[organization.primaryAddress.addressCounty.name] 					,''),
			nullif(source.[organization.primaryAddress.addressLocality.name]				,''),
			nullif(source.[organization.primaryAddress.addressRegion.name]					,''),
			nullif(source.[organization.primaryAddress.continentalRegion.name]				,''),
			nullif(source.[organization.primaryAddress.latitude] 							,''),
			nullif(source.[organization.primaryAddress.longitude] 							,''),
			nullif(source.[organization.primaryAddress.postalCode]							,''),
			nullif(source.[organization.corporateLinkage.hierarchyLevel]					,''),
			nullif(source.[organization.corporateLinkage.role]								,''),
			nullif(source.[organization.isStandalone]										,''),
			nullif(source.[organization.dunsControlStatus.operatingStatus.description]		,'')
			)

		WHEN MATCHED THEN UPDATE SET
			target.[organization.controlOwnershipDate]								= nullif(source.[organization.controlOwnershipDate]				,''),
			target.[organization.controlOwnershipType.description]					= nullif(source.[organization.controlOwnershipType.description]	,''),
			target.[organization.corporateLinkage.domesticUltimate.duns] 			= (case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.domesticUltimate.duns]		is null then nullif(source.[duns]						,'') else nullif(source.[organization.corporateLinkage.domesticUltimate.duns]			,'') end),
			target.[organization.corporateLinkage.domesticUltimate.primaryName] 	= (case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.domesticUltimate.primaryName] is null then nullif(source.[organization.primaryName]	,'') else nullif(source.[organization.corporateLinkage.domesticUltimate.primaryName]	,'') end),
			target.[organization.corporateLinkage.globalUltimate.duns]				= (case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.globalUltimate.duns]			is null then nullif(source.[duns]						,'') else nullif(source.[organization.corporateLinkage.globalUltimate.duns]				,'') end),
			target.[organization.corporateLinkage.globalUltimate.primaryName] 		= (case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.globalUltimate.primaryName]	is null then nullif(source.[organization.primaryName]	,'') else nullif(source.[organization.corporateLinkage.globalUltimate.primaryName]		,'') end),
			target.[organization.corporateLinkage.parent.duns]						= (case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.parent.duns]					is null then nullif(source.[duns]						,'') else nullif(source.[organization.corporateLinkage.parent.duns]						,'') end),
			target.[organization.corporateLinkage.parent.primaryName]				= (case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.parent.primaryName]			is null then nullif(source.[organization.primaryName]	,'') else nullif(source.[organization.corporateLinkage.parent.primaryName]				,'') end),
			target.[organization.legalForm.description]								= nullif(source.[organization.legalForm.description]					,''),
			target.[organization.legalForm.startDate]								= nullif(source.[organization.legalForm.startDate]						,''),
			target.[organization.primaryName]										= nullif(source.[organization.primaryName]								,''),
			target.[organization.registeredDetails.legalForm.description]			= nullif(source.[organization.registeredDetails.legalForm.description]	,''),
			target.[organization.registeredName]									= nullif(source.[organization.registeredName],''),	
			target.[organization.corporateLinkage.headQuarter.duns]					= (case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.headQuarter.duns]			is null then nullif(source.[duns]						,'') else nullif(source.[organization.corporateLinkage.headQuarter.duns]		,'') end),
			target.[organization.corporateLinkage.headQuarter.primaryName]			= (case when source.[organization.isStandalone] = 1 and source.[organization.corporateLinkage.headQuarter.primaryName]	is null then nullif(source.[organization.primaryName]	,'') else nullif(source.[organization.corporateLinkage.headQuarter.primaryName] ,'') end),
			target.[organization.legalForm.registrationLocation.addressRegion]		= nullif(source.[organization.legalForm.registrationLocation.addressRegion],''),
			target.[organization.primaryAddress] 									= nullif(source.[organization.primaryAddress] 							,''),	
			target.[organization.primaryAddress.addressCountry.name] 				= nullif(source.[organization.primaryAddress.addressCountry.name] 		,''),
			target.[organization.primaryAddress.addressCounty.name] 				= nullif(source.[organization.primaryAddress.addressCounty.name] 		,''),
			target.[organization.primaryAddress.addressLocality.name]				= nullif(source.[organization.primaryAddress.addressLocality.name]		,''),
			target.[organization.primaryAddress.addressRegion.name]					= nullif(source.[organization.primaryAddress.addressRegion.name]		,''),
			target.[organization.primaryAddress.continentalRegion.name]				= nullif(source.[organization.primaryAddress.continentalRegion.name]	,''),
			target.[organization.primaryAddress.latitude] 							= nullif(source.[organization.primaryAddress.latitude] 					,''),
			target.[organization.primaryAddress.longitude] 							= nullif(source.[organization.primaryAddress.longitude] 				,''),
			target.[organization.primaryAddress.postalCode] 						= nullif(source.[organization.primaryAddress.postalCode]				,''),
			target.[organization.corporateLinkage.hierarchyLevel]					= nullif(source.[organization.corporateLinkage.hierarchyLevel]			,''),
			target.[organization.corporateLinkage.role]								= (case when source.[organization.corporateLinkage.role] != 'Dummy' then nullif(source.[organization.corporateLinkage.role],'') else nullif(target.[organization.corporateLinkage.role],'') end),
			target.[organization.isStandalone]										= nullif(source.[organization.isStandalone]									,''),
			target.[organization.dunsControlStatus.operatingStatus.description]		= nullif(source.[organization.dunsControlStatus.operatingStatus.description],'')
		;

	COMMIT TRAN @ds_bloque;

	-- IndustryCodes
    SET @ds_bloque = 'Refrescamos IndustryCodes';

	BEGIN TRAN @ds_bloque;

		WITH temporal AS 
		(
		select DISTINCT duns
		from stage.IndustryCodes
		)
		delete indCode
		from dnb.IndustryCodes as indCode
		inner join temporal as t
			on indCode.duns = t.duns;

		INSERT INTO dnb.IndustryCodes (
		duns
		,[organization.industryCodes.code]
		,[organization.industryCodes.description]
		,[organization.industryCodes.typeDescription]
		,[organization.industryCodes.priority]
		,[organization.industryCodes.typeDnBCode]
		)
		SELECT 
		 nullif(duns										,'')
		,nullif([organization.industryCodes.code]			,'')
		,nullif([organization.industryCodes.description]	,'')
		,nullif([organization.industryCodes.typeDescription],'')
		,nullif([organization.industryCodes.priority]		,'')
		,nullif([organization.industryCodes.typeDnBCode]	,'')
		FROM stage.IndustryCodes;

	COMMIT TRAN @ds_bloque;

	-- UnspscCodes
    SET @ds_bloque = 'Refrescamos UnspscCodes';

	BEGIN TRAN @ds_bloque;

		WITH temporal AS 
		(
		select DISTINCT duns
		from stage.UnspscCodes
		)
		delete unspsc
		from dnb.UnspscCodes as unspsc
		inner join temporal as t
			on unspsc.duns = t.duns;

		INSERT INTO dnb.UnspscCodes
		(
		[duns]									,
		[organization.unspscCodes.code]			,
		[organization.unspscCodes.description]	,
		[organization.unspscCodes.priority]		
		)
		SELECT 
		nullif([duns]									,''),
		nullif([organization.unspscCodes.code]			,''),
		nullif([organization.unspscCodes.description]	,''),
		nullif([organization.unspscCodes.priority]		,'')
		FROM stage.UnspscCodes;

	COMMIT TRAN @ds_bloque;

	-- Financials
    SET @ds_bloque = 'Refrescamos Financials';

	BEGIN TRAN @ds_bloque;

		WITH temporal AS 
		(
		select DISTINCT duns
		from stage.Financials
		)
		delete Financials
		from dnb.Financials as Financials
		inner join temporal as t
			on Financials.duns = t.duns;

		INSERT INTO dnb.Financials
		(
		[duns]												,
		[organization.financials.financialStatementToDate]	,
		[organization.financials.yearlyRevenue.value]		,
		[organization.financials.yearlyRevenue.currency]	
		)
		SELECT 
		nullif([duns]												,''),  	
		nullif([organization.financials.financialStatementToDate]	,''),
		nullif([organization.financials.yearlyRevenue.value]		,''),
		nullif([organization.financials.yearlyRevenue.currency]	   	,'')
		FROM stage.Financials;

	COMMIT TRAN @ds_bloque;

	-- FamilyTree
    SET @ds_bloque = 'Refrescamos FamilyTree';

	BEGIN TRAN @ds_bloque;

		WITH temporal AS 
		(
		select DISTINCT duns
		from stage.FamilyTree
		)
		delete FamilyTree
		from dnb.FamilyTree as FamilyTree
		inner join temporal as t
			on FamilyTree.duns = t.duns;

		INSERT INTO dnb.FamilyTree
		(
		[duns]																,
		[organization.corporateLinkage.familytreeRolesPlayed.description]	,
		[organization.corporateLinkage.familytreeRolesPlayed.dnbCode]		
		)
		SELECT 
		nullif([duns]															,'')	,
		nullif([organization.corporateLinkage.familytreeRolesPlayed.description],'')	,
		nullif([organization.corporateLinkage.familytreeRolesPlayed.dnbCode]	,'')	
		FROM stage.FamilyTree;

	COMMIT TRAN @ds_bloque;

	-- NumberOfEmployees
    SET @ds_bloque = 'Refrescamos NumberOfEmployees';

	BEGIN TRAN @ds_bloque;

		WITH temporal AS 
		(
		select DISTINCT duns
		from stage.numberOfEmployees
		)
		delete numberOfEmployees
		from dnb.numberOfEmployees as numberOfEmployees
		inner join temporal as t
			on numberOfEmployees.duns = t.duns;

		INSERT INTO dnb.numberOfEmployees
		(
		[duns]														,
		[organization.numberOfEmployees.informationScopeDescription],
		[organization.numberOfEmployees.value]						
		)
		SELECT 
		nullif([duns]														,''),
		nullif([organization.numberOfEmployees.informationScopeDescription] ,''),
		nullif([organization.numberOfEmployees.value]						,'')
		FROM stage.numberOfEmployees;

	COMMIT TRAN @ds_bloque;

	-- Insert into CoC_DUNS_sign from local signed companies

	SET @ds_bloque = 'Insert DUNS signed'

	BEGIN TRAN @ds_bloque;

	WITH cte AS (
		SELECT DISTINCT dnb.DUNS
		FROM ext.CoC_Local_sign as ls
		LEFT JOIN dnb.DnBCustomerAndSupplier as dnb
			ON ls.dw_id = cast(dnb.dw_id as bigint)
				AND ls.is_customer = dnb.is_customer
		WHERE dnb.DUNS IS NOT NULL
	)
	MERGE INTO ext.CoC_DUNS_sign as target
	USING cte AS source
	ON target.DUNS = source.DUNS
	WHEN NOT MATCHED THEN
		INSERT (DUNS)
		VALUES (source.DUNS);

	COMMIT TRAN @ds_bloque;

	/*
	If we are running the monitor process that means that we have the records that were updated
	so we will update the dnb.DunsInMonitoring table to know the latest changes on each duns
	*/
	IF @process = 'monitor' and @process IS NOT NULL
		BEGIN
			update dnb
				set last_modified_date = CAST(GETDATE() as DATE)
			from dnb.DunsInMonitoring as dnb
			INNER JOIN stage.MasterTable as smt
				on dnb.duns = smt.duns;
	END

end try

begin catch
	IF @@TRANCOUNT > 0
	ROLLBACK;
	DECLARE @ErrorMessage NVARCHAR(4000), @Bloque NVARCHAR(80),@ErrorLine INT;
	SET @Bloque = @ds_bloque;
	SET @ErrorLine = ERROR_LINE();
	SELECT @ErrorMessage = ERROR_MESSAGE();
	RAISERROR('Error en la transacción %s, línea %d: %s',16,1,@Bloque, @ErrorLine, @ErrorMessage);
end catch
GO
