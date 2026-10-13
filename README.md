# Credit Card Transaction & Fraud Analysis

**PostgreSQL + Power BI** | 250K transactions | 25K customers | 32K cards | 500 merchants

An end-to-end analysis of a credit card portfolio: schema design and data cleaning in PostgreSQL, 25+ business-question queries, and a two-page Power BI dashboard (Transaction Overview and Fraud Report). The focus is on **where fraud comes from, how much of it the controls stop, and which customer and merchant assumptions the data does and does not support.**

---

## At a Glance

| Metric | Value |
|---|---|
| Transactions analysed | 250,000 (Jan 2023 to 18 Aug 2026) |
| Total spend | ₹415 Cr (average ₹16.6K per transaction) |
| Customers (transacting / total) | 24,902 / 25,000 |
| Cards (active / total) | 30,463 / 32,457 |
| Merchants (active / total) | 487 / 500 |
| Transaction success rate | 91.1% (Declined 4.8%, Failed 4.1%) |
| Fraud attempts | **13,473 (5.39%)**, worth ₹105.2 Cr |
| Fraud that succeeded | **3,147 (23%)**, worth **₹37.07 Cr** |

---

## Tools

- **PostgreSQL**: schema design, constraints, cleaning, analysis (CTEs, window functions, `FILTER`, subqueries)
- **Power BI**: data model, DAX measures, 2-page interactive report

---

## Dataset

Four related tables (CSV imported into PostgreSQL):

| Table | Rows | Grain | Key |
|---|---|---|---|
| `customer` | 25,000 | one row per customer | `customer_id` |
| `card` | 32,457 | one row per card | `card_id` → `customer_id` |
| `merchant` | 500 | one row per merchant | `merchant_id` |
| `transaction` | 250,000 | one row per transaction (fact table) | `transaction_id` → customer, card, merchant |

Relationships are one-to-many from customer, card and merchant into transaction.

---

## Workflow

1. **Schema design**: 4 tables with primary and foreign keys and proper types (`DECIMAL` for money).
2. **Data cleaning**: duplicate checks (`ROW_NUMBER`, `GROUP BY ... HAVING`), NULL checks on every column, distinct-value audits on every categorical field, and correction of the `'Divorsed'` typo in `marital_status`.
3. **Exploratory analysis**: distributions of segments, card status, networks, payment methods, channels.
4. **Business-question analysis**: fraud, credit risk, utilization, merchant performance, customer behaviour.
5. **Dashboard**: Power BI report built on the same tables, with every headline number reconciled back to SQL.

---

## Key Insights

### Fraud

1. **Controls stopped most fraud, but ₹37 Cr still got through.** Of 13,473 fraud attempts, 10,326 (76.6%) were Declined or Failed. By value the block rate is lower, at 64.8% (₹68.2 Cr of ₹105.2 Cr), so the fraud that succeeds tends to be higher-value.
2. **International transactions are about 4x riskier.** Fraud rate is **19.7% vs 4.6%** domestic; international is only 5% of volume but 18% of all fraud, with an average fraud ticket of ₹1.32 lakh vs ₹66K.
   *Caveat:* 70% of international fraud (1,721 of 2,476) is flagged by a single cross-border rule. Without it the gap is 6.0% vs 4.6%, so the headline is partly definitional.
3. **Transaction amount is the strongest predictor.** Fraud rate is 3.9% under ₹10K, 5.3% for ₹10K to ₹50K, and **17.7% above ₹50K**. For international transactions above ₹50K it reaches **60.8%**.
4. **One fraud reason drives most of the money.** "Unusual High Transaction Amount vs Credit Limit" accounts for **73% of fraud value** (₹77.2 Cr) from only 1,707 cases, while all 8 reasons have a similar count (850 to 2,470). Ranking by count would miss this.
5. **Expired, blocked and lost cards are 100% flagged as fraud** (4,909 attempts), so these should be hard-declined at authorization.
6. **What does not predict fraud:** channel (5.3 to 5.6%), device, payment method, card tier, time of day, and **merchant risk level** (High 5.34% vs Low 5.36%). The "High risk" label does not separate risky merchants in this data.

### Customers and credit risk

