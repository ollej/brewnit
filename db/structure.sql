--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

--
-- Name: medal; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE medal AS ENUM (
    'gold',
    'silver',
    'bronze'
);


--
-- Name: swedish; Type: TEXT SEARCH DICTIONARY; Schema: public; Owner: -
--

CREATE TEXT SEARCH DICTIONARY swedish (
    TEMPLATE = pg_catalog.ispell,
    dictfile = 'sv_se', afffile = 'sv_se', stopwords = 'swedish' );


--
-- Name: swedish_snowball_dict; Type: TEXT SEARCH DICTIONARY; Schema: public; Owner: -
--

CREATE TEXT SEARCH DICTIONARY swedish_snowball_dict (
    TEMPLATE = pg_catalog.snowball,
    language = 'swedish', stopwords = 'swedish' );


--
-- Name: swedish_stem; Type: TEXT SEARCH DICTIONARY; Schema: public; Owner: -
--

CREATE TEXT SEARCH DICTIONARY swedish_stem (
    TEMPLATE = pg_catalog.snowball,
    language = 'swedish', stopwords = 'swedish' );


--
-- Name: brewnit_swedish; Type: TEXT SEARCH CONFIGURATION; Schema: public; Owner: -
--

CREATE TEXT SEARCH CONFIGURATION brewnit_swedish (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION brewnit_swedish
    ADD MAPPING FOR asciiword WITH swedish_stem;

ALTER TEXT SEARCH CONFIGURATION brewnit_swedish
    ADD MAPPING FOR word WITH swedish_stem;

ALTER TEXT SEARCH CONFIGURATION brewnit_swedish
    ADD MAPPING FOR hword_part WITH swedish_stem;

ALTER TEXT SEARCH CONFIGURATION brewnit_swedish
    ADD MAPPING FOR hword_asciipart WITH swedish_stem;

ALTER TEXT SEARCH CONFIGURATION brewnit_swedish
    ADD MAPPING FOR asciihword WITH swedish_stem;

ALTER TEXT SEARCH CONFIGURATION brewnit_swedish
    ADD MAPPING FOR hword WITH swedish_stem;


--
-- Name: swedish; Type: TEXT SEARCH CONFIGURATION; Schema: public; Owner: -
--

CREATE TEXT SEARCH CONFIGURATION swedish (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR asciiword WITH swedish_stem;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR word WITH swedish_stem;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR numword WITH simple;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR email WITH simple;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR url WITH simple;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR host WITH simple;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR sfloat WITH simple;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR version WITH simple;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR hword_numpart WITH simple;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR hword_part WITH swedish_stem;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR hword_asciipart WITH swedish_stem;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR numhword WITH simple;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR asciihword WITH swedish_stem;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR hword WITH swedish_stem;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR url_path WITH simple;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR file WITH simple;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR "float" WITH simple;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR "int" WITH simple;

ALTER TEXT SEARCH CONFIGURATION swedish
    ADD MAPPING FOR uint WITH simple;


--
-- Name: swedish_snowball; Type: TEXT SEARCH CONFIGURATION; Schema: public; Owner: -
--

CREATE TEXT SEARCH CONFIGURATION swedish_snowball (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION swedish_snowball
    ADD MAPPING FOR asciiword WITH swedish, swedish_snowball_dict;

ALTER TEXT SEARCH CONFIGURATION swedish_snowball
    ADD MAPPING FOR word WITH swedish, swedish_snowball_dict;

ALTER TEXT SEARCH CONFIGURATION swedish_snowball
    ADD MAPPING FOR hword_part WITH swedish, swedish_snowball_dict;

ALTER TEXT SEARCH CONFIGURATION swedish_snowball
    ADD MAPPING FOR hword_asciipart WITH swedish, swedish_snowball_dict;

ALTER TEXT SEARCH CONFIGURATION swedish_snowball
    ADD MAPPING FOR asciihword WITH swedish, swedish_snowball_dict;

ALTER TEXT SEARCH CONFIGURATION swedish_snowball
    ADD MAPPING FOR hword WITH swedish, swedish_snowball_dict;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: commontator_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE commontator_comments (
    id integer NOT NULL,
    creator_type character varying,
    creator_id integer,
    editor_type character varying,
    editor_id integer,
    thread_id integer NOT NULL,
    body text NOT NULL,
    deleted_at timestamp without time zone,
    cached_votes_up integer DEFAULT 0,
    cached_votes_down integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: commontator_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE commontator_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commontator_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE commontator_comments_id_seq OWNED BY commontator_comments.id;


--
-- Name: commontator_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE commontator_subscriptions (
    id integer NOT NULL,
    subscriber_type character varying NOT NULL,
    subscriber_id integer NOT NULL,
    thread_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: commontator_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE commontator_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commontator_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE commontator_subscriptions_id_seq OWNED BY commontator_subscriptions.id;


--
-- Name: commontator_threads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE commontator_threads (
    id integer NOT NULL,
    commontable_type character varying,
    commontable_id integer,
    closed_at timestamp without time zone,
    closer_type character varying,
    closer_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: commontator_threads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE commontator_threads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commontator_threads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE commontator_threads_id_seq OWNED BY commontator_threads.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE events (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying,
    description character varying DEFAULT ''::character varying,
    organizer character varying DEFAULT ''::character varying,
    location character varying DEFAULT ''::character varying,
    held_at date,
    event_type character varying DEFAULT ''::character varying,
    url character varying,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    media_main_id integer,
    last_registration timestamp without time zone,
    locked boolean DEFAULT false,
    official boolean DEFAULT false
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: events_recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE events_recipes (
    event_id integer NOT NULL,
    recipe_id integer NOT NULL
);


--
-- Name: media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media (
    id integer NOT NULL,
    file character varying,
    caption character varying,
    sorting integer,
    parent_id integer,
    parent_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone
);


--
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_id_seq OWNED BY media.id;


--
-- Name: placements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE placements (
    id integer NOT NULL,
    medal medal,
    category character varying DEFAULT ''::character varying,
    locked boolean DEFAULT false,
    recipe_id integer,
    event_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: placements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE placements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: placements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE placements_id_seq OWNED BY placements.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE recipes (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying,
    description text DEFAULT ''::text,
    beerxml text,
    public boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    abv numeric,
    ibu numeric,
    og numeric,
    fg numeric,
    style_code character varying,
    style_guide character varying,
    style_name character varying DEFAULT ''::character varying,
    batch_size numeric,
    color numeric,
    brewer character varying DEFAULT ''::character varying,
    downloads integer DEFAULT 0 NOT NULL,
    media_main_id integer,
    cached_votes_up integer DEFAULT 0,
    equipment character varying DEFAULT ''::character varying
);


--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recipes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recipes_id_seq OWNED BY recipes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    admin boolean,
    avatar character varying,
    presentation text DEFAULT ''::text,
    location character varying,
    brewery character varying DEFAULT ''::character varying,
    twitter character varying DEFAULT ''::character varying,
    url character varying,
    equipment character varying DEFAULT ''::character varying,
    media_avatar_id integer,
    media_brewery_id integer,
    registration_data jsonb
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE votes (
    id integer NOT NULL,
    votable_id integer,
    votable_type character varying,
    voter_id integer,
    voter_type character varying,
    vote_flag boolean,
    vote_scope character varying,
    vote_weight integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE votes_id_seq OWNED BY votes.id;


--
-- Name: words; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE words (
    word text
);


--
-- Name: commontator_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY commontator_comments ALTER COLUMN id SET DEFAULT nextval('commontator_comments_id_seq'::regclass);


--
-- Name: commontator_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY commontator_subscriptions ALTER COLUMN id SET DEFAULT nextval('commontator_subscriptions_id_seq'::regclass);


--
-- Name: commontator_threads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY commontator_threads ALTER COLUMN id SET DEFAULT nextval('commontator_threads_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: media id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media ALTER COLUMN id SET DEFAULT nextval('media_id_seq'::regclass);


--
-- Name: placements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY placements ALTER COLUMN id SET DEFAULT nextval('placements_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipes ALTER COLUMN id SET DEFAULT nextval('recipes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: votes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);


--
-- Name: commontator_comments commontator_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commontator_comments
    ADD CONSTRAINT commontator_comments_pkey PRIMARY KEY (id);


--
-- Name: commontator_subscriptions commontator_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commontator_subscriptions
    ADD CONSTRAINT commontator_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: commontator_threads commontator_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commontator_threads
    ADD CONSTRAINT commontator_threads_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: placements placements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY placements
    ADD CONSTRAINT placements_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: votes votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: fulltext_index_events_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_index_events_on_name ON events USING gin (to_tsvector('swedish_snowball'::regconfig, (COALESCE(name, ''::character varying))::text));


--
-- Name: fulltext_index_events_on_primary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_index_events_on_primary ON events USING gin (to_tsvector('swedish_snowball'::regconfig, (((((((((COALESCE(name, ''::character varying))::text || ' '::text) || (COALESCE(organizer, ''::character varying))::text) || ' '::text) || (COALESCE(location, ''::character varying))::text) || ' '::text) || (COALESCE(event_type, ''::character varying))::text) || ' '::text) || (COALESCE(description, ''::character varying))::text)));


--
-- Name: fulltext_index_recipes_on_equipment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_index_recipes_on_equipment ON recipes USING gin (to_tsvector('swedish_snowball'::regconfig, (COALESCE(equipment, ''::character varying))::text));


--
-- Name: fulltext_index_recipes_on_primary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_index_recipes_on_primary ON recipes USING gin (to_tsvector('swedish_snowball'::regconfig, (((((((((COALESCE(name, ''::character varying))::text || ' '::text) || COALESCE(description, ''::text)) || ' '::text) || (COALESCE(style_name, ''::character varying))::text) || ' '::text) || (COALESCE(equipment, ''::character varying))::text) || ' '::text) || (COALESCE(brewer, ''::character varying))::text)));


--
-- Name: fulltext_index_recipes_on_style_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_index_recipes_on_style_name ON recipes USING gin (to_tsvector('simple'::regconfig, (style_name)::text));


--
-- Name: fulltext_index_users_on_brewery; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_index_users_on_brewery ON users USING gin (to_tsvector('swedish_snowball'::regconfig, (COALESCE(brewery, ''::character varying))::text));


--
-- Name: fulltext_index_users_on_equipment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_index_users_on_equipment ON users USING gin (to_tsvector('swedish_snowball'::regconfig, (COALESCE(equipment, ''::character varying))::text));


--
-- Name: fulltext_index_users_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_index_users_on_name ON users USING gin (to_tsvector('simple'::regconfig, (name)::text));


--
-- Name: fulltext_index_users_on_primary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fulltext_index_users_on_primary ON users USING gin (to_tsvector('swedish_snowball'::regconfig, (((((((((COALESCE(name, ''::character varying))::text || ' '::text) || COALESCE(presentation, ''::text)) || ' '::text) || (COALESCE(equipment, ''::character varying))::text) || ' '::text) || (COALESCE(brewery, ''::character varying))::text) || ' '::text) || (COALESCE(twitter, ''::character varying))::text)));


--
-- Name: idx_recipes_on_description_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_recipes_on_description_trigram ON recipes USING gin (description gin_trgm_ops);


--
-- Name: index_commontator_comments_on_c_id_and_c_type_and_t_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commontator_comments_on_c_id_and_c_type_and_t_id ON commontator_comments USING btree (creator_id, creator_type, thread_id);


--
-- Name: index_commontator_comments_on_cached_votes_down; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commontator_comments_on_cached_votes_down ON commontator_comments USING btree (cached_votes_down);


--
-- Name: index_commontator_comments_on_cached_votes_up; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commontator_comments_on_cached_votes_up ON commontator_comments USING btree (cached_votes_up);


--
-- Name: index_commontator_comments_on_thread_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commontator_comments_on_thread_id_and_created_at ON commontator_comments USING btree (thread_id, created_at);


--
-- Name: index_commontator_subscriptions_on_s_id_and_s_type_and_t_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_commontator_subscriptions_on_s_id_and_s_type_and_t_id ON commontator_subscriptions USING btree (subscriber_id, subscriber_type, thread_id);


--
-- Name: index_commontator_subscriptions_on_thread_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commontator_subscriptions_on_thread_id ON commontator_subscriptions USING btree (thread_id);


--
-- Name: index_commontator_threads_on_c_id_and_c_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_commontator_threads_on_c_id_and_c_type ON commontator_threads USING btree (commontable_id, commontable_type);


--
-- Name: index_events_on_media_main_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_media_main_id ON events USING btree (media_main_id);


--
-- Name: index_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_user_id ON events USING btree (user_id);


--
-- Name: index_events_recipes_on_event_id_and_recipe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_events_recipes_on_event_id_and_recipe_id ON events_recipes USING btree (event_id, recipe_id);


--
-- Name: index_events_recipes_on_recipe_id_and_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_events_recipes_on_recipe_id_and_event_id ON events_recipes USING btree (recipe_id, event_id);


--
-- Name: index_media_on_parent_type_and_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_media_on_parent_type_and_parent_id ON media USING btree (parent_type, parent_id);


--
-- Name: index_placements_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_placements_on_event_id ON placements USING btree (event_id);


--
-- Name: index_placements_on_medal; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_placements_on_medal ON placements USING btree (medal);


--
-- Name: index_placements_on_recipe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_placements_on_recipe_id ON placements USING btree (recipe_id);


--
-- Name: index_placements_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_placements_on_user_id ON placements USING btree (user_id);


--
-- Name: index_recipes_on_abv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_abv ON recipes USING btree (abv);


--
-- Name: index_recipes_on_batch_size; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_batch_size ON recipes USING btree (batch_size);


--
-- Name: index_recipes_on_brewer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_brewer ON recipes USING btree (brewer);


--
-- Name: index_recipes_on_cached_votes_up; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_cached_votes_up ON recipes USING btree (cached_votes_up);


--
-- Name: index_recipes_on_color; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_color ON recipes USING btree (color);


--
-- Name: index_recipes_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_created_at ON recipes USING btree (created_at);


--
-- Name: index_recipes_on_fg; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_fg ON recipes USING btree (fg);


--
-- Name: index_recipes_on_ibu; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_ibu ON recipes USING btree (ibu);


--
-- Name: index_recipes_on_media_main_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_media_main_id ON recipes USING btree (media_main_id);


--
-- Name: index_recipes_on_og; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_og ON recipes USING btree (og);


--
-- Name: index_recipes_on_public; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_public ON recipes USING btree (public);


--
-- Name: index_recipes_on_style_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_style_code ON recipes USING btree (style_code);


--
-- Name: index_recipes_on_style_guide; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_style_guide ON recipes USING btree (style_guide);


--
-- Name: index_recipes_on_style_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_style_name ON recipes USING btree (style_name);


--
-- Name: index_recipes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_user_id ON recipes USING btree (user_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_media_avatar_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_media_avatar_id ON users USING btree (media_avatar_id);


--
-- Name: index_users_on_media_brewery_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_media_brewery_id ON users USING btree (media_brewery_id);


--
-- Name: index_users_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_name ON users USING btree (name);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: index_votes_on_votable_id_and_votable_type_and_vote_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_votable_id_and_votable_type_and_vote_scope ON votes USING btree (votable_id, votable_type, vote_scope);


--
-- Name: index_votes_on_voter_id_and_voter_type_and_vote_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_voter_id_and_voter_type_and_vote_scope ON votes USING btree (voter_id, voter_type, vote_scope);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: words_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX words_idx ON words USING gin (word gin_trgm_ops);


--
-- Name: recipes fk_rails_0fd2ed4eeb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipes
    ADD CONSTRAINT fk_rails_0fd2ed4eeb FOREIGN KEY (media_main_id) REFERENCES media(id);


--
-- Name: placements fk_rails_344f224d46; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY placements
    ADD CONSTRAINT fk_rails_344f224d46 FOREIGN KEY (recipe_id) REFERENCES recipes(id);


--
-- Name: users fk_rails_793a220a68; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_793a220a68 FOREIGN KEY (media_avatar_id) REFERENCES media(id);


--
-- Name: placements fk_rails_7f5b80573c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY placements
    ADD CONSTRAINT fk_rails_7f5b80573c FOREIGN KEY (event_id) REFERENCES events(id);


--
-- Name: users fk_rails_9c9dd5b0b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_9c9dd5b0b7 FOREIGN KEY (media_brewery_id) REFERENCES media(id);


--
-- Name: events fk_rails_eddd50df5b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_eddd50df5b FOREIGN KEY (media_main_id) REFERENCES media(id);


--
-- Name: placements fk_rails_fe81c39da1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY placements
    ADD CONSTRAINT fk_rails_fe81c39da1 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20151214195013');

INSERT INTO schema_migrations (version) VALUES ('20151214200025');

INSERT INTO schema_migrations (version) VALUES ('20151214210544');

INSERT INTO schema_migrations (version) VALUES ('20151214210606');

INSERT INTO schema_migrations (version) VALUES ('20151215200333');

INSERT INTO schema_migrations (version) VALUES ('20151223113228');

INSERT INTO schema_migrations (version) VALUES ('20151223125714');

INSERT INTO schema_migrations (version) VALUES ('20160102165716');

INSERT INTO schema_migrations (version) VALUES ('20160102173544');

INSERT INTO schema_migrations (version) VALUES ('20160102210028');

INSERT INTO schema_migrations (version) VALUES ('20160105190205');

INSERT INTO schema_migrations (version) VALUES ('20160105234837');

INSERT INTO schema_migrations (version) VALUES ('20160112215316');

INSERT INTO schema_migrations (version) VALUES ('20160119204655');

INSERT INTO schema_migrations (version) VALUES ('20160119214911');

INSERT INTO schema_migrations (version) VALUES ('20160124162437');

INSERT INTO schema_migrations (version) VALUES ('20160124174400');

INSERT INTO schema_migrations (version) VALUES ('20160209201838');

INSERT INTO schema_migrations (version) VALUES ('20160307193952');

INSERT INTO schema_migrations (version) VALUES ('20161213184727');

INSERT INTO schema_migrations (version) VALUES ('20170127111423');

INSERT INTO schema_migrations (version) VALUES ('20170130190351');

INSERT INTO schema_migrations (version) VALUES ('20171025204911');

INSERT INTO schema_migrations (version) VALUES ('20171027223202');

INSERT INTO schema_migrations (version) VALUES ('20171028120552');

INSERT INTO schema_migrations (version) VALUES ('20171028145021');

INSERT INTO schema_migrations (version) VALUES ('20171029201125');

INSERT INTO schema_migrations (version) VALUES ('20171102202524');

INSERT INTO schema_migrations (version) VALUES ('20171107191308');

