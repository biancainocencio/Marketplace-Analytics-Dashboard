# 🛍️ Brazilian E-Commerce Analytics Dashboard

This project showcases a full-scale analytics dashboard built using SQL, Python, and BI tools to derive actionable insights from the [Olist e-commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). The analysis spans customer behavior, logistics performance, seller quality, and revenue patterns across regions and categories.

> 📽️ **Watch the Dashboard Demo**  
> ▶️ [dashboard_video.mp4](./dashboard%20video%20(1).mp4)

---

## 🔍 Project Overview

The dashboard was designed as part of the **FLY Analytics suite**, a data-driven initiative under the FLY product line (see [case presentation](./FLY%20-%20Case%20Presentation.pdf)). The goal was to enable Brazilian marketplaces to unlock granular, actionable insights that support:

- Revenue optimization
- Churn reduction
- Seller performance monitoring
- Product category strategy

---

## 🛠️ Tech Stack

- **BigQuery SQL** — for large-scale data processing and analysis
- **Python (Matplotlib, Pandas)** — for intermediate exploration and visual prototyping
- **BI Tool (Looker Studio / Tableau / PowerBI)** — for the final interactive dashboard
- **FLY Analytics & FLY AI** — architecture outlined in the [presentation PDF](./FLY%20-%20Case%20Presentation.pdf)

---

## 📊 Key Metrics and Queries

### 📦 Logistics Performance
- On-time delivery rate
- Churn after late delivery
- Average delivery time by city

### 💬 Customer Behavior
- Repeat Purchase Rate (RPR) overall and by state/category
- Average revenue per customer
- Average order value
- Churn rate after negative experiences

### 💰 Revenue Insights
- Monthly GMV trends
- Revenue by state and city
- Most profitable product categories by region and month

### 🧾 Seller Insights
- Late delivery rate by seller
- Average review scores by seller
- Top 10 underperforming sellers

### 🧠 Advanced Metrics
- Estimated lost revenue due to churn
- Synthetic LTV calculation
- Category trends across seasons and locations

---

## 📁 File Structure

- `dashboard video (1).mp4` – Final demo of the interactive dashboard
- `FLY - Case Presentation.pdf` – Business and technical context behind FLY Analytics
- `*.sql` – Dozens of modular SQL queries used to power the dashboard metrics

---

## 📈 Sample Query: Repeat Purchase Rate by State

```sql
WITH customer_order_counts AS (
    SELECT 
        c.customer_unique_id,
        c.customer_state,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM `abi_data.customers` c
    JOIN `abi_data.orders` o ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id, c.customer_state
),
repeat_customers AS (
    SELECT 
        customer_state,
        COUNT(customer_unique_id) AS repeat_customers
    FROM customer_order_counts
    WHERE total_orders > 1
    GROUP BY customer_state
),
total_customers AS (
    SELECT 
        customer_state,
        COUNT(DISTINCT customer_unique_id) AS total_customers
    FROM `abi_data.customers`
    GROUP BY customer_state
)
SELECT 
    t.customer_state,
    t.total_customers,
    COALESCE(r.repeat_customers, 0) AS repeat_customers,
    (COALESCE(r.repeat_customers, 0) * 100.0 / t.total_customers) AS repeat_purchase_rate
FROM total_customers t
LEFT JOIN repeat_customers r ON t.customer_state = r.customer_state
ORDER BY repeat_purchase_rate DESC;
```

# 📚 Business Impact
Using the dashboard and insights derived from this project, decision-makers can:

- Identify high-churn risk regions and categories
- Improve seller accountability and delivery logistics
- Align category marketing based on seasonality and region
- Estimate revenue loss due to late deliveries and formulate prevention strategies

# 🙋🏻‍♀️ Author
Bianca Inocencio
📧 contactbiancainocencio@gmail.com