7. **Students are over-limited.** Average credit limit is **193% of annual income** for Students vs 13% for Business owners and 27.6% overall. By segment, "Basic" sits at 161%. Credit limits fall as income rises, and Students are the outlier.
8. **No occupation-specific spending pattern.** Hospital and Airline are the top spend categories for almost every occupation. The only signal is ticket size, from about ₹15.0K (Student) to ₹18.5K (Chartered Accountant), consistent with income rather than preference.
9. **Tenure does not drive value.** Customer tenure vs transaction count (r = 0.004) and total spend (r = 0.009): a new customer transacts as much as a 10-year one.

### Merchants

10. **Rating is disconnected from business.** Average volume is about 500 transactions per merchant in every rating tier (below 3.5 through 4.5+), and correlation of rating with volume is r = -0.07 (revenue r = -0.05).

---

## Dashboard

**Page 1: Transaction Overview.** KPI cards (customers, active cards, active merchants, transactions, total amount, average transaction), transaction status, payment method, account type, gender, merchant category, and monthly and yearly trends. Slicers: age category, card type, year and quarter.
![preview image](/<img <img <img width="1083" height="607" alt="Screenshot 2026-10-13 at 1 30 26 PM" src="https://github.com/user-attachments/assets/cc9c5436-037e-4d08-ab22-d7f2e3d399d8" />
 />
/>
)

**Page 2: Fraud Report.** Fraud attempts, successful fraud, international vs domestic fraud, fraud amount, average fraud amount and fraud rate; fraud by card type, payment method and reason; monthly and yearly trends.
![preview image]
(/<img <img <img width="1083" height="607" alt="Screenshot 2026-10-13 at 1 31 00 PM" src="https://github.com/user-attachments/assets/551e5335-db89-4d4d-9c98-f8ec8c432221" />
 />
/>
)

### Transaction Overview
![Transaction Overview dashboard](screenshots/overview.png)

### Fraud Report
![Fraud Report dashboard](screenshots/fraud_report.png)

### Key DAX measures

```dax
Fraud Attempts = CALCULATE(COUNT('public transaction'[transaction_id]),
                           'public transaction'[fraud_flag] = 1)

Successful Fraud = CALCULATE(COUNT('public transaction'[transaction_id]),
                             'public transaction'[fraud_flag] = 1,
                             'public transaction'[transaction_status] = "Successful")

Fraud Rate % = DIVIDE([Fraud Attempts], COUNT('public transaction'[transaction_id]), 0)

Fraud Loss Amount = CALCULATE(SUM('public transaction'[transaction_amount]),
                              'public transaction'[fraud_flag] = 1,
                              'public transaction'[transaction_status] = "Successful")

Active Merchants = CALCULATE(DISTINCTCOUNT('public merchant'[merchant_id]),
                             'public merchant'[merchant_status] = "Active")
```

---

## Repository Structure

```
├── sql/
│   ├── schema.sql          # table creation and constraints
│   ├── data_cleaning.sql   # null, duplicate and typo checks
│   └── analysis.sql        # business-question queries
├── dashboard/
│   └── credit_card.pbix
├── screenshots/
└── README.md
```

## How to Run

1. Create a PostgreSQL database and run the table definitions from `schema.sql`.
2. Update the file paths in the `COPY` commands to where the four CSVs are stored (or use `\copy` / the pgAdmin import wizard if the server cannot read your local path).
3. Run `data_cleaning.sql`, then `analysis.sql`.
4. Open `credit_card.pbix` in Power BI Desktop and point the data source at your PostgreSQL database.

---

## Limitations

- **The data appears synthetic.** Distributions are very even (balanced occupations, near-equal card networks), so the "no relationship" findings (tenure, rating, channel, merchant risk level) may reflect how the data was generated rather than real-world behaviour.
- **Fraud labels are partly rule-based.** Expired, blocked and lost card attempts and cross-border transactions are flagged by definition, so their fraud rates describe the rules, not independent risk.
- **2026 is a partial year** (data ends 18 Aug 2026), so September to December have three years of data and the other months have four. Compare rates, not raw monthly counts.

---

## Author

**Abhay**, aspiring data analyst 
