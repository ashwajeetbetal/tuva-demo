select
    -- Primary Keys
    claim_id,
    claim_line_number,
    person_id as patient_id,

    -- Financials
    paid_amount,
    allowed_amount,
    total_cost_amount,

    -- Dimensions
    claim_type,
    claim_start_date,
    claim_end_date,
    hcpcs_code as procedure_code
from {{ ref('medical_claim') }}