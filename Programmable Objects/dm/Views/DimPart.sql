IF OBJECT_ID('[dm].[DimPart]') IS NOT NULL
	DROP VIEW [dm].[DimPart];

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dm].[DimPart] AS

SELECT CONVERT(BIGINT, PART.PartID) AS PartID
	,CONVERT(BIGINT, PART.CompanyID) AS CompanyID
	,PART.[Company]
	,PART.[PartNum]
	,MAX(PART.[PartName]) AS [PartName]
	,CONCAT (
		TRIM(PART.[PartNum])
		,' - '
		,COALESCE(NULLIF(TRIM(MAX(PART.[PartName])), ''), TRIM(MAX(PART.[PartDescription])))
		) AS Part
	,MAX(PART.[PartDescription]) AS [PartDescription]
	,MAX(PART.[PartDescription2]) AS [PartDescription2]
	,MAX(PART.[PartDescription3]) AS [PartDescription3]
	,MAX(PART.MainSupplier) AS MainSupplier
	,MAX(PART.AlternativeSupplier) AS AlternativeSupplier
	,MAX(PART.[ProductGroup]) AS ProductGroup --took away propercase 2023-03-31 SB
	,MAX(PART.[ProductGroup2]) AS [ProductGroup2]
	,MAX(PART.[ProductGroup3]) AS [ProductGroup3]
	,MAX(PART.[ProductGroup4]) AS [ProductGroup4]
	,MAX(PART.[Brand]) AS [Brand]
	,MAX(PART.[CommodityCode]) AS [CommodityCode]
	,MAX(PART.[PartReplacementNum]) AS [PartReplacementNum]
	,MAX(PART.[PartStatus]) AS [PartStatus]
	,[dbo].[ProperCase](MAX(PART.[CountryOfOrigin])) AS CountryOfOrigin
	,MAX(PART.[NetWeight]) AS [NetWeight]
	,MAX(PART.[UoM]) AS [UoM]
	,MAX(PART.[Material]) AS [Material]
	,MAX(PART.[ReOrderLevel]) AS [ReOrderlevel]
	,MAX(PART.[Barcode]) AS [Barcode]
	,MAX(PART.[PartResponsible]) AS [PartResponsible]
	,ProductID
	,PimID
	,PIM_Category1
	,PIM_Category2
	,PIM_Category3
	,PIM_Category4
	,PIM_Category5
	,PIM_Category6
	,PIM_Brand
	,PIM_Heading
	,PIM_Original_Description
	,PIM_LCName
	,ManufacturerID
	,MAX(PART.[StartDate]) AS [StartDate]
	,MAX(PART.[EndDate]) AS [EndDate]
	,PART.PARes1
	,PART.is_inferred
	

	------------------------------------------------ Inventory Age Analysis --------------------------------------------------------
	,CASE WHEN PART.Company in ('AFISCM', 'CSECERT', 'CDKCERT', 'ACZARKOV', 'SCOFI', 'SMKFI','NomoSE', 'NomoFI', 'NomoDK', 'NomoNO', 'NINSE','FSEFORA', 'FESFORA', 'IEEWIDN', 'IFIWIDN', 'JDKJENSS', 'JNOJENSS', 'JSEJENSS', 'NORNO', 'SSWSE', 'FITMT', 'ABKSE', 'SVESE', 'ROROSE','CERNO')
		THEN (
		CASE WHEN DATEDIFF(day, MAX(PINV.MaxPurchaseDelivDate), GETDATE()) <= 90 OR DATEDIFF(day, MAX(PROD1.MAXPoductionEndDate), GETDATE()) <= 90
			THEN '1: 0-3 Month'
		WHEN DATEDIFF(day, MAX(PINV.MaxPurchaseDelivDate), GETDATE()) <= 180 OR DATEDIFF(day, MAX(PROD1.MAXPoductionEndDate), GETDATE()) <= 180
			THEN '2: 3-6 Month'
		WHEN DATEDIFF(day, MAX(PINV.MaxPurchaseDelivDate), GETDATE()) <= 365 OR DATEDIFF(day, MAX(PROD1.MAXPoductionEndDate), GETDATE()) <= 365
			THEN '3: 6-12 Month'
		WHEN DATEDIFF(day, MAX(PINV.MaxPurchaseDelivDate), GETDATE()) <= 730 OR DATEDIFF(day, MAX(PROD1.MAXPoductionEndDate), GETDATE()) <= 730
			THEN '4: 12-24 Month'
		WHEN DATEDIFF(day, MAX(PINV.MaxPurchaseDelivDate), GETDATE()) <= 1095 OR DATEDIFF(day, MAX(PROD1.MAXPoductionEndDate), GETDATE()) <= 1095
			THEN '5: 24-36 Month'
		ELSE '6: 36+ Month'
		END)
	END AS PartAge --Hej David, vet du vad denna post är i PartAge? Är det när vi saknar lagertransaktioner? Borde den inte ligga på 36+månader då? 2022-07-05 TÖ
	--		  WHEN DATEDIFF(day, MIN(PINV.MaxPurchaseDelivDate), GETDATE()) > 1095  THEN '6: 36+ Month'
	--		  ELSE 'Unclassified' END AS PartAge
	/* for that 'where company='NOMOse' and partnum='24026 CJ W33-TIMKEN' ' should be classified as 36+ NOT currently as Unclassified, according to Åsa (20220519 meeting). We may should add one more table/condition of purchaseOrder, since this item has an internal order on the 20160203, but not in the PurchaseInvoice (PINV), therefore it is "mis-classified". What do you think Emil? /DZ  */
	------------------------------------------------ Part Activity Analysis --------------------------------------------------------
	,CASE WHEN PART.Company in ('AFISCM', 'CSECERT', 'CDKCERT', 'ACZARKOV', 'SCOFI', 'SMKFI','NomoSE', 'NomoFI', 'NomoDK', 'NomoNO', 'NINSE', 'FSEFORA', 'FESFORA', 'IEEWIDN', 'IFIWIDN', 'JDKJENSS', 'JNOJENSS', 'JSEJENSS', 'NORNO', 'SSWSE', 'FITMT', 'ABKSE', 'SVESE', 'ROROSE','CERNO')
		THEN (
		CASE WHEN DATEDIFF(day, MAX(STRA.TransactionDate), GETDATE()) <= 180
			THEN '1: 0-6 Month'
		WHEN DATEDIFF(day, MAX(STRA.TransactionDate), GETDATE()) <= 365
			THEN '2: 6-12 Month'
		WHEN DATEDIFF(day, MAX(STRA.TransactionDate), GETDATE()) <= 730
			THEN '3: 12-24 Month'
		WHEN DATEDIFF(day, MAX(STRA.TransactionDate), GETDATE()) <= 1095
			THEN '4: 24-36 Month'
		WHEN DATEDIFF(day, MAX(STRA.TransactionDate), GETDATE()) > 1095
			THEN '5: 36+ Month'
		ELSE 'Unclassified'
		END)
	END AS PartActivity
	--,CASE WHEN DATEDIFF(day, MAX(po.OrderDate), GETDATE()) > 730 or MAX(po.OrderDate) is NULL THEN 'Y' ELSE 'N' END AS "2YearPOItem" --Items NOT added to the product range during the last 24 months is included from the assessment
	--,CASE WHEN DATEDIFF(day, MAX(STRA.TransactionDate), GETDATE()) > 730 or MAX(STRA.TransactionDate) is NULL THEN 'Y' ELSE 'N' END AS "2YearStockTransaction"
	--,CASE WHEN DATEDIFF(day, MAX(CAGR.ValidToDate), GETDATE()) > 730 or MAX(CAGR.ValidToDate) is NULL THEN 'Y' ELSE 'N' END AS "2YearOldAgreement"
	--,CASE WHEN DATEDIFF(day, MAX(SINV.InvoiceDate), GETDATE()) > 730 or MAX(InvoiceDate) is NULL THEN 'Y' ELSE 'N' END AS Obsolete
	--,CASE WHEN STRA2.StockBalanceQTY > SINV2.TwoYearSellingShipQty THEN 'Y' ELSE 'N' END AS ExcessStock --For Items with inventory on hand exceeding the last 24months 
	
	------------------------------------------- Model for Excess and Obsolete Stock -------------------------------------------------
	,CASE 
		WHEN PART.Company in ('AFISCM', 'CSECERT', 'CDKCERT', 'ACZARKOV', 'SCOFI', 'SMKFI','NomoSE', 'NomoFI', 'NomoDK', 'NomoNO', 'NINSE', 'FSEFORA', 'FESFORA', 'IEEWIDN', 'IFIWIDN', 'JDKJENSS', 'JNOJENSS', 'JSEJENSS', 'NORNO', 'SSWSE', 'FITMT', 'ABKSE', 'SVESE', 'ROROSE','CERNO')
		THEN (
			CASE WHEN ABS(DATEDIFF(day, GETDATE(), MAX(STRA.MinTransactionDate))) <= 730 /* or MAX(STRA.TransactionDate) is NULL */ --MAX  
			THEN 'New Parts' /* 'Exist in last 24 month Stock transactions' + left(DATEDIFF(day, MAX(STRA.TransactionDate), GETDATE()),6) */
			ELSE (/* CASE WHEN DATEDIFF(day, MAX(CAGR.ValidToDate), GETDATE()) <= 730 OR  MAX(CAGR.ValidToDate NULL */ 
					CASE /* If an item/Part's agreemnet date has not expired, then this item is 'Fully Agreed Parts'  */
						WHEN MAX(CAGR.ValidToDate) >= GETDATE()
							AND AgreedQty >= StockBalanceQTY
							OR (
								MAX(SINV.InvoiceDate) IS NULL
								AND MAX(SORD.OrderDate) IS NULL
								AND MAX(STRA.TransactionDate) IS NULL
								AND MAX(CAGR.ValidToDate) IS NOT NULL
								)
						THEN 'Fully Agreed Parts' /* 'Exist in active customer agreement' + left(DATEDIFF(day, MAX(CAGR.ValidToDate), GETDATE()),6) */
					ELSE ( /* Many items are without the above agreement, this block is to look from Sales (invoice), Orders and production orders    */
							CASE --some sales in the last 2 yrs may be mistake, retured or only a quation but no qty, here is the mistake correction scenario
								WHEN (-- There are cases where an order has been placed by mistake and then corrected with a credit. In such cases we might find an INVOICE within the last 2 years and the part will not get obsolete. This line will minimize that risk.
										ABS(DATEDIFF(day, MAX(SINV.InvoiceDate), GETDATE())) > 730
										OR MAX(SINV.InvoiceDate) IS NULL OR SINV2.TwoYearSellingShipQty <= 0 
										)
									AND (-- There are cases where an order has been placed by mistake and then corrected with a credit. In such cases we might find an ORDER within the last 2 years and the part will not get obsolete. This line will minimize that risk.
										ABS(DATEDIFF(day, MAX(SORD.OrderDate), GETDATE())) > 730
										OR MAX(SORD.OrderDate) IS NULL OR SORD2.TwoYearOrderQty <= 0 
										)
									AND (--sales Order Backlog
										SORD3.TotalRemainingQty = 0	OR SORD3.TotalRemainingQty IS NULL
										)
									AND (--Production information in the past two years, after production order scenario TÖ/DZ 20230509
												SUM(PROD.TwoYearPoductionConsumedQty) = 0 OR SUM(PROD.TwoYearPoductionConsumedQty) IS NULL
										)
									AND AgreedQty < StockBalanceQTY
									--OR (MAX(SINV.InvoiceDate) is NULL AND MAX(SORD.OrderDate) is NULL AND AgreedQty < StockBalanceQTY)  
									--OR MAX(InvoiceDate) is NULL 
									-- Think about Backlog and creditnotes. Jiri comment 2021-11-23. WHCODE 901. Returns?
								THEN 'Agreed Obsolete Parts' /* + left(DATEDIFF(day, MAX(SINV.InvoiceDate), GETDATE()),6) */
							ELSE ( -- Full Obsolete scenarios:
									CASE -- Full Obsolete scenarios:
										WHEN (-- There are cases where an order has been placed by mistake and then corrected with a credit. In such cases we might find an INVOICE within the last 2 years and the part will not get obsolete. This code line will minimize that risk.
												ABS(DATEDIFF(day, MAX(SINV.InvoiceDate), GETDATE())) > 730
												OR MAX(SINV.InvoiceDate) IS NULL OR SINV2.TwoYearSellingShipQty <= 0 
											  )
											AND (-- There are cases where an order has been placed by mistake and then corrected with a credit. In such cases we might find an ORDER within the last 2 years and the part will not get obsolete. This code line will minimize that risk.
												ABS(DATEDIFF(day, MAX(SORD.OrderDate), GETDATE())) > 730
												OR MAX(SORD.OrderDate) IS NULL OR SORD2.TwoYearOrderQty <= 0 
												)
											AND (--sales Order Backlog
												SORD3.TotalRemainingQty = 0	OR SORD3.TotalRemainingQty IS NULL
												)
											AND (--Production information in the past two years, after production order scenario TÖ/DZ 20230509
												SUM(PROD.TwoYearPoductionConsumedQty) = 0 OR SUM(PROD.TwoYearPoductionConsumedQty) IS NULL
												)
											--OR (MAX(SINV.InvoiceDate) is NULL AND MAX(SORD.OrderDate) is NULL AND SORD3.TotalRemainingQty is NULL)
											--OR MAX(InvoiceDate) is NULL 
											-- Think about Backlog and creditnotes. Jiri comment 2021-11-23. WHCODE 901. Returns?									
										THEN 'Fully Obsolete Parts'
									ELSE ( --Excess scenarios:
											CASE --Agreed excess: 24 Month Sales Invoice Quantity less than current stock OHB, include not invoiced but in the order backlog
												WHEN STRA2.StockBalanceQTY > (COALESCE(SINV2.TwoYearSellingShipQty, 0) + COALESCE(SORD3.TotalRemainingQty, 0)+COALESCE(SUM(PROD.TwoYearPoductionConsumedQty), 0))
													AND STRA2.StockBalanceQTY > COALESCE(SORD2.TwoYearOrderQty, 0) + COALESCE(SUM(PROD.TwoYearPoductionConsumedQty), 0) -- after TÖ/DZ
													--AND STRA2.StockBalanceQTY > COALESCE(SUM(PROD.TwoYearPoductionConsumedQty), 0) -- after production order scenario TÖ/DZ 20230509
													AND AgreedQty < COALESCE(StockBalanceQTY, 0) --For Items with inventory on hand exceeding the last 24months 
												THEN 'Agreed Excess Parts' /* + left(STRA.StockBalanceQTY,6)+'>'+left(SINV2.TwoYearSellingShipQty,6) */
											ELSE ( --Fully excess: 
													CASE 
														WHEN STRA2.StockBalanceQTY > (COALESCE(SINV2.TwoYearSellingShipQty, 0) + COALESCE(SORD3.TotalRemainingQty, 0)+COALESCE(SUM(PROD.TwoYearPoductionConsumedQty), 0))
															AND STRA2.StockBalanceQTY > COALESCE(SORD2.TwoYearOrderQty, 0) + COALESCE(SUM(PROD.TwoYearPoductionConsumedQty), 0) -- after TÖ/DZ
															--AND STRA2.StockBalanceQTY > COALESCE(SUM(PROD.TwoYearPoductionConsumedQty), 0) -- after production order scenario TÖ/DZ 20230509
														THEN 'Fully Excess Parts' /* + left(STRA.StockBalanceQTY,6)+'>'+left(SINV2.TwoYearSellingShipQty,6) */
													ELSE 'Active Parts' -- ET Added 20220228 --if none above scenarios
													END
												 )
											END
										 )
									END
								 )
							END
						 )
					END
				 )
		END )
	END AS StockMovement

