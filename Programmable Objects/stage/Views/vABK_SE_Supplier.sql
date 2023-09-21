IF OBJECT_ID('[stage].[vABK_SE_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vABK_SE_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [stage].[vABK_SE_Supplier] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM([Company]),'#',TRIM([SupplierNum]))))) AS SupplierID
    ,UPPER(CONCAT([Company],'#',TRIM([SupplierNum]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',UPPER(TRIM([Company])))) AS CompanyID
	,[PartitionKey]
	,UPPER(TRIM([Company])) AS Company
	,UPPER(TRIM([SupplierNum])) AS SupplierNum
	--,'' AS MainSupplierName
	,[dbo].[ProperCase](TRIM(SupplierName)) AS SupplierName
	,TRIM([AddressLine1]) AS AddressLine1
    ,TRIM([AddressLine2]) AS AddressLine2
    ,TRIM([AddressLine3]) AS AddressLine3
	,TelephoneNumber1 AS [TelephoneNum]
	,[Email]
	,TRIM([ZipCode]) AS ZipCode
	,TRIM([City]) AS City
	--,'' AS District
	,CountryCode
    ,IIF(CountryName = '', 'Sweden', CountryName) AS CountryName
	--,'' AS [Region] 
	--,'' AS SupplierCategory 
	,TRIM(SupplierPersonResponsible) AS SupplierResponsible
	,[dbo].[ProperCase](TRIM(concat (addressline1+' '+ addressline2, null))) AS AddressLine
	,[dbo].[ProperCase](TRIM(concat_ws(',',coalesce([dbo].[ProperCase](CountryCode),null),IIF(City= ' ',null,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))),IIF([ZipCode]= ' ',null,[dbo].[udf_GetNumeric]([Addressline3]))
		,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
		,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3]))))) AS FullAddressLine
	--,'' AS [AccountNum] 
	,VATRegNo AS [VATNum]
	,OrganizationNum
	,AxInterInternal AS InternalExternal
	,[CodeOfConduct]
	--,'' AS CustomerNum
	--,'' AS SupplierScore
	,NULL AS [MinOrderQty]
	,0 AS MinOrderValue	
	,[Website]
	--,'' AS Comments
	,CreatedTimeStamp AS SRes1
	,ModifiedTimeStamp AS SRes2
	--,OrdNum AS SRes3 ---????

FROM [stage].[ABK_SE_Supplier] 
--LEFT JOIN stage.ABK_SE_Part p ON sp.SupplierNum = p.PrimarySupplier
/*GROUP BY 
      [PartitionKey],[Company],[SupplierNum],[SupplierName],[AddressLine1],[AddressLine2],[AddressLine3],[City],[ZIP],[Region],[CountryName]
	  ,[SupplierCategory],[Reference],[BankAccountNum],[VATNum],[SupplierABC],[CustomerCode],[TelephoneNum],[Email],[Website],[CodeOfConduct]
	  ,[MinOrderQty],[InternalName],[Comment] */
GO
