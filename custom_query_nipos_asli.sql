SELECT
    DATE(connote__created_at)connote__created_at,
    UPPER(customer_code)customer_code,
UPPER(nipos.custom_field__jenis_barang)custom_field__jenis_barang,
    location_data_created__custom_field__nokprk,
    UPPER(transform__channel)transform__channel,
    UPPER(connote__connote_service)connote__connote_service,
    connote_sender_custom_field__pks_no__to_be_verified,
    SUM(connote__connote_amount)connote__connote_amount,
    COUNT(connote__connote_code)connote__connote_code,
(SUM(connote__connote_service_price)* 1000) / 1011 AS beadasar,  
(SUM(connote__connote_surcharge_amount)*  100) /  111 AS htnb,       
(SUM(connote__connote_service_price)*11) / 1011 AS ppn,        
(SUM(connote__connote_surcharge_amount *   11) /  111) AS ppnthnb,
SUM(connote__chargeable_weight)connote__chargeable_weight
FROM nipos.nipos
where connote__created_at>'20260101'
and UPPER(nipos.connote__location_name) !='AGP TESTING LOCATION'
and UPPER(nipos.connote__connote_state) not in ('CANCEL','PENDING')
GROUP BY 1,2,3,4,5,6,7