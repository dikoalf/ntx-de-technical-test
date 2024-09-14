-- menghitung total pendapatan untuk setiap produk
WITH ProductPerformance AS (
    SELECT
        v2ProductName,
        COALESCE(SUM(totalTransactionRevenue), 0) AS totalRevenue,  -- Total pendapatan untuk produk, menggantikan NULL dengan 0
        COALESCE(SUM(productQuantity), 0) AS totalQuantity,  -- Total kuantitas terjual untuk produk, menggantikan NULL dengan 0
        COALESCE(SUM(productRefundAmount), 0) AS totalRefunds  -- Total jumlah pengembalian untuk produk, menggantikan NULL dengan 0
    FROM
        ecommerce_sessions
    GROUP BY
        v2ProductName  -- Mengelompokkan hasil berdasarkan nama produk
),

-- menghitung pendapatan bersih dan flag pengembalian produk
ProductNetRevenue AS (
    SELECT
        v2ProductName, 
        totalRevenue,  
        totalQuantity, 
        totalRefunds, 
        totalRevenue - totalRefunds AS netRevenue,  -- Pendapatan bersih (total pendapatan dikurangi pengembalian)
        CASE
            WHEN totalRefunds > 0.1 * totalRevenue THEN 'High Refund'  -- Menandai produk dengan pengembalian melebihi 10% dari total pendapatan
            ELSE 'Normal'  -- Produk dengan pengembalian 10% atau kurang dari total pendapatan
        END AS refundFlag  -- Flag pengembalian untuk produk
    FROM
        ProductPerformance  -- Menggunakan hasil dari ProductPerformance
)

-- menampilkan hasil akhir dan mengurutkan produk berdasarkan pendapatan bersih
SELECT
    v2ProductName,
    totalRevenue,
    totalQuantity, 
    totalRefunds,
    netRevenue, 
    refundFlag
FROM
    ProductNetRevenue  -- Menggunakan hasil dari ProductNetRevenue
ORDER BY
    netRevenue DESC;  -- Mengurutkan produk berdasarkan pendapatan bersih dalam urutan menurun
