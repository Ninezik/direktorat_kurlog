select 
 date_trunc('month', nipos.connote__created_at) AS connote_month,
    nipos.location_data_created__custom_field__nopen,
    nipos.custom_field__destination_nopen,
    nipos.connote__connote_service,
    round(nipos.connote__connote_service_price / greatest(floor(connote__chargeable_weight),1)
    )nilai,
    COUNT(*) AS jumlah,
    ROW_NUMBER() OVER (
        PARTITION BY 
            nipos.location_data_created__custom_field__nopen,
            nipos.custom_field__destination_nopen,
            nipos.connote__connote_service
        ORDER BY date_trunc('month', nipos.connote__created_at) desc ,COUNT(*) desc,nilai DESC
    ) AS rank_service
from nipos.nipos
WHERE nipos.connote__connote_state NOT IN ('CANCEL','PENDING')
and nipos.location_data_created__custom_field__nopen is not null
and nipos.custom_field__destination_nopen  is not NULL
AND nipos.connote__connote_service != 'PJB'
and nipos.connote__connote_service !='LNINCOMING'
and nipos.connote__create_from !='POSINDOOUTGOING'
and nipos.connote__connote_service_price >1000
and connote__created_at>'20240101'
GROUP BY 1,2,3,4,5
limit 10
