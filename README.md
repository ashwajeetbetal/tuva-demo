# Oncology Financials Analysis

## 1. Methodology
**Cohort Definition:**
I defined the "Active Oncology" population by filtering for ICD-10 diagnosis codes starting with 'C' (Malignant Neoplasms) in the `medical_claim` table. I excluded 'D' codes (In Situ) to focus on active malignancy.

**Architectural Decision - Claims-First Approach:**
Upon profiling the provided data, I discovered that the clinical seed files (`condition`, `encounter`) were unpopulated. To ensure the analysis was based on valid data, I refactored the pipeline to use `medical_claim` as the single source of truth:
* **Conditions:** Extracted from primary diagnosis codes (`diagnosis_code_1`) on claim lines.
* **Encounters:** Synthesized using a surrogate key (`patient_id` + `date`) from claims to proxy patient visits.

**Data Handling:**
* **Segmentation:** Patients were segmented by Cancer Type (Breast, Lung, Prostate, Colorectal) and Spend Bucket (High/Medium/Low).
* **Cost Profiling:** Spend was broken down into Facility (Institutional) vs. Professional settings to analyze whether costs are driven by hospital fees or provider services.

## 2. Key Findings
Based on the final data mart analysis:

* **Extreme Outliers:** The risk pool is heavily skewed by a few high-cost claimants. The top Lung Cancer patient (ID `11524`) generated **$2.23M** in total spend, and the top Breast Cancer patient (ID `10408`) generated **$1.74M**.
* **Care Setting Dichotomy:** There is a distinct difference in cost drivers between cancer types:
    * **Lung Cancer:** Costs are predominantly driven by **Facility Spend** (~84% for the top claimant), suggesting high inpatient usage.
    * **Breast Cancer:** Costs are heavily driven by **Professional Spend** (77%-100% for top claimants). For example, Patient `11512` had $807k in total spend with **$0** in facility costs, indicating a treatment regimen focused entirely on expensive outpatient/provider-administered therapies (e.g., biologics/chemotherapy).
* **Top Drivers:** In terms of individual patient severity, **Lung Cancer** and **Breast Cancer** represent the highest-cost specific cohorts in the top 10 rankings.

## 3. AI Usage Log
Per the assignment instructions, the following AI tools were used to accelerate the build:
* **Data Profiling:** Used AI to generate `dbt show` queries to profile the empty `observation` tables, which led to the discovery that diagnoses were only present in the `medical_claim` table.
* **Code Generation:** Leveraged AI to generate the SQL `CASE` logic for grouping ICD-10 codes (e.g., `C50%` -> Breast Cancer) and to write the surrogate key logic for synthesizing encounters.
* **Correction Log:** The AI initially suggested using the standard Tuva `condition` model. I had to correct this workflow after discovering the source seeds were empty, prompting the refactor to a Claims-based architecture.