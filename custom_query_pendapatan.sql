select
DATE(connote__created_at) AS connote__created_at,
date_part('hour',connote__created_at)jam,
UPPER(customer_code) AS customer_code,
upper(custom_field__jenis_barang)custom_field__jenis_barang,
location_data_created__custom_field__nokprk,
UPPER(transform__channel)transform__channel,
UPPER(connote__connote_service) AS connote__connote_service,
connote_sender_custom_field__pks_no__to_be_verified,
SUM(connote__connote_amount)connote__connote_amount,
COUNT(connote__connote_code)connote__connote_code,
SUM(
  CASE 
    WHEN UPPER(custom_field__jenis_barang) LIKE '%DOC%'
      OR UPPER(custom_field__jenis_barang) LIKE '%DOK%'
      OR custom_field__jenis_barang IS NULL
    THEN connote__connote_amount
    ELSE connote__connote_amount/(1+(1.1/100))
  END
) AS pendapatan,
SUM(
  CASE 
    WHEN UPPER(custom_field__jenis_barang) LIKE '%DOC%'
      OR UPPER(custom_field__jenis_barang) LIKE '%DOK%'
      OR custom_field__jenis_barang IS NULL
    THEN 0
    ELSE connote__connote_amount-(connote__connote_amount/(1+(1.1/100)))
  END
) AS pajak,
SUM(
CASE
-- COD dan bukan Shopee
WHEN UPPER(custom_field__cod)!='NONCOD'
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
) AS fee_cod,
'NIPOS' sumber,
SUM(nipos.nipos.connote__chargeable_weight)connote__chargeable_weight
FROM nipos.nipos
WHERE connote__created_at > '20250101'
AND UPPER(connote__location_name) != 'AGP TESTING LOCATION'
AND UPPER(connote__connote_state) NOT IN ('CANCEL','PENDING')
AND connote__connote_service != 'LNINCOMING'
AND NOT (
    UPPER(nipos.customer_code) = 'DAGSHOPEE04120A'
    AND UPPER(nipos.custom_field__cod)!= 'NONCOD'
)
GROUP BY
1,2,3,4,5,6,7,8

union
SELECT
DATE(t.created_at) connote__created_at,
date_part('hour',t.created_at)jam,
'AGRIPOS' customer_code,
'AGRIPOS' custom_field__jenis_barang,
s.kota location_data_created__custom_field__nokprk,
'AGRIPOS' transform__channel,
'AGRIPOS' connote__connote_service,
null connote_sender_custom_field__pks_no__to_be_verified,
SUM(t.total) connote__connote_amount,
COUNT(DISTINCT t.id) connote__connote_code,
SUM(((p.price - p.base) * td.qty) / (1+(1.1/100))) pendapatan,
SUM((p.price - p.base) * td.qty)
- SUM(((p.price - p.base) * td.qty) / (1+(1.1/100))) pajak,
0 fee_cod,
'AGRIPOS' sumber,
SUM(td.qty)*5 connote__chargeable_weight
FROM agripost.transactions t
LEFT JOIN agripost.transaction_details td
ON t.id = td.transaction_id
LEFT JOIN agripost.stores s
ON t.store_id = s.id
LEFT JOIN agripost.products p
ON td.product_id = p.id
WHERE t.store_id NOT IN (1,2,3,4,5,6,7,8,9,10,11,12)
and UPPER(t.status) ='SELESAI'
GROUP BY
1,2,3,4,5,6,7,8


union
SELECT date(created_at)created_at ,
date_part('hour',created_at)jam,
'KARGO HAJI' customer_code,
'KARGO HAJI' custom_field__jenis_barang,
'KARGO HAJI' location_data_created__custom_field__nokprk,
'KARGO HAJI'  transform__channel,
'KARGO HAJI'  connote__connote_service,
null connote_sender_custom_field__pks_no__to_be_verified,
SUM(total_fee_idr)connote__connote_amount,
COUNT(distinct no_resi)connote__connote_code,
SUM(total_fee_idr)/(1+(1.1/100)) pendapatan,
SUM(total_fee_idr)-(SUM(total_fee_idr)/(1+(1.1/100))) pajak,
0 fee_cod,
'KARGO HAJI' sumber,
SUM(total_weight)connote__chargeable_weight
FROM kargo.kargo_haji_kolekting
where UPPER(status)='MANIFEST'
and is_paid='t'
GROUP BY
1,2,3,4,5,6,7,8

union
SELECT  
    date(wkt_payment) AS connote__created_at,
    date_part('hour',wkt_payment)jam,
    'LN_INCOMING_VA' AS customer_code,
    'LN_INCOMING_VA' AS custom_field__jenis_barang,
    'LN_INCOMING_VA' AS location_data_created__custom_field__nokprk,
    'LN_INCOMING_VA' AS transform__channel,
    'LN_INCOMING_VA' AS connote__connote_service,
    'LN_INCOMING_VA' AS connote_sender_custom_field__pks_no__to_be_verified,
    SUM(BSU_BLB + BSU_BEASIMPAN + BSU_HANDLING + ppn_blb + ppn_beasimpan + ppn_handling) AS connote__connote_amount,
    COUNT(distinct va_number) AS connote__connote_code,
    SUM(BSU_BLB + BSU_BEASIMPAN + BSU_HANDLING) AS pendapatan,
    SUM(ppn_blb + ppn_beasimpan + ppn_handling) AS pajak,
    0 AS fee_cod,
    'LN_INCOMING_VA' sumber,
    SUM(jml_berat)connote__chargeable_weight
FROM posint.LN_INCOMING_VA
group by 1,2,3,4,5,6,7,8

union
SELECT 
    date(tgl_billing) connote__created_at,
    date_part('hour',tgl_billing::timestamp)jam,
    customer_code,
    'GLID'  custom_field__jenis_barang,
    kode_nopen location_data_created__custom_field__nokprk,
    'GLID' transform__channel,
    service_code connote__connote_service,
    'GLID' connote_sender_custom_field__pks_no__to_be_verified,
    SUM(total_amount)  connote__connote_amount,
    COUNT(DISTINCT order_code) connote__connote_code,
    SUM(
        CASE 
            WHEN LOWER(jenis_produk) LIKE '%include%'
            THEN total_amount / (1+(1.1/100))
            ELSE total_amount 
        END
    ) AS pendapatan,
    SUM(
        total_amount - 
        (CASE 
            WHEN LOWER(jenis_produk) LIKE '%include%'
            THEN total_amount /(1+(1.1/100))
            ELSE total_amount 
        END)
    ) AS pajak,
    0 AS fee_cod,
    'GLID' sumber, 
    SUM(0)connote__chargeable_weight
FROM glid.glid g 
GROUP BY 
1,2,3,4,5,6,7,8

union
SELECT 
    date(connote__created_at) AS connote__created_at, 
    date_part('hour',connote__created_at)jam,
    customer_code, 
    custom_field__jenis_barang, 
    location_data_created__custom_field__nokprk, 
    transform__channel, 
    connote__connote_service, 
    connote_sender_custom_field__pks_no__to_be_verified,
    SUM(connote__connote_amount)connote__connote_amount, 
    COUNT(connote__connote_code)connote__connote_code,
    SUM(connote__connote_amount)/(1+(1.1/100)) as pendapatan,
    SUM(connote__connote_amount)-SUM(connote__connote_amount)/(1+(1.1/100)) as pajak,
    SUM(goods_value)*(0.5/100) fee_cod,
    'SHOPEE COD' sumber,
    SUM(0)connote__chargeable_weight
FROM nipos.v_shopee_cod_detail
GROUP BY 1,2,3,4,5,6,7,8