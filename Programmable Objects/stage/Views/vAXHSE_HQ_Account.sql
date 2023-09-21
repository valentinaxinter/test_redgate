IF OBJECT_ID('[stage].[vAXHSE_HQ_Account]') IS NOT NULL
	DROP VIEW [stage].[vAXHSE_HQ_Account];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vAXHSE_HQ_Account] AS 
SELECT 
	CONVERT(binary(32), HASHBYTES('SHA2_256',CONCAT(N'AXHSE', '#', [AccountNum]))) AS AccountID
	,CONVERT(binary(32), HASHBYTES('SHA2_256',N'AXHSE')) AS CompanyID
	,CONCAT(N'AXHSE', '#', [AccountNum]) AS AccountCode
	,CONVERT(varchar, GETDATE(), 23) AS PartitionKey
	,N'AXHSE'	AS [Company]
	,nullif([AccountNum]					  ,'NULL') as [AccountNum]					  
	,nullif([AccountName]					  ,'NULL') as [AccountName]					  
	,nullif(CONCAT(AccountNum,'-',AccountName),'NULL') AS Account
	,nullif([AccountStatus]					  ,'NULL') AS [AccountStatus]			
	,nullif([Assets]						  ,'NULL') AS [Assets]				
	,nullif([Amortization]					  ,'NULL') AS [Amortization]			
	,nullif([Costs]							  ,'NULL') AS [Costs]					
	,nullif([LiabilitiesAndEquity]			  ,'NULL') AS [LiabilitiesAndEquity]	
	,nullif([Revenue]						  ,'NULL') AS [Revenue]				
	,nullif([CurrentAssets]					  ,'NULL') AS [CurrentAssets]			
	,nullif([CurrentLiabilities]			  ,'NULL') AS [CurrentLiabilities]	
	,nullif([Deprecation] 					  ,'NULL') AS [Deprecation] 			
	,nullif([Equity]						  ,'NULL') AS [Equity]				
	,nullif([AccountReceivables]			  ,'NULL') AS [AccountReceivables]	
	,nullif([CashAndEquivalents]			  ,'NULL') AS [CashAndEquivalents]	
	,nullif(Liability						  ,'NULL') AS Liability				
	,nullif(Tax								  ,'NULL') AS Tax						
	,nullif(Interest						  ,'NULL') AS Interest				
	,nullif(Materials						  ,'NULL') AS Materials				
	,nullif(Expenses						  ,'NULL') AS Expenses				
	,nullif([AccountType]					  ,'NULL') AS [AccountType]			
	,nullif([AccountType2]					  ,'NULL') AS [AccountType2]			
	,nullif([AccountType3]					  ,'NULL') AS [AccountType3]			
	,nullif([AccountType4]					  ,'NULL') AS [AccountType4]			
	,nullif([AccountType5]					  ,'NULL') AS [AccountType5]			
	,nullif([AccountType6]					  ,'NULL') AS [AccountType6]			
	,nullif([AccountType7]					  ,'NULL') AS [AccountType7]			
	,nullif([AccountType8]					  ,'NULL') AS [AccountType8]			
	,nullif([AccountType9]					  ,'NULL') AS [AccountType9]			
	,nullif([AccountType10]					  ,'NULL') AS [AccountType10]			
	,nullif([AccountGroupName]				  ,'NULL') AS [AccountGroupName]		
	,nullif([AccountGroup2]					  ,'NULL') AS [AccountGroup2]			
	,nullif([AccountGroup3]					  ,'NULL') AS [AccountGroup3]			
	,nullif([Statement] 					  ,'NULL') AS [Statement] 			
	--,NULL AS [StatementNum]
	,'From sharepoint' AS [AccRes1]
	--,[AccRes2]
	--,[AccRes3]
  FROM stage.AXHSE_HQ_Account AS A
  WHERE A.AccountNum IS NOT NULL;
GO
