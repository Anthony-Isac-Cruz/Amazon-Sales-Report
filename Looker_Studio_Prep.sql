/* Step 1: Check for null values*/

SELECT 
  COUNTIF(Category IS NULL) AS null_Category,
  COUNTIF(Size IS NULL) AS null_Size,
  COUNTIF(Date IS NULL) AS null_Date,
  COUNTIF(Status IS NULL) AS null_Status,
  COUNTIF(Fulfilment IS NULL) AS null_Fulfilment,
  COUNTIF(Style IS NULL) AS null_Style,
  COUNTIF(SKU IS NULL) AS null_SKU,
  COUNTIF(ASIN IS NULL) AS null_ASIN,
  COUNTIF(`Courier Status` IS NULL) AS null_Courier_Status,
  COUNTIF(Qty IS NULL) AS null_Qty,
  COUNTIF(Amount IS NULL) AS null_Amount,
  COUNTIF(B2B IS NULL) AS null_B2B,
  COUNTIF(Currency IS NULL) AS null_Currency
FROM `e-commerce-sales-464921.ECM.AmazonSaleReport`;


  -- Parse date from string: '05-29-22' → 2022-05-29
CREATE OR REPLACE VIEW `e-commerce-sales-464921.ECM.AmazonSaleReport_Cleaned` AS
SELECT
  `index` AS Index,
  `Order ID` AS Order_ID,
  SAFE.PARSE_DATE('%m-%d-%y', Date) AS Sales_Date,
  Status,
  Fulfilment,
  `Sales Channel ` AS Sales_Channel,
  `ship-service-level` AS Ship_Level,
  Style,
  SKU,
  Category,
  Size,
  ASIN,

  -- Fixing courier status directly from source columns
  CASE 
    WHEN LOWER(`Courier Status`) IS NOT NULL THEN `Courier Status`
    WHEN LOWER(Status) IN ('cancelled') THEN 'Cancelled'
    WHEN LOWER(Status) IN ('pending', 'pending - waiting for pick up') THEN 'Unshipped'
    WHEN LOWER(Status) LIKE 'shipped%' OR LOWER(Status) = 'shipping' THEN 'Shipped'
    ELSE 'Shipping'
  END AS Courier_Status,

  Qty AS Quantity,
  IFNULL(Currency, 'Unknown') AS Currency,
  Amount,
  `ship-city` AS Ship_City,
  `ship-state` AS Ship_State,
  `ship-postal-code` AS Ship_Postal,
  `ship-country` AS Ship_Country,
  `promotion-ids` AS PromotionIDs,
  IFNULL(B2B, FALSE) AS B2B,
  `fulfilled-by` AS Fulfilled_By

FROM 
  `e-commerce-sales-464921.ECM.AmazonSaleReport`

--Total Records: 128,975
--select count(*) from `e-commerce-sales-464921.ECM.AmazonSaleReport_Cleaned`;


/* Finalize for Looker Studio*/

CREATE OR REPLACE VIEW `e-commerce-sales-464921.ECM.AmazonSaleReport_Final` AS
SELECT
  *,
  
  -- Order Status normalization (if not already present)
  CASE 
    WHEN LOWER(Status) = 'cancelled' THEN 'Cancelled'
    WHEN LOWER(Status) IN ('pending', 'pending - waiting for pick up') THEN 'Pending'
    WHEN LOWER(Status) LIKE 'shipped%' THEN 'Shipped'
    WHEN LOWER(Status) = 'shipping' THEN 'Shipping'
    ELSE 'Other'
  END AS Order_Status,

  -- Date helpers
  EXTRACT(YEAR FROM Sales_Date) AS Sales_Year,
  FORMAT_DATE('%B', Sales_Date) AS Sales_Month,
  CONCAT('Q', CAST(EXTRACT(QUARTER FROM Sales_Date) AS STRING)) AS Sales_Quarter,

  -- Status flags
  CASE WHEN LOWER(Status) = 'cancelled' THEN 1 ELSE 0 END AS Is_Cancelled,
  CASE WHEN LOWER(Status) LIKE 'shipped%' THEN 1 ELSE 0 END AS Is_Shipped,

  -- Revenue Tiering
  CASE 
    WHEN Amount < 500 THEN 'Low'
    WHEN Amount >= 500 AND Amount < 2000 THEN 'Medium'
    WHEN Amount >= 2000 THEN 'High'
    ELSE 'Unknown'
  END AS Revenue_Tier,

  -- Fulfilment Simplification
  CASE 
    WHEN LOWER(Fulfilment) = 'merchant' THEN 'Merchant Fulfilled'
    WHEN LOWER(Fulfilment) = 'amazon' THEN 'Amazon Fulfilled'
    ELSE 'Other'
  END AS Fulfilment_Type

FROM `e-commerce-sales-464921.ECM.AmazonSaleReport_Cleaned`

