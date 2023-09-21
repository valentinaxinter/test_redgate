IF OBJECT_ID('[stage].[vOCS_SE_PurchaseClaims]') IS NOT NULL
	DROP VIEW [stage].[vOCS_SE_PurchaseClaims];

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [stage].[vOCS_SE_PurchaseClaims] as

SELECT

--------------------------------------------- Keys/ IDs ---------------------------------------------
CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(COMPANY), '#', TRIM(ClaimNum))))) AS ClaimID
--,CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(COMPANY), '#', TRIM(CustomerNum))))) AS CustomerID
,CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(COMPANY), '#', TRIM(SupplierNum))))) AS SupplierID
,CONVERT(binary(32), HASHBYTES('SHA2_256', UPPER(CONCAT(TRIM(COMPANY), '#', TRIM(PartNum))))) AS PartID
,CONVERT([binary](32),HASHBYTES('SHA2_256',UPPER(TRIM(Company)))) as CompanyID
,PartitionKey

--------------------------------------------- Regular Fields ---------------------------------------------
---Mandatory Fields ---
,UPPER(TRIM(Company)) AS Company
,UPPER(TRIM(ClaimNum)) AS ClaimNum
,UPPER(TRIM(PartNum)) AS PartNum

--Valuable Fields ---
--,UPPER(TRIM(CustomerNum)) AS CustomerNum
--,UPPER(TRIM(SalesOrderNum)) AS SalesOrderNum
,UPPER(TRIM(SupplierNum)) AS SupplierNum
,UPPER(TRIM(PurchaseOrderNum)) AS PurchaseOrderNum
--,UPPER(TRIM(ClaimHandler)) AS ClaimHandler
--,UPPER(TRIM(ClaimResponsible)) AS ClaimResponsible
--,CASE WHEN CreateDate = '' OR CreateDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, CreateDate) END AS CreateDate
--,CASE WHEN StartDate = '' OR StartDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, StartDate) END AS StartDate
--,CASE WHEN EndDate = '' OR EndDate is NULL THEN CONVERT(date,'1900-01-01') ELSE CONVERT(date, EndDate) END AS EndDate
--,UPPER(TRIM(WarehouseCode)) AS WarehouseCode
,UPPER(TRIM(Comment)) AS Comment

--- Good-to-have Fields ---
--,UPPER(TRIM(CreateTime)) AS CreateTime
--,UPPER(TRIM(StartTime)) AS StartTime
--,UPPER(TRIM(EndTime)) AS EndTime
--,UPPER(TRIM(SalesOrderLine)) AS SalesOrderLine
,UPPER(TRIM(PurchaseOrderLine)) AS PurchaseOrderLine
,UPPER(TRIM(ClaimDescription)) AS ClaimDescription
,UPPER(TRIM(ClaimType)) AS ClaimType
--,UPPER(TRIM(ClaimGroup)) AS ClaimGroup
--,UPPER(TRIM(ClaimPriority)) AS ClaimPriority

--------------------------------------------- Meta Data ---------------------------------------------
,CONVERT(date, CreatedTimeStamp) AS CreatedTimeStamp
,CONVERT(date, ModifiedTimeStamp) AS ModifiedTimeStamp
--,TRIM(IsActiveRecord) AS IsActiveRecord

--------------------------------------------- Extra Fields ---------------------------------------------
,UPPER(TRIM(CLRes1)) AS CLRes1
--,UPPER(TRIM(CLRes2)) AS CLRes2
--,UPPER(TRIM(CLRes3)) AS CLRes3

FROM
[stage].[OCS_SE_PurchaseClaims]
GO
