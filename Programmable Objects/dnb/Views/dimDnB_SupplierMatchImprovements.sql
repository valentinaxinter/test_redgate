IF OBJECT_ID('[dnb].[dimDnB_SupplierMatchImprovements]') IS NOT NULL
	DROP VIEW [dnb].[dimDnB_SupplierMatchImprovements];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dnb].[dimDnB_SupplierMatchImprovements] as
select convert(bigint,dnb.dw_id) as SupplierID
,dnb.confidence_code																as DUNS_MatchScore
,error.errorDescription																as DUNS_MatchDescription	-- DUNS_MatchDescription
--,dnb.match_status																										-- THIS CAN BE EXCLUDED SINCE THE CODE IS NOT INTERESTING
,case 
	when mc.[matchCandidates.matchQualityInformation.matchGradeComponents.componentType] = 'PostalCode' then 'ZipCode'
	when mc.[matchCandidates.matchQualityInformation.matchGradeComponents.componentType] = 'Street Name' then 'Address Name'
	when mc.[matchCandidates.matchQualityInformation.matchGradeComponents.componentType] = 'Street Number' then 'Address Number'
	when mc.[matchCandidates.matchQualityInformation.matchGradeComponents.componentType] = 'Phone' then 'TelephoneNum'
	else mc.[matchCandidates.matchQualityInformation.matchGradeComponents.componentType]
end as InputField						--as componentType		-- InputField
,mc.[matchCandidates.matchQualityInformation.matchGradeComponents.componentRating]	as InputField_Rating				--as componentRating      -- InputField_Rating
,mgs.GradeScore																		as InputField_MatchScore						-- InputField_MatchScore
,mgs.Definition																		as InputField_MatchDescription						-- InputField_MatchDescription
,mgs.Example																		as InputField_Example						-- InputField_Example
from dnb.MatchComponents as mc
inner join dnb.DnBCustomerAndSupplier as dnb
on	CAST(left(mc.customerReference,len(mc.customerReference)-2) as bigint) = CAST(dnb.dw_id as bigint)
		and dnb.is_customer = 0
inner join dnb.dimError as error
	on dnb.match_status = error.errorCode and stage = 'match'
inner join dnb.dimMatchGradeString as mgs
	on mgs.Grade = mc.[matchCandidates.matchQualityInformation.matchGradeComponents.componentRating]
where (confidence_code < 9 or confidence_code is null)
and mc.[matchCandidates.matchQualityInformation.matchGradeComponents.componentType] in ('Name', 'State','City','PostalCode','Street Name','Street Number','Phone')
;
GO
