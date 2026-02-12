with conditions as (
    select * from {{ ref('stg_conditions') }}
),

active_cancer as (
    select distinct
        patient_id,
        icd_10_code,
        condition_description,
        diagnosis_date,
        -- Categorize top cancer types for reporting
        case 
            when upper(icd_10_code) like 'C50%' then 'Breast Cancer'
            when upper(icd_10_code) like 'C34%' then 'Lung Cancer'
            when upper(icd_10_code) like 'C61%' then 'Prostate Cancer'
            when upper(icd_10_code) like 'C18%' or upper(icd_10_code) like 'C19%' or upper(icd_10_code) like 'C20%' then 'Colorectal Cancer'
            else 'Other Oncology'
        end as cancer_type
    from conditions
    where upper(icd_10_code) like 'C%' -- Active Malignancy
)

select * from active_cancer