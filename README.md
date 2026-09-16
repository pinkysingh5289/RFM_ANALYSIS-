# RFM_ANALYSIS-
End-to-end RFM (Recency, Frequency, Monetary) customer segmentation built entirely in SQL on the Olist Brazilian e-commerce dataset — from raw order tables to scored customer segments like Champions, Loyal, At Risk and Hibernating.

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