FROM dw.Part AS PART
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------- Tables for Obsolecense Model -----------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
------------------------------------- First/Last Date of External Stocktransaction ---------------------------------------------
LEFT JOIN (
	SELECT PartID
		,MAX(TransactionDate) AS TransactionDate
		,MIN(TransactionDate) AS MinTransactionDate
	FROM dw.StockTransaction
	WHERE LEFT(InternalExternal, 1) = 'E' -- There is currently a mix of Arkov use I for internal E for External transactions, and those should be excluded; Widni, has "InternalAxInter" & "InternalCompany" -- were REFERENCE <> 'I'
		AND is_deleted != 1 -- added after major function update in dw, after discusstion between Tobias & David 20230302
	GROUP BY PartID
	) STRA ON PART.partid = STRA.partid -- Checking stocktransactions if part has been added during the last 24 month
------------------------------------------------ Current Stock Balance ---------------------------------------------------------
LEFT JOIN (
	SELECT PartID
		,SUM(TransactionQty) AS StockBalanceQTY
	FROM dw.StockTransaction
	WHERE is_deleted IS NULL OR is_deleted = '0' -- added after major function update in dw, after discusstion between Tobias & David 20230302
	GROUP BY PartID
	) STRA2 ON PART.partid = STRA2.partid
---------------------------------------------- Active Customer Agreement -------------------------------------------------------
LEFT JOIN (
	SELECT PartID
		,MAX(AgreementEnd) AS ValidToDate
		,SUM(AgreementQty) AS AgreedQty
	FROM dw.CustomerAgreement
	WHERE AgreementQty > 0 and AgreementEnd > GETDATE()
			AND (is_deleted IS NULL OR is_deleted = '0') -- added after major function update in dw, after discusstion between Tobias & David 20230302
	GROUP BY PartID
	) CAGR ON PART.partid = CAGR.partid -- Checking that the part does not have any customer liabilities during the last 24 month. Should only take Agreements that has a future End Date. 
