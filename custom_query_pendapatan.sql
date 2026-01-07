select
DATE(connote__created_at) AS connote__created_at,
UPPER(customer_code) AS customer_code,
upper(custom_field__jenis_barang)custom_field__jenis_barang,
location_data_created__custom_field__nokprk,
UPPER(transform__channel)transform__channel,
UPPER(connote__connote_service) AS connote__connote_service,
connote_sender_custom_field__pks_no__to_be_verified,
SUM(connote__connote_amount)connote__connote_amount,
COUNT(connote__connote_code)connote__connote_code,
SUM(connote__chargeable_weight)connote__chargeable_weight,
SUM(connote__connote_amount)/(1+(1.1/100)) as pendapatan,
SUM(connote__connote_amount)-SUM(connote__connote_amount)/(1+(1.1/100)) as pajak,
SUM(
CASE
-- Hitung fee hanya jika benar-benar COD dan bukan Shopee
WHEN (UPPER(custom_field__cod)!='NONCOD'
AND (customer_code!='DAGSHOPEE04120A'
or nipos.customer_code is null))
THEN
CASE
WHEN koli_data__koli_custom_field__harga_barang < 100000
THEN 2000
WHEN customer_code IN ('LOGKIRIMAJA04550A','LOGAUTOKIRIM05603A','LOGAUTOKIRM05603A')
THEN koli_data__koli_custom_field__harga_barang * 0.015
WHEN customer_code = 'LOGBOSAMPUH04563A'
THEN koli_data__koli_custom_field__harga_barang * 0.01
ELSE koli_data__koli_custom_field__harga_barang * 0.02
END
ELSE 0
END
) AS fee_cod
FROM nipos.nipos
WHERE connote__created_at > '20260106'
AND UPPER(connote__location_name) != 'AGP TESTING LOCATION'
AND UPPER(connote__connote_state) NOT IN ('CANCEL','PENDING')
AND connote__connote_service != 'LNINCOMING'
GROUP BY
1,2,3,4,5,6,7