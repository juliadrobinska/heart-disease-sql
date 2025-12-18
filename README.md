# Heart Disease Analysis — SQL (PostgreSQL)

This project is a **SQL-only exploratory data analysis** of the Cleveland Heart Disease dataset.
The goal is to identify how selected clinical factors relate to heart disease prevalence.

## Dataset

Source (Kaggle / UCI):

https://www.kaggle.com/datasets/cherngs/heart-disease-cleveland-uci

> The dataset is not included in the repository.

## Tech stack

- PostgreSQL
- DBeaver
- SQL (no Python / no modeling)

## Project scope

The analysis focuses on:
- data sanity checks
- clinically meaningful grouping of features
- percentage-based comparison of disease prevalence

This is **EDA**, not a predictive model.

## Analysis steps

### 1. Data validation
- row count and preview
- NULL checks
- min / max range checks
- target distribution (`condition`)

### 2. Baseline statistics
- average age by disease status
- average cholesterol by disease status
- average resting blood pressure by disease status
- disease prevalence by sex

### 3. Feature bucketing (main analysis)

Clinical features were grouped into meaningful buckets:

- **Age**
  - `<50`
  - `50–60`
  - `>60`

- **Cholesterol**
  - `<200 mg/dL`
  - `≥200 mg/dL`

- **Resting blood pressure**
  - `<140 mmHg`
  - `≥140 mmHg`

For each bucket:
- total number of patients
- number of patients with heart disease
- percentage of patients with heart disease

### 4. Cross-factor comparison

To compare how strongly each factor differentiates disease prevalence:
- all bucket-level results were combined using `UNION ALL`
- for each factor, the difference between:
  - minimum % sick
  - maximum % sick  
  was calculated

This value is reported as:

**effect_pp** = difference in percentage points

## Key insight

Among the analyzed factors:
- **age** shows the strongest differentiation in disease prevalence
- blood pressure shows a moderate effect
- cholesterol shows a relatively smaller effect

This does not imply causation — only descriptive relationships.

## How to run

1. Create a PostgreSQL database
2. Import the dataset CSV into a table named `heart_data`
3. Run the SQL script top-to-bottom

## Limitations

- no statistical testing
- no confounder control
- simplified clinical thresholds
- dataset size is limited

---

This project demonstrates structured SQL-based reasoning, not medical conclusions.

