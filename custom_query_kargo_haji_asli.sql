SELECT date(created_at)created_at ,
COUNT(distinct no_resi)jumlah_trx,
SUM(total_fee_idr )total_fee_idr,
SUM(packing_price_idr )packing_price_idr,
SUM(total_weight )total_weight
FROM kargo.kargo_haji_kolekting
where UPPER(status)='MANIFEST'
and is_paid='t'
group by 1