IF OBJECT_ID('[stage].[vCER_NO_BC_Supplier]') IS NOT NULL
	DROP VIEW [stage].[vCER_NO_BC_Supplier];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--select * from dw.Supplier where Company = 'CERNO'
--select SupplierID,count(*) from [stage].[vCER_NO_BC_Supplier] group by SupplierID order by 2;

CREATE VIEW [stage].[vCER_NO_BC_Supplier]
AS
SELECT

--------------------------------------------- Keys/ IDs ---------------------------------------------
		CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))))) AS SupplierID
		,UPPER(CONCAT(TRIM(Company),'#',TRIM(SupplierNum))) AS SupplierCode
		,CONVERT(binary(32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) AS CompanyID
		,PartitionKey
--------------------------------------------- Regular Fields ---------------------------------------------
---Mandatory Fields ---
		,UPPER(TRIM(Company)) AS Company
		,UPPER(TRIM(SupplierNum)) AS SupplierNum
		,UPPER(TRIM(SupplierName)) AS SupplierName
		--,UPPER(TRIM(OrgNum)) AS OrgNum
		,UPPER(TRIM(VATNum)) AS VATNum

---Valuable Fields ---
		--,UPPER(TRIM(ParentSupplierName)) AS ParentSupplierName
		,UPPER(TRIM(AddressLine1)) AS AddressLine1
		,UPPER(TRIM(AddressLine2)) AS AddressLine2
		,UPPER(TRIM(IIF([TelephoneNum1] is null, [TelephoneNum2],[TelephoneNum1]))) AS TelephoneNum1
		,UPPER(TRIM(Email)) AS Email
		,UPPER(TRIM(ZipCode)) AS ZipCode
		,UPPER(TRIM(City)) AS City
		,UPPER(TRIM(CountryCode)) AS CountryCode
        ,[PrimaryPurchaser] AS [MainSupplierName]--PREGUNTAR
        ,UPPER(TRIM(MinOrderValueCurrency)) AS MinOrderValueCurrency--REVISAR
        --,TRIM(IsActiveRecord) AS IsActiveRecord -- preguntar
        ,UPPER(TRIM(Website)) AS Website
		,CAST(left([CreatedTimeStamp],19)    AS DATETIME)    AS [CreatedTimeStamp] 
		,CAST(left([ModifiedTimeStamp],19)   AS DATETIME)    AS [ModifiedTimeStamp]
		,CAST([IsMaterialSupplier]   AS BIT) AS    [IsMaterialSupplier]
		,CAST([CodeOfConduct] AS BIT) AS       [CodeOfConduct] 
FROM [stage].[CER_NO_BC_Supplier];
GO
