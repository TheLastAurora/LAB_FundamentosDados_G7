WITH album_tracks AS (

    SELECT
        album,
        COUNT(*) AS total_tracks
    FROM {{ ref('silver_tracks') }}
    GROUP BY album

),

album_views AS (

    SELECT
        album,
        SUM(views) AS total_views,
        AVG(views) AS avg_views
    FROM {{ ref('silver_tracks') }}
    GROUP BY album

)

SELECT
    a.id AS album_id,
    a.title,
    a.type,
    a.year,

    COALESCE(at.total_tracks, 0) AS total_tracks,
    COALESCE(av.total_views, 0) AS total_views,
    COALESCE(av.avg_views, 0) AS avg_views

FROM {{ ref('silver_albums') }} a
LEFT JOIN album_tracks at
    ON a.id = at.album
LEFT JOIN album_views av
    ON a.id = av.album
