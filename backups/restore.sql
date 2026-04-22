--
-- NOTE:
--
-- File paths need to be edited. Search for /opt/airflow/backups and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE fulldb;
--
-- Name: fulldb; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE fulldb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE fulldb OWNER TO postgres;

-- \connect fulldb

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: english_stem_nostop; Type: TEXT SEARCH DICTIONARY; Schema: public; Owner: postgres
--

CREATE TEXT SEARCH DICTIONARY public.english_stem_nostop (
    TEMPLATE = pg_catalog.snowball,
    language = 'english' );


ALTER TEXT SEARCH DICTIONARY public.english_stem_nostop OWNER TO postgres;

--
-- Name: english_nostop; Type: TEXT SEARCH CONFIGURATION; Schema: public; Owner: postgres
--

CREATE TEXT SEARCH CONFIGURATION public.english_nostop (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR asciiword WITH public.english_stem_nostop;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR word WITH public.english_stem_nostop;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR numword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR email WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR url WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR host WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR sfloat WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR version WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR hword_numpart WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR hword_part WITH public.english_stem_nostop;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR hword_asciipart WITH public.english_stem_nostop;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR numhword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR asciihword WITH public.english_stem_nostop;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR hword WITH public.english_stem_nostop;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR url_path WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR file WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR "float" WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR "int" WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.english_nostop
    ADD MAPPING FOR uint WITH simple;


ALTER TEXT SEARCH CONFIGURATION public.english_nostop OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: album_relation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.album_relation (
    relatedid text,
    baseid text
);


ALTER TABLE public.album_relation OWNER TO postgres;

--
-- Name: albums; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.albums (
    id text NOT NULL,
    title text,
    artwork text,
    type text,
    year integer
);


ALTER TABLE public.albums OWNER TO postgres;

--
-- Name: artist_album; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artist_album (
    artist_id text NOT NULL,
    album_id text NOT NULL
);


ALTER TABLE public.artist_album OWNER TO postgres;

--
-- Name: artist_track; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artist_track (
    artist_id text NOT NULL,
    track_id text NOT NULL
);


ALTER TABLE public.artist_track OWNER TO postgres;

--
-- Name: artists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artists (
    id text NOT NULL,
    name text,
    profile_photo text,
    subscribers integer
);


ALTER TABLE public.artists OWNER TO postgres;

--
-- Name: features_track; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.features_track (
    artist_id text NOT NULL,
    track_id text NOT NULL
);


ALTER TABLE public.features_track OWNER TO postgres;

--
-- Name: playbacks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.playbacks (
    id text NOT NULL,
    audio_ytid text,
    video_ytid text,
    audio_live text,
    is_explicit integer
);


ALTER TABLE public.playbacks OWNER TO postgres;

--
-- Name: tracks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tracks (
    id text NOT NULL,
    playback_clean text,
    playback_explicit text,
    mxid text,
    title text,
    runtime_seconds integer,
    views integer,
    album_index integer,
    album text,
    titletrgm text,
    albumtrgm text,
    artiststrgm text,
    title_vector tsvector,
    album_vector tsvector,
    artist_vector tsvector,
    combined_vector tsvector
);


ALTER TABLE public.tracks OWNER TO postgres;

--
-- Data for Name: album_relation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.album_relation (relatedid, baseid) FROM stdin;
\.
COPY public.album_relation (relatedid, baseid) FROM '/opt/airflow/backups/3705.dat';

--
-- Data for Name: albums; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.albums (id, title, artwork, type, year) FROM stdin;
\.
COPY public.albums (id, title, artwork, type, year) FROM '/opt/airflow/backups/3702.dat';

--
-- Data for Name: artist_album; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artist_album (artist_id, album_id) FROM stdin;
\.
COPY public.artist_album (artist_id, album_id) FROM '/opt/airflow/backups/3706.dat';

--
-- Data for Name: artist_track; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artist_track (artist_id, track_id) FROM stdin;
\.
COPY public.artist_track (artist_id, track_id) FROM '/opt/airflow/backups/3707.dat';

--
-- Data for Name: artists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artists (id, name, profile_photo, subscribers) FROM stdin;
\.
COPY public.artists (id, name, profile_photo, subscribers) FROM '/opt/airflow/backups/3701.dat';

--
-- Data for Name: features_track; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.features_track (artist_id, track_id) FROM stdin;
\.
COPY public.features_track (artist_id, track_id) FROM '/opt/airflow/backups/3708.dat';

--
-- Data for Name: playbacks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.playbacks (id, audio_ytid, video_ytid, audio_live, is_explicit) FROM stdin;
\.
COPY public.playbacks (id, audio_ytid, video_ytid, audio_live, is_explicit) FROM '/opt/airflow/backups/3703.dat';

--
-- Data for Name: tracks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tracks (id, playback_clean, playback_explicit, mxid, title, runtime_seconds, views, album_index, album, titletrgm, albumtrgm, artiststrgm, title_vector, album_vector, artist_vector, combined_vector) FROM stdin;
\.
COPY public.tracks (id, playback_clean, playback_explicit, mxid, title, runtime_seconds, views, album_index, album, titletrgm, albumtrgm, artiststrgm, title_vector, album_vector, artist_vector, combined_vector) FROM '/opt/airflow/backups/3704.dat';

--
-- Name: album_relation album_relation_relatedid_baseid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album_relation
    ADD CONSTRAINT album_relation_relatedid_baseid_key UNIQUE (relatedid, baseid);


--
-- Name: albums albums_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (id);


--
-- Name: artist_album artist_album_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_album
    ADD CONSTRAINT artist_album_pkey PRIMARY KEY (artist_id, album_id);


--
-- Name: artist_track artist_track_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_track
    ADD CONSTRAINT artist_track_pkey PRIMARY KEY (artist_id, track_id);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: features_track features_track_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.features_track
    ADD CONSTRAINT features_track_pkey PRIMARY KEY (artist_id, track_id);


--
-- Name: playbacks playbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playbacks
    ADD CONSTRAINT playbacks_pkey PRIMARY KEY (id);


--
-- Name: tracks tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (id);


--
-- Name: albums_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX albums_id_idx ON public.albums USING btree (id);


--
-- Name: albums_year_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX albums_year_idx ON public.albums USING btree (year);


--
-- Name: artist_track_artist_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX artist_track_artist_id_idx ON public.artist_track USING btree (artist_id);


--
-- Name: artist_track_track_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX artist_track_track_id_idx ON public.artist_track USING btree (track_id);


--
-- Name: artists_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX artists_id_idx ON public.artists USING btree (id);


--
-- Name: features_track_artist_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX features_track_artist_id_idx ON public.features_track USING btree (artist_id);


--
-- Name: features_track_track_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX features_track_track_id_idx ON public.features_track USING btree (track_id);


--
-- Name: idx_track_album_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_track_album_id ON public.tracks USING btree (album);


--
-- Name: idx_tracks_views; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tracks_views ON public.tracks USING btree (views);


--
-- Name: relatedid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX relatedid_idx ON public.album_relation USING btree (relatedid);


--
-- Name: tracks_album_trgm_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tracks_album_trgm_idx ON public.tracks USING gin (albumtrgm public.gin_trgm_ops);


--
-- Name: tracks_album_vector_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tracks_album_vector_idx ON public.tracks USING gin (album_vector);


--
-- Name: tracks_artist_vector_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tracks_artist_vector_idx ON public.tracks USING gin (artist_vector);


--
-- Name: tracks_artists_trgm_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tracks_artists_trgm_idx ON public.tracks USING gin (artiststrgm public.gin_trgm_ops);


--
-- Name: tracks_combined_vector_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tracks_combined_vector_idx ON public.tracks USING gin (combined_vector);


--
-- Name: tracks_title_trgm_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tracks_title_trgm_idx ON public.tracks USING gin (titletrgm public.gin_trgm_ops);


--
-- Name: tracks_title_vector_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tracks_title_vector_idx ON public.tracks USING gin (title_vector);


--
-- Name: artist_album artist_album_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_album
    ADD CONSTRAINT artist_album_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.albums(id);


--
-- Name: artist_album artist_album_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_album
    ADD CONSTRAINT artist_album_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artists(id);


--
-- Name: artist_track artist_track_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_track
    ADD CONSTRAINT artist_track_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artists(id);


--
-- Name: artist_track artist_track_track_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_track
    ADD CONSTRAINT artist_track_track_id_fkey FOREIGN KEY (track_id) REFERENCES public.tracks(id);


--
-- Name: features_track features_track_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.features_track
    ADD CONSTRAINT features_track_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artists(id);


--
-- Name: features_track features_track_track_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.features_track
    ADD CONSTRAINT features_track_track_id_fkey FOREIGN KEY (track_id) REFERENCES public.tracks(id);


--
-- Name: tracks tracks_album_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_album_fkey FOREIGN KEY (album) REFERENCES public.albums(id);


--
-- Name: tracks tracks_playback_clean_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_playback_clean_fkey FOREIGN KEY (playback_clean) REFERENCES public.playbacks(id);


--
-- Name: tracks tracks_playback_explicit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tracks
    ADD CONSTRAINT tracks_playback_explicit_fkey FOREIGN KEY (playback_explicit) REFERENCES public.playbacks(id);


--
-- PostgreSQL database dump complete
--

