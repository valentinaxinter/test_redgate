IF OBJECT_ID('[dnb].[DunsHierarchy]') IS NOT NULL
	DROP PROCEDURE [dnb].[DunsHierarchy];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dnb].[DunsHierarchy] 

AS

BEGIN TRY
	DECLARE @ds_bloque NVARCHAR(80);
    

	DECLARE @MergeStatement varchar(max);
	DECLARE @targetTable varchar(100) = 'dnb.dimDUNSHierarchy'
	DECLARE @sourceTable varchar(100) = 'stage.dimDUNSHierarchy'
	DECLARE @ignoreColumns varchar(100) = 'duns'
	DECLARE @columns			VARCHAR(MAX);
	DECLARE @updateColumns		VARCHAR(MAX);
	DECLARE @checkChangeColumns VARCHAR(MAX);
	DECLARE @sourceUnionColumn varchar(50) = 'duns';
	DECLARE @targetUnionColumn varchar(50) = 'duns';
	DECLARE @date varchar(20) = cast(getdate() as date)

	SET @ds_bloque = 'Merge source and target tables';
	BEGIN TRAN @ds_bloque;

		exec meta.GetTableColumnList_test
			@targetTable, 
			@sourceTable,
			@ignoreColumns,
			@ColumnList=        @columns			output,
			@updateList=		@updateColumns		output ,
			@checkForChangeList=@checkChangeColumns output

		SET @MergeStatement = 'MERGE ' + @targetTable + ' as target
								Using ' + @sourceTable + ' as source 
								ON target.' + @targetUnionColumn + ' = source.' + @sourceUnionColumn + CHAR(10) +
								' WHEN MATCHED AND ('
								+ CHAR(10)
								+ ' NOT (' + @checkChangeColumns + '))'
								+ ' THEN UPDATE SET ' + @updateColumns  + ','
								+ CHAR(10)
								+ 'last_modified_date = ''' + @date + ''''
								+ ' WHEN NOT MATCHED BY TARGET THEN'
								+ CHAR(10)
								+ ' INSERT (' + @targetUnionColumn + ',' + @columns + ',last_modified_date)'
								+ ' VALUES (' + @sourceUnionColumn + ',' + @columns + ',''' + @date +''')'
								+ ' WHEN NOT MATCHED BY SOURCE THEN DELETE'
								+ ';' 
		EXEC(@MergeStatement)

	COMMIT TRAN @ds_bloque;

	SET @ds_bloque = 'Update dnb.dimDUNS_Names';
	BEGIN TRAN @ds_bloque;

		with tmp as (
		select distinct duns from dnb.DnBCustomerAndSupplier 
		where last_modified_date = (
		select MAX(last_modified_date)
		from dnb.DnBCustomerAndSupplier)
		)
		, parent as 
		(
		select distinct m.[organization.corporateLinkage.parent.duns] as duns, m.[organization.corporateLinkage.parent.primaryName] as name
		from dnb.MasterTable as m
		INNER JOIN tmp as t
			ON m.duns = t.duns
		group by m.[organization.corporateLinkage.parent.duns], m.[organization.corporateLinkage.parent.primaryName]
		)
		, hq as 
		(
		select distinct m.[organization.corporateLinkage.headQuarter.duns] as duns, m.[organization.corporateLinkage.headQuarter.primaryName] as name
		from dnb.MasterTable as m
		INNER JOIN tmp as t
			ON m.duns = t.duns
		group by m.[organization.corporateLinkage.headQuarter.duns], m.[organization.corporateLinkage.headQuarter.primaryName]
		)
		, gu as 
		(
		select distinct m.[organization.corporateLinkage.globalUltimate.duns] as duns, m.[organization.corporateLinkage.globalUltimate.primaryName] as name
		from dnb.MasterTable as m
		INNER JOIN tmp as t
			ON m.duns = t.duns
		group by m.[organization.corporateLinkage.globalUltimate.duns], m.[organization.corporateLinkage.globalUltimate.primaryName]
		)
		, normal_duns as 
		(
		select distinct m.duns as duns, m.[organization.primaryName] as name
		from dnb.MasterTable as m
		INNER JOIN tmp as t
			ON m.duns = t.duns
		group by m.duns, m.[organization.primaryName]
		)
		, all_together as 
		(
		select duns,name
		from parent
		union
		select duns,name
		from hq
		union
		select duns,name
		from gu
		union
		select duns,name
		from normal_duns
		)
		, duns_unique as (
		select duns
		from all_together
		group by duns
		having COUNT(1) = 1 )
		MERGE dnb.dimDUNS_Names as target
		USING (select duns,name	from all_together where duns in (select duns from duns_unique)) as source
			ON target.duns = source.duns
		WHEN MATCHED and target.name != source.name THEN UPDATE SET
			target.name = source.name
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (duns,name)
			VALUES (source.duns,source.name)
		;

	COMMIT TRAN @ds_bloque;

END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
	ROLLBACK;
	DECLARE @ErrorMessage NVARCHAR(4000), @Bloque NVARCHAR(80),@ErrorLine INT;
	SET @Bloque = @ds_bloque;
	SET @ErrorLine = ERROR_LINE();
	SELECT @ErrorMessage = ERROR_MESSAGE();
	RAISERROR('Error en la transacción %s, línea %d: %s',16,1,@Bloque, @ErrorLine, @ErrorMessage);
END CATCH
GO
