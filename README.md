# Heart Disease Analysis (SQL, PostgreSQL)

This project contains a **SQL-based exploratory data analysis** of the Cleveland Heart Disease dataset.

The goal of the analysis is to understand how selected clinical factors
(age, cholesterol level, and blood pressure) relate to the presence of heart disease.

---

## Dataset

Source:
https://www.kaggle.com/datasets/cherngs/heart-disease-cleveland-uci

The dataset is **not included** in this repository.
Please download it manually from Kaggle.

Target variable:
- `condition`  
  - `0` — no heart disease  
  - `1` — heart disease present  

---

## Technologies

- PostgreSQL
- SQL
- DBeaver (database client)

---

## Analysis overview

The analysis is performed entirely in SQL and includes:

### 1. Data sanity checks
- row count
- missing values
- min / max values for key numeric columns
- distribution of the target variable

### 2. Baseline comparisons
- average age by disease status
- average cholesterol by disease status
- average resting blood pressure by disease status
- disease prevalence by sex

### 3. Clinically meaningful buckets
Based on common clinical thresholds:
- Age: `<50`, `50–60`, `>60`
- Cholesterol: `<200` vs `>=200`
- Blood pressure: `<140` vs `>=140`

For each bucket the percentage of patients with heart disease is calculated.

### 4. Factor comparison
For each factor (age, cholesterol, blood pressure) the analysis computes:
- minimum percentage of sick patients
- maximum percentage of sick patients
- **effect_pp** — difference in percentage points between the highest and lowest risk group

This allows a simple comparison of which factor shows the strongest association
with heart disease in this dataset.

---

## How to run

1. Create a PostgreSQL database (e.g. `heart_disease_sql`)
2. Create a table `heart_data`
3. Import the CSV dataset into the table
4. Run the SQL script top-to-bottom

---

## Notes

- This is an exploratory analysis (EDA), not a predictive model.
- Thresholds are simplified and used for educational purposes.
- Results should not be treated as medical advice.