----------------------------------------------- Last Sales Invoice Date --------------------------------------------------------
LEFT JOIN (
	SELECT Company
		,PartID
		,MAX(SalesInvoiceDate) AS InvoiceDate
	FROM dw.SalesInvoice
	WHERE IsUpdatingStock IS NULL OR IsUpdatingStock = '1' -- added 2022-11-10 BY TÖ/DZ
		AND is_deleted != 1 -- added after major function update in dw, after discusstion between Tobias & David 20230302
	GROUP BY Company
		,PartID
	) SINV ON PART.partid = SINV.partid
	AND PART.Company = SINV.Company -- Checking that the part has no allocated sales during the last 24 month
-------------------------------------------- 24 Month Sales Invoice Quantity ---------------------------------------------------
LEFT JOIN (
	SELECT Company
		,PartID
		,SUM(SalesInvoiceQty) AS TwoYearSellingShipQty
	FROM dw.SalesInvoice
	WHERE SalesInvoiceDate > DATEADD(YEAR, - 2, GETDATE())  AND (IsUpdatingStock IS NULL OR IsUpdatingStock='1') -- added 2022-11-10 BY TÖ/DZ
		AND (is_deleted IS NULL OR is_deleted = '0') -- added after major function update in dw, after discusstion between Tobias & David 20230302
	GROUP BY Company
		,PartID
	) SINV2 ON PART.partid = SINV2.partid
	AND PART.Company = SINV2.Company -- Checking that the part has no allocated sales during the last 24 month
------------------------------------------------ Last Sales Order Date ---------------------------------------------------------
LEFT JOIN (
	SELECT Company
		,PartID
		,MAX(SalesOrderDate) AS OrderDate
	FROM dw.SalesOrder
	WHERE SalesOrderType != 'Internal Order' AND (IsUpdatingStock IS NULL OR IsUpdatingStock='1') -- added 2022-11-10 TÖ/DZ
		AND (is_deleted IS NULL OR is_deleted = '0') -- added after major function update in dw, after discusstion between Tobias & David 20230302
	GROUP BY Company
		,PartID
	) SORD ON PART.partid = SORD.partid
	AND PART.Company = SORD.Company -- Checking that the part has no allocated sales during the last 24 month
--------------------------------------------- 24 Month Sales Order Quantity ----------------------------------------------------
LEFT JOIN (
	SELECT Company
		,PartID
		,SUM(SalesOrderQty) AS TwoYearOrderQty
	FROM dw.SalesOrder
	WHERE SalesOrderDate > DATEADD(YEAR, - 2, GETDATE()) AND SalesOrderType != 'Internal Order'  AND (IsUpdatingStock IS NULL OR IsUpdatingStock='1') -- added 2022-11-10 TÖ/DZ
		AND (is_deleted IS NULL OR is_deleted = '0') -- added after major function update in dw, after discusstion between Tobias & David 20230302
	GROUP BY Company
		,PartID
	) SORD2 ON PART.partid = SORD2.partid
	AND PART.Company = SORD2.Company -- Added to also use in the excess stock definition. ET 2022-03-09. 
