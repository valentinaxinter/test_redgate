IF OBJECT_ID('[ext].[DnBSupplier_new]') IS NOT NULL
	DROP VIEW [ext].[DnBSupplier_new];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [ext].[DnBSupplier_new]
	AS 
		
	WITH joined_tables AS (
	SELECT DUNS
	, supp.SupplierName
	, supp.SupplierNum
	, supp.Company
	, IIF(c.CompanyLegalName is null, c.CompanyName, c.CompanyLegalName) as CompanyName
	FROM dnb.DnBCustomerAndSupplier as dnb
	INNER JOIN dw.Supplier as supp
		on supp.SupplierID = dnb.dw_id 
		and dnb.is_customer = 0
	LEFT JOIN dbo.Company as c
		on supp.Company = c.Company
	WHERE dnb.DUNS IS NOT NULL
	), result as (
	SELECT DUNS
	, STUFF((
		SELECT ' | ' + SupplierName
		FROM joined_tables jt
		WHERE DUNS = t.DUNS
		FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 3, '') 
	as Names
	,STUFF((
		SELECT ' | ' + Company
		FROM joined_tables jt
		WHERE DUNS = t.DUNS
		FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 3, '') 
	as Companies
	,STUFF((
		SELECT ' | ' + SupplierNum
		FROM joined_tables jt
		WHERE DUNS = t.DUNS
		FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 3, '') 
	as Companies_Num
	,STUFF((
		SELECT ' | ' + CompanyName
		FROM joined_tables jt
		WHERE DUNS = t.DUNS
		FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 3, '') 
	as CompanyNames
	, COUNT(1) as rows
	FROM joined_tables t
	GROUP BY DUNS
	)
	SELECT 
	r.DUNS
	,m.[organization.primaryName] as DnB_Name
	,r.Names
	,r.Companies as CompanyCodes
	,r.CompanyNames
	,r.Companies_Num as Suppliers_Num
	,CASE WHEN duns_signed.DUNS IS NULL then 0 else 1 end as CoC_DUNS_signed
	FROM result AS r
	LEFT JOIN [ext].[CoC_DUNS_sign] as duns_signed
		on duns_signed.DUNS = r.DUNS
	LEFT JOIN dnb.MasterTable as m
		on r.DUNS = m.duns
	;
GO
