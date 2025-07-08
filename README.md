# 🛍️ E-commerce Sales Dashboard

**Link to my dashboard:** [https://lookerstudio.google.com/s/muUuWN30I2s]

---

## 📌 Project Overview

This project showcases an end-to-end e-commerce analytics workflow using **BigQuery** and **Looker Studio**. The goal was to clean and transform raw Amazon sales data and build a powerful, interactive dashboard that provides insights into order performance, revenue trends, product metrics, and fulfillment efficiency.

---

## 🧹 Data Cleaning & Preparation

The dataset contained raw order-level data with messy or missing values. Using BigQuery, the data was cleaned, normalized, and enhanced with helper columns such as:
- **Parsed date fields**
- **Standardized order statuses (e.g., Shipped, Cancelled, Pending)**
- **Courier status inference based on order status**
- **Revenue tier classification**
- **Order flags** (Is_Shipped, Is_Cancelled)
- **Date helpers** (Month, Quarter, Year)

A final view was created specifically optimized for visualization in Looker Studio.

---

## 📊 Dashboard Highlights

The dashboard is organized into multiple sections to help business users quickly understand key performance metrics:

### 📈 Sales Overview
- Total Revenue, Total Orders, Average Order Value (AOV)
- Revenue trends over time
- Order status breakdown (Shipped, Cancelled, Unshipped)
- Revenue by Fulfilment type (Amazon vs. Merchant)

### 🛍️ Product & Category Insights
- Pivot table with revenue, orders, and quantity by category and size
- Bar chart showing revenue by size and fulfillment
- Filters for Quarter, B2B, Category, and Sales Channel

### 📦 Fulfillment & Shipping KPIs
- Gauge charts for revenue goals
- Funnel chart showing order flow from placement to shipping
- Visual breakdown of courier performance

---

## 💼 Business Impact

This dashboard helps businesses:
- Monitor order performance and fulfillment quality
- Identify top-selling sizes and styles
- Track cancellations and unshipped orders
- Compare Amazon vs. Merchant fulfillment
- Enable strategic decisions for marketing, operations, and logistics

---

## 🧠 Skills Demonstrated

- SQL for data cleaning and transformation (BigQuery)
- Dashboard design and interactivity (Looker Studio)
- Metric calculation and formatting
- Filtering, pivot tables, and advanced chart types

