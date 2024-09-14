-- membuat table baru
CREATE TABLE ecommerce_sessions (
    id SERIAL PRIMARY KEY,
    fullVisitorId TEXT NOT NULL,
    channelGrouping VARCHAR(255) NOT NULL,
    time INTEGER NOT NULL,
    country VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    totalTransactionRevenue FLOAT,
    transactions FLOAT,
    timeOnSite FLOAT,
    pageviews FLOAT,
    sessionQualityDim FLOAT,
    date INTEGER NOT NULL,
    visitId INTEGER NOT NULL,
    type VARCHAR(255) NOT NULL,
    productRefundAmount FLOAT,
    productQuantity FLOAT,
    productPrice INTEGER NOT NULL,
    productRevenue FLOAT,
    productSKU VARCHAR(255) NOT NULL,
    v2ProductName VARCHAR(255) NOT NULL,
    v2ProductCategory VARCHAR(255) NOT NULL,
    productVariant VARCHAR(255) NOT NULL,
    currencyCode VARCHAR(255),
    itemQuantity FLOAT,
    itemRevenue FLOAT,
    transactionRevenue FLOAT,
    transactionId FLOAT,
    pageTitle VARCHAR(255),
    searchKeyword FLOAT,
    pagePathLevel1 VARCHAR(255) NOT NULL,
    eCommerceAction_type INTEGER NOT NULL,
    eCommerceAction_step INTEGER NOT NULL,
    eCommerceAction_option FLOAT
);