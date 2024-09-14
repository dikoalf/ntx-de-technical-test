-- import data
BEGIN;

COPY ecommerce_sessions (fullVisitorId, channelGrouping, time, country, city, totalTransactionRevenue, transactions, timeOnSite, pageviews, sessionQualityDim, date, visitId, type, productRefundAmount, productQuantity, productPrice, productRevenue, productSKU, v2ProductName, v2ProductCategory, productVariant, currencyCode, itemQuantity, itemRevenue, transactionRevenue, transactionId, pageTitle, searchKeyword, pagePathLevel1, eCommerceAction_type, eCommerceAction_step, eCommerceAction_option)
FROM 'F:\MyCode\ntx-de-technical-test\Soal 1 - Data Transformation dan Analysis Case\ecommerce-session-bigquery.csv'
DELIMITER ','
CSV HEADER;

COMMIT;