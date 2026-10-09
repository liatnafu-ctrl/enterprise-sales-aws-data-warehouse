-- Enterprise Sales Data Warehouse | Amazon Redshift Serverless
-- Database: dev | Schema: enterprise_sales
-- Re-run CREATE TABLE only in a clean schema. COPY may duplicate rows if run again.
CREATE SCHEMA IF NOT EXISTS enterprise_sales;

CREATE TABLE enterprise_sales.customers (
 customer_id BIGINT PRIMARY KEY, first_name VARCHAR(100), last_name VARCHAR(100),
 email VARCHAR(255), city VARCHAR(100), state VARCHAR(50), created_date VARCHAR(50));
CREATE TABLE enterprise_sales.products (
 product_id BIGINT PRIMARY KEY, product_name VARCHAR(100), category VARCHAR(50),
 unit_price DOUBLE PRECISION, created_date VARCHAR(50));
CREATE TABLE enterprise_sales.orders (
 order_id BIGINT PRIMARY KEY, customer_id BIGINT, order_date VARCHAR(50),
 order_status VARCHAR(30), total_amount DOUBLE PRECISION);
CREATE TABLE enterprise_sales.orderdetails (
 order_detail_id BIGINT PRIMARY KEY, order_id BIGINT, product_id BIGINT,
 quantity BIGINT, unit_price DOUBLE PRECISION);

-- Load processed Parquet; executed successfully in project environment.
COPY enterprise_sales.customers FROM 's3://enterprise-sales-data-li/processed/customers/'
 IAM_ROLE default FORMAT AS PARQUET REGION 'us-east-2';
COPY enterprise_sales.products FROM 's3://enterprise-sales-data-li/processed/products/'
 IAM_ROLE default FORMAT AS PARQUET REGION 'us-east-2';
COPY enterprise_sales.orders FROM 's3://enterprise-sales-data-li/processed/orders/'
 IAM_ROLE default FORMAT AS PARQUET REGION 'us-east-2';
COPY enterprise_sales.orderdetails FROM 's3://enterprise-sales-data-li/processed/orderdetails/'
 IAM_ROLE default FORMAT AS PARQUET REGION 'us-east-2';

-- Validation
SELECT 'Customers' AS dataset, COUNT(*) AS records FROM enterprise_sales.customers
UNION ALL SELECT 'Products', COUNT(*) FROM enterprise_sales.products
UNION ALL SELECT 'Orders', COUNT(*) FROM enterprise_sales.orders
UNION ALL SELECT 'OrderDetails', COUNT(*) FROM enterprise_sales.orderdetails;

-- Reporting views
CREATE OR REPLACE VIEW enterprise_sales.vw_monthly_sales AS
 SELECT DATE_TRUNC('month',order_date::TIMESTAMP)::DATE AS sales_month,
 COUNT(*) AS total_orders, SUM(total_amount::DECIMAL(18,2)) AS total_revenue
 FROM enterprise_sales.orders GROUP BY 1;
CREATE OR REPLACE VIEW enterprise_sales.vw_customer_sales AS
 SELECT c.customer_id,c.first_name,c.last_name,COUNT(o.order_id) AS total_orders,
 SUM(o.total_amount::DECIMAL(18,2)) AS total_sales
 FROM enterprise_sales.customers c JOIN enterprise_sales.orders o
 ON c.customer_id=o.customer_id
 GROUP BY c.customer_id,c.first_name,c.last_name;
CREATE OR REPLACE VIEW enterprise_sales.vw_category_sales AS
 SELECT p.category,SUM(od.quantity) AS units_sold,
 SUM(od.quantity*od.unit_price::DECIMAL(18,2)) AS total_sales
 FROM enterprise_sales.orderdetails od JOIN enterprise_sales.products p
 ON od.product_id=p.product_id GROUP BY p.category;
CREATE OR REPLACE VIEW enterprise_sales.vw_daily_sales AS
 SELECT order_date::TIMESTAMP::DATE AS sales_date, COUNT(*) AS total_orders,
 SUM(total_amount::DECIMAL(18,2)) AS total_revenue
 FROM enterprise_sales.orders GROUP BY 1;
CREATE OR REPLACE VIEW enterprise_sales.vw_product_performance AS
 SELECT p.product_id,p.product_name,p.category,SUM(od.quantity) AS units_sold,
 SUM(od.quantity*od.unit_price::DECIMAL(18,2)) AS total_revenue
 FROM enterprise_sales.products p JOIN enterprise_sales.orderdetails od
 ON p.product_id=od.product_id
 GROUP BY p.product_id,p.product_name,p.category;

-- Analytics
SELECT COUNT(*) AS total_orders,SUM(total_amount::DECIMAL(18,2)) AS total_revenue,
 AVG(total_amount::DECIMAL(18,2))::DECIMAL(18,2) AS average_order_value
 FROM enterprise_sales.orders;
SELECT * FROM enterprise_sales.vw_monthly_sales ORDER BY sales_month;
SELECT * FROM enterprise_sales.vw_customer_sales ORDER BY total_sales DESC;
SELECT * FROM enterprise_sales.vw_category_sales ORDER BY total_sales DESC;
SELECT * FROM enterprise_sales.vw_daily_sales ORDER BY sales_date;
SELECT * FROM enterprise_sales.vw_product_performance ORDER BY total_revenue DESC;
