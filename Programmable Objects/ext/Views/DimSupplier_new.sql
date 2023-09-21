IF OBJECT_ID('[ext].[DimSupplier_new]') IS NOT NULL
	DROP VIEW [ext].[DimSupplier_new];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [ext].[DimSupplier_new]
	AS 
	
with dim_HL as (
	select duns, isnull(iif([organization.isStandalone] = 1,1,cast(cast(m.[organization.corporateLinkage.hierarchyLevel] as float) as int)),1) as HL
	from dnb.MasterTable as m
), duns_inherited as (
select	   iSign.DUNS
		  ,dim_HL.HL as DUNS_HL
		  ,iSign.Duns_Inherited
		  , ROW_NUMBER() over (partition by iSign.Duns_Inherited order by dim_HL.HL desc) as rn
from [ext].[CoC_Inherited_sign] as iSign
left join dim_HL
	on iSign.DUNS = dim_HL.duns
where last_modified_date = (select max(last_modified_date) from ext.CoC_Inherited_sign)
)
SELECT 
	 ds.SupplierID
	 ,ds.Company
	 ,IIF(c.CompanyLegalName is null, c.CompanyName, c.CompanyLegalName) as CompanyName
	,ds.SupplierNum
	,ds.SupplierName
	,ds.DUNS
	--, dim_HL.HL as DUNS_HL
	,CASE WHEN local_signed.dw_id is null THEN 0 ELSE 1
	 END AS COC_Local_sign
	,CASE WHEN duns_signed.DUNS is null THEN 0 ELSE 1
	 END AS COC_DUNS_sign
	, case when duns_inherited.DUNS is null then 0 else 1 end as COC_Inherited_sign
	, duns_inherited.DUNS as Closest_DUNS
FROM dm.DimSupplier as ds
LEFT JOIN [ext].[CoC_Local_sign] as local_signed
	ON ds.SupplierID = local_signed.dw_id
	AND local_signed.is_customer = 0
LEFT JOIN [ext].[CoC_DUNS_sign] as duns_signed
	ON ds.DUNS = duns_signed.DUNS
LEFT JOIN dbo.Company as c
	on ds.Company = c.Company
LEFT JOIN duns_inherited
	on ds.DUNS = duns_inherited.DUNS_Inherited
	and duns_inherited.rn = 1
--where ds.DUNS = 403243921
	;
GO
