select 
nipos.nipos.customer_code ,
nipos.nipos.connote__connote_amount ,
nipos.nipos.connote__connote_surcharge_amount,
nipos.nipos.connote__connote_service_price,
nipos.nipos.custom_field__cod_value,
nipos.nipos.custom_field__free_beacod_value ,
nipos.nipos.koli_data__koli_custom_field__harga_barang,
custom_field__cod
from nipos.nipos
where nipos.nipos.custom_field__cod_value >1
limit 10