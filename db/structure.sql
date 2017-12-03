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


SET search_path = public, pg_catalog;

--
-- Name: fermentable_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE fermentable_type AS ENUM (
    'Grain',
    'Sugar',
    'Extract',
    'Dry Extract',
    'Adjunct'
);


--
-- Name: hop_form; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE hop_form AS ENUM (
    'Pellet',
    'Plug',
    'Leaf'
);


--
-- Name: hop_use; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE hop_use AS ENUM (
    'Mash',
    'First Wort',
    'Boil',
    'Aroma',
    'Dry Hop'
);


--
-- Name: mash_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE mash_type AS ENUM (
    'Infusion',
    'Temperature',
    'Decoction'
);


--
-- Name: medal; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE medal AS ENUM (
    'gold',
    'silver',
    'bronze'
);


--
-- Name: misc_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE misc_type AS ENUM (
    'Spice',
    'Fining',
    'Water Agent',
    'Herb',
    'Flavor',
    'Other'
);


--
-- Name: misc_use; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE misc_use AS ENUM (
    'Mash',
    'Boil',
    'Primary',
    'Secondary',
    'Bottling'
);


--
-- Name: yeast_form; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE yeast_form AS ENUM (
    'Liquid',
    'Dry',
    'Slant',
    'Culture'
);


--
-- Name: yeast_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE yeast_type AS ENUM (
    'Ale',
    'Lager',
    'Wheat',
    'Wine',
    'Champagne'
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
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


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
-- Name: event_registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_registrations (
    id bigint NOT NULL,
    message text DEFAULT ''::text NOT NULL,
    event_id bigint,
    recipe_id bigint,
    user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: event_registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_registrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_registrations_id_seq OWNED BY event_registrations.id;


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
    official boolean DEFAULT false,
    registration_information text DEFAULT ''::text NOT NULL,
    address text DEFAULT ''::text NOT NULL,
    coordinates character varying DEFAULT ''::character varying NOT NULL,
    contact_email character varying DEFAULT ''::character varying NOT NULL
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
    event_id bigint NOT NULL,
    recipe_id bigint NOT NULL
);


--
-- Name: fermentables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE fermentables (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    amount numeric DEFAULT 0 NOT NULL,
    yield numeric DEFAULT 0 NOT NULL,
    potential numeric DEFAULT 0 NOT NULL,
    ebc numeric DEFAULT 0 NOT NULL,
    after_boil boolean DEFAULT false NOT NULL,
    fermentable boolean DEFAULT true NOT NULL,
    recipe_detail_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    grain_type fermentable_type DEFAULT 'Grain'::fermentable_type NOT NULL
);


--
-- Name: fermentables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fermentables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fermentables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fermentables_id_seq OWNED BY fermentables.id;


--
-- Name: hops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE hops (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    amount numeric DEFAULT 0 NOT NULL,
    alpha_acid numeric DEFAULT 0 NOT NULL,
    use_time numeric DEFAULT 0 NOT NULL,
    recipe_detail_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    use hop_use DEFAULT 'Boil'::hop_use NOT NULL,
    form hop_form DEFAULT 'Leaf'::hop_form NOT NULL
);


--
-- Name: hops_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hops_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hops_id_seq OWNED BY hops.id;


--
-- Name: mash_steps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mash_steps (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    mash_type mash_type NOT NULL,
    step_temperature numeric NOT NULL,
    step_time numeric NOT NULL,
    water_grain_ratio numeric,
    infuse_amount numeric,
    infuse_temperature numeric,
    ramp_time numeric,
    end_temperature numeric,
    decoction_amount numeric,
    description text DEFAULT ''::text NOT NULL,
    recipe_detail_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mash_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mash_steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mash_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mash_steps_id_seq OWNED BY mash_steps.id;


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
-- Name: miscs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE miscs (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    weight boolean DEFAULT true NOT NULL,
    amount numeric DEFAULT 0 NOT NULL,
    use_time numeric DEFAULT 0 NOT NULL,
    recipe_detail_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    use misc_use DEFAULT 'Boil'::misc_use NOT NULL,
    misc_type misc_type DEFAULT 'Other'::misc_type NOT NULL
);


--
-- Name: miscs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE miscs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: miscs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE miscs_id_seq OWNED BY miscs.id;


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
-- Name: recipe_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE recipe_details (
    id bigint NOT NULL,
    batch_size numeric,
    boil_size numeric,
    boil_time numeric,
    grain_temp numeric,
    sparge_temp numeric,
    efficiency numeric,
    recipe_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    og numeric DEFAULT 0 NOT NULL,
    fg numeric DEFAULT 0 NOT NULL,
    brewed_at date,
    carbonation numeric DEFAULT 0 NOT NULL,
    style_id bigint
);


--
-- Name: recipe_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recipe_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipe_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recipe_details_id_seq OWNED BY recipe_details.id;


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
    equipment character varying DEFAULT ''::character varying,
    complete boolean DEFAULT false NOT NULL
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
-- Name: styles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE styles (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    category character varying DEFAULT ''::character varying NOT NULL,
    number integer NOT NULL,
    letter character varying NOT NULL,
    aroma text DEFAULT ''::text NOT NULL,
    appearance text DEFAULT ''::text NOT NULL,
    flavor text DEFAULT ''::text NOT NULL,
    texture text DEFAULT ''::text NOT NULL,
    examples text DEFAULT ''::text NOT NULL,
    summary text DEFAULT ''::text NOT NULL,
    og_min numeric DEFAULT 0 NOT NULL,
    og_max numeric DEFAULT 0 NOT NULL,
    fg_min numeric DEFAULT 0 NOT NULL,
    fg_max numeric DEFAULT 0 NOT NULL,
    ebc_min numeric DEFAULT 0 NOT NULL,
    ebc_max numeric DEFAULT 0 NOT NULL,
    ibu_min numeric DEFAULT 0 NOT NULL,
    ibu_max numeric DEFAULT 0 NOT NULL,
    abv_min numeric DEFAULT 0 NOT NULL,
    abv_max numeric DEFAULT 0 NOT NULL,
    style_guide character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: styles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE styles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE styles_id_seq OWNED BY styles.id;


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
-- Name: yeasts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE yeasts (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    weight boolean DEFAULT true NOT NULL,
    amount numeric DEFAULT 0 NOT NULL,
    recipe_detail_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    form yeast_form DEFAULT 'Dry'::yeast_form NOT NULL,
    yeast_type yeast_type DEFAULT 'Ale'::yeast_type NOT NULL
);


--
-- Name: yeasts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE yeasts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: yeasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE yeasts_id_seq OWNED BY yeasts.id;


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
-- Name: event_registrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_registrations ALTER COLUMN id SET DEFAULT nextval('event_registrations_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: fermentables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fermentables ALTER COLUMN id SET DEFAULT nextval('fermentables_id_seq'::regclass);


--
-- Name: hops id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hops ALTER COLUMN id SET DEFAULT nextval('hops_id_seq'::regclass);


--
-- Name: mash_steps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mash_steps ALTER COLUMN id SET DEFAULT nextval('mash_steps_id_seq'::regclass);


--
-- Name: media id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media ALTER COLUMN id SET DEFAULT nextval('media_id_seq'::regclass);


--
-- Name: miscs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY miscs ALTER COLUMN id SET DEFAULT nextval('miscs_id_seq'::regclass);


--
-- Name: placements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY placements ALTER COLUMN id SET DEFAULT nextval('placements_id_seq'::regclass);


--
-- Name: recipe_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipe_details ALTER COLUMN id SET DEFAULT nextval('recipe_details_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipes ALTER COLUMN id SET DEFAULT nextval('recipes_id_seq'::regclass);


--
-- Name: styles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY styles ALTER COLUMN id SET DEFAULT nextval('styles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: votes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);


--
-- Name: yeasts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY yeasts ALTER COLUMN id SET DEFAULT nextval('yeasts_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


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
-- Name: event_registrations event_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_registrations
    ADD CONSTRAINT event_registrations_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: fermentables fermentables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fermentables
    ADD CONSTRAINT fermentables_pkey PRIMARY KEY (id);


--
-- Name: hops hops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hops
    ADD CONSTRAINT hops_pkey PRIMARY KEY (id);


--
-- Name: mash_steps mash_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mash_steps
    ADD CONSTRAINT mash_steps_pkey PRIMARY KEY (id);


--
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: miscs miscs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY miscs
    ADD CONSTRAINT miscs_pkey PRIMARY KEY (id);


--
-- Name: placements placements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY placements
    ADD CONSTRAINT placements_pkey PRIMARY KEY (id);


--
-- Name: recipe_details recipe_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipe_details
    ADD CONSTRAINT recipe_details_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: styles styles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY styles
    ADD CONSTRAINT styles_pkey PRIMARY KEY (id);


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
-- Name: yeasts yeasts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY yeasts
    ADD CONSTRAINT yeasts_pkey PRIMARY KEY (id);


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
-- Name: index_event_registrations_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_registrations_on_event_id ON event_registrations USING btree (event_id);


--
-- Name: index_event_registrations_on_recipe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_registrations_on_recipe_id ON event_registrations USING btree (recipe_id);


--
-- Name: index_event_registrations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_registrations_on_user_id ON event_registrations USING btree (user_id);


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
-- Name: index_fermentables_on_recipe_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fermentables_on_recipe_detail_id ON fermentables USING btree (recipe_detail_id);


--
-- Name: index_hops_on_recipe_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_hops_on_recipe_detail_id ON hops USING btree (recipe_detail_id);


--
-- Name: index_mash_steps_on_recipe_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mash_steps_on_recipe_detail_id ON mash_steps USING btree (recipe_detail_id);


--
-- Name: index_media_on_parent_type_and_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_media_on_parent_type_and_parent_id ON media USING btree (parent_type, parent_id);


--
-- Name: index_miscs_on_recipe_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_miscs_on_recipe_detail_id ON miscs USING btree (recipe_detail_id);


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
-- Name: index_recipe_details_on_recipe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipe_details_on_recipe_id ON recipe_details USING btree (recipe_id);


--
-- Name: index_recipe_details_on_style_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipe_details_on_style_id ON recipe_details USING btree (style_id);


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
-- Name: index_styles_on_style_guide; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_styles_on_style_guide ON styles USING btree (style_guide);


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
-- Name: index_yeasts_on_recipe_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_yeasts_on_recipe_detail_id ON yeasts USING btree (recipe_detail_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: mash_steps fk_rails_0f11dbd377; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mash_steps
    ADD CONSTRAINT fk_rails_0f11dbd377 FOREIGN KEY (recipe_detail_id) REFERENCES recipe_details(id);


--
-- Name: recipes fk_rails_0fd2ed4eeb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipes
    ADD CONSTRAINT fk_rails_0fd2ed4eeb FOREIGN KEY (media_main_id) REFERENCES media(id);


--
-- Name: event_registrations fk_rails_23148f43c2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_registrations
    ADD CONSTRAINT fk_rails_23148f43c2 FOREIGN KEY (event_id) REFERENCES events(id);


--
-- Name: placements fk_rails_344f224d46; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY placements
    ADD CONSTRAINT fk_rails_344f224d46 FOREIGN KEY (recipe_id) REFERENCES recipes(id);


--
-- Name: recipe_details fk_rails_426b7d6920; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipe_details
    ADD CONSTRAINT fk_rails_426b7d6920 FOREIGN KEY (style_id) REFERENCES styles(id);


--
-- Name: miscs fk_rails_4aca03e5cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY miscs
    ADD CONSTRAINT fk_rails_4aca03e5cb FOREIGN KEY (recipe_detail_id) REFERENCES recipe_details(id);


--
-- Name: hops fk_rails_58ff15d669; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY hops
    ADD CONSTRAINT fk_rails_58ff15d669 FOREIGN KEY (recipe_detail_id) REFERENCES recipe_details(id);


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
-- Name: event_registrations fk_rails_8a0b1c0506; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_registrations
    ADD CONSTRAINT fk_rails_8a0b1c0506 FOREIGN KEY (recipe_id) REFERENCES recipes(id);


--
-- Name: recipe_details fk_rails_9509a5b996; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipe_details
    ADD CONSTRAINT fk_rails_9509a5b996 FOREIGN KEY (recipe_id) REFERENCES recipes(id);


--
-- Name: users fk_rails_9c9dd5b0b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_9c9dd5b0b7 FOREIGN KEY (media_brewery_id) REFERENCES media(id);


--
-- Name: event_registrations fk_rails_9d37217e35; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_registrations
    ADD CONSTRAINT fk_rails_9d37217e35 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: yeasts fk_rails_e5e114c272; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY yeasts
    ADD CONSTRAINT fk_rails_e5e114c272 FOREIGN KEY (recipe_detail_id) REFERENCES recipe_details(id);


--
-- Name: events fk_rails_eddd50df5b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT fk_rails_eddd50df5b FOREIGN KEY (media_main_id) REFERENCES media(id);


--
-- Name: fermentables fk_rails_fa5fd15b19; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY fermentables
    ADD CONSTRAINT fk_rails_fa5fd15b19 FOREIGN KEY (recipe_detail_id) REFERENCES recipe_details(id);


--
-- Name: placements fk_rails_fe81c39da1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY placements
    ADD CONSTRAINT fk_rails_fe81c39da1 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20151214195013'),
('20151214200025'),
('20151214210544'),
('20151214210606'),
('20151215200333'),
('20151223113228'),
('20151223125714'),
('20160102165716'),
('20160102173544'),
('20160102210028'),
('20160105190205'),
('20160105234837'),
('20160112215316'),
('20160119204655'),
('20160119214911'),
('20160124162437'),
('20160124174400'),
('20160209201838'),
('20160307193952'),
('20161213184727'),
('20170127111423'),
('20170130190351'),
('20171025204911'),
('20171027223202'),
('20171028120552'),
('20171028145021'),
('20171029201125'),
('20171102202524'),
('20171107191308'),
('20171113205317'),
('20171114204510'),
('20171115220620'),
('20171115220627'),
('20171115221112'),
('20171115221353'),
('20171115221645'),
('20171119161104'),
('20171119165458'),
('20171119182201'),
('20171119190427'),
('20171121184814'),
('20171122201201'),
('20171126121130'),
('20171126161659'),
('20171202132847'),
('20171203174307');


