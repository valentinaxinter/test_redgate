IF OBJECT_ID('[dnb].[vCustomerImprovement]') IS NOT NULL
	DROP VIEW [dnb].[vCustomerImprovement];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dnb].[vCustomerImprovement] as
select convert(bigint,dnb.dw_id) as CustomerID
,dnb.confidence_code
,dnb.match_status
,mc.[matchCandidates.matchQualityInformation.matchGradeComponents.componentType]   as componentType
,mc.[matchCandidates.matchQualityInformation.matchGradeComponents.componentRating] as componentRating
,error.errorDescription
,mgs.Definition
,mgs.GradeScore
,mgs.Example
from dnb.MatchComponents as mc
inner join dnb.DnBCustomerAndSupplier as dnb
on	CAST(left(mc.customerReference,len(mc.customerReference)-2) as bigint) = CAST(dnb.dw_id as bigint)
		and dnb.is_customer = 1
inner join dnb.dimError as error
	on dnb.match_status = error.errorCode and stage = 'match'
inner join dnb.dimMatchGradeString as mgs
	on mgs.Grade = mc.[matchCandidates.matchQualityInformation.matchGradeComponents.componentRating]
where confidence_code < 9 or confidence_code is null
;
GO
