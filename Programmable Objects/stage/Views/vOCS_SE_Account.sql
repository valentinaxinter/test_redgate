IF OBJECT_ID('[stage].[vOCS_SE_Account]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_Account];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vOCS_SE_Account] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', [AccountNum]))) AS AccountID,
	CONCAT(Company, '#', [AccountNum], '#', [AccountName]) AS AccountCode,
	CONVERT([binary](32), HASHBYTES('SHA2_256',Company)) AS CompanyID,
	PartitionKey,
	Company,
	[AccountNum],
	[AccountName],
	[AccountType2Num] AS [AccountName2],
	CASE WHEN TRIM([AccountType2]) = 'Material'					THEN '1. Material'
	     WHEN TRIM([AccountType2]) = 'Design & PL'				THEN '2. Design & PL'
	     WHEN TRIM([AccountType2]) = 'Automation'				THEN '3. Automation'
		 WHEN TRIM([AccountType2]) = 'Installation'				THEN '4. Installation'
		 WHEN TRIM([AccountType2]) = 'Frakter & Emballage'		THEN '5. Frakter & Emballage'
		 WHEN TRIM([AccountType2]) = 'Övrigt'			        THEN '6. Övrigt'
		 ELSE [AccountType2] END AS AccountType3, --added case clauses on 2023-08-28 SB at OCS request to be able to order them
	CONCAT(AccountNum,' - ',AccountName) AS Account, -- added 2023-03-22 SB
	CONVERT(nvarchar(50), IIF([AccountGroupNum] = '', '9999', REPLACE([AccountGroupNum],'X',''))) as [AccountGroupNum],
	CONVERT(nvarchar(50), IIF([AccountGroupNum] = '', '*Saknar kategori*',[AccountGroup])) as AccountGroupName,
	concat(IIF([AccountGroupNum] = '', '9999', REPLACE([AccountGroupNum],'X','')) ,' - ',IIF([AccountGroupNum] = '', '*Saknar kategori*',[AccountGroup])) as AccountGroup, --. changed  2023-04-04 SB
	CASE WHEN TRIM([AccountGroup]) = 'Balanserade_utgifter'					THEN 1
	     WHEN TRIM([AccountGroup]) = 'Patent'								THEN 2
	     WHEN TRIM([AccountGroup]) = 'Byggnader_o_mark'						THEN 3
		 WHEN TRIM([AccountGroup]) = 'Maskiner_o_inventarier'				THEN 4
		 WHEN TRIM([AccountGroup]) = 'Andelar_i_koncernföretag'				THEN 5
		 WHEN TRIM([AccountGroup]) = 'Andelar_i_intresseföretag'			THEN 6
		 WHEN TRIM([AccountGroup]) = 'Uppskjuten_skattefordran'				THEN 7
		 WHEN TRIM([AccountGroup]) = 'Lager_av_råvaror'						THEN 8
		 WHEN TRIM([AccountGroup]) = 'Lager_av_halvfabrikat'				THEN 9
		 WHEN TRIM([AccountGroup]) = 'Påg_arbete_för_annans_räkning'		THEN 10
		 WHEN TRIM([AccountGroup]) = 'Förskott_till_leverantörer'			THEN 11
		 WHEN TRIM([AccountGroup]) = 'Kundfordringar'						THEN 12
		 WHEN TRIM([AccountGroup]) = 'Övriga_kortfristiga_fordringar'		THEN 13
		 WHEN TRIM([AccountGroup]) = 'Förutbetalda_kostn_uppl_intäkter'		THEN 14
		 WHEN TRIM([AccountGroup]) = 'Kassa_och_bank'						THEN 15
		 WHEN TRIM([AccountGroup]) = 'Bundet_eget_kapital'					THEN 16
		 WHEN TRIM([AccountGroup]) = 'Fritt_eget_kapital'					THEN 17
		 WHEN TRIM([AccountGroup]) = 'Obeskattade_reserver'					THEN 18
		 WHEN TRIM([AccountGroup]) = 'Avsättningar'							THEN 19
		 WHEN TRIM([AccountGroup]) = 'Skulder_till_kreditinstitut'			THEN 20
		 WHEN TRIM([AccountGroup]) = 'Leverantörsskulder'					THEN 21
		 WHEN TRIM([AccountGroup]) = 'Skatteskulder'						THEN 22
		 WHEN TRIM([AccountGroup]) = 'Moms'									THEN 23
		 WHEN TRIM([AccountGroup]) = 'Personalens_skatter'					THEN 24
		 WHEN TRIM([AccountGroup]) = 'Personalens_övr_skulder'				THEN 25
		 WHEN TRIM([AccountGroup]) = 'Övr_kortfristiga_skulder'				THEN 26
		 WHEN TRIM([AccountGroup]) = 'Uppl_kostn_o_förutbet_int'			THEN 27
		 WHEN TRIM([AccountGroup]) = 'Prel_kostn_attest'					THEN 28 -- End of Balance Statement
		 WHEN TRIM([AccountGroup]) = 'Huvudintäkter'					    THEN 29 -- Start of Income Statement
		 WHEN TRIM([AccountGroup]) = 'Rörelsens_sidointäkter'			    THEN 30
		 WHEN TRIM([AccountGroup]) = 'Intäktskorrigeringar'					THEN 31
		 WHEN TRIM([AccountGroup]) = 'Aktiverat_arbete'					    THEN 32
		 WHEN TRIM([AccountGroup]) = 'Övriga_rörelseintäkter'				THEN 33
		 WHEN TRIM([AccountGroup]) = 'Inköp_varor_o_material'				THEN 34 
		 WHEN TRIM([AccountGroup]) = 'Legoarbeten'					        THEN 35
		 WHEN TRIM([AccountGroup]) = 'Reduktion_av_inköpspriser'			THEN 36
		 WHEN TRIM([AccountGroup]) = 'Förändring_lager'					    THEN 37
		 WHEN TRIM([AccountGroup]) = 'Frakter_o_transporter'				THEN 38
		 WHEN TRIM([AccountGroup]) = 'Lokalkostnader'					    THEN 39
		 WHEN TRIM([AccountGroup]) = 'Fastighetskostnader'					THEN 40
		 WHEN TRIM([AccountGroup]) = 'Hyra_av_anläggningstillgångar'		THEN 41
		 WHEN TRIM([AccountGroup]) = 'Förbrukningsinv_o_material'			THEN 42
		 WHEN TRIM([AccountGroup]) = 'Reparation_o_underhåll'				THEN 43
		 WHEN TRIM([AccountGroup]) = 'Kostnad_transportmedel'				THEN 44
		 WHEN TRIM([AccountGroup]) = 'Resekostnader'					    THEN 45
		 WHEN TRIM([AccountGroup]) = 'Reklam_o_pr'					        THEN 46 
		 WHEN TRIM([AccountGroup]) = 'Övr_försäljningskostnader'			THEN 47
		 WHEN TRIM([AccountGroup]) = 'Kontorsmaterial_o_trycksaker'			THEN 48
		 WHEN TRIM([AccountGroup]) = 'Tele_o_post'					        THEN 49
		 WHEN TRIM([AccountGroup]) = 'Företagsförsäkring'					THEN 50
		 WHEN TRIM([AccountGroup]) = 'Förvaltningskostnader'				THEN 51
		 WHEN TRIM([AccountGroup]) = 'Övr_externa_tjänster'					THEN 52
		 WHEN TRIM([AccountGroup]) = 'Inhyrd_personal'					    THEN 53
		 WHEN TRIM([AccountGroup]) = 'Övr_externa_kostnader'				THEN 54
		 WHEN TRIM([AccountGroup]) = 'Förvaltningskostnader'				THEN 55
		 WHEN TRIM([AccountGroup]) = 'Löner_kollektivanställda'				THEN 56
		 WHEN TRIM([AccountGroup]) = 'Löner_tjänstemän_företagsledare'		THEN 57
		 WHEN TRIM([AccountGroup]) = 'Kostnadsersättningar_o_förmåner'		THEN 58
		 WHEN TRIM([AccountGroup]) = 'Pensionskostnader'					THEN 59
		 WHEN TRIM([AccountGroup]) = 'Sociala_avgifter'					    THEN 60
		 WHEN TRIM([AccountGroup]) = 'Övriga_personalkostnader'				THEN 61
		 WHEN TRIM([AccountGroup]) = 'Nedskrivning_o_återför_nedskr'		THEN 62
		 WHEN TRIM([AccountGroup]) = 'Övriga_rörelsekostnader'				THEN 63
		 WHEN TRIM([AccountGroup]) = 'Avskrivning_enl_plan'					THEN 64
		 WHEN TRIM([AccountGroup]) = 'Resultat_fr_andelar_koncern'			THEN 65
		 WHEN TRIM([AccountGroup]) = 'Övriga_ränteintäkter'					THEN 66
		 WHEN TRIM([AccountGroup]) = 'Räntekostnader'					    THEN 67
		 WHEN TRIM([AccountGroup]) = 'Bokslutsdispositioner'				THEN 68
		 WHEN TRIM([AccountGroup]) = 'Skatt_på_årets_resultat'				THEN 69 
		 ELSE 70 END AS AccountGroupOrder,
	CONVERT(nvarchar(50), 
	CASE WHEN LEFT([AccountNum],1) in ('1') OR LEFT([AccountNum],4) in ('2330','2420') THEN 'Tillgångar'
	     WHEN LEFT([AccountNum],1) in ('2') THEN 'Eget kapital och skulder'
		 WHEN TRIM([AccountGroup]) = 'Övriga_rörelseintäkter' THEN 'Övriga rörelseintäkter'
		 WHEN LEFT([AccountNum],1) in ('3') THEN 'Rörelsens inkomster/intäkter'
		 WHEN LEFT([AccountNum],1) in ('4') OR LEFT([AccountNum],2) in ('57')  THEN 'Kostnader för varor, material och vissa köpta tjänster'
		 WHEN LEFT([AccountNum],1) in ('5','6') THEN 'Övriga externa rörelsekostnader'
		 WHEN LEFT([AccountGroupNum],3) in ('781') THEN 'Avskrivningar'
		 WHEN LEFT([AccountNum],1) in ('7') THEN 'Kostnader för personal, m.m'
		 WHEN LEFT([AccountNum],1) in ('8') THEN 'Finansiella och andra inkomster/intäkter och kostnader'
		 WHEN LEFT([AccountNum],1) in ('9') THEN 'Statistiska/interna konton'
		 ELSE '*Saknar kategori*'
		 END) AS [Statement],
	CONVERT(nvarchar(50), CASE WHEN LEFT([AccountNum],1) in ('1') OR LEFT([AccountNum],4) in ('2330','2420') THEN '1'
	     WHEN LEFT([AccountNum],1) in ('2') THEN '2'
		 WHEN TRIM([AccountGroup]) = 'Övriga_rörelseintäkter' THEN '4' --added 2023-05-31
		 WHEN LEFT([AccountNum],1) in ('3') THEN '3'
		 WHEN LEFT([AccountNum],1) in ('4')  OR LEFT([AccountNum],2) in ('57') THEN '5'
         WHEN LEFT([AccountNum],1) in ('5','6') THEN '6'
		 WHEN LEFT([AccountNum],1) in ('7') THEN '7'
		 WHEN LEFT([AccountNum],1) in ('8') THEN '8'
		 ELSE '9'
		 END) AS [StatementNum],
	AccountIsActive AS AccountStatus,
	IIF( LEFT([AccountNum],1) in ('1','2'),'1','0') AS BalanceAccount,
	Revenue,
	Costs,
	IIF(LEFT([AccountNum],1) = '1','1','0') AS Assets,
	IIF(substring([AccountNum],1,3) = '102', '1', '0') AS Amortization,
	IIF(LEFT([AccountNum],1) = '2','1','0') AS LiabilitiesAndEquity,
	IIF(substring([AccountNum],1,3)  between '140' AND '199', '1', '0') AS CurrentAssets,
	IIF(substring([AccountNum],1,3) between '240' AND '299', '1', '0') AS CurrentLiabilities,
	IIF(substring([AccountNum],1,2) BETWEEN '78' AND '79', '1', '0') AS Deprecation, --this is spelled wrong?
	IIF(substring([AccountNum],1,2) BETWEEN '20' AND '21', '1', '0') AS Equity,
	IIF(substring([AccountNum],1,2) = '15', '1', '0') AS AccountReceivables,
	IIF(substring([AccountNum],1,2) = '19', '1', '0') AS CashAndEquivalents,
	IIF([AccountNum] between '8200' AND '8400', '1', '0') AS Interest,
	IIF(substring([AccountNum],1,2) BETWEEN '22' AND '29', '1', '0') AS Liability,
	IIF([AccountNum] between '8900' AND '8940', '1', '0') AS Tax,
	IIF(TRIM([AccountGroupNum]) = '401X', '1', '0') AS Materials, 		
	IIF([Statement] = 'Expenses', '1', '0') AS Expenses,
	CASE WHEN LEFT([AccountNum],1) in ('1','2') then 'B' -- Balance Accounts
	     WHEN LEFT([AccountNum],1) IN ('3','4','5','6','7','8') THEN 'R' --Income Statement Accounts 
	     WHEN LEFT([AccountNum],1) = ('9') then 'U' -- Statistical Accounts
		 ELSE '*Error*' END AS AccountType, -- added 2023-03-15 SB
	CASE WHEN [AccountNum] = '2420'                         THEN 'Förskott'
	     WHEN LEFT([AccountNum],1) = ('1')				    THEN 'Tillgångar'
		 WHEN LEFT([AccountNum],1) = ('2')					THEN 'Eget kapital och skulder'
	     WHEN LEFT([AccountNum],1) = ('3')					THEN 'Intäkter'
		 WHEN LEFT([AccountNum],1) IN ('4','5','6','7','8') THEN 'Kostnader'
	     WHEN LEFT([AccountNum],1) = ('9')					THEN '9-konton' 
		 ELSE '*Error*' END AS AccountType2, -- added 2023-05-08 SB
	CreatedTimeStamp AS AccRes1,
	ModifiedTimeStamp AS AccRes2
	
FROM stage.OCS_SE_Account
GO
