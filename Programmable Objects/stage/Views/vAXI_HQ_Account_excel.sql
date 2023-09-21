IF OBJECT_ID('[stage].[vAXI_HQ_Account_excel]') IS NOT NULL
	DROP VIEW [stage].[vAXI_HQ_Account_excel];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO














/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW  [stage].[vAXI_HQ_Account_excel] AS

SELECT 
	CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(N'AXISE', '#', [AccountNum]))) AS AccountID
	,CONVERT(binary(32), HASHBYTES('SHA2_256',N'AXISE')) AS CompanyID
	,CONCAT(N'AXISE', '#', [AccountNum]) AS AccountCode
	,CONVERT(varchar, GETDATE(), 23) AS PartitionKey
	,N'AXISE'	AS [Company]
	,nullif([AccountNum]					  ,'NULL') as [AccountNum]
	,nullif([AccountName]					  ,'NULL') as [AccountName]
	,nullif([AccountName English]			  ,'NULL') AS [AccountName2]
	,nullif(CONCAT(AccountNum,'-',AccountName),'NULL') AS Account
	,nullif([AccountStatus]					  ,'NULL') as [AccountStatus]			
	,nullif([BalanceAccount]				  ,'NULL') as [BalanceAccount]		
	,nullif([TransactionAccount]			  ,'NULL') as [TransactionAccount]	
	,nullif([Assets]						  ,'NULL') as [Assets]				
	,nullif([Amortization]					  ,'NULL') as [Amortization]			
	,nullif([Costs]							  ,'NULL') as [Costs]					
	,nullif([LiabilitiesAndEquity]			  ,'NULL') as [LiabilitiesAndEquity]	
	,nullif([Revenue]						  ,'NULL') as [Revenue]				
	,nullif([CurrentAssets]					  ,'NULL') as [CurrentAssets]			
	,nullif([CurrentLiabilities]			  ,'NULL') as [CurrentLiabilities]	
	,nullif([Deprecation] 					  ,'NULL') as [Deprecation] 			
	,nullif([Equity]						  ,'NULL') as [Equity]				
	,nullif([AccountReceivables]			  ,'NULL') as [AccountReceivables]	
	,nullif([CashAndEquivalents]			  ,'NULL') as [CashAndEquivalents]	
	,nullif(Liability						  ,'NULL') as Liability				
	,nullif(Tax								  ,'NULL') as Tax						
	,nullif(Interest						  ,'NULL') as Interest				
	,nullif(Materials						  ,'NULL') as Materials				
	,nullif(Expenses						  ,'NULL') as Expenses				
	,nullif([AccountType]					  ,'NULL') as [AccountType]			
	,nullif([AccountType2]					  ,'NULL') as [AccountType2]			
	,nullif([AccountType3]					  ,'NULL') as [AccountType3]			
	,nullif([AccountType4]					  ,'NULL') as [AccountType4]			
	,nullif([AccountType5]					  ,'NULL') as [AccountType5]			
	,nullif([AccountType6]					  ,'NULL') as [AccountType6]			
	,nullif([AccountType7]					  ,'NULL') as [AccountType7]			
	,nullif([AccountType8]					  ,'NULL') as [AccountType8]			
	,nullif([AccountType9]					  ,'NULL') as [AccountType9]			
	,nullif([AccountType10]					  ,'NULL') as [AccountType10]			
	,nullif([AccountGroupNum]				  ,'NULL') as [AccountGroupNum]		
	,nullif([AccountGroupName]				  ,'NULL') as [AccountGroupName]		
	,nullif([AccountGroup]					  ,'NULL') as [AccountGroup]			
	,nullif([AccountGroup2]					  ,'NULL') as [AccountGroup2]			
	,nullif([AccountGroup3]					  ,'NULL') as [AccountGroup3]			
	,nullif([Statement]						  ,'NULL') as [Statement]				   --83161 to 83173 different currencies, sub-account of 8311 also cost
	,'From sharepoint' AS [AccRes1]
	,[AccRes2]
	,[AccRes3]
	, CASE 
	    WHEN trim(AccountGroupName) = 'Rental of premises' THEN 1
		WHEN trim(AccountGroupName) = 'Consumable material' THEN 2 
		WHEN trim(AccountGroupName) = 'Vehicle costs' THEN 3
		WHEN trim(AccountGroupName) = 'Travel costs' THEN 4
		WHEN trim(AccountGroupName) = 'Representation' THEN 5
		WHEN trim(AccountGroupName) = 'It costs' THEN 6
		WHEN trim(AccountGroupName) = 'Auditing costs' THEN 7
		WHEN trim(AccountGroupName) = 'Consulting cost' THEN 8
		WHEN trim(AccountGroupName) = 'Interim staff' THEN 9
		WHEN trim(AccountGroupName) = 'Other external cost' THEN 10
		WHEN trim(AccountGroupName) = 'Staff cost' THEN 11
		WHEN trim(AccountGroupName) = 'Depreciation' THEN 12
		WHEN trim(AccountGroupName) = 'Foreign exchange adjustments on WC' THEN 13
		WHEN trim(AccountGroupName) = 'Financial cost' THEN 14
		WHEN trim(AccountGroupName) = 'Taxes' THEN 15
	    ELSE 0 END AS AccountGroupOrder
	       
  FROM [stage].[AXI_HQ_Account_excel] AS A
--  LEFT JOIN [stage].[AXI_HQ_Account_map_complement] AS m ON A.AccountNum = m.Konto
  WHERE A.AccountNum IS NOT NULL
GO