-------------------------------------------------- Total sales Order Backlog ---------------------------------------------------------
LEFT JOIN (
	SELECT Company
		,PartID
		,SUM(remainingqty) AS TotalRemainingQty
	FROM dw.SalesOrder
	WHERE SalesOrderType != 'Internal Order'  AND (IsUpdatingStock IS NULL OR IsUpdatingStock='1') AND year(SalesOrderDate) >= YEAR(Dateadd(Year, -4, Getdate())) -- added 2022-11-10 TÖ/DZ
		AND (is_deleted IS NULL OR is_deleted = '0') -- added after major function update in dw, after discusstion between Tobias & David 20230302
	GROUP BY Company
		,PartID--, SalesOrderDate
	) SORD3 ON PART.partid = SORD3.partid
	AND PART.Company = SORD3.Company -- Added to also use in the excess stock definition. ET 2022-04-12. 
------------------------------------------ Purchase Invoice to Determine PartAge --------------------------------------------------
LEFT JOIN (
	SELECT Company
		,PartID
		,MAX(ActualDelivDate) AS MaxPurchaseDelivDate
	FROM dw.PurchaseInvoice
	WHERE (is_deleted IS NULL OR is_deleted = '0') -- added after major function update in dw, after discusstion between Tobias & David 20230302
	GROUP BY Company
		,PartID
	) PINV ON PART.partid = PINV.partid
	AND PART.Company = PINV.Company -- Added to use in the PartAge definition (Inventory Age Analysis). ET 2022-04-07. 
