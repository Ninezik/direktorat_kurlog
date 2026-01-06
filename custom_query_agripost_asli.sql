SELECT
s.name AS nama_kantor,
s.kota AS nopend_kckcu,
DATE(t.created_at) AS tanggal,
COUNT(DISTINCT t.id) AS jml_trx,
SUM(td.qty) AS total_qty,
SUM(t.total) AS total_sales,
-- Gross revenue
SUM((p.price - p.base) * td.qty) AS jumlah_revenue,
-- Revenue after tax (net)
SUM(((p.price - p.base) * td.qty) / 1.011) AS revenue_after_tax,
-- TAX = gross - net
SUM((p.price - p.base) * td.qty)
- SUM(((p.price - p.base) * td.qty) / 1.011) AS tax
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
s.name, s.kota, DATE(t.created_at)