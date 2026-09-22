# Olist RFM & Cohort Analysis

End-to-end RFM (Recency, Frequency, Monetary) customer segmentation and 
cohort retention analysis built entirely in SQL on the Olist Brazilian 
e-commerce dataset — from raw order tables to scored customer segments 
like Champions, Loyal, At Risk, and Lost.

## Tools
MySQL 8.0 (MySQL Workbench)

## Business Problem

Olist is a Brazilian e-commerce marketplace connecting small sellers to 
online storefronts, with order data spanning 2016-2018. This project 
analyzes customer purchasing behavior to answer a core business question 
marketing teams face: are we retaining customers after their first 
purchase, and which customers are worth the most investment?

## Stakeholder
Marketing / Customer Retention team — deciding where to allocate 
retention campaign budget and identifying high-value customer segments.

## Business Questions
This project combines two complementary techniques: cohort analysis 
(questions 1–3, 6) to track retention over time, and RFM segmentation 
(questions 4–5) to identify high-value customers at a point in time.

1. What percentage of customers make a second purchase?
2. How does repeat-purchase behavior differ across acquisition month 
   cohorts — is retention improving or declining over time?
3. How long after their first purchase do customers typically return?
4. When segmented by Recency, Frequency, and Monetary value, how are 
   customers distributed across value tiers (Champions, At Risk, Lost)?
5. What share of total revenue comes from the top customer segments?
6. Do retention patterns differ by state or product category?

## Key Assumptions
- Customer identity is tracked via `customer_unique_id`, not `customer_id` 
  (which is regenerated per order in this dataset)
- Analysis is restricted to orders with status `delivered`
- Monetary value is calculated from `payment_value` (order_payments table)
- Recency is calculated relative to the latest order date in the dataset, 
  not the current date
- A cohort is defined as the calendar month of a customer's first purchase

## Limitations
- Dataset covers ~2 years only, limiting long-term retention conclusions
- As a marketplace (not a single retail brand), naturally low repeat 
  rates may be structural rather than a performance issue
- No marketing spend or acquisition channel data — CAC/ROI can't be 
  calculated
- No customer demographic data beyond city/state
- With ~97% of customers ordering exactly once, the Frequency (F) score 
  has limited discriminative power — NTILE splits this large tied group 
  somewhat arbitrarily across buckets

## Data Exploration Highlights
- All 9 source tables imported cleanly with row counts matching expected 
  Olist dataset sizes
- Confirmed `customer_id` is regenerated per order, while 
  `customer_unique_id` correctly identifies repeat customers — critical 
  for accurate cohort/RFM grouping
- 96.9% of orders have status `delivered`; the remaining ~3% (canceled, 
  unavailable, etc.) are excluded from analysis
- Only ~3% of customers (2,987 of 96,086) placed more than one order — 
  an early signal that repeat purchasing is structurally rare in this 
  marketplace

## Methodology
1. **Data Cleaning** — filtered orders to `delivered` status only; 
   converted inconsistent date formats via staging tables
2. **Cohort Analysis** — grouped customers by first-purchase month, 
   calculated months-since-joining for every order using window 
   functions, and converted raw retention counts into percentages
3. **RFM Analysis** — calculated Recency, Frequency, and Monetary per 
   customer; scored each 1–5 using `NTILE()`; combined scores into 
   named segments via `CASE WHEN`; aggregated segment size and revenue 
   contribution

## Key Findings

**Cohort Retention:**
- Repeat purchasing is rare: only ~3% of customers (2,987 of 96,086) 
  placed more than one order
- Retention drops sharply after the first purchase — cohorts show 
  retention rates below 1% by month 6 and beyond, consistent with 
  Olist's marketplace model rather than a loyalty-driven single brand
- No cohort shows meaningfully improving retention over time; the 
  low-repeat pattern is structural across the full 2016–2018 dataset

**RFM Segmentation:**
- Customers split into six segments: New/Promising (34%), Loyal (24%), 
  At Risk (19%), Others (19%), Lost (2.6%), and Champions (1.8%)
- Champions are the most efficient segment: 1.8% of customers generate 
  3.7% of total revenue — roughly 2x their proportional share
- Lost customers contribute disproportionately little: 2.6% of customers 
  drive under 1% of revenue, indicating low ROI potential for win-back 
  campaigns
- Ranking customers by raw Monetary value alone is misleading — most 
  top spenders by total payment are one-time high-ticket buyers 
  (Frequency = 1), not loyal repeat customers. RFM segmentation 
  correctly separates these from genuine high-value repeat buyers.

## Recommendations
1. **Prioritize retention investment in Champions** — this small segment 
   (1.8% of customers) delivers outsized revenue efficiency; loyalty 
   perks or early access to new products could deepen this relationship
2. **Deprioritize reactivation spend on Lost customers** — their revenue 
   contribution is too low to justify aggressive win-back campaigns
3. **Investigate the New/Promising segment further** — as the largest 
   group by both customer count and revenue, converting even a small 
   percentage into repeat buyers could meaningfully shift overall retention
4. **Treat Monetary value with caution in isolation** — high one-time 
   spenders should not be conflated with loyal customers when designing 
   retention campaigns; combine with Frequency and Recency, as this 
   project does

## Project Structure
```
/sql/01_table_setup.sql        -- table creation & data import
/sql/02_data_cleaning.sql      -- staging-to-final conversions, filtering
/sql/03_cohort_analysis.sql    -- cohort table + retention % 
/sql/04_rfm_analysis.sql       -- RFM scoring + segment summary
/README.md
```
