select
    -- Generate a Surrogate Key for Encounter ID
    -- Logic: One encounter per patient per day
    md5(cast(person_id as varchar) || cast(claim_start_date as varchar)) as encounter_id,    
    person_id as patient_id,
    
    -- Dates
    claim_start_date as encounter_start_date,
    claim_end_date as encounter_end_date,
    
    -- Type (Use Claim Type as a proxy for Encounter Type)
    -- e.g. 'professional' = Office Visit, 'institutional' = Hospital Stay
    claim_type as encounter_type,
    
    place_of_service_code as location_id,
    'medical_claim' as source_table

from {{ ref('medical_claim') }}
where claim_start_date is not null