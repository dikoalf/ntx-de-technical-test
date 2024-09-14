-- menghitung metrik rata-rata per pengguna
WITH UserMetrics AS (
    SELECT
        fullVisitorId,
        AVG(timeOnSite) AS avgTimeOnSite,  -- Rata-rata waktu di situs per pengunjung
        AVG(pageviews) AS avgPageviews,  -- Rata-rata jumlah halaman yang dilihat per pengunjung
        AVG(sessionQualityDim) AS avgSessionQualityDim  -- Rata-rata kualitas sesi per pengunjung
    FROM
        ecommerce_sessions
    GROUP BY
        fullVisitorId  -- Mengelompokkan hasil berdasarkan ID pengunjung
),

-- menghitung metrik rata-rata keseluruhan
OverallAverages AS (
    SELECT
        AVG(avgTimeOnSite) AS avgOverallTimeOnSite,  -- Rata-rata waktu di situs untuk semua pengguna
        AVG(avgPageviews) AS avgOverallPageviews  -- Rata-rata jumlah halaman yang dilihat untuk semua pengguna
    FROM
        UserMetrics  -- Menggunakan hasil dari UserMetrics
),

-- mengidentifikasi pengguna yang menghabiskan waktu di situs lebih lama dari rata-rata tetapi melihat halaman lebih sedikit
AboveAverageUsers AS (
    SELECT
        um.fullVisitorId,
        um.avgTimeOnSite,
        um.avgPageviews,
        oa.avgOverallTimeOnSite,
        oa.avgOverallPageviews
    FROM
        UserMetrics um  -- Menggunakan hasil dari UserMetrics
    CROSS JOIN
        OverallAverages oa  -- Menggunakan hasil dari OverallAverages
    WHERE
        um.avgTimeOnSite > oa.avgOverallTimeOnSite  -- Menghabiskan waktu di situs lebih lama dari rata-rata
        AND um.avgPageviews < oa.avgOverallPageviews  -- Melihat halaman lebih sedikit dari rata-rata
)

-- menampilkan hasil akhir
SELECT
    fullVisitorId,
    avgTimeOnSite,
    avgPageviews,
    avgOverallTimeOnSite,
    avgOverallPageviews
FROM
    AboveAverageUsers  -- Menggunakan hasil dari AboveAverageUsers
ORDER BY
    avgTimeOnSite DESC;  -- Mengurutkan hasil berdasarkan waktu di situs secara menurun