------------------------------------------ Production information in the past two years-----------------------------------------------
LEFT JOIN (
	SELECT Company
		,PartID
		,SUM(ABS(CompletedQuantity)) AS TwoYearPoductionConsumedQty -- TMT use negative sign for component out take from storage
	FROM dw.ProductionOrder
	WHERE EndDate > DATEADD(YEAR, - 2, GETDATE()) AND PartType = 'Component' AND Status in('Completed', 'Closed') AND (is_deleted IS NULL OR is_deleted = '0')
	GROUP BY Company, PartID
	) PROD ON PART.partid = PROD.PartID	AND PART.Company = PROD.Company -- Added to for use in the Model for Obsolescence 2023-05-09 TÖ/DZ 

--------------------------------------------Production for PartAge------------------------------------------------------------
LEFT JOIN (
	SELECT Company
		,PartID
		,MAX(EndDate) AS MAXPoductionEndDate 
	FROM dw.ProductionOrder
	WHERE PartType = 'Assembly' AND Status in ('Processing') AND (is_deleted IS NULL OR is_deleted = '0')
	GROUP BY Company, PartID
	) PROD1 ON PART.partid = PROD1.partid	AND PART.Company = PROD1.Company 
---------------------------------------------------PIM inormation---------------------------------------------------------------------
LEFT JOIN (
	SELECT
		ProductID
		,PimID
		,PartID
		,IIF(Category_name IS NULL, '#Missing Category#', Category_name) AS PIM_Category1
		,IIF(Category_name2 IS NULL, '#Missing Category#', Category_name2) AS PIM_Category2
		,IIF(Category_name3 IS NULL, '#Missing Category#', Category_name3) AS PIM_Category3
		,IIF(Category_name4 IS NULL, '#Missing Category#', Category_name4) AS PIM_Category4
		,IIF(Category_name5 IS NULL, '#Missing Category#', Category_name5) AS PIM_Category5
		,IIF(Category_name6 IS NULL, '#Missing Category#', Category_name6) AS PIM_Category6
		,IIF(Brand IS NULL, '#Missing Brand#', Brand) AS PIM_Brand 
		,IIF(Heading IS NULL, '#Missing Brand#', Heading) AS PIM_Heading 
		,IIF(Original_Description IS NULL, '#Missing Brand#', Original_Description) AS PIM_Original_Description 
		,IIF(Last_category_name IS NULL, '#Missing LCName#', Last_category_name) AS PIM_LCName
		,IIF(Manufacturer_Id IS NULL, '#Missing Category#', Manufacturer_Id) AS ManufacturerID
	FROM dm.DimPIM) PIM ON PART.PartID = pim.PartID


GROUP BY PART.PartID
	,CompanyID
	,PART.[Company]
	,PART.[PartNum]
	,StockBalanceQTY
	,TwoYearSellingShipQty
	,TwoYearOrderQty
	,TotalRemainingQty
	,AgreedQty
	,ProductID
	,PimID
	,PIM_Category1
	,PIM_Category2
	,PIM_Category3
	,PIM_Category4
	,PIM_Category5
	,PIM_Category6
	,PIM_Brand
	,PIM_Heading
	,PIM_Original_Description
	,PIM_LCName
	,ManufacturerID
	,PART.PARes1
	,PART.is_inferred
GO
