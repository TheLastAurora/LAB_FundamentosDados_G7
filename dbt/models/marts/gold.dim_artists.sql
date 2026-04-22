WITH artist_tracks AS (

    SELECT
        at.artist_id,
        COUNT(DISTINCT at.track_id) AS total_tracks
    FROM {{ ref('silver_artist_track') }} at
    GROUP BY at.artist_id

),

artist_views AS (

    SELECT
        at.artist_id,
        SUM(t.views) AS total_views,
        AVG(t.views) AS avg_views
    FROM {{ ref('silver_artist_track') }} at
    JOIN {{ ref('silver_tracks') }} t
        ON at.track_id = t.id
    GROUP BY at.artist_id

)

SELECT
    a.id AS artist_id,
    a.name,
    a.subscribers,

    COALESCE(at.total_tracks, 0) AS total_tracks,
    COALESCE(av.total_views, 0) AS total_views,
    COALESCE(av.avg_views, 0) AS avg_views,

    RANK() OVER (ORDER BY COALESCE(av.total_views,0) DESC) AS ranking_popularity

FROM {{ ref('silver_artists') }} a
LEFT JOIN artist_tracks at
    ON a.id = at.artist_id
LEFT JOIN artist_views av
    ON a.id = av.artist_id
