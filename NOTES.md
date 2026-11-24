# Notes: Developing Applications with Apache Spark

My own notes from the Databricks Academy course *Developing Applications with Apache Spark* (ASP 2, v3.0.1, ~3.5 h).

## Lessons

| # | Topic |
|---|-------|
| 01 | Required setup: `spark_dev` schema, `raw_customer_profiles` and `raw_franchise_sales` JSON-string tables |
| 1.1–1.2 | DataFrame API basics, optional end-to-end ETL demo |
| 2.1–2.3 | Grouping, aggregation, window functions; NYC taxi demo; e-commerce (Bakehouse) lab |
| 3.1–3.2 | Joins, set operations, join performance; demo over the Bakehouse tables |
| 4.1–4.3 | Arrays, structs, maps and JSON; demo and lab over the JSON-string tables |

## Setup notes

- Compute: classic **DBR 17.3 LTS** cluster *Developing Apps with Apache Spark (&lt;you&gt;)* for the Spark UI;
  all demos also run on serverless (env v4).
- Writes to `labuser_<user>.spark_dev` (shared catalog with the other course repos).
- Data: `samples.bakehouse`, `samples.nyctaxi`.

## Notes

<!-- Add what you learn as you go through each module -->
