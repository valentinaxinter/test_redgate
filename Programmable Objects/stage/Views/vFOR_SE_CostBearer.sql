IF OBJECT_ID('[stage].[vFOR_SE_CostBearer]') IS NOT NULL
	DROP VIEW [stage].[vFOR_SE_CostBearer];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- Good-to-know:
-- DESCRIBE (AND DATE) ANY CHANGES TO STANDARD SCRIPT HERE.

CREATE VIEW [stage].[vFOR_SE_CostBearer] AS

SELECT
--------------------------------------------- Keys/ IDs ---------------------------------------------
	CONVERT([binary](32),HASHBYTES('SHA2_256',CONCAT(Company, '#', CostBearerNum))) AS CostBearerID,
	CONCAT(Company,'#',CostBearerNum) AS CostBearerCode,
	CONVERT([binary](32),HASHBYTES('SHA2_256',Company)) AS CompanyID,
	PartitionKey,

--------------------------------------------- Regular Fields ---------------------------------------------
---Mandatory Fields ---
	Company,
	CostBearerNum,

---Valuable Fields ---
	CostBearerName,
	CostBearerStatus,
	CostBearerGroup,

--- Good-to-have Fields ---
	CostBearerGroup2,
	CostBearerGroup3,

--------------------------------------------- Meta Data ---------------------------------------------
--CONVERT(date, ModifiedTimeStamp) AS ModifiedTimeStamp,
--CONVERT(date, CreatedTimeStamp) AS CreatedTimeStamp,
--TRIM(IsActiveRecord) AS IsActiveRecord,

--------------------------------------------- Extra Fields ---------------------------------------------
	'' AS CBRes1,
	'' AS CBRes2,
	'' AS CBRes3

FROM 
	stage.FOR_SE_CostBearer
/*GROUP BY
	PartitionKey, Company, CostBearerNum,CostBearerName,CostBearerStatus,CostBearerGroup,CostBearerGroup2,CostBearerGroup3 */
GO
