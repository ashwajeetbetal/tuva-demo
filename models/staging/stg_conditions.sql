select
    -- Create a surrogate key or use claim_id
    claim_id as condition_id, 
    person_id as patient_id,

    -- Use primary diagnosis code from claims as ICD-10 code
    diagnosis_code_1 as icd_10_code,
    
    -- Hardcode description since claims tables often lack descriptions
    'Primary Claim Diagnosis' as condition_description, 
    
    claim_start_date as diagnosis_date,
    'medical_claim' as source_table

from {{ ref('medical_claim') }}
where diagnosis_code_1 is not null