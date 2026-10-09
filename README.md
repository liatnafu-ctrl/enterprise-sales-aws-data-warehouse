# Enterprise Sales Data Warehouse Pipeline on AWS

## Project Overview

Designed and implemented an end-to-end batch data warehouse pipeline using Microsoft SQL Server, Amazon S3, AWS Glue, Amazon Athena, and Amazon Redshift Serverless.

The project demonstrates data extraction, cloud storage, ETL processing, data validation, and analytical reporting.

## Architecture
![AWS Data Warehouse Architecture](AWS%20Sales%20Data%20Warehouse%20Pipeline.png) 

**SQL Server → CSV Export → Amazon S3 (Raw) → AWS Glue → Amazon S3 (Parquet) → Amazon Redshift Serverless**

Amazon Athena is used to validate the processed datasets before loading them into Redshift.

## Technologies Used

- Microsoft SQL Server — Source database
- Amazon S3 — Raw and processed data storage
- AWS Glue — Crawlers, Data Catalog, and ETL transformations
- Amazon Athena — Data validation
- Amazon Redshift Serverless — Data warehouse and analytics
- AWS IAM — Access management
- AWS Budgets — Cost monitoring

## Datasets

| Dataset | Records |
|---|---:|
| Customers | 5 |
| Products | 5 |
| Orders | 5 |
| OrderDetails | 6 |
| **Total** | **21** |

## ETL Process

1. Exported four SQL Server tables into CSV files.
2. Uploaded source files to the Amazon S3 raw zone.
3. Cataloged the source datasets using AWS Glue crawlers.
4. Transformed the data using AWS Glue ETL jobs.
5. Converted CSV files into Parquet format.
6. Stored transformed datasets in the S3 processed zone.
7. Validated data using Amazon Athena.
8. Loaded processed datasets into Amazon Redshift Serverless.
9. Created reusable SQL views for analytical reporting.

## Reporting Views

- `vw_monthly_sales` — Monthly sales reporting
- `vw_daily_sales` — Daily sales reporting
- `vw_customer_sales` — Customer purchase analysis
- `vw_category_sales` — Product category revenue
- `vw_product_performance` — Product sales performance

## Key Results

- Total Orders: **5**
- Total Revenue: **$2,779.94**
- Average Order Value: **$555.98**
- Highest-Revenue Category: **Electronics**
- Highest-Revenue Product: **Laptop**

## Data Validation

Successfully validated all 21 records across four datasets. Confirmed source-to-warehouse row counts and tested SQL joins, aggregations, and analytical views.

## Cost Management

Configured AWS Budgets notifications and a monthly Redshift Serverless compute usage limit.

## Future Enhancements

- Automate SQL Server ingestion using AWS DMS.
- Implement Change Data Capture (CDC).
- Add pipeline orchestration and monitoring.
- Build business intelligence dashboards.

## Project Status

**Completed — October 2026**

This implementation demonstrates a functional batch data warehouse pipeline. Source CSV extraction is manual; AWS DMS and CDC were not implemented.
