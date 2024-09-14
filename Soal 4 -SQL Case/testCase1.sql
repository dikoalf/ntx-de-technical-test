 -- menghitung total pendapatan untuk setiap negara
WITH TotalRevenuePerCountry AS (
    SELECT
        country,
        COALESCE(SUM(totalTransactionRevenue), 0) AS totalRevenue  -- Total pendapatan, menggantikan NULL dengan 0
    FROM
        ecommerce_sessions
    GROUP BY
        country  -- Mengelompokkan hasil berdasarkan negara
),

-- memilih 5 negara dengan total pendapatan tertinggi
Top5Countries AS (
    -- Mengurutkan negara berdasarkan total pendapatan dan memilih 5 negara teratas
    SELECT
        country
    FROM
        TotalRevenuePerCountry  -- Menggunakan hasil dari TotalRevenuePerCountry
    ORDER BY
        totalRevenue DESC  -- Mengurutkan negara dari yang memiliki pendapatan tertinggi ke terendah
    LIMIT 5  -- Memilih hanya 5 negara teratas
),

-- menghitung total pendapatan per channel grouping untuk negara-negara teratas
RevenueByChannelForTopCountries AS (
    -- Menghitung total pendapatan per channel grouping untuk negara-negara yang terpilih
    SELECT
        es.channelGrouping,
        es.country,
        COALESCE(SUM(es.totalTransactionRevenue), 0) AS totalRevenue  -- Total pendapatan untuk setiap channel grouping, menggantikan NULL dengan 0
    FROM
        ecommerce_sessions es
    JOIN
        Top5Countries top5
    ON
        es.country = top5.country
    GROUP BY
        es.channelGrouping,  -- Mengelompokkan hasil berdasarkan channel grouping
        es.country  -- Mengelompokkan hasil berdasarkan negara
)

-- menampilkan hasil akhir
SELECT
    channelGrouping,
    country,
    totalRevenue
FROM
    RevenueByChannelForTopCountries  -- Menggunakan hasil dari RevenueByChannelForTopCountries
ORDER BY
    country,  -- Mengurutkan hasil berdasarkan negara
    totalRevenue DESC;  -- Mengurutkan total pendapatan dalam urutan menurun
