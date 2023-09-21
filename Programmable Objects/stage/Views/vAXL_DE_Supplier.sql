IF OBJECT_ID('[stage].[vAXL_DE_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vAXL_DE_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [stage].[vAXL_DE_Supplier] AS

SELECT
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company,'#', TRIM(UPPER([SupplierNum]))))) AS SupplierID
    ,CONCAT([Company],'#',TRIM(UPPER([SupplierNum]))) AS SupplierCode
	,CONVERT([binary](32), HASHBYTES('SHA2_256',[Company])) AS CompanyID
	,[PartitionKey]

	,[Company]
	,TRIM(UPPER([SupplierNum])) AS SupplierNum
	,[dbo].[ProperCase](TRIM(MainSupplierName)) AS MainSupplierName
	,[dbo].[ProperCase](TRIM(SupplierName)) AS SupplierName
	,TRIM([AddressLine1]) AS AddressLine1
    ,TRIM([AddressLine2]) AS AddressLine2
    ,TRIM([AddressLine3]) AS AddressLine3
	,[TelephoneNum]
	,[Email]
	,District
	,TRIM([City]) AS City
	,TRIM([ZIP]) AS ZIP
	,[Region] 
	,CountryName
	,[dbo].[ProperCase](TRIM(concat (addressline1+' '+ addressline2, null))) AS AddressLine
	,[dbo].[ProperCase](TRIM(concat_ws(',',coalesce([dbo].[ProperCase](CountryName),null),IIF(City= ' ',null,trim(substring(replace([dbo].[ProperCase](AddressLine3),' ', ''), 6, 100))),IIF(ZIP= ' ',null,([Addressline3]))
		,coalesce(IIF([addressline1]= ' ',null,[addressline1]),IIF([addressline2]= ' ',null,[addressline2]))
		,coalesce(IIF([addressline2]= ' ',null,[addressline2]),IIF([addressline3]= ' ',null,[addressline3]))))) AS FullAddressLine
	,TRIM([SupplierCategory]) AS SupplierCategory
	,TRIM(SupplierResponsible) AS SupplierResponsible
	,CONVERT([binary](32), HASHBYTES('SHA2_256', [BankAccountNum])) AS [BankAccountNum] --required by Ian Morgan & approved by Emil T on 20200630
	,[VATNum]
	,TRIM([SupplierABC]) AS SupplierABC
	,CustomerNum
	,[Website]
	,[CodeOfConduct]
	,[MinOrderQty]
	,InternalExternal
	,Comments
FROM [stage].[AXL_DE_Supplier]
GROUP BY
	PartitionKey, Company, UPPER([SupplierNum]), MainSupplierName, SupplierName, AddressLine1,AddressLine2, AddressLine3, [TelephoneNum], [Email], District, ZIP, City, [Region], CountryName, SupplierCategory, SupplierResponsible, [BankAccountNum], [VATNum], SupplierABC, [Website], [CodeOfConduct], [MinOrderQty], InternalExternal, Comments, CustomerNum
GO
