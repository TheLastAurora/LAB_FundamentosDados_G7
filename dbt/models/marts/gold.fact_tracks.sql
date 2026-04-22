WITH base AS (

    SELECT
        t.id AS track_id,
        t.title,
        t.runtime_seconds,
        t.views,
        t.album,
        t.album_index,

        p.is_explicit,
        p.audio_live,

        CASE
            WHEN p.audio_live IS NOT NULL THEN 'Live'
            ELSE 'Studio'
        END AS content_type

    FROM {{ ref('silver_tracks') }} t
    LEFT JOIN {{ ref('silver_playbacks') }} p
        ON t.playback_clean = p.id

),

features AS (

    SELECT
        ft.track_id,
        COUNT(ft.artist_id) AS qtd_artistas_feat
    FROM {{ ref('silver_features_track') }} ft
    GROUP BY ft.track_id

)

SELECT
    b.track_id,
    b.title,
    b.runtime_seconds,
    b.views,

    b.album AS album_id,
    b.album_index,

    b.is_explicit,
    b.content_type,

    COALESCE(f.qtd_artistas_feat, 1) AS qtd_artistas,

    -- Classificação de conteúdo
    CASE
        WHEN b.is_explicit = 1 THEN 'Explicit'
        ELSE 'Clean'
    END AS explicit_flag,

    -- Faixa de popularidade
    CASE
        WHEN b.views >= 1000000 THEN 'Hit'
        WHEN b.views >= 100000 THEN 'Medium'
        ELSE 'Low'
    END AS popularity_tier

FROM base b
LEFT JOIN features f
    ON b.track_id = f.track_id
