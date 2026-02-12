with cohort as (
    select * from {{ ref('int_active_cancer_patients') }}
),

claims as (
    select * from {{ ref('stg_medical_claim') }}
),

patient_spend as (
    select
        c.patient_id,
        c.cancer_type,
        
        -- Aggregate Metrics
        count(distinct cl.claim_id) as total_claims,
        sum(cl.paid_amount) as total_paid_amount,
        
        -- Cost Profiling by Care Setting
        -- Institutional = Facility fees (Inpatient/Outpatient Hospitals)
        sum(case when cl.claim_type = 'institutional' then cl.paid_amount else 0 end) as facility_spend,
        -- Professional = Physician fees
        sum(case when cl.claim_type = 'professional' then cl.paid_amount else 0 end) as professional_spend

    from cohort c
    inner join claims cl 
        on c.patient_id = cl.patient_id
    group by 1, 2
)

select 
    *,
    -- Segmentation by Spend Bucket
    case 
        when total_paid_amount >= 50000 then 'High Spend (> $50k)'
        when total_paid_amount >= 10000 then 'Medium Spend ($10k-$50k)'
        else 'Low Spend (< $10k)'
    end as spend_bucket
from patient_spend
order by total_paid_amount desc