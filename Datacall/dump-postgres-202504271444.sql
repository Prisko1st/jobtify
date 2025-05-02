--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2025-04-27 14:44:28

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5234 (class 1262 OID 5)
-- Name: postgres; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en-US';


\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5235 (class 0 OID 0)
-- Dependencies: 5234
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 7 (class 2615 OID 18554)
-- Name: companies; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA companies;


--
-- TOC entry 8 (class 2615 OID 18555)
-- Name: jobs; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA jobs;


--
-- TOC entry 9 (class 2615 OID 18556)
-- Name: locations; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA locations;


--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- TOC entry 5236 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 925 (class 1247 OID 18558)
-- Name: companySizes; Type: TYPE; Schema: companies; Owner: -
--

CREATE TYPE companies."companySizes" AS ENUM (
    'SMALL',
    'MEDIUM',
    'LARGE',
    'ENTERPRISE'
);


--
-- TOC entry 928 (class 1247 OID 18568)
-- Name: salaryFrequency; Type: TYPE; Schema: jobs; Owner: -
--

CREATE TYPE jobs."salaryFrequency" AS ENUM (
    'MONTHLY',
    'YEARLY',
    'PROGRESSIVE'
);


--
-- TOC entry 259 (class 1255 OID 18575)
-- Name: list_ct(); Type: PROCEDURE; Schema: locations; Owner: -
--

CREATE PROCEDURE locations.list_ct()
    LANGUAGE plpgsql
    AS $$Begin
	select city_id, city_name, st.state_name, ct.country_name
	from locations.city as ci
	left join locations.state as st on ci.state_id = st.state_id
	left join locations.country as ct on st.country_id = ct.country_id
	order by city_id;
end;$$;


--
-- TOC entry 5237 (class 0 OID 0)
-- Dependencies: 259
-- Name: PROCEDURE list_ct(); Type: COMMENT; Schema: locations; Owner: -
--

COMMENT ON PROCEDURE locations.list_ct() IS 'Return list of cities';


--
-- TOC entry 260 (class 1255 OID 18576)
-- Name: list_st(); Type: PROCEDURE; Schema: locations; Owner: -
--

CREATE PROCEDURE locations.list_st()
    LANGUAGE plpgsql
    AS $$Begin
	select st.state_name, st.state_code, ct.country_name
	from locations.state as st
	left join locations.country as ct
	on st.country_id = ct.country_id
	order by state_id;
end;$$;


--
-- TOC entry 5238 (class 0 OID 0)
-- Dependencies: 260
-- Name: PROCEDURE list_st(); Type: COMMENT; Schema: locations; Owner: -
--

COMMENT ON PROCEDURE locations.list_st() IS 'Return states';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 18577)
-- Name: company; Type: TABLE; Schema: companies; Owner: -
--

CREATE TABLE companies.company (
    company_id integer NOT NULL,
    company_uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    company_name character varying(255),
    company_description character varying(16000),
    company_website character varying(1000),
    establishment_date date,
    company_size companies."companySizes",
    company_location_id integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    company_email character varying(320),
    phone_number character varying(20),
    is_remote boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


--
-- TOC entry 222 (class 1259 OID 18586)
-- Name: company_company_id_seq1; Type: SEQUENCE; Schema: companies; Owner: -
--

CREATE SEQUENCE companies.company_company_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5239 (class 0 OID 0)
-- Dependencies: 222
-- Name: company_company_id_seq1; Type: SEQUENCE OWNED BY; Schema: companies; Owner: -
--

ALTER SEQUENCE companies.company_company_id_seq1 OWNED BY companies.company.company_id;


--
-- TOC entry 223 (class 1259 OID 18587)
-- Name: company_image; Type: TABLE; Schema: companies; Owner: -
--

CREATE TABLE companies.company_image (
    company_image_id integer NOT NULL,
    company_id integer,
    company_image character varying,
    is_primary boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 224 (class 1259 OID 18595)
-- Name: company_image_company_image_id_seq; Type: SEQUENCE; Schema: companies; Owner: -
--

CREATE SEQUENCE companies.company_image_company_image_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 224
-- Name: company_image_company_image_id_seq; Type: SEQUENCE OWNED BY; Schema: companies; Owner: -
--

ALTER SEQUENCE companies.company_image_company_image_id_seq OWNED BY companies.company_image.company_image_id;


--
-- TOC entry 225 (class 1259 OID 18596)
-- Name: company_industry; Type: TABLE; Schema: companies; Owner: -
--

CREATE TABLE companies.company_industry (
    company_industry_id integer NOT NULL,
    company_industry_uuid uuid NOT NULL,
    company_id integer NOT NULL,
    industry_category_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 18601)
-- Name: company_industry_company_industry_id_seq; Type: SEQUENCE; Schema: companies; Owner: -
--

CREATE SEQUENCE companies.company_industry_company_industry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 226
-- Name: company_industry_company_industry_id_seq; Type: SEQUENCE OWNED BY; Schema: companies; Owner: -
--

ALTER SEQUENCE companies.company_industry_company_industry_id_seq OWNED BY companies.company_industry.company_industry_id;


--
-- TOC entry 227 (class 1259 OID 18602)
-- Name: industry_category; Type: TABLE; Schema: companies; Owner: -
--

CREATE TABLE companies.industry_category (
    industry_category_id integer NOT NULL,
    industry_name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 228 (class 1259 OID 18607)
-- Name: industry_category_id_seq; Type: SEQUENCE; Schema: companies; Owner: -
--

CREATE SEQUENCE companies.industry_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 228
-- Name: industry_category_id_seq; Type: SEQUENCE OWNED BY; Schema: companies; Owner: -
--

ALTER SEQUENCE companies.industry_category_id_seq OWNED BY companies.industry_category.industry_category_id;


--
-- TOC entry 229 (class 1259 OID 18608)
-- Name: job; Type: TABLE; Schema: jobs; Owner: -
--

CREATE TABLE jobs.job (
    job_id integer NOT NULL,
    job_uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    job_company integer NOT NULL,
    job_description text,
    job_name character varying(255) NOT NULL,
    job_posted_date date NOT NULL,
    apply_link character varying(1000) NOT NULL,
    salary_min numeric(10,2),
    salary_max numeric(10,2),
    salary_currency character(3) DEFAULT 'IDR'::bpchar NOT NULL,
    salary_frequency jobs."salaryFrequency" DEFAULT 'MONTHLY'::jobs."salaryFrequency",
    job_location_id integer NOT NULL,
    job_status boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 230 (class 1259 OID 18618)
-- Name: job_category; Type: TABLE; Schema: jobs; Owner: -
--

CREATE TABLE jobs.job_category (
    job_category_id integer NOT NULL,
    job_category_name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 231 (class 1259 OID 18623)
-- Name: job_category_job_category_id_seq; Type: SEQUENCE; Schema: jobs; Owner: -
--

CREATE SEQUENCE jobs.job_category_job_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 231
-- Name: job_category_job_category_id_seq; Type: SEQUENCE OWNED BY; Schema: jobs; Owner: -
--

ALTER SEQUENCE jobs.job_category_job_category_id_seq OWNED BY jobs.job_category.job_category_id;


--
-- TOC entry 232 (class 1259 OID 18624)
-- Name: job_category_map; Type: TABLE; Schema: jobs; Owner: -
--

CREATE TABLE jobs.job_category_map (
    job_category_map_id integer NOT NULL,
    job_category_map_uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    job_id integer NOT NULL,
    category_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 233 (class 1259 OID 18629)
-- Name: job_category_map_job_category_map_id_seq; Type: SEQUENCE; Schema: jobs; Owner: -
--

CREATE SEQUENCE jobs.job_category_map_job_category_map_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 233
-- Name: job_category_map_job_category_map_id_seq; Type: SEQUENCE OWNED BY; Schema: jobs; Owner: -
--

ALTER SEQUENCE jobs.job_category_map_job_category_map_id_seq OWNED BY jobs.job_category_map.job_category_map_id;


--
-- TOC entry 234 (class 1259 OID 18630)
-- Name: job_job_id_seq; Type: SEQUENCE; Schema: jobs; Owner: -
--

CREATE SEQUENCE jobs.job_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 234
-- Name: job_job_id_seq; Type: SEQUENCE OWNED BY; Schema: jobs; Owner: -
--

ALTER SEQUENCE jobs.job_job_id_seq OWNED BY jobs.job.job_id;


--
-- TOC entry 235 (class 1259 OID 18631)
-- Name: job_salary; Type: TABLE; Schema: jobs; Owner: -
--

CREATE TABLE jobs.job_salary (
    job_salary_id integer NOT NULL,
    job_salary_name character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 236 (class 1259 OID 18636)
-- Name: job_salary_job_salary_id_seq; Type: SEQUENCE; Schema: jobs; Owner: -
--

CREATE SEQUENCE jobs.job_salary_job_salary_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 236
-- Name: job_salary_job_salary_id_seq; Type: SEQUENCE OWNED BY; Schema: jobs; Owner: -
--

ALTER SEQUENCE jobs.job_salary_job_salary_id_seq OWNED BY jobs.job_salary.job_salary_id;


--
-- TOC entry 237 (class 1259 OID 18637)
-- Name: job_salary_map; Type: TABLE; Schema: jobs; Owner: -
--

CREATE TABLE jobs.job_salary_map (
    job_salary_map_id integer NOT NULL,
    job_salary_map_uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    job_id integer NOT NULL,
    salary_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 238 (class 1259 OID 18642)
-- Name: job_salary_map_job_salary_map_id_seq; Type: SEQUENCE; Schema: jobs; Owner: -
--

CREATE SEQUENCE jobs.job_salary_map_job_salary_map_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 238
-- Name: job_salary_map_job_salary_map_id_seq; Type: SEQUENCE OWNED BY; Schema: jobs; Owner: -
--

ALTER SEQUENCE jobs.job_salary_map_job_salary_map_id_seq OWNED BY jobs.job_salary_map.job_salary_map_id;


--
-- TOC entry 239 (class 1259 OID 18643)
-- Name: job_schedule; Type: TABLE; Schema: jobs; Owner: -
--

CREATE TABLE jobs.job_schedule (
    job_schedule_id integer NOT NULL,
    job_schedule_name character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 240 (class 1259 OID 18648)
-- Name: job_schedule_job_schedule_id_seq; Type: SEQUENCE; Schema: jobs; Owner: -
--

CREATE SEQUENCE jobs.job_schedule_job_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 240
-- Name: job_schedule_job_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: jobs; Owner: -
--

ALTER SEQUENCE jobs.job_schedule_job_schedule_id_seq OWNED BY jobs.job_schedule.job_schedule_id;


--
-- TOC entry 241 (class 1259 OID 18649)
-- Name: job_schedule_map; Type: TABLE; Schema: jobs; Owner: -
--

CREATE TABLE jobs.job_schedule_map (
    job_schedule_map_id integer NOT NULL,
    job_schedule_map_uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    job_id integer NOT NULL,
    schedule_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 242 (class 1259 OID 18654)
-- Name: job_schedule_map_job_schedule_map_id_seq; Type: SEQUENCE; Schema: jobs; Owner: -
--

CREATE SEQUENCE jobs.job_schedule_map_job_schedule_map_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 242
-- Name: job_schedule_map_job_schedule_map_id_seq; Type: SEQUENCE OWNED BY; Schema: jobs; Owner: -
--

ALTER SEQUENCE jobs.job_schedule_map_job_schedule_map_id_seq OWNED BY jobs.job_schedule_map.job_schedule_map_id;


--
-- TOC entry 254 (class 1259 OID 18859)
-- Name: job_skill; Type: TABLE; Schema: jobs; Owner: -
--

CREATE TABLE jobs.job_skill (
    job_skill_id integer NOT NULL,
    skill_name character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 256 (class 1259 OID 18880)
-- Name: job_skill_map; Type: TABLE; Schema: jobs; Owner: -
--

CREATE TABLE jobs.job_skill_map (
    job_skill_map_id integer NOT NULL,
    job_id integer NOT NULL,
    skill_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 255 (class 1259 OID 18879)
-- Name: job_skill_map_job_skill_map_id_seq; Type: SEQUENCE; Schema: jobs; Owner: -
--

CREATE SEQUENCE jobs.job_skill_map_job_skill_map_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 255
-- Name: job_skill_map_job_skill_map_id_seq; Type: SEQUENCE OWNED BY; Schema: jobs; Owner: -
--

ALTER SEQUENCE jobs.job_skill_map_job_skill_map_id_seq OWNED BY jobs.job_skill_map.job_skill_map_id;


--
-- TOC entry 253 (class 1259 OID 18858)
-- Name: job_skill_skill_id_seq; Type: SEQUENCE; Schema: jobs; Owner: -
--

CREATE SEQUENCE jobs.job_skill_skill_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 253
-- Name: job_skill_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: jobs; Owner: -
--

ALTER SEQUENCE jobs.job_skill_skill_id_seq OWNED BY jobs.job_skill.job_skill_id;


--
-- TOC entry 243 (class 1259 OID 18655)
-- Name: job_type; Type: TABLE; Schema: jobs; Owner: -
--

CREATE TABLE jobs.job_type (
    job_type_id integer NOT NULL,
    job_type_name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 244 (class 1259 OID 18660)
-- Name: job_type_job_type_id_seq; Type: SEQUENCE; Schema: jobs; Owner: -
--

CREATE SEQUENCE jobs.job_type_job_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 244
-- Name: job_type_job_type_id_seq; Type: SEQUENCE OWNED BY; Schema: jobs; Owner: -
--

ALTER SEQUENCE jobs.job_type_job_type_id_seq OWNED BY jobs.job_type.job_type_id;


--
-- TOC entry 245 (class 1259 OID 18661)
-- Name: job_type_map; Type: TABLE; Schema: jobs; Owner: -
--

CREATE TABLE jobs.job_type_map (
    job_type_map_id integer NOT NULL,
    job_type_map_uuid uuid DEFAULT gen_random_uuid() NOT NULL,
    job_id integer NOT NULL,
    type_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 246 (class 1259 OID 18666)
-- Name: job_type_map_job_type_map_id_seq; Type: SEQUENCE; Schema: jobs; Owner: -
--

CREATE SEQUENCE jobs.job_type_map_job_type_map_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 246
-- Name: job_type_map_job_type_map_id_seq; Type: SEQUENCE OWNED BY; Schema: jobs; Owner: -
--

ALTER SEQUENCE jobs.job_type_map_job_type_map_id_seq OWNED BY jobs.job_type_map.job_type_map_id;


--
-- TOC entry 247 (class 1259 OID 18667)
-- Name: city; Type: TABLE; Schema: locations; Owner: -
--

CREATE TABLE locations.city (
    city_id integer NOT NULL,
    city_name character varying(255) NOT NULL,
    state_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 248 (class 1259 OID 18672)
-- Name: cities_city_id_seq; Type: SEQUENCE; Schema: locations; Owner: -
--

CREATE SEQUENCE locations.cities_city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 248
-- Name: cities_city_id_seq; Type: SEQUENCE OWNED BY; Schema: locations; Owner: -
--

ALTER SEQUENCE locations.cities_city_id_seq OWNED BY locations.city.city_id;


--
-- TOC entry 249 (class 1259 OID 18673)
-- Name: country; Type: TABLE; Schema: locations; Owner: -
--

CREATE TABLE locations.country (
    country_id integer NOT NULL,
    country_name character varying(255) NOT NULL,
    country_code character(3) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 250 (class 1259 OID 18678)
-- Name: country_country_id_seq; Type: SEQUENCE; Schema: locations; Owner: -
--

CREATE SEQUENCE locations.country_country_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 250
-- Name: country_country_id_seq; Type: SEQUENCE OWNED BY; Schema: locations; Owner: -
--

ALTER SEQUENCE locations.country_country_id_seq OWNED BY locations.country.country_id;


--
-- TOC entry 251 (class 1259 OID 18679)
-- Name: state; Type: TABLE; Schema: locations; Owner: -
--

CREATE TABLE locations.state (
    state_id integer NOT NULL,
    state_name character varying(255) NOT NULL,
    state_code character varying(10),
    country_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 252 (class 1259 OID 18684)
-- Name: states_state_id_seq; Type: SEQUENCE; Schema: locations; Owner: -
--

CREATE SEQUENCE locations.states_state_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 252
-- Name: states_state_id_seq; Type: SEQUENCE OWNED BY; Schema: locations; Owner: -
--

ALTER SEQUENCE locations.states_state_id_seq OWNED BY locations.state.state_id;


--
-- TOC entry 258 (class 1259 OID 18901)
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id integer NOT NULL,
    company text,
    company_location text,
    company_city text,
    company_country text,
    title text,
    job_description text,
    job_date text,
    apply_link text
);


--
-- TOC entry 257 (class 1259 OID 18900)
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 257
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- TOC entry 4880 (class 2604 OID 18685)
-- Name: company company_id; Type: DEFAULT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company ALTER COLUMN company_id SET DEFAULT nextval('companies.company_company_id_seq1'::regclass);


--
-- TOC entry 4886 (class 2604 OID 18686)
-- Name: company_image company_image_id; Type: DEFAULT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company_image ALTER COLUMN company_image_id SET DEFAULT nextval('companies.company_image_company_image_id_seq'::regclass);


--
-- TOC entry 4890 (class 2604 OID 18687)
-- Name: company_industry company_industry_id; Type: DEFAULT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company_industry ALTER COLUMN company_industry_id SET DEFAULT nextval('companies.company_industry_company_industry_id_seq'::regclass);


--
-- TOC entry 4893 (class 2604 OID 18688)
-- Name: industry_category industry_category_id; Type: DEFAULT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.industry_category ALTER COLUMN industry_category_id SET DEFAULT nextval('companies.industry_category_id_seq'::regclass);


--
-- TOC entry 4896 (class 2604 OID 18689)
-- Name: job job_id; Type: DEFAULT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job ALTER COLUMN job_id SET DEFAULT nextval('jobs.job_job_id_seq'::regclass);


--
-- TOC entry 4903 (class 2604 OID 18690)
-- Name: job_category job_category_id; Type: DEFAULT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_category ALTER COLUMN job_category_id SET DEFAULT nextval('jobs.job_category_job_category_id_seq'::regclass);


--
-- TOC entry 4906 (class 2604 OID 18691)
-- Name: job_category_map job_category_map_id; Type: DEFAULT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_category_map ALTER COLUMN job_category_map_id SET DEFAULT nextval('jobs.job_category_map_job_category_map_id_seq'::regclass);


--
-- TOC entry 4910 (class 2604 OID 18692)
-- Name: job_salary job_salary_id; Type: DEFAULT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_salary ALTER COLUMN job_salary_id SET DEFAULT nextval('jobs.job_salary_job_salary_id_seq'::regclass);


--
-- TOC entry 4913 (class 2604 OID 18693)
-- Name: job_salary_map job_salary_map_id; Type: DEFAULT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_salary_map ALTER COLUMN job_salary_map_id SET DEFAULT nextval('jobs.job_salary_map_job_salary_map_id_seq'::regclass);


--
-- TOC entry 4917 (class 2604 OID 18694)
-- Name: job_schedule job_schedule_id; Type: DEFAULT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_schedule ALTER COLUMN job_schedule_id SET DEFAULT nextval('jobs.job_schedule_job_schedule_id_seq'::regclass);


--
-- TOC entry 4920 (class 2604 OID 18695)
-- Name: job_schedule_map job_schedule_map_id; Type: DEFAULT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_schedule_map ALTER COLUMN job_schedule_map_id SET DEFAULT nextval('jobs.job_schedule_map_job_schedule_map_id_seq'::regclass);


--
-- TOC entry 4940 (class 2604 OID 18862)
-- Name: job_skill job_skill_id; Type: DEFAULT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_skill ALTER COLUMN job_skill_id SET DEFAULT nextval('jobs.job_skill_skill_id_seq'::regclass);


--
-- TOC entry 4943 (class 2604 OID 18883)
-- Name: job_skill_map job_skill_map_id; Type: DEFAULT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_skill_map ALTER COLUMN job_skill_map_id SET DEFAULT nextval('jobs.job_skill_map_job_skill_map_id_seq'::regclass);


--
-- TOC entry 4924 (class 2604 OID 18696)
-- Name: job_type job_type_id; Type: DEFAULT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_type ALTER COLUMN job_type_id SET DEFAULT nextval('jobs.job_type_job_type_id_seq'::regclass);


--
-- TOC entry 4927 (class 2604 OID 18697)
-- Name: job_type_map job_type_map_id; Type: DEFAULT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_type_map ALTER COLUMN job_type_map_id SET DEFAULT nextval('jobs.job_type_map_job_type_map_id_seq'::regclass);


--
-- TOC entry 4931 (class 2604 OID 18698)
-- Name: city city_id; Type: DEFAULT; Schema: locations; Owner: -
--

ALTER TABLE ONLY locations.city ALTER COLUMN city_id SET DEFAULT nextval('locations.cities_city_id_seq'::regclass);


--
-- TOC entry 4934 (class 2604 OID 18699)
-- Name: country country_id; Type: DEFAULT; Schema: locations; Owner: -
--

ALTER TABLE ONLY locations.country ALTER COLUMN country_id SET DEFAULT nextval('locations.country_country_id_seq'::regclass);


--
-- TOC entry 4937 (class 2604 OID 18700)
-- Name: state state_id; Type: DEFAULT; Schema: locations; Owner: -
--

ALTER TABLE ONLY locations.state ALTER COLUMN state_id SET DEFAULT nextval('locations.states_state_id_seq'::regclass);


--
-- TOC entry 4946 (class 2604 OID 18904)
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- TOC entry 5191 (class 0 OID 18577)
-- Dependencies: 221
-- Data for Name: company; Type: TABLE DATA; Schema: companies; Owner: -
--

INSERT INTO companies.company VALUES (22, 'fcf41d70-8cd0-4404-9052-aea960c178ba', 'SUBSCRIPT', NULL, NULL, NULL, NULL, 15, true, NULL, NULL, false, '2025-04-27 11:20:06.552352+07', '2025-04-27 11:20:06.552352+07', NULL);
INSERT INTO companies.company VALUES (25, '6f604b95-b8e5-4bf1-b413-2bbf41d392c9', 'KANGAROOHEALTH', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:20.424709+07', '2025-04-27 11:45:20.424709+07', NULL);
INSERT INTO companies.company VALUES (28, '0e9076f2-33fb-468c-b3c3-e12bd749f4e2', 'BATAMON.ASIA', NULL, NULL, NULL, NULL, 56, true, NULL, NULL, false, '2025-04-27 11:45:50.787684+07', '2025-04-27 11:45:50.787684+07', NULL);
INSERT INTO companies.company VALUES (34, '0b864d8b-22f4-4ec5-aa72-2f1f1296ed47', 'ALEX SOLUTIONS', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:50.85634+07', '2025-04-27 11:45:50.85634+07', NULL);
INSERT INTO companies.company VALUES (36, 'd93ad179-f1c4-4f74-91f1-8299774f5f4e', 'COFFEESPACE', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:50.871311+07', '2025-04-27 11:45:50.871311+07', NULL);
INSERT INTO companies.company VALUES (37, '72479d17-a814-4ca1-af5c-fba96a217939', 'FLY.IO', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:50.878289+07', '2025-04-27 11:45:50.878289+07', NULL);
INSERT INTO companies.company VALUES (40, 'a423c77f-dd78-4a27-82e0-526ac49f3069', 'PITCH', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:50.899625+07', '2025-04-27 11:45:50.899625+07', NULL);
INSERT INTO companies.company VALUES (41, 'f651809b-933d-42f2-98d0-a11b6f78c8ae', 'ATTAC', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:50.906654+07', '2025-04-27 11:45:50.906654+07', NULL);
INSERT INTO companies.company VALUES (42, 'a363669c-6381-4860-8b03-e5103b03d6fd', 'VERVERICA', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:50.913578+07', '2025-04-27 11:45:50.913578+07', NULL);
INSERT INTO companies.company VALUES (43, '6b04601e-26b4-4937-9c4b-189d58c00be7', 'ITERATIVE', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:50.919773+07', '2025-04-27 11:45:50.919773+07', NULL);
INSERT INTO companies.company VALUES (44, '9796214b-2850-446a-a6d1-fb57273a40dc', 'FIRECUT', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:50.926455+07', '2025-04-27 11:45:50.926455+07', NULL);
INSERT INTO companies.company VALUES (45, 'e3aac348-9827-4088-8c79-b69f7e094caf', 'GITLAB', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:50.932954+07', '2025-04-27 11:45:50.932954+07', NULL);
INSERT INTO companies.company VALUES (46, '6059e3b5-02ea-4991-972b-084eb4388e1c', 'RUBYTHALIB.AI', NULL, NULL, NULL, NULL, 35, true, NULL, NULL, false, '2025-04-27 11:45:50.93968+07', '2025-04-27 11:45:50.93968+07', NULL);
INSERT INTO companies.company VALUES (47, '0923a685-8cbf-4ff8-a53d-a497efd27030', 'HANGRY', NULL, NULL, NULL, NULL, 14, true, NULL, NULL, false, '2025-04-27 11:45:50.944709+07', '2025-04-27 11:45:50.944709+07', NULL);
INSERT INTO companies.company VALUES (48, '12d15b87-c920-4c01-9522-17d13ac3b3e2', 'DNV', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:50.950878+07', '2025-04-27 11:45:50.950878+07', NULL);
INSERT INTO companies.company VALUES (49, '2515f52f-0c85-44b8-aa80-82b91091b075', 'CSG', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:50.957412+07', '2025-04-27 11:45:50.957412+07', NULL);
INSERT INTO companies.company VALUES (51, 'c6c19752-213e-46dc-b49e-39e9eef2d66b', 'GE VERNOVA', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:50.970704+07', '2025-04-27 11:45:50.970704+07', NULL);
INSERT INTO companies.company VALUES (54, '3c04ef01-d5cb-4df3-971d-c49d84d107bd', 'WYND LABS', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:50.991469+07', '2025-04-27 11:45:50.991469+07', NULL);
INSERT INTO companies.company VALUES (55, '02b89c4e-59bf-44c7-9155-b8f868b7a708', 'CONTRA', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:51.000068+07', '2025-04-27 11:45:51.000068+07', NULL);
INSERT INTO companies.company VALUES (56, 'fad7ba62-1dc4-4879-aa30-b7a177210b02', 'NEYBOX', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:51.008159+07', '2025-04-27 11:45:51.008159+07', NULL);
INSERT INTO companies.company VALUES (58, 'b95bfaff-b415-49a7-b851-905750e51199', 'LOVABLE', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:51.02238+07', '2025-04-27 11:45:51.02238+07', NULL);
INSERT INTO companies.company VALUES (64, 'e96800b8-021c-4114-a20e-577eac5fe084', 'LAUNCHGOOD', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:51.061951+07', '2025-04-27 11:45:51.061951+07', NULL);
INSERT INTO companies.company VALUES (65, '73ad44f1-841c-47b6-b812-7fc40d1dae57', 'MEDME HEALTH', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:51.069025+07', '2025-04-27 11:45:51.069025+07', NULL);
INSERT INTO companies.company VALUES (67, 'fb57c117-0cad-4395-a9e2-8e79d6005c86', 'AUTOMATTIC', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:51.082331+07', '2025-04-27 11:45:51.082331+07', NULL);
INSERT INTO companies.company VALUES (68, '065c19c7-4791-4319-b501-b7f24abaf272', 'INTERACTION DESIGN FOUNDATION', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:51.088769+07', '2025-04-27 11:45:51.088769+07', NULL);
INSERT INTO companies.company VALUES (69, '90741d64-827d-405e-bcb6-bcca1368ca84', 'NERS ANALYTICS LIMITED', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:51.095172+07', '2025-04-27 11:45:51.095172+07', NULL);
INSERT INTO companies.company VALUES (70, 'bac44186-fc44-4f81-a7e5-1985affb5184', 'WEGO', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:51.101642+07', '2025-04-27 11:45:51.101642+07', NULL);
INSERT INTO companies.company VALUES (72, '322bce73-724e-4379-a487-dc3752af1e8e', 'SENTIENT', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:51.114504+07', '2025-04-27 11:45:51.114504+07', NULL);
INSERT INTO companies.company VALUES (73, 'bb4af59c-0bcb-4e50-97da-bc4749443e1d', 'TESTLIO', NULL, NULL, NULL, NULL, 9997, true, NULL, NULL, false, '2025-04-27 11:45:51.120838+07', '2025-04-27 11:45:51.120838+07', NULL);


--
-- TOC entry 5193 (class 0 OID 18587)
-- Dependencies: 223
-- Data for Name: company_image; Type: TABLE DATA; Schema: companies; Owner: -
--



--
-- TOC entry 5195 (class 0 OID 18596)
-- Dependencies: 225
-- Data for Name: company_industry; Type: TABLE DATA; Schema: companies; Owner: -
--



--
-- TOC entry 5197 (class 0 OID 18602)
-- Dependencies: 227
-- Data for Name: industry_category; Type: TABLE DATA; Schema: companies; Owner: -
--

INSERT INTO companies.industry_category VALUES (1, 'AGRICULTURE & FARMING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (2, 'FORESTRY & LOGGING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (3, 'FISHING & AQUACULTURE', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (4, 'MINING & QUARRYING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (5, 'OIL & GAS EXTRACTION', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (6, 'CONSTRUCTION (RESIDENTIAL, COMMERCIAL, INFRASTRUCTURE)', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (7, 'AUTOMOTIVE MANUFACTURING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (8, 'AEROSPACE & DEFENSE', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (9, 'ELECTRONICS MANUFACTURING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (10, 'CHEMICAL & PLASTICS MANUFACTURING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (11, 'FOOD & BEVERAGE PRODUCTION', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (12, 'TEXTILES & APPAREL MANUFACTURING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (13, 'MACHINERY & TOOLS MANUFACTURING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (14, 'PHARMACEUTICAL MANUFACTURING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (15, 'PAPER & PULP MANUFACTURING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (16, 'FURNITURE MANUFACTURING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (17, 'RETAIL & WHOLESALE TRADE', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (18, 'TRANSPORTATION & LOGISTICS', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (19, 'HOSPITALITY & TOURISM', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (20, 'ENTERTAINMENT & MEDIA', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (21, 'HEALTHCARE & SOCIAL ASSISTANCE', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (22, 'EDUCATION & TRAINING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (23, 'REAL ESTATE & PROPERTY MANAGEMENT', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (24, 'BANKING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (25, 'INSURANCE', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (26, 'INVESTMENT & ASSET MANAGEMENT', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (27, 'LEGAL SERVICES', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (28, 'ACCOUNTING SERVICES', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (29, 'CONSULTING SERVICES', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (30, 'ARCHITECTURE & DESIGN SERVICES', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (31, 'INFORMATION TECHNOLOGY (IT) & SOFTWARE', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (32, 'TELECOMMUNICATIONS', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (33, 'PUBLIC ADMINISTRATION & GOVERNMENT SERVICES', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (34, 'UTILITIES (ELECTRICITY, WATER, GAS)', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (35, 'PERSONAL SERVICES (E.G., BEAUTY, WELLNESS, CLEANING)', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (36, 'PET CARE SERVICES', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (37, 'SCIENTIFIC RESEARCH & DEVELOPMENT', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (38, 'DATA & ANALYTICS', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (39, 'ARTIFICIAL INTELLIGENCE / MACHINE LEARNING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (40, 'BIOTECHNOLOGY', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (41, 'E-LEARNING & EDTECH', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (42, 'CYBERSECURITY', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (43, 'FINANCIAL TECHNOLOGY (FINTECH)', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (44, 'EXECUTIVE LEADERSHIP & POLICY MAKING', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (45, 'THINK TANKS', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (46, 'NON-PROFIT ORGANIZATIONS & NGOS', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (47, 'CULTURAL INSTITUTIONS & FOUNDATIONS', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');
INSERT INTO companies.industry_category VALUES (48, 'INTERNATIONAL ORGANIZATIONS (E.G., UN, WHO)', '2025-04-11 12:15:13.041987+07', '2025-04-11 12:15:13.041987+07');


--
-- TOC entry 5199 (class 0 OID 18608)
-- Dependencies: 229
-- Data for Name: job; Type: TABLE DATA; Schema: jobs; Owner: -
--

INSERT INTO jobs.job VALUES (19, '248892ba-2b06-4909-8d51-42ca8eb5c640', 22, 'SUBSCRIPT IS SEEKING A VERSATILE SOFTWARE ENGINEER PROFICIENT IN FRONTEND, BACKEND, OR FULL-STACK DEVELOPMENT TO JOIN THEIR TEAM. THE ROLE INVOLVES BUILDING AND ENHANCING THEIR SUBSCRIPTION INTELLIGENCE PLATFORM, FOCUSING ON DELIVERING ROBUST AND SCALABLE SOLUTIONS FOR B2B SAAS COMPANIES.', 'SOFTWARE ENGINEER (FRONTEND, BACKEND, OR FULL STACK)', '2024-11-21', 'HTTPS://APPLY.WORKABLE.COM/SUBSCRIPT/J/E58599B066/', NULL, NULL, 'IDR', 'MONTHLY', 15, true, '2025-04-27 11:20:06.552352+07', '2025-04-27 11:20:06.552352+07');
INSERT INTO jobs.job VALUES (21, 'cf00b74a-2594-4768-9d0f-7486d9559710', 25, 'WE ARE BUILDING AN INTELLIGENT EARLY DETECTION SYSTEM FOR PATIENT CARE—A $100B+ MARKET IN THE US ALONE. HEADQUARTERED IN CALIFORNIA, OUR PASSIONATE AND TALENTED TEAM IS TRANSFORMING HEALTHCARE BY DELIVERING REAL IMPACT TO PATIENTS AND PROVIDERS. WE ARE LOOKING FOR A SENIOR QA AUTOMATION ENGINEER WHO THRIVES IN A STARTUP ENVIRONMENT AND IS EAGER TO CONTRIBUTE TO THE NEXT HEALTHCARE UNICORN. THIS IS A HIGH-OWNERSHIP ROLE WHERE YOU WILL DRIVE THE QUALITY OF OUR WEB AND MOBILE APPLICATIONS. YOU ARE DETAIL-ORIENTED, PROACTIVE, AND COMFORTABLE WORKING IN A FAST-PACED, AGILE ENVIRONMENT WITH MINIMAL OVERSIGHT. WHAT YOU’LL DO: • DESIGN, BUILD, AND MAINTAIN AUTOMATION TEST FRAMEWORKS AND SCRIPTS. • LEAD QA EFFORTS FOR WEB AND MOBILE (IOS, ANDROID) APPLICATIONS. • WORK CLOSELY WITH DEVELOPERS AND PRODUCT TEAMS TO ENSURE SEAMLESS INTEGRATION OF QA PROCESSES. • EXECUTE TEST CASES, TRACK BUGS, AND MANAGE DEFECT LIFE CYCLES USING JIRA. • AUTOMATE TEST EXECUTION USING PYTEST + SELENIUM FOR WEB AND MOBILE TESTING. • ENSURE ADA COMPLIANCE FOR WEB APPLICATIONS AS NEEDED. • COLLABORATE IN AN AGILE ENVIRONMENT WITH A STRONG FOCUS ON CONTINUOUS IMPROVEMENT AND EFFICIENCY. WHAT YOU BRING: • 5+ YEARS OF EXPERIENCE IN QA AUTOMATION FOR WEB AND MOBILE APPLICATIONS. • PROFICIENCY IN PYTHON, SELENIUM, AND MOBILE TESTING FRAMEWORKS (IOS 9.0+, ANDROID 16.0+). • HANDS-ON EXPERIENCE WITH TESTRAIL, JIRA, GIT/GITHUB, JENKINS, AND GITHUB ACTIONS. • STRONG DEBUGGING AND PROBLEM-SOLVING SKILLS. • ABILITY TO WORK PST HOURS AND ADAPT TO A STARTUP’S DYNAMIC ENVIRONMENT. • EXCELLENT ATTENTION TO DETAIL, DOCUMENTATION, AND COMMUNICATION SKILLS. WORK HOURS: 6PM-2AM WIB WHY JOIN US? • SALARY: 50-80 IDR MIO / MONTH. • OPPORTUNITY TO SHAPE AND SCALE A GAME-CHANGING HEALTHTECH PLATFORM. • RAPID CAREER GROWTH WITH LEADERSHIP OPPORTUNITIES. • WORK WITH TOP-TIER ENGINEERING AND PRODUCT MENTORS. • 100% REMOTE, FLEXIBLE WORKING ENVIRONMENT. PREFERRED: STARTUP EXPERIENCE AND A PASSION FOR DIGITAL HEALTH INNOVATION. READY TO MAKE AN IMPACT? APPLY NOW AND BE PART OF SOMETHING BIG!', 'QA AUTOMATION TESTER (WEB AND MOBILE) - REMOTE', '2025-03-07', 'HTTPS://WELLFOUND.COM/JOBS/2726462-QA-AUTOMATION-TESTER-WEB-AND-MOBILE-REMOTE', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:20.424709+07', '2025-04-27 11:45:20.424709+07');
INSERT INTO jobs.job VALUES (22, '42fe700b-3692-419c-8280-8b6077d682f3', 28, 'BATAMON.ASIA IS SEEKING AN EXPERIENCED FULLSTACK DEVELOPER (AI INTEGRATION). KEY RESPONSIBILITIES INCLUDE BUILDING DYNAMIC UIS (REACT/VUE.JS), DEVELOPING BACKEND SERVICES (PYTHON/NODE.JS), INTEGRATING AI MODELS, AND ENSURING SECURE, HIGH-PERFORMANCE ARCHITECTURES. ROLES AND RESPONSIBILITIES: • ﻿﻿DESIGN, DEVELOP, AND MAINTAIN FULLSTACK WEB APPLICATIONS WITH SEAMLESS FRONTEND-BACKEND INTEGRATION TO SUPPORT AL-DRIVEN PRODUCTS. • ﻿﻿BUILD DYNAMIC, RESPONSIVE ULS USING REACT OR VUE.JS WHILE COLLABORATING WITH UI/UX TEAMS FOR INTUITIVE USER EXPERIENCES. • ﻿﻿DEVELOP AND OPTIMIZE BACKEND SERVICES USING PYTHON OR NODE.JS, ENSURING EFFICIENT DATABASE MANAGEMENT AND SECURE ARCHITECTURES. • ﻿﻿INTEGRATE AL MODELS INTO APPLICATIONS, ENHANCING PERFORMANCE, RELIABILITY, AND ALIGNMENT WITH BUSINESS NEEDS. • ﻿﻿DEVELOP AND MAINTAIN RESTFUL APLS AND MICROSERVICES WITH A FOCUS ON SECURITY, MODULARITY, AND HIGH PERFORMANCE. • ﻿﻿ENSURE CODE QUALITY THROUGH UNIT TESTING, CI/CD PIPELINES, RIGOROUS CODE REVIEWS, AND PERFORMANCE OPTIMIZATION TECHNIQUES. • ﻿﻿MONITOR PRODUCTION SYSTEMS, TROUBLESHOOT ISSUES, AND IMPLEMENT FIXES WHILE CONTINUOUSLY IMPROVING CODEBASES. • ﻿﻿STAY UPDATED ON FULLSTACK DEVELOPMENT, AL ADVANCEMENTS, AND EMERGING TECHNOLOGIES TO DRIVE INNOVATION AND EFFICIENCY. REQUIREMENTS: • ﻿﻿5+ YEARS OF FULLSTACK DEVELOPMENT EXPERIENCE WITH AL INTEGRATION, DELIVERING END-TO-END WEB APPLICATIONS. • ﻿﻿EXPERTISE IN REACT, VUE.JS, PYTHON, NODE.JS, PHP, SQL, AND NOSQL DATABASES, ENSURING SEAMLESS FRONTEND-BACKEND DEVELOPMENT. • ﻿﻿SKILLED IN AL MODEL INTEGRATION, LEVERAGING FRAMEWORKS, LIBRARIES, AND AL TOOLS LIKE CHATGPT AND GITHUB COPILOT. • ﻿﻿STRONG KNOWLEDGE OF RESTFUL APLS, MICROSERVICES, CLOUD PLATFORMS (AWS, AZURE, GCP), AND CONTAINERIZATION WITH DOCKER AND KUBERNETES. • ﻿﻿PROVEN ABILITY TO OPTIMIZE PERFORMANCE, SCALABILITY, AND RELIABILITY WHILE EXCELLING IN REMOTE COLLABORATION AND AGILE WORKFLOWS.', 'FULLSTACK DEVELOPER  - AL & SOFTWARE PROJECTS (REMOTE, INDONESIA)', '2025-03-11', 'HTTP://BIT.LY/APPLYGLOBALJOBNOW', NULL, NULL, 'IDR', 'MONTHLY', 56, true, '2025-04-27 11:45:50.787684+07', '2025-04-27 11:45:50.787684+07');
INSERT INTO jobs.job VALUES (23, '7034601c-3162-4e16-b95b-b92cf5649f54', 28, 'BATAMON.ASIA IS SEEKING AN AL WORKFLOW/AUTOMATION/SOLUTIONS ENGINEER TO DESIGN, BUILD, AND OPTIMIZE AI-DRIVEN AUTOMATED WORKFLOWSUSING PLATFORMS LIKE N8N, LATENODE, AND ZAPIER. ROLES AND RESPONSIBILITIES: • ﻿﻿DESIGN AND BUILD AUTOMATED WORKFLOWS INTEGRATING AL-DRIVEN SOLUTIONS TO OPTIMIZE BUSINESS PROCESSES AND HANDLE OPERATIONAL TASKS. • ﻿﻿USE PLATFORMS LIKE N8N, LATENODE, OR ZAPIER TO CREATE SCALABLE AUTOMATION SOLUTIONS AND INTEGRATE APPLICATIONS AND APIS FOR SEAMLESS DATA FLOW. • ﻿﻿COLLABORATE WITH TEAMS TO IDENTIFY AUTOMATION OPPORTUNITIES AND CONVERT BUSINESS OBJECTIVES INTO TECHNICAL AL AND AUTOMATION SOLUTIONS. • ﻿﻿MONITOR AUTOMATED WORKFLOWS FOR PERFORMANCE, DIAGNOSE ISSUES, AND RESOLVE THEM QUICKLY TO ENSURE SYSTEM STABILITY. • ﻿﻿REFINE AUTOMATION PIPELINES FOR EFFICIENCY AND SCALABILITY, AND MAINTAIN DETAILED TECHNICAL DOCUMENTATION AND WORKFLOW DIAGRAMS. • ﻿﻿STAY UPDATED ON AL AND AUTOMATION TRENDS, PROPOSE INNOVATIVE SOLUTIONS, AND WORK WITH STAKEHOLDERS TO MEET PROJECT GOALS ACROSS TEAMS. REQUIREMENTS: • ﻿﻿AT LEAST 5 YEARS IN WORKFLOW AUTOMATION AND AL SOLUTIONS ENGINEERING, WITH FAMILIARITY IN AGENTIC AL METHODOLOGIES A PLUS. • ﻿﻿STRONG IN SCRIPTING LANGUAGES (E.G., PYTHON, JAVASCRIPT), AP| INTEGRATIONS, AND DATA PROCESSING. EXPERIENCE WITH AL TOOLS FOR TASK MANAGEMENT. • ﻿﻿PROFICIENT IN WORKFLOW AUTOMATION PLATFORMS LIKE ZAPIER, LATENODE, OR N8N, AND AL-BASED TOOLS LIKE CHATGPT AND GITHUB COPILOT. • ﻿﻿EXCELLENT AT ASSESSING BUSINESS PROCESSES, TROUBLESHOOTING, AND IMPLEMENTING LONG-TERM SOLUTIONS. • ﻿﻿STRONG COMMUNICATION SKILLS, EFFECTIVE COLLABORATION WITH REMOTE TEAMS, AND ABILITY TO ADAPT TO EVOLVING AL AND AUTOMATION TECHNOLOGIES. • ﻿﻿COMFORTABLE WITH PERFORMANCE-BASED COMPENSATION, MEETING DEADLINES, AND WORKING INDEPENDENTLY IN A REMOTE ENVIRONMENT.', 'AL WORKFLOW/AUTOMATION/SOLUTIONS ENGINEER (REMOTE, INDONESIA)', '2025-03-11', 'HTTP://BIT.LY/APPLYGLOBALJOBNOW', NULL, NULL, 'IDR', 'MONTHLY', 56, true, '2025-04-27 11:45:50.820832+07', '2025-04-27 11:45:50.820832+07');
INSERT INTO jobs.job VALUES (24, '9d9a408e-286b-4783-8863-f173d02151ad', 28, 'BATAMON.ASIA IS SEEKING A BUSINESS DEVELOPMENT EXECUTIVE TO EXPLORE NEW MARKET OPPORTUNITIES, BUILD STRATEGIC PARTNERSHIPS, AND DRIVE GROWTH IN KEY REGIONS LIKE SINGAPORE, HONG KONG, NEW YORK, AND DUBAI. ROLES AND RESPONSIBILITIES: • ﻿﻿RESEARCH NEW BUSINESS OPPORTUNITIES AND DEVELOP STRATEGIES FOR KEY MARKETS LIKE SINGAPORE, HONG KONG, NEW YORK, AND DUBAI. • ﻿﻿ANALYZE TRENDS, COMPETITORS, AND CUSTOMER NEEDS TO GUIDE DECISION-MAKING ON AL AND TECHNOLOGY SOLUTIONS. • ﻿﻿NURTURE RELATIONSHIPS WITH VENDORS AND REFERRAL PARTNERS, ENSURING A CONSISTENT LEAD FLOW AND MEETING SALES TARGETS. • ﻿﻿ASSIST IN CREATING PROPOSALS AND COORDINATING WITH CROSS-FUNCTIONAL TEAMS TO ALIGN WITH CLIENT NEEDS. • ﻿﻿SUPPORT NEGOTIATIONS AND STRUCTURING DEALS WITH VENDORS, SETTING CLEAR MILESTONES AND PERFORMANCE METRICS. • ﻿﻿REPRESENT THE COMPANY AT EVENTS AND PROVIDE INSIGHTS TO ADJUST STRATEGIES BASED ON BUSINESS PERFORMANCE. REQUIREMENTS: • ﻿﻿AT LEAST 4 YEARS IN BUSINESS DEVELOPMENT WITHIN THE TECHNOLOGY OR SOFTWARE SECTOR, WITH KNOWLEDGE OF AL SOLUTIONS PREFERRED. • ﻿﻿EXPERIENCE DEVELOPING STRATEGIES FOR INTERNATIONAL MARKETS LIKE SINGAPORE, HONG KONG, NEW YORK, AND DUBAI, WITH AN UNDERSTANDING OF REGIONAL CULTURAL AND REGULATORY NUANCES. • ﻿﻿EXCEPTIONAL VERBAL AND WRITTEN SKILLS, ABLE TO EXPLAIN COMPLEX AL CONCEPTS CLEARLY. PROVEN ABILITY TO BUILD AND MAINTAIN RELATIONSHIPS WITH PARTNERS AND CLIENTS. • ﻿﻿SKILLED IN MARKET RESEARCH AND DATA ANALYTICS, LEVERAGING AL TOOLS FOR OPERATIONAL SUPPORT AND BUSINESS STRATEGIES. • ﻿﻿HIGHLY SELF-DRIVEN AND ADAPTABLE IN FAST-PACED, REMOTE ENVIRONMENTS, MEETING BUSINESS TARGETS AND DEADLINES. • ﻿﻿TRACK RECORD OF MEETING AMBITIOUS SALES AND PARTNERSHIP GOALS, COMFORTABLE WORKING WITHIN A PERFORMANCE-BASED COMPENSATION MODEL.', 'BUSINESS DEVELOPMENT EXECUTIVE (REMOTE, INDONESIA)', '2025-03-11', 'HTTP://BIT.LY/APPLYGLOBALJOBNOW', NULL, NULL, 'IDR', 'MONTHLY', 56, true, '2025-04-27 11:45:50.827802+07', '2025-04-27 11:45:50.827802+07');
INSERT INTO jobs.job VALUES (43, '40d71cd2-7cf0-451c-9754-37e46587b332', 49, 'CSG IS SEEKING A LEAD FRONTEND ENGINEER TO JOIN THEIR TEAM IN INDONESIA. THE ROLE INVOLVES DRIVING TECHNICAL DIRECTION, MENTORING THE TEAM, AND COLLABORATING ON UI/UX SOLUTIONS FOR THE CSQ QUOTE & ORDER PRODUCT. THE POSITION REQUIRES AT LEAST 7 YEARS OF EXPERIENCE IN FRONTEND DEVELOPMENT AND OFFERS BENEFITS LIKE MEDICAL INSURANCE, WORK FROM HOME, AND PAID VACATION.', 'LEAD FRONTEND ENGINEER', '2025-03-27', 'HTTPS://CSGI.WD5.MYWORKDAYJOBS.COM/EN-US/CSGCAREERS/JOB/INDONESIA-REMOTE/LEAD-FRONTEND-ENGINEER_29068?REMOTETYPE=D0C4F782266D1000C2BE6D47736A0000&LOCATIONS=5B7D5DA3E2551000CDB28EE56EB80000', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.957412+07', '2025-04-27 11:45:50.957412+07');
INSERT INTO jobs.job VALUES (25, '5b2f1240-2bec-4f0f-b026-88b56dc1f080', 28, 'BATAMON.ASIA IS LOOKING FOR A CUSTOMER SUPPORT OFFICER TO PROVIDE PROMPT ASSISTANCE FOR ODOO ERP AND AI PRODUCTS, TROUBLESHOOT ISSUES, AND ENSURE CUSTOMER SATISFACTION. ROLES AND RESPONSIBILITIES: • ﻿﻿PROVIDE PROMPT SUPPORT FOR ODOO ERP AND AL PRODUCTS, DIAGNOSING AND RESOLVING ISSUES TO MINIMIZE CUSTOMER DOWNTIME. • ﻿﻿RESPOND TO TECHNICAL INQUIRIES AND IDENTIFY ROOT CAUSES OF ISSUES, DELIVERING ACCURATE AND TIMELY SOLUTIONS. • ﻿﻿LOG AND TRACK CUSTOMER ISSUES WITH DETAILED NOTES, MAINTAINING AN ORGANIZED TICKETING OR CRM SYSTEM FOR RESOLUTION. • ﻿﻿UPDATE AND MANAGE SUPPORT RESOURCES LIKE FAQS, GUIDES, AND BEST PRACTICES, STAYING CURRENT ON PRODUCT CHANGES. • ﻿﻿DEVELOP CLEAR HELP MATERIALS SUCH AS MANUALS, TUTORIALS, AND VIDEOS, COLLABORATING WITH TEAMS TO KEEP THEM UPDATED. • ﻿﻿ESCALATE COMPLEX ISSUES TO TECHNICAL TEAMS AND ENSURE FOLLOW-THROUGH FOR TIMELY RESOLUTION. • ﻿﻿BUILD STRONG CUSTOMER RELATIONSHIPS, ENSURING HIGH SATISFACTION AND OFFERING GUIDANCE ON BEST PRACTICES FOR USING ODOO AND AL SOLUTIONS. REQUIREMENTS: • ﻿﻿AT LEAST 4 YEARS IN CUSTOMER OR TECHNICAL SUPPORT WITHIN SOFTWARE INDUSTRY, WITH EXPERIENCE IN ERP SYSTEMS (ODOO PREFERRED) AND AL TECHNOLOGIES. • ﻿﻿BASIC UNDERSTANDING OF ERP AND AL SOLUTIONS, WITH THE ABILITY TO TROUBLESHOOT COMMON ISSUES AND ADAPT TO NEW SOFTWARE. • ﻿﻿STRONG VERBAL AND WRITTEN COMMUNICATION, ABLE TO CONVEY TECHNICAL INFO CLEARLY TO NON-TECHNICAL USERS, WITH PROFESSIONAL PHONE AND EMAIL ETIQUETTE. • ﻿﻿STRONG ANALYTICAL SKILLS TO DIAGNOSE AND RESOLVE CUSTOMER ISSUES, REMAINING CALM UNDER PRESSURE. • ﻿﻿PROACTIVE, EMPATHETIC, AND COMMITTED TO EXCEEDING CUSTOMER EXPECTATIONS FOR RESPONSE TIME AND SOLUTION QUALITY. • ﻿﻿SELF-MOTIVATED AND ORGANIZED, ABLE TO WORK INDEPENDENTLY, MANAGE TIME EFFECTIVELY, AND MEET DEADLINES WITH MINIMAL SUPERVISION.', 'CUSTOMER SUPPORT OFFICER - ODOO & AL PROJECTS (REMOTE, INDONESIA)', '2025-03-11', 'HTTP://BIT.LY/APPLYGLOBALJOBNOW', NULL, NULL, 'IDR', 'MONTHLY', 56, true, '2025-04-27 11:45:50.83604+07', '2025-04-27 11:45:50.83604+07');
INSERT INTO jobs.job VALUES (26, '596b3033-cda4-404d-8e75-dd140f0152f2', 28, 'BATAMON.ASIA IS SEEKING A DEVOPS ENGINEER TO MANAGE CLOUD INFRASTRUCTURE, AUTOMATE CI/CD PIPELINES, CONTAINERIZE APPLICATIONS, AND OPTIMIZE SYSTEM PERFORMANCE FOR SCALABLE AND SECURE DEPLOYMENTS. ROLES AND RESPONSIBILITIES: • ﻿﻿OVERSEE DEVOPS TASKS, COORDINATE WITH TEAMS FOR RELEASES, AND MANAGE INFRASTRUCTURE ACROSS CLOUD PLATFORMS (AWS, AZURE, GCP) AND ON-PREM. • ﻿﻿DESIGN AND MAINTAIN CI/CD PIPELINES, AUTOMATING CODE TESTING AND DELIVERY WHILE COLLABORATING WITH DEVELOPMENT TEAMS. • ﻿﻿USE LAC TOOLS (TERRAFORM, ANSIBLE) FOR STANDARDIZED DEPLOYMENTS, ENSURING VERSION CONTROL AND CHANGE MANAGEMENT BEST PRACTICES. • ﻿﻿CONTAINERIZE APPLICATIONS WITH DOCKER, MANAGE ORCHESTRATION WITH KUBERNETES, AND OPTIMIZE MICROSERVICES FOR SCALE AND RELIABILITY. • ﻿﻿SET UP MONITORING SOLUTIONS (E.G., PROMETHEUS, GRAFANA), DEVELOP INCIDENT RESPONSE PROTOCOLS, AND RESOLVE PRODUCTION ISSUES SWIFTLY. • ﻿﻿OPTIMIZE SYSTEM PERFORMANCE THROUGH CACHING AND LOAD BALANCING, WHILE INTEGRATING SECURITY PRACTICES THROUGHOUT THE DEVOPS LIFECYCLE AND MAINTAINING COMPLIANCE. REQUIREMENTS: • ﻿﻿AT LEAST 5 YEARS IN DEVOPS OR SIMILAR ROLES, MANAGING INFRASTRUCTURE, CI/CD PIPELINES, PRODUCTION ENVIRONMENTS AND ABLE TO HANDLE MULTIPLE PROJECTS. • ﻿﻿PROFICIENT IN CLOUD PLATFORMS (AWS, AZURE, GCP), CONTAINERIZATION (DOCKER, KUBERNETES), LAC TOOLS (TERRAFORM, ANSIBLE), SCRIPTING (BASH, PYTHON), AND MONITORING/LOGGING TOOLS (PROMETHEUS, GRAFANA, ELK). • ﻿﻿STRONG UNDERSTANDING OF DEVSECOPS PRINCIPLES, SECRETS MANAGEMENT, AND VULNERABILITY SCANNING. • ﻿﻿EXCELLENT INTERPERSONAL SKILLS FOR REMOTE COLLABORATION AND PRESENTING TECHNICAL CONCEPTS TO VARIOUS STAKEHOLDERS. • ﻿﻿SKILLED IN DIAGNOSING ISSUES, CREATING SOLUTIONS, AND ADAPTING TO NEW TECHNOLOGIES AND EVOLVING NEEDS. • ﻿﻿SELF-MOTIVATED, ORGANIZED, AND CAPABLE OF WORKING INDEPENDENTLY IN A REMOTE ENVIRONMENT, MEETING DEADLINES, AND DELIVERING HIGH-QUALITY WORK.', 'DEVOPS ENGINEER (REMOTE, INDONESIA)', '2025-03-11', 'HTTP://BIT.LY/APPLYGLOBALJOBNOW', NULL, NULL, 'IDR', 'MONTHLY', 56, true, '2025-04-27 11:45:50.842959+07', '2025-04-27 11:45:50.842959+07');
INSERT INTO jobs.job VALUES (27, 'dc4eae46-076a-4465-8d61-cd67dd76f988', 28, 'BATAMON.ASIA IS LOOKING FOR A QA ENGINEER TO DESIGN TEST PLANS, EXECUTE AUTOMATED AND MANUAL TESTING, IDENTIFY DEFECTS, AND ENSURE THE QUALITY OF ODOO ERP AND AI-DRIVEN SOLUTIONS. ROLES AND RESPONSIBILITIES: • ﻿﻿DESIGN COMPREHENSIVE TEST PLANS FOR ODOO ERP AND AL-DRIVEN SOLUTIONS, COLLABORATING WITH PROJECT TEAMS TO ALIGN ON OBJECTIVES. • ﻿﻿CREATE AND EXECUTE AUTOMATED TEST SCRIPTS, WHILE PERFORMING MANUAL TESTS AND EXPLORATORY TESTING TO IDENTIFY EDGE CASES AND VULNERABILITIES. • ﻿﻿COLLABORATE WITH DEVELOPERS TO IDENTIFY, DOCUMENT, AND TRACK DEFECTS, PROVIDING CLEAR FEEDBACK FOR RESOLUTION. • ﻿﻿CONDUCT REGRESSION TESTS TO ENSURE STABILITY AND PERFORMANCE TESTS FOR SCALABILITY. • ﻿﻿IMPLEMENT QA BEST PRACTICES, ENSURING HIGH-QUALITY STANDARDS AND CONTINUOUSLY OPTIMIZING TESTING PROCESSES. • ﻿﻿MAINTAIN DETAILED TEST DOCUMENTATION AND COLLABORATE WITH CROSS-FUNCTIONAL TEAMS TO IMPROVE TESTING PROCESSES AND OVERALL PRODUCT QUALITY. REQUIREMENTS: • ﻿﻿AT LEAST 5 YEARS IN QA OR SOFTWARE TESTING WITH ERP (ODOO) AND AL-DRIVEN SOLUTIONS, WITH EXPERIENCE IN BOTH MANUAL AND AUTOMATED TESTING. • ﻿﻿STRONG KNOWLEDGE OF QA METHODOLOGIES, TESTING TOOLS (E.G., SELENIUM, ROBOT FRAMEWORK), AND AUTOMATED TESTING PIPELINES. FAMILIAR WITH AL TOOLS FOR TASK MANAGEMENT. • ﻿﻿PROFICIENT IN PYTHON OR JAVASCRIPT FOR TEST AUTOMATION SCRIPTS. EXPERIENCED WITH VERSION CONTROL (E.G., GIT) AND CI/CD PIPELINES. • ﻿﻿STRONG ATTENTION TO DETAIL AND PROBLEM-SOLVING SKILLS, WITH THE ABILITY TO IDENTIFY AND RESOLVE COMPLEX DEFECTS. • ﻿﻿EXCELLENT COMMUNICATION SKILLS FOR REMOTE TEAMWORK, WITH THE ABILITY TO EXPLAIN TECHNICAL DETAILS TO NON-TECHNICAL STAKEHOLDERS. • ﻿﻿QUICK TO LEARN NEW TECHNOLOGIES, ADAPTABLE TO EVOLVING PROJECT NEEDS, AND EXPERIENCED IN REMOTE WORK ENVIRONMENTS WITH A FOCUS ON MEETING DEADLINES AND PRODUCING HIGH-QUALITY WORK INDEPENDENTLY.', 'QA ENGINEER - ODOO & AL PROJECTS (REMOTE, INDONESIA)', '2025-03-11', 'HTTP://BIT.LY/APPLYGLOBALJOBNOW', NULL, NULL, 'IDR', 'MONTHLY', 56, true, '2025-04-27 11:45:50.849438+07', '2025-04-27 11:45:50.849438+07');
INSERT INTO jobs.job VALUES (28, '095f8c90-5436-4914-b048-4b39ec068e69', 34, 'JOIN ALEX SOLUTIONS TO WORK ON AI-DRIVEN INNOVATION, INTEGRATING AI AND GENAI ACROSS THE PRODUCT DEVELOPMENT LIFECYCLE. THE ROLE INVOLVES LEVERAGING AI FOR NATURAL LANGUAGE SEARCH, ENRICHMENT, CLASSIFICATION, AND ANOMALY DETECTION.', 'CLOUD SUPPORT ENGINEER', '2025-03-13', 'HTTPS://WWW.LINKEDIN.COM/JOBS/VIEW/4122773041', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.85634+07', '2025-04-27 11:45:50.85634+07');
INSERT INTO jobs.job VALUES (29, 'e85df983-69b7-4ab7-92aa-96b46dcd6cdb', 34, 'JOIN ALEX SOLUTIONS TO WORK ON AI-DRIVEN INNOVATION, INTEGRATING AI AND GENAI ACROSS THE PRODUCT DEVELOPMENT LIFECYCLE. FOCUS ON NATURAL LANGUAGE SEARCH, ENRICHMENT, CLASSIFICATION, AND ANOMALY DETECTION.', 'FULL STACK ENGINEER', '2025-03-13', 'HTTPS://WWW.LINKEDIN.COM/JOBS/VIEW/4122772084', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.864455+07', '2025-04-27 11:45:50.864455+07');
INSERT INTO jobs.job VALUES (30, 'dc856c3c-8761-4dea-a1e2-d6ffb6ff3994', 36, 'COFFEESPACE IS A PLATFORM DESIGNED TO HELP ANYONE BUILD THEIR EARLY STARTUP TEAM. THEY ARE STARTING WITH COFOUNDER MATCHING, MAKING IT EASIER TO FIND THE RIGHT PARTNERS TO BUILD WITH, ESPECIALLY IN TODAY''S RAPIDLY EVOLVING ENVIRONMENT.', 'FULL-STACK SOFTWARE ENGINEER', '2025-03-13', 'HTTPS://WWW.LINKEDIN.COM/JOBS/VIEW/4181237772/', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.871311+07', '2025-04-27 11:45:50.871311+07');
INSERT INTO jobs.job VALUES (31, 'c941b06a-1419-4c71-ade1-63fb3352e04a', 37, 'AT FLY.IO, THE INFRA OPS TEAM BUILDS AND MAINTAINS THE PLATFORM AND TOOLING THAT ALLOW OUR PRODUCT ENGINEERS TO BUILD SOME REALLY AMAZING STUFF FOR USERS. IN PARTICULAR, THAT MEANS MAKING IT SO THAT PRODUCT TEAMS (MACHINES, MANAGED POSTGRES, PROXY/NETWORKING, ETC.) CAN OPERATE THE PRODUCTS THEY’RE BUILDING WELL. SOME THINGS YOU MIGHT WORK ON: SETTING UP AND ITERATING ON TOOLING FOR METRICS/MONITORING AND ALERTING, SO THAT PRODUCT TEAMS CAN RELIABLY OPERATE THEIR PRODUCTS. WRITING LOTS OF “GLUE” CODE INTEGRATING VARIOUS TOOLS IN WAYS THAT ARE VALUABLE (AND EASY TO USE) FOR PRODUCT TEAMS. PIECING TOOLS TOGETHER IN CLEVER/NEW/INTERESTING WAYS TO SOLVE PRODUCT TEAM NEEDS. HELPING REFINE CAPACITY PLANNING, AND AUTOMATING QUICK BURST CAPACITY (FOR WHEN OUR CAPACITY PLANNING ISN’T QUITE RIGHT). BUILDING THE UNDERLYING HOSTING INFRASTRUCTURE THAT ALLOWS PRODUCT TEAMS TO RUN MULTI-TENANT WORKLOADS WITHOUT HAVING TO WORRY ABOUT INDIVIDUAL HOSTS. RESPONDING TO HARDWARE FAILURES, AND INTERFACING WITH OUR PROVIDER TO GET HARDWARE CHANGED OUT AS NEEDED. MAKING IT EASY AND SAFE (AND AS AUTOMATIC AS POSSIBLE) TO MAKE CHANGES TO CRITICAL SYSTEM COMPONENTS (LIKE UPGRADING THE OS ON OUR SERVERS). WORKING WITH OUR UPSTREAM PROVIDERS TO DEBUG HAIRY NETWORKING ISSUES. THIS ROLE WILL BE A GOOD FIT FOR YOU IF: YOU’RE GOOD AT FIGURING OUT WHAT PRODUCT TEAMS REALLY NEED IN ORDER TO BUILD AND OPERATE THEIR PRODUCTS. YOU KNOW CORE INFRASTRUCTURE TECH CONCEPTS AND TOOLS (LINUX, NETWORKING, ETC.). YOU’RE GOOD AT DEBUGGING, FIGURING OUT WEIRD STUFF, PICKING UP NEW TOOLS AND WAYS OF DOING THINGS, AND YOU CAN DO IT ALL UNDER PRESSURE. YOU CAN WORK AUTONOMOUSLY — YOU CAN LOOK AT A BIG PROBLEM, AND FIGURE OUT A SMALL PIECE TO WORK ON NEXT, WITHOUT BEING TOLD WHAT TO DO, AND YOU CAN SEE THE LONG-TERM VISION OF WHERE TO GO AFTER THAT. YOU ARE VERY EFFECTIVE AT WRITTEN COMMUNICATION. YOU CAN WRITE CONCISELY, FOCUSING ON THE MOST IMPORTANT POINTS, AND YOU CONSIDER YOUR AUDIENCE. YOU ARE GOOD AT SHARING OWNERSHIP AND WORKING ON A TEAM. YOU MOVE FAST. THIS ABSOLUTELY DOES NOT MEAN YOU OVER-WORK YOURSELF (WE WANT YOU TO WORK NORMAL HUMAN HOURS AND TAKE CARE OF YOURSELF), BUT IT MEANS THAT YOU’RE DECISIVE, WORK WITH PURPOSE, AND DON’T LET YOURSELF GET BOGGED DOWN IN LESS IMPACTFUL WORK. YOU’LL KNOW YOU’RE SUCCEEDING IN YOUR JOB IF: YOU’RE ALWAYS THINKING ABOUT HOW FOLKS ON THE PRODUCT TEAMS ARE USING THE TOOLS YOU’RE BUILDING, AND WHAT PROBLEM YOU’RE SOLVING FOR THEM. YOUR SOLUTIONS ARE BROADLY USEFUL. YOU PROBABLY HAD ONE SMALL INITIAL USE-CASE IN MIND, BUT THE THING YOU BUILT GETS USED AGAIN AND AGAIN, BY SEVERAL DIFFERENT PRODUCT TEAMS. PRODUCT TEAMS AT FLY.IO ARE ABLE TO BUILD NEW FEATURES FAST ON TOP OF THE INFRASTRUCTURE YOU’VE BUILT. PRODUCT TEAMS AT FLY.IO ARE ABLE TO OPERATE THEIR PRODUCTS EFFECTIVELY. THEY KNOW WHEN THEIR PRODUCT IS WORKING (AND WHEN IT’S NOT), AND HAVE THE TOOLS THEY NEED TO QUICKLY SOLVE PROBLEMS.', 'INFRASTRUCTURE ENGINEER-LEVEL 2/SENIOR', '2025-03-13', 'HTTPS://FLY.IO/JOBS/INFRA-ENGINEER/', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.878289+07', '2025-04-27 11:45:50.878289+07');
INSERT INTO jobs.job VALUES (32, 'd1dcd8b5-1504-4406-a170-b623f4f7408d', 37, 'WE’RE LOOKING FOR ENGINEERS TO JOIN THE TEAM WORKING ON OUR ANYCAST NETWORK AND ITS CORE COMPONENT, FLY-PROXY. WHAT WE’RE DOING NOW THERE ARE TWO BIG PROJECTS HAPPENING WITH OUR NETWORK STACK RIGHT NOW. THE FIRST IS REGIONALIZATION. WE’VE GOTTEN AS FAR AS WE’RE GOING TO GET WITH A SINGLE FLAT GLOBAL TOPOLOGY. THE NEXT ITERATION OF OUR PROXY ARCHITECTURE RUNS MULTIPLE CORROSION INSTANCES, FOR EACH REGION, AND PUBLISHES SUMMARY INFORMATION TO THE GLOBAL CLOUD; FOR A DEEP-CUT ANALOGY, THINK OF HOW OSPF DOES AREAS. THIS HAS PROFOUND IMPLICATIONS ON HOW OUR PROXIES HANDLE THINGS LIKE BALANCING AND FLY-REPLAY. THE SECOND BIG PROJECT IS EVOLVING OUR PRIVATE NETWORKING PRIMITIVES. THIS WILL INVOLVE GIVING FLY MACHINES STABLE ADDRESSES THAT CAN BE MOVED FROM HARDWARE SERVER TO HARDWARE SERVER, AND PROVIDING FINER-GRAINED ACCESS CONTROL, SO THAT IT’S EVEN EASIER TO RUN UNTRUSTED WORKLOADS ON FLY MACHINES WITHOUT HAVING TO DO FIDDLY THINGS INSIDE OF FLY MACHINES. WE THINK THESE ARE FUN PROBLEMS. WE CAN’T PROMISE THEY WON’T BE STRESSFUL PROBLEMS. IF THAT’S A KIND OF BITTERSWEET YOU’RE INTERESTED IN, LET’S SEE IF WE’D WORK WELL TOGETHER. THE SALARY FOR THIS ROLE IS $190 TO $225K USD, DEPENDING ON LEVEL. IF YOU’RE INTERESTED, MAIL JOBS+PLATFORM-PROXY@FLY.IO. YOU CAN TELL US A BIT ABOUT YOURSELF, IF YOU LIKE. PLEASE ALSO INCLUDE YOUR LOCATION (COUNTRY), AND YOUR GITHUB USERNAME, FOR WORK SAMPLE ACCESS.', 'PLATFORM ENGINEER: PROXY - SENIOR', '2025-03-13', 'HTTPS://FLY.IO/JOBS/PLATFORM-PROXY/', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.887681+07', '2025-04-27 11:45:50.887681+07');
INSERT INTO jobs.job VALUES (44, 'd8d2db4a-047e-444b-852a-ddfca183ec60', 49, 'CSG IS SEEKING A FRONTEND SOFTWARE ENGINEER TO JOIN THEIR TEAM, FOCUSING ON PRODUCT R&D, INNOVATION, AND OWNERSHIP. THE ROLE INVOLVES USING ANGULAR, WEB COMPONENTS, AND REST API, WITH A FOCUS ON BUILDING USER-FRIENDLY UI/UX. CANDIDATES SHOULD HAVE 3+ YEARS OF EXPERIENCE IN FRONT-END DEVELOPMENT AND A BACHELOR''S DEGREE IN A RELATED FIELD.', 'FRONTEND SOFTWARE ENGINEER | PRODUCT R&D, INNOVATION & OWNERSHIP', '2025-03-27', 'HTTPS://CSGI.WD5.MYWORKDAYJOBS.COM/EN-US/CSGCAREERS/JOB/INDONESIA-REMOTE/FRONTEND-SOFTWARE-ENGINEER---PRODUCT-R-D--INNOVATION---OWNERSHIP_29189?REMOTETYPE=D0C4F782266D1000C2BE6D47736A0000&LOCATIONS=5B7D5DA3E2551000CDB28EE56EB80000', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.963837+07', '2025-04-27 11:45:50.963837+07');
INSERT INTO jobs.job VALUES (33, 'e222ee4c-7fd1-4b61-b084-077e9f64fdff', 37, 'WE’RE LOOKING FOR ENGINEERS TO JOIN THE TEAM WORKING ON FLY MACHINES AND THEIR ORCHESTRATOR, FLYD. WHAT WE’RE DOING NOW : FLY MACHINES ARE MAKING A BEELINE TOWARDS ENABLING TWO BIG INTERNAL USE CASES FOR US. THE FIRST IS MPG, OUR UPCOMING MANAGED POSTGRES OFFERING. BEING A PLATFORM FOR MANAGED DATABASE MEANS BEING GOOD BOTH AT MANAGING COMPUTE RESOURCES AND, ESPECIALLY, STORAGE — AND WE’RE CHASING DOWN A BUNCH OF INTERESTING IDEAS THERE. BUT MORE THAN ANYTHING ELSE IT INVOLVES MAKING MACHINES MOVE, AND IMPROVING AND TOOLING UP MACHINE MIGRATION SO WE CAN TRANSPARENTLY SHUFFLE WORKLOADS. THE SECOND USE CASE IS LLM EXECUTION ENVIRONMENTS. A CRAZY THING HAPPENS WHEN YOU GIVE A HALLUCINATION-PRONE LLM ACCESS TO A SECURE, EPHEMERAL ENVIRONMENT WITH WHICH TO ACTUALLY COMPILE AND RUN CODE: THE LLM ACTUALLY GETS GOOD AT CODING. MAKING THIS WORK WELL FOR CUSTOMERS MEANS GIVING FLY MACHINES SAFE ACCESS TO APIS AND SECRETS WITHOUT EXPOSING THEM TO UNTRUSTED CODE, AND MANAGING GIGANTIC POOLS OF MACHINES. WE THINK THESE ARE FUN PROBLEMS. WE CAN’T PROMISE THEY WON’T BE STRESSFUL PROBLEMS. IF THAT’S A KIND OF BITTERSWEET YOU’RE INTERESTED IN, LET’S SEE IF WE’D WORK WELL TOGETHER. THE SALARY FOR THIS ROLE IS $190 TO $225K USD, DEPENDING ON LEVEL. IF YOU’RE INTERESTED, MAIL JOBS+PLATFORM-MACHINES@FLY.IO. YOU CAN TELL US A BIT ABOUT YOURSELF, IF YOU LIKE. PLEASE ALSO INCLUDE YOUR LOCATION (COUNTRY), AND YOUR GITHUB USERNAME, FOR WORK SAMPLE ACCESS.', 'PLATFORM ENGINEER: FLY MACHINES - SENIOR', '2025-03-13', 'HTTPS://FLY.IO/JOBS/PLATFORM-MACHINES/', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.89388+07', '2025-04-27 11:45:50.89388+07');
INSERT INTO jobs.job VALUES (34, '58399fe2-aa94-4ed4-be17-9b4fa473bf34', 40, 'PITCH IS HIRING SENIOR ACCOUNT EXECUTIVES FOR THE APAC REGION TO DRIVE SALES AND EXPAND THEIR CUSTOMER BASE. THE ROLE INVOLVES MANAGING THE ENTIRE SALES CYCLE, BUILDING RELATIONSHIPS, AND ACHIEVING SALES TARGETS. CANDIDATES SHOULD HAVE EXPERIENCE IN SAAS SALES, EXCELLENT COMMUNICATION SKILLS, AND A TRACK RECORD OF MEETING SALES GOALS.', 'SENIOR ACCOUNT EXECUTIVE – APAC', '2025-03-15', 'HTTPS://BIRD.COM/EN-US/CAREERS/JOB?ASHBY_JID=668F98F8-F224-4F55-B8A6-97F184F6C0E0', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.899625+07', '2025-04-27 11:45:50.899625+07');
INSERT INTO jobs.job VALUES (35, '0e828a80-aaaf-4e43-a7c2-b80c15c0b9ac', 41, 'ATTAC IS SEEKING ACCOUNT EXECUTIVES FOR THE APAC REGION TO DRIVE GROWTH AND MANAGE CLIENT RELATIONSHIPS. THE ROLE INVOLVES WORKING WITH THE SALES TEAM, DEVELOPING STRATEGIES, AND MEETING SALES TARGETS. CANDIDATES SHOULD HAVE 3-5 YEARS OF EXPERIENCE IN SAAS SALES, STRONG COMMUNICATION SKILLS, AND A PROVEN TRACK RECORD IN SALES.', 'ACCOUNT EXECUTIVE - APAC', '2025-03-15', 'HTTPS://BIRD.COM/EN-US/CAREERS/JOB?ASHBY_JID=757EADDE-CB88-4952-934C-6333AE783277', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.906654+07', '2025-04-27 11:45:50.906654+07');
INSERT INTO jobs.job VALUES (36, '7705d2e0-b796-464e-b165-7974d118d3a0', 42, 'AS A SOFTWARE ENGINEER AT VERVERICA, YOU WILL SOLVE CHALLENGING DATA ENGINEERING AND STREAM PROCESSING PROBLEMS, WORK ON OPEN-SOURCE AND PROPRIETARY PRODUCTS, AND CONTRIBUTE TO THE APACHE FLINK COMMUNITY. REQUIREMENTS INCLUDE EXPERTISE IN JAVA, DISTRIBUTED SYSTEMS, AND DATA-INTENSIVE APPLICATIONS.', 'SENIOR SOFTWARE ENGINEER (M/F/D)', '2025-03-17', 'HTTPS://APPLY.WORKABLE.COM/VERVERICA/J/4D10DC86F9/?UTM_MEDIUM=SOCIAL_SHARE_LINK', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.913578+07', '2025-04-27 11:45:50.913578+07');
INSERT INTO jobs.job VALUES (37, '87790de4-e0d8-4e62-98af-35a15ba56c51', 43, 'WHAT YOU’LL DO: THE PRODUCT LEAD WILL DESIGN, BUILD, AND SCALE PRODUCTS THAT DRIVE VALUE TO FOUNDERS AND GROW APPLICATIONS TO OUR ACCELERATOR PROGRAM. KEY RESPONSIBILITIES INCLUDE: OWN AND IMPROVE EXISTING PRODUCTS – TAKE OVER EXISTING INITIATIVES LIKE INVESTOR DIRECTORY AND CO-FOUNDER MATCHING, IMPROVING USABILITY, ENGAGEMENT AND IMPACT. LAUNCH NEW PRODUCTS – LEAD THE DESIGN, DEVELOPMENT, AND LAUNCH OF NEW PRODUCTS AND FEATURES. DEVELOP PROJECT SPECS AND MANAGE THE ROADMAP TO ENSURE SUCCESSFUL EXECUTION. EXPERIMENT AND ITERATE – USE NO-CODE TOOLS (E.G. AIRTABLE, ZAPIER, WEBFLOW, ETC) TO VALIDATE IDEAS QUICKLY. COLLECT AND ANALYSE USER FEEDBACK AND DATA TO CONTINUOUSLY IMPROVE PRODUCTS AND ENSURE THEY RESONATE WITH OUR AUDIENCE. DRIVE GROWTH – LEAD INITIATIVES TO GROW USER ADOPTION AND ENGAGEMENT ACROSS PRODUCTS. DESIGN AND RUN GROWTH EXPERIMENTS TO IDENTIFY THE MOST EFFECTIVE METHODS FOR INCREASING PRODUCT USAGE. IDENTIFY GAPS AND OPPORTUNITIES – RESEARCH FOUNDER PAIN POINTS AND ECOSYSTEM INEFFICIENCIES. PROPOSE AND EXECUTE HIGH-IMPACT SOLUTIONS, WORKING WITH FOUNDERS TO ENSURE RELEVANCE AND VALUE. FRAMEWORKS AND PLAYBOOKS – DOCUMENT YOUR LEARNINGS TO ESTABLISH SCALABLE PROCESSES FOR PRODUCT DISCOVERY, DEVELOPMENT, AND GROWTH. SHARE INSIGHTS WITH THE BROADER TEAM TO ENHANCE ORGANISATIONAL LEARNING. WHO YOU ARE WE’RE LOOKING FOR CANDIDATES WITH THE FOLLOWING CHARACTERISTICS: PRODUCT BUILDER – YOU HAVE EXPERIENCE BUILDING AND LAUNCHING PRODUCTS, MVPS, OR TOOLS THAT SOLVE REAL-WORLD PROBLEMS. YOU’RE FAMILIAR WITH THE PRODUCT LIFECYCLE AND CAN DEVELOP PROJECTS FROM CONCEPT TO EXECUTION. EXECUTION-ORIENTED – YOU’RE ADEPT AT BALANCING LONG-TERM VISION WITH SHORT-TERM EXECUTION. YOU EFFECTIVELY MANAGE TIMELINES, PRIORITIES, AND RESOURCES TO DELIVER SUCCESSFUL OUTCOMES. RESOURCEFUL – YOU LEVERAGE NO-CODE TOOLS, CREATIVE PROBLEM-SOLVING, AND RESOURCEFULNESS TO MOVE PROJECTS FORWARD EFFICIENTLY. DATA-DRIVEN – YOU HAVE A STRONG ANALYTICAL MINDSET AND USE DATA AND USER FEEDBACK TO REFINE PRODUCT DIRECTION AND DRIVE CONTINUOUS IMPROVEMENT. STRONG COMMUNICATOR – YOU CAN EFFECTIVELY COMMUNICATE THE PRODUCT ROADMAP AND VISION TO STAKEHOLDERS. YOU MANAGE PRIORITIES, MAKE TRADE-OFFS AND BUILD CROSS-TEAM CONSENSUS TO ENSURE ALIGNMENT. SELF-DIRECTED – YOU TAKE OWNERSHIP OF PROJECTS, WORK INDEPENDENTLY, AND ASK FOR HELP WHEN NEEDED. COMFORTABLE WITH AMBIGUITY – YOU OFTEN WORK ON PROJECTS WITH UNDEFINED PARAMETERS, REQUIRING YOU TO ASSESS WHETHER THE INITIATIVE IS WORTH PURSUING, DEFINE SUCCESS METRICS, AND NAVIGATE UNKNOWNS TO BRING IDEAS TO LIFE. CURIOUS AND EXPERIMENTAL – YOU’RE COMFORTABLE TESTING IDEAS, LEARNING FROM FAILURE, AND PIVOTING WHEN NEEDED. YOU APPROACH EVERY PROJECT WITH A MINDSET OF EXPERIMENTATION AND CONTINUOUS LEARNING. STARTUP-FOCUSED – EXPERIENCE AS A FOUNDER OR EARLY TEAM MEMBER IS A PLUS. IF YOU DON’T HAVE DIRECT EXPERIENCE, YOU’RE EAGER TO LEARN AND READY TO DIVE INTO THE SOUTHEAST ASIA STARTUP ECOSYSTEM.', 'PRODUCT LEAD', '2025-03-17', 'HTTPS://JOBS.ASHBYHQ.COM/ITERATIVE/079A27CF-717D-4F1A-91AA-3367879C6169', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.919773+07', '2025-04-27 11:45:50.919773+07');
INSERT INTO jobs.job VALUES (38, 'd715ea13-92b4-4490-a9d6-c8a434ce27c4', 44, 'WHAT WILL I DO IN THIS ROLE? KEY RESPONSIBILITIES OF THIS ROLE INCLUDE - BUILDING SOMETHING AMAZING! - FEATURE DEVELOPMENT — YOU WILL WORK CLOSELY WITH THE FOUNDER OF FIRECUT TO DEVELOP NEW FEATURES IN THE FIRECUT PLUGIN FOR ADOBE PREMIERE PRO. - BUG FIXING — YOU WILL OWN THE BUG-FIXING PROCESS END-TO-END, WHICH WILL INVOLVE READING CUSTOMER FEEDBACK, RECREATING BUGS AND FINDING THE ROOT CAUSE, FIXING BUGS IN THE CODE, ETC. - [OPTIONAL] SERVER MANAGEMENT — YOU WILL OWN SERVER UPTIME AND TAKE STEPS TO OPTIMIZE THE SERVER SETUP. - [OPTIONAL] USER COMMUNICATION — YOU WILL SUPPORT THE FOUNDER IN RESPONDING TO USER FEEDBACK AND REQUESTS. WHO YOU ARE - YOU ARE LOOKING FOR THAT ONCE-IN-A-CAREER OPPORTUNITY WHERE YOU CAN GO FROM IDEA TO SHIPPED FEATURE THAT’S IN USERS’ HANDS IN DAYS - WORKING ON THE SAME PROBLEM FOR MONTHS / HAVING LITTLE IMPACT MAKES YOU WANT TO FLIP A TABLE - YOU LIKE TO DO PROGRAMMING PROJECTS IN YOUR SPARE TIME - YOU ARE PASSIONATE ABOUT AUTOMATING REPETITIVE / MANUAL TASKS - WHEN WORKING IN A TEAM, YOU TAKE OWNERSHIP OF YOUR WORK ( = YOU VIEW YOURSELF AS THE ULTIMATE ACCOUNTABLE PERSON FOR YOUR WORK, IF SOMETHING BREAKS ON A WEEKEND AND YOUR USERS ARE STRANDED YOU GENUINELY WANT TO FIX IT ASAP) - YOU ARE COMFORTABLE (WHAT DOES THIS MEAN? SOME NON-EXHAUSTIVE GUIDANCE BELOW…) WITH: - HTML. - TAILWINDCSS. - JAVASCRIPT. - NODE.JS. - [OPTIONAL] PYTHON / DJANGO. - [OPTIONAL] LINUX, NGINX, POSTGRES. WHY ARE SOME THINGS MARKED “OPTIONAL”? - THE WORK IS PRIMARILY FRONT-END DEVELOPMENT, BUT DEPENDING ON YOUR EXPERIENCE AND INTERESTS THERE IS OPPORTUNITY TO HELP OUT WITH BACK-END AS WELL AS PRODUCT MANAGEMENT. WE ARE A SMALL TEAM SO, AS YOU MIGHT EXPECT, WE WEAR MANY HATS! WHO YOU ARE NOT (BECAUSE THIS IS NOT FOR EVERYONE) - YOU DISLIKE THE IDEA OF GRINDING FOR A PROJECT IN A STARTUP ENVIRONMENT - YOU WANT A RELIABLE 9-5 JOB WITH NO RISK AND A RELIABLE TRAJECTORY - YOU PREFER A MANAGER TO TAKE THE ULTIMATE RESPONSIBILITY FOR DECISIONS IN YOUR TEAM HOW DO I APPLY? - SEND YOUR CV/RESUME TO [SWE@FIRECUT.AI](MAILTO:SWE@FIRECUT.AI) - [OPTIONAL] RECORD A SHORT VIDEO RESPONSE TO A PROMPT: HTTPS://FORMS.GLE/EFBMEVDECZIM1Y4D7', 'SOFTWARE ENGINEER', '2025-03-17', 'HTTPS://FIRECUT.NOTION.SITE/SOFTWARE-ENGINEER-REMOTE-DDF537C47A2F4B7FB2B4B8AACF5E903A', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.926455+07', '2025-04-27 11:45:50.926455+07');
INSERT INTO jobs.job VALUES (39, '12a3a91a-75ce-47b3-b72b-9a1cd7672662', 45, 'GITLAB IS SEEKING AN ECOSYSTEM SPECIALIST FOR THE APAC REGION TO MANAGE PARTNER AND SALES TEAM RELATIONSHIPS, PROVIDE OPERATIONAL SUPPORT, AND ESTABLISH BEST PRACTICES TO ENSURE GITLAB''S PARTNER ECOSYSTEM REMAINS EFFICIENT, SCALABLE, AND COMPLIANT. THE ROLE INVOLVES VALIDATING PARTNER QUOTE REQUESTS, MANAGING RELATIONSHIPS WITH GLOBAL DISTRIBUTORS, AND DEVELOPING PARTNER PROCESSES.', 'ECOSYSTEM SPECIALIST - APAC', '2025-03-20', 'HTTPS://JOB-BOARDS.GREENHOUSE.IO/GITLAB/JOBS/7858831002', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.932954+07', '2025-04-27 11:45:50.932954+07');
INSERT INTO jobs.job VALUES (40, 'd7c3577e-8179-461a-ac03-265951b360e9', 46, 'WE''RE HIRING: EXPERIENCED SENIOR SALES PROFESSIONAL AT RUBYTHALIB.AI ARE YOU AN EXPERIENCED SALES PROFESSIONAL WITH A PASSION FOR TECHNOLOGY? RUBYTHALIB.AI IS SEEKING A SKILLED SENIOR SALES SPECIALIST TO DRIVE OUR BUSINESS FORWARD. THIS ROLE IS REMOTE WITH A PREFERENCE FOR CANDIDATES BASED IN JAKARTA. WHAT YOU’LL DO: - DEVELOP AND EXECUTE SALES STRATEGIES TO ATTRACT NEW BUSINESS - BUILD AND MAINTAIN STRONG RELATIONSHIPS WITH CLIENTS - MANAGE THE ENTIRE SALES CYCLE FROM PROSPECTING TO CLOSING - COLLABORATE WITH THE TEAM TO ACHIEVE AND EXCEED SALES TARGETS WHAT WE’RE LOOKING FOR: - SOLID EXPERIENCE IN SALES, PREFERABLY WITHIN THE TECH OR AI INDUSTRY - EXCELLENT COMMUNICATION, NEGOTIATION, AND RELATIONSHIP-BUILDING SKILLS - A SELF-DRIVEN AND PROACTIVE APPROACH WITH A FOCUS ON RESULTS - ABILITY TO WORK REMOTELY WHILE STAYING CONNECTED WITH A DYNAMIC TEAM SALARY: 7 MILLION - 10 MILLION IDR + COMMISSION FOR SUCCESSFUL SALES. JOIN RUBYTHALIB.AI AND HELP SHAPE THE FUTURE OF AI TECHNOLOGY!', 'EXPERIENCED SENIOR SALES PROFESSIONAL', '2025-03-24', 'HTTPS://FORMS.GLE/ANEFKFNPVYMXFLED6', NULL, NULL, 'IDR', 'MONTHLY', 35, true, '2025-04-27 11:45:50.93968+07', '2025-04-27 11:45:50.93968+07');
INSERT INTO jobs.job VALUES (41, 'ac75f27e-5243-40c1-981d-051bd8a7aad3', 47, 'MANAGE POS AND PLATFORM MENUS, CONSULT WITH RELATED PARTIES, PREPARE PERFORMANCE REPORTS, HANDLE MERCHANDISE FULFILLMENT, AND ADDRESS INTERNAL INQUIRIES. FRESH GRADUATES WELCOME.', 'PRODUCT OPERATION OFFICER (FULL REMOTE)', '2025-03-25', 'HTTPS://CAREER.ISHANGRY.COM/JOB/376', NULL, NULL, 'IDR', 'MONTHLY', 14, true, '2025-04-27 11:45:50.944709+07', '2025-04-27 11:45:50.944709+07');
INSERT INTO jobs.job VALUES (42, 'fc5fe70d-317a-4f09-85dc-35ef297fddd4', 48, 'THE ENERGY TRANSITION ANALYST WILL SUPPORT THE ENERGY TRANSITION OUTLOOK (ETO) TEAM IN DELIVERING HIGH-QUALITY RESEARCH AND ANALYSIS ON ENERGY TRANSITION TOPICS. RESPONSIBILITIES INCLUDE DATA ANALYSIS, REPORT WRITING, AND STAKEHOLDER ENGAGEMENT. THE ROLE REQUIRES A STRONG UNDERSTANDING OF ENERGY SYSTEMS, EXCELLENT COMMUNICATION SKILLS, AND THE ABILITY TO WORK INDEPENDENTLY AND COLLABORATIVELY.', 'ENERGY TRANSITION ANALYST', '2025-03-27', 'HTTPS://CAREERS.GEVERNOVA.COM/GLOBAL/EN/JOB/GVXGVWGLOBALR3790525EXTERNALENGLOBAL/APAC-DECARBONIZATION-SALES-DIRECTOR-POWER-ENERGY-RESOURCES-SOFTWARE', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.950878+07', '2025-04-27 11:45:50.950878+07');
INSERT INTO jobs.job VALUES (45, 'bf5e17d1-c617-4d63-8c6d-5443c152f1b0', 51, 'THE SENIOR PROJECT MANAGER IS RESPONSIBLE FOR LEADING THE IMPLEMENTATION OF SOFTWARE SOLUTIONS FOR ELECTRIC UTILITIES. THE ROLE INVOLVES MANAGING PROJECT SCOPE, SCHEDULE, AND BUDGET, AS WELL AS COORDINATING WITH INTERNAL AND EXTERNAL STAKEHOLDERS. THE POSITION REQUIRES EXPERIENCE IN PROJECT MANAGEMENT, SOFTWARE IMPLEMENTATION, AND KNOWLEDGE OF ELECTRIC UTILITY OPERATIONS.', 'SENIOR PROJECT MANAGER', '2025-03-27', 'HTTPS://CAREERS.GEVERNOVA.COM/GLOBAL/EN/JOB/R5005800/SENIOR-STAFF-SERVICES-PROJECT-MANAGER', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.970704+07', '2025-04-27 11:45:50.970704+07');
INSERT INTO jobs.job VALUES (46, '527a395d-4407-4d8d-979b-4e332379cec0', 49, 'CSG IS SEEKING A JAVA SOFTWARE ENGINEER TO JOIN THEIR TEAM RESPONSIBLE FOR DEVELOPING THE CSQ QUOTE & ORDER PLATFORM. THE ROLE INVOLVES BUILDING NEW FEATURES, MAINTAINING EXISTING SERVICES, AND COLLABORATING WITH CROSS-FUNCTIONAL TEAMS. CANDIDATES SHOULD HAVE 3+ YEARS OF EXPERIENCE WITH JAVA SE (17+), AND FAMILIARITY WITH TOOLS LIKE GITHUB, MAVEN, DOCKER, AND KUBERNETES.', 'JAVA SOFTWARE ENGINEER | PRODUCT R&D, INNOVATION & OWNERSHIP', '2025-03-27', 'HTTPS://CSGI.WD5.MYWORKDAYJOBS.COM/EN-US/CSGCAREERS/JOB/INDONESIA-REMOTE/JAVA-SOFTWARE-ENGINEER---PRODUCT-R-D--INNOVATION---OWNERSHIP_29137?REMOTETYPE=D0C4F782266D1000C2BE6D47736A0000&LOCATIONS=5B7D5DA3E2551000CDB28EE56EB80000', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.978664+07', '2025-04-27 11:45:50.978664+07');
INSERT INTO jobs.job VALUES (47, '05051bca-6694-4fb4-8027-501c2d37388a', 49, 'CSG IS SEEKING A LEAD TEST ENGINEER TO DRIVE TECHNICAL DIRECTION, MENTOR TEAMS, AND IMPROVE THE QUALITY OF CSG''S QUOTE & ORDER TEST AUTOMATION. THE ROLE INVOLVES TEST AUTOMATION, COLLABORATION, AND ENSURING HIGH-QUALITY OUTCOMES FOR CUSTOMERS. BENEFITS INCLUDE FLEXIBLE WORK ARRANGEMENTS AND PROFESSIONAL DEVELOPMENT OPPORTUNITIES.', 'LEAD TEST ENGINEER | PRODUCT R&D, INNOVATION & OWNERSHIP', '2025-03-27', 'HTTPS://CSGI.WD5.MYWORKDAYJOBS.COM/EN-US/CSGCAREERS/JOB/INDONESIA-REMOTE/LEAD-TEST-ENGINEER---PRODUCT-R-D--INNOVATION---OWNERSHIP_29065?REMOTETYPE=D0C4F782266D1000C2BE6D47736A0000&LOCATIONS=5B7D5DA3E2551000CDB28EE56EB80000', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.984751+07', '2025-04-27 11:45:50.984751+07');
INSERT INTO jobs.job VALUES (48, '7f789557-aeda-470e-8f74-f7e2784cf448', 54, 'WHO YOU ARE. BACHELOR’S, MASTER’S, OR DOCTORAL DEGREE IN DATA SCIENCE, COMPUTER SCIENCE, STATISTICS, OR A RELATED FIELD. A MINIMUM OF 3 YEARS OF WORK OR RESEARCH EXPERIENCE DEALING WITH LARGE DATASETS. STRONG CODING SKILLS IN PYTHON OR OTHER OBJECT-ORIENTED PROGRAMMING LANGUAGES. GRADUATE-LEVEL KNOWLEDGE OF STATISTICS, INCLUDING BUT NOT LIMITED TO HYPOTHESIS TESTING, REGRESSION ANALYSIS, AND PROBABILITY. EXCELLENT WORK ETHIC AND THE ABILITY TO THRIVE IN A FAST-PACED STARTUP ENVIRONMENT. STRONG PROBLEM-SOLVING SKILLS AND ATTENTION TO DETAIL. GOOD COMMUNICATION SKILLS, WITH THE ABILITY TO ARTICULATE COMPLEX DATA CONCEPTS TO NON-TECHNICAL STAKEHOLDERS. EXPERIENCE WORKING IN A HIGH OUTPUT TEAM. WHAT YOU''LL BE DOING. DEVELOPING, FINE-TUNING, AND DEPLOYING LLMS FOR VARIOUS NLP TASKS SUCH AS TEXT GENERATION, SUMMARIZATION, TRANSLATION, AND SENTIMENT ANALYSIS. DESIGNING AND IMPLEMENTING PIPELINES FOR PROCESSING AND ANALYZING LARGE TEXT DATASETS. ANALYZING AND INTERPRETING COMPLEX TIME SERIES DATA TO PROVIDE ACTIONABLE INSIGHTS AND SOLUTIONS. DESIGNING, IMPLEMENTING, AND MAINTAINING DATA-DRIVEN MODELS AND ALGORITHMS. COLLABORATING WITH CROSS-FUNCTIONAL TEAMS TO UNDERSTAND DATA NEEDS AND DELIVER TIMELY SOLUTIONS. ENSURING DATA QUALITY AND INTEGRITY THROUGHOUT ALL PROCESSES. UTILIZING OPTICAL CHARACTER RECOGNITION (OCR) TECHNOLOGY TO CONVERT DIFFERENT TYPES OF DOCUMENTS INTO EDITABLE AND SEARCHABLE DATA. CONTINUOUSLY RESEARCHING AND IMPLEMENTING BEST PRACTICES IN DATA SCIENCE AND MACHINE LEARNING. CONTRIBUTING TO THE DEVELOPMENT AND IMPROVEMENT OF INTERNAL DATA PROCESSING TOOLS AND INFRASTRUCTURE.', 'MACHINE LEARNING ENGINEER', '2025-04-10', 'HTTPS://JOB-BOARDS.GREENHOUSE.IO/WYNDLABS/JOBS/4008777008', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:50.991469+07', '2025-04-27 11:45:50.991469+07');
INSERT INTO jobs.job VALUES (49, 'f335e82e-60e7-496a-b50a-0930810485a5', 55, 'CONTRA IS SEEKING A FREELANCE 3D DESIGNER TO CREATE HIGH-QUALITY 3D VISUALS FOR MARKETING, PRODUCT, AND WEB. THE ROLE INVOLVES COLLABORATING WITH CROSS-FUNCTIONAL TEAMS, ITERATING BASED ON FEEDBACK, AND ENSURING QUALITY STANDARDS. REQUIREMENTS INCLUDE A STRONG PORTFOLIO, PROFICIENCY IN TOOLS LIKE BLENDER OR CINEMA 4D, AND EXPERIENCE IN DIGITAL ENVIRONMENTS.', '3D DESIGNER', '2025-04-10', 'HTTPS://CONTRA.COM/OPPORTUNITY/X2MQSQ6R-3-D-DESIGNER', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.000068+07', '2025-04-27 11:45:51.000068+07');
INSERT INTO jobs.job VALUES (50, 'e1b0fc85-4e34-4c31-ba81-911833ad58b1', 56, 'FULL-TIME SENIOR IOS DEVELOPER POSITION AT NEYBOX, RESPONSIBLE FOR BUILDING NEW FEATURES, FIXING BUGS, MAINTAINING CODEBASE, WRITING UNIT TESTS, AND RESEARCHING NEW TECHNOLOGIES. REQUIRES 40 HOURS PER WEEK. TECH STACK INCLUDES SWIFT, SWIFTUI, AND UIKIT. FULLY REMOTE WITH FLEXIBLE HOURS.', 'SENIOR IOS DEVELOPER (REMOTE)', '2025-04-10', 'HTTPS://APPLY.WORKABLE.COM/NEYBOX-DIGITAL/J/6E7EB8814C/', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.008159+07', '2025-04-27 11:45:51.008159+07');
INSERT INTO jobs.job VALUES (51, 'e8638fd3-797c-4a66-9d1e-235f9165a6b9', 56, 'NEYBOX IS SEEKING A DEDICATED MOBILE QA ENGINEER/TESTER TO JOIN THEIR REMOTE TEAM. RESPONSIBILITIES INCLUDE TESTING APPS ON IOS DEVICES, CREATING ISSUES, WRITING TEST CASES, AND ENSURING PROPER LOCALIZATION. THE ROLE REQUIRES EXPERIENCE IN MOBILE APP TESTING, PROFICIENCY IN ENGLISH, AND FAMILIARITY WITH MACOS AND IOS. BENEFITS INCLUDE A FULLY REMOTE POSITION, 24 DAYS OF PAID LEAVE, AND A FLEXIBLE SCHEDULE.', 'MOBILE QA ENGINEER/TESTER (REMOTE)', '2025-04-10', 'HTTPS://APPLY.WORKABLE.COM/J/3C0B4587F7', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.015216+07', '2025-04-27 11:45:51.015216+07');
INSERT INTO jobs.job VALUES (52, '7331888c-0547-4e41-a037-69e4ebe9675a', 58, 'LOVABLE IS SEEKING AN APPLIED AI ENGINEER TO WORK ON AUTONOMOUS CODING, ENSURING PRODUCT RELIABILITY AND INNOVATION. THE ROLE INVOLVES IDENTIFYING CHALLENGES, RAPID DEBUGGING, AND DATA-DRIVEN IMPROVEMENTS. CANDIDATES SHOULD HAVE FULL-STACK PROFICIENCY, EXPERIENCE WITH LLMS, AND STRONG PROBLEM-SOLVING SKILLS.', 'APPLIED AI ENGINEER', '2025-04-10', 'HTTPS://LOVABLE.DEV/CAREERS/AI-RELIABILITY-ENGINEER', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.02238+07', '2025-04-27 11:45:51.02238+07');
INSERT INTO jobs.job VALUES (53, '376fa395-d8ca-4c3f-be46-38413fa07927', 54, 'WHO YOU ARE : - BACHELOR’S DEGREE IN COMPUTER SCIENCE, INFORMATION SYSTEMS, DATA ENGINEERING, OR A RELATED TECHNICAL FIELD. - EXTENSIVE EXPERIENCE WITH DATABASE SYSTEMS SUCH AS REDSHIFT, SNOWFLAKE, OR SIMILAR CLOUD-BASED SOLUTIONS. - ADVANCED PROFICIENCY IN SQL AND EXPERIENCE WITH OPTIMIZING COMPLEX QUERIES FOR PERFORMANCE. - HANDS-ON EXPERIENCE WITH BUILDING AND MANAGING DATA PIPELINES USING TOOLS SUCH AS APACHE AIRFLOW, AWS GLUE, OR SIMILAR TECHNOLOGIES. - SOLID UNDERSTANDING OF ETL (EXTRACT, TRANSFORM, LOAD) PROCESSES AND BEST PRACTICES FOR DATA INTEGRATION. - EXPERIENCE WITH INFRASTRUCTURE AUTOMATION TOOLS (E.G., TERRAFORM, CLOUDFORMATION) FOR MANAGING DATA ECOSYSTEMS. - KNOWLEDGE OF PROGRAMMING LANGUAGES SUCH AS PYTHON, SCALA, OR JAVA FOR PIPELINE ORCHESTRATION AND DATA MANIPULATION. - STRONG ANALYTICAL AND PROBLEM-SOLVING SKILLS, WITH AN ABILITY TO TROUBLESHOOT AND RESOLVE DATA FLOW ISSUES. - FAMILIARITY WITH CONTAINERIZATION (E.G., DOCKER) AND ORCHESTRATION (E.G., KUBERNETES) TECHNOLOGIES FOR DATA INFRASTRUCTURE DEPLOYMENT. - COLLABORATIVE TEAM PLAYER WITH STRONG COMMUNICATION SKILLS TO WORK WITH CROSS-FUNCTIONAL TEAMS. WHAT YOU''LL BE DOING: - DESIGNING, BUILDING, AND OPTIMIZING SCALABLE DATA PIPELINES TO PROCESS AND INTEGRATE DATA FROM VARIOUS SOURCES IN REAL-TIME OR BATCH MODES. - DEVELOPING AND MANAGING ETL/ELT WORKFLOWS TO TRANSFORM RAW DATA INTO STRUCTURED FORMATS FOR ANALYSIS AND REPORTING. - INTEGRATING AND CONFIGURING DATABASE INFRASTRUCTURE, ENSURING PERFORMANCE, SCALABILITY, AND DATA SECURITY. - AUTOMATING DATA WORKFLOWS AND INFRASTRUCTURE SETUP USING TOOLS LIKE APACHE AIRFLOW, TERRAFORM, OR SIMILAR. - COLLABORATING WITH DATA SCIENTISTS, ANALYSTS, AND OTHER STAKEHOLDERS TO ENSURE EFFICIENT DATA ACCESSIBILITY AND USABILITY. - MONITORING, TROUBLESHOOTING, AND IMPROVING THE PERFORMANCE OF DATA PIPELINES AND INFRASTRUCTURE TO ENSURE DATA QUALITY AND FLOW CONSISTENCY. - WORKING WITH CLOUD INFRASTRUCTURE (AWS, GCP, AZURE) TO MANAGE DATABASES, STORAGE, AND COMPUTE RESOURCES EFFICIENTLY. - IMPLEMENTING BEST PRACTICES FOR DATA GOVERNANCE, DATA SECURITY, AND DISASTER RECOVERY IN ALL INFRASTRUCTURE DESIGNS. - STAYING CURRENT WITH THE LATEST TRENDS AND TECHNOLOGIES IN DATA ENGINEERING, PIPELINE AUTOMATION, AND INFRASTRUCTURE AS CODE. WHY WORK WITH US : - OPPORTUNITY. WE ARE AT AT THE FOREFRONT OF DEVELOPING A WEB-SCALE CRAWLER AND KNOWLEDGE GRAPH THAT ALLOWS ORDINARY PEOPLE TO PARTICIPATE IN THE PROCESS, AND SHARE IN THE BENEFITS OF AI DEVELOPMENT. - CULTURE. WE’RE A LEAN TEAM WORKING TOGETHER TO ACHIEVE A VERY AMBITIOUS GOAL OF IMPROVING ACCESS TO PUBLIC WEB DATA AND DISTRIBUTING THE VALUE OF AI TO THE PEOPLE. WE PRIORITIZE LOW EGO AND HIGH OUTPUT. - COMPENSATION. YOU’LL RECEIVE A COMPETITIVE SALARY AND EQUITY PACKAGE. - RESOURCES AND GROWTH. WE’RE WELL-CAPITALIZED, WITH BACKING FROM LEADING VENTURE FUNDS LIKE POLYCHAIN, TRIBE, NLH, HACK, BH DIGITAL, AND MORE. WE KEEP A LEAN TEAM, AND THIS IS A RARE OPPORTUNITY TO JOIN. YOU’LL LEARN A LOT AND GROW AS OUR COMPANY SCALES.', 'DATA ENGINEER', '2025-04-10', 'HTTPS://JOB-BOARDS.GREENHOUSE.IO/WYNDLABS/JOBS/4133699008', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.029322+07', '2025-04-27 11:45:51.029322+07');
INSERT INTO jobs.job VALUES (54, '69acf9ca-2dc4-4315-bc18-c3be5bc73943', 54, 'WHO YOU ARE. STRONG PROFICIENCY IN REACT (MATERIAL UI, CHAKRA UI). SOLID EXPERIENCE WITH BACK-END TECHNOLOGIES SUCH AS NODE.JS, GO, REDIS AND FAMILIARITY WITH DATABASES (SQL AND NOSQL). EXCEPTIONAL PROBLEM-SOLVING SKILLS AND A DEEP UNDERSTANDING OF BOTH CLIENT-SIDE AND SERVER-SIDE ARCHITECTURE. PROVEN ABILITY TO WORK COLLABORATIVELY WITH CROSS-FUNCTIONAL TEAMS, INCLUDING DESIGNERS, PRODUCT MANAGERS, AND OTHER ENGINEERS. A TRACK RECORD OF DELIVERING HIGH-QUALITY, MAINTAINABLE CODE AND CONTRIBUTING TO SIGNIFICANT PROJECTS. WHAT YOU''LL BE DOING. DEVELOP AND MAINTAIN BOTH FRONT-END AND BACK-END COMPONENTS OF OUR APPLICATION, ENSURING SEAMLESS INTEGRATION AND OPTIMAL PERFORMANCE. COLLABORATE WITH PRODUCT MANAGERS AND DESIGNERS FROM INITIAL CONCEPT THROUGH TO DEPLOYMENT, TRANSLATING IDEAS INTO FUNCTIONAL AND USER-FRIENDLY SOLUTIONS. OPTIMIZE APPLICATION PERFORMANCE, SECURITY, AND SCALABILITY TO ENHANCE THE OVERALL USER EXPERIENCE AND MEET BUSINESS GOALS. PARTICIPATE IN CODE REVIEWS, CONTRIBUTE TO BEST PRACTICES, AND CONTINUOUSLY IMPROVE DEVELOPMENT PROCESSES. STAY ABREAST OF EMERGING TECHNOLOGIES AND INDUSTRY TRENDS, INTEGRATING NEW TOOLS AND METHODOLOGIES TO KEEP OUR TECH STACK MODERN AND EFFICIENT. TROUBLESHOOT AND RESOLVE COMPLEX TECHNICAL ISSUES, PROVIDING TIMELY SOLUTIONS AND MAINTAINING SYSTEM RELIABILITY.', 'FULL STACK ENGINEER', '2025-04-12', 'HTTPS://JOB-BOARDS.GREENHOUSE.IO/WYNDLABS/JOBS/4111763008', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.037204+07', '2025-04-27 11:45:51.037204+07');
INSERT INTO jobs.job VALUES (55, '4ba85c89-e875-41e4-b19c-35741746fb78', 54, 'WHO YOU ARE. DEMONSTRATED ABILITY TO EXTRACT DATA FROM COMPLEX WEBSITES WITH MINIMAL SUPERVISION, WITH A PORTFOLIO OR EXAMPLES OF PAST PROJECTS. PROFICIENCY IN LANGUAGES SUCH AS PYTHON OR JAVASCRIPT, WITH STRONG SKILLS IN LIBRARIES AND FRAMEWORKS LIKE BEAUTIFULSOUP, SCRAPY, OR SELENIUM. KNOWLEDGE OF ASYNCHRONOUS PROGRAMMING, MULTITHREADING, AND DISTRIBUTED SCRAPING. IN-DEPTH KNOWLEDGE OF HTML, CSS, JAVASCRIPT, AND THE DOCUMENT OBJECT MODEL (DOM). EXPERIENCE WITH NOSQL DATABASES (MONGODB, CASSANDRA), CAPABLE OF DESIGNING EFFICIENT STORAGE SOLUTIONS AND MANAGING DATA INTEGRITY. ABILITY TO APPLY MACHINE LEARNING ALGORITHMS FOR DATA CLEANING, CATEGORIZATION, OR PREDICTIVE ANALYSIS ADDS SIGNIFICANT VALUE. EXPERIENCE WITH CLOUD SERVICES (AWS, GOOGLE CLOUD, AZURE) FOR DEPLOYING AND MANAGING SCRAPING JOBS AT SCALE. ACTIVE PARTICIPATION IN OPEN-SOURCE PROJECTS RELATED TO WEB SCRAPING, DATA PROCESSING, OR SIMILAR FIELDS. WHAT YOU''LL BE DOING. WRITE, TEST, AND REFINE CODE THAT EXTRACTS DATA FROM VARIOUS ONLINE SOURCES, ENSURING RELIABILITY AND EFFICIENCY. PERFORM DATA RETRIEVAL TASKS, HANDLING COMPLEXITIES SUCH AS PAGINATION AND DYNAMIC CONTENT LOADED WITH AJAX. CLEAN AND FORMAT EXTRACTED DATA, ENSURING IT MEETS QUALITY STANDARDS FOR FURTHER ANALYSIS OR PROCESSING. DATABASE MANAGEMENT: STORE AND MANAGE THE SCRAPED DATA IN APPROPRIATE DATABASES, OPTIMIZING FOR ACCESS SPEED AND DATA INTEGRITY. REGULARLY MONITOR THE SCRAPING PROCESSES, IDENTIFY AND RESOLVE ANY ISSUES TO MAINTAIN CONTINUOUS DATA FLOW.', 'WEB SCRAPING SPECIALIST', '2025-04-12', 'HTTPS://JOB-BOARDS.GREENHOUSE.IO/WYNDLABS/JOBS/4008789008', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.043495+07', '2025-04-27 11:45:51.043495+07');
INSERT INTO jobs.job VALUES (56, '2cdb7f49-4a90-43f8-956d-b8adb27f659c', 54, 'WHO YOU ARE. BS OR MS DEGREE IN A STEM MAJOR OR EQUIVALENT JOB EXPERIENCE REQUIRED. 5+ YEARS EXPERIENCE IN SOFTWARE DEVELOPMENT AND WRITING VERY HIGH QUALITY CODE THAT IS ROBUST AND EASY TO MAINTAIN. KNOWLEDGE ON HOW TO BUILD LARGE SCALABLE SYSTEMS. KNOWLEDGE AND EXPERIENCE IN IDENTIFYING AND SOLVING ISSUES WITH INTRICATE, LIVE SOFTWARE SYSTEMS, AS WELL AS IN-DEPTH FAMILIARITY WITH CONTEMPORARY SOFTWARE DEVELOPMENT PROCESSES SUCH AS CONTINUOUS INTEGRATION AND CONTINUOUS DEPLOYMENT. PROFESSIONAL OR NATIVE ENGLISH LANGUAGE PROFICIENCY. WHAT YOU''LL BE DOING. SMART CONTRACT DEVELOPMENT: DESIGN, CODE, AND DEPLOY ROBUST AND SECURE SMART CONTRACTS THAT EXECUTE SEAMLESSLY ON BLOCKCHAIN NETWORKS. BLOCKCHAIN INTEGRATION: COLLABORATE WITH CROSS-FUNCTIONAL TEAMS TO INTEGRATE SMART CONTRACTS INTO VARIOUS DECENTRALIZED APPLICATIONS, ENSURING COMPATIBILITY AND FUNCTIONALITY. SECURITY AND AUDITING: IMPLEMENT BEST PRACTICES FOR SECURE SMART CONTRACT DEVELOPMENT, CONDUCT CODE AUDITS, AND ADDRESS VULNERABILITIES TO ENSURE THE INTEGRITY AND RELIABILITY OF THE BLOCKCHAIN-BASED APPLICATIONS. COLLABORATION: WORK CLOSELY WITH OTHER DEVELOPERS, ARCHITECTS, AND STAKEHOLDERS TO UNDERSTAND PROJECT REQUIREMENTS AND CONTRIBUTE TO THE OVERALL ARCHITECTURE OF DECENTRALIZED SYSTEMS. DOCUMENTATION: CREATE AND MAINTAIN COMPREHENSIVE DOCUMENTATION FOR SMART CONTRACTS, ENSURING TRANSPARENCY AND EASE OF UNDERSTANDING FOR OTHER TEAM MEMBERS AND EXTERNAL AUDITORS. TROUBLESHOOTING AND SUPPORT: PROVIDE TIMELY SUPPORT FOR ANY ISSUES RELATED TO SMART CONTRACT FUNCTIONALITY, ADDRESSING BUGS, AND IMPLEMENTING UPDATES AS REQUIRED.', 'SMART CONTRACT ENGINEER - SVM', '2025-04-15', 'HTTPS://JOB-BOARDS.GREENHOUSE.IO/WYNDLABS/JOBS/4008790008', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.050492+07', '2025-04-27 11:45:51.050492+07');
INSERT INTO jobs.job VALUES (57, 'f6c1096e-4690-483d-8b69-9493c3c87589', 54, 'WHO YOU ARE. BS OR MS DEGREE IN A STEM MAJOR OR EQUIVALENT JOB EXPERIENCE REQUIRED 4+ YEARS EXPERIENCE IN SOFTWARE DEVELOPMENT AND WRITING VERY HIGH QUALITY CODE THAT IS ROBUST AND EASY TO MAINTAIN KNOWLEDGE ON HOW TO BUILD LARGE SCALABLE SYSTEMS KNOWLEDGE AND EXPERIENCE IN IDENTIFYING AND SOLVING ISSUES WITH INTRICATE, LIVE SOFTWARE SYSTEMS, AS WELL AS IN-DEPTH FAMILIARITY WITH CONTEMPORARY SOFTWARE DEVELOPMENT PROCESSES SUCH AS CONTINUOUS INTEGRATION AND CONTINUOUS DEPLOYMENT. PROFESSIONAL OR NATIVE ENGLISH LANGUAGE PROFICIENCY WHAT YOU''LL BE DOING. DEVELOP NEW FEATURES AND SOFTWARE IMPROVEMENTS TEST, DEPLOY AND DEBUG BACKEND API SERVICES WRITE CLEAR, TESTED, DOCUMENTED CODE CREATE AND REVIEW TECHNICAL DESIGN, CODE, AND DOCUMENTATION CONTRIBUTE TO WYND’S INFRASTRUCTURE WHICH INCLUDES MOBILE, DESKTOP AND SERVER-SIDE APPLICATIONS TECHNOLOGIES USED. RUST, NODE.JS, REDIS CLUSTERS, KUBERNETES, AWS (EKS, SQS, DYNAMODB, ELASTICACHE, S3, ETC.)', 'SENIOR RUST ENGINEER (BACKEND)', '2025-04-15', 'HTTPS://JOB-BOARDS.GREENHOUSE.IO/WYNDLABS/JOBS/4458860008', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.056422+07', '2025-04-27 11:45:51.056422+07');
INSERT INTO jobs.job VALUES (58, '82f6537e-b4c0-49fa-9b8c-a3cf717243b4', 64, 'WE ARE LOOKING FOR A SENIOR FULL STACK ENGINEER WITH EXTENSIVE EXPERIENCE IN TYPESCRIPT TO JOIN OUR TALENTED DEVELOPMENT TEAM. IN THIS ROLE, YOU WILL DESIGN, DEVELOP, AND MAINTAIN OUR FULL-STACK PLATFORM CONSISTING OF MICROSERVICES, USING TYPESCRIPT AS A PRIMARY LANGUAGE FOR BOTH FRONT-END AND BACK-END DEVELOPMENT. YOU WILL BE RESPONSIBLE FOR DELIVERING HIGH-QUALITY, SCALABLE SOLUTIONS WHILE ALSO MENTORING JUNIOR DEVELOPERS AND CONTRIBUTING TO TECHNICAL STRATEGY. KEY RESPONSIBILITIES: - ARCHITECT, DESIGN, AND IMPLEMENT FULL-STACK WEB APPLICATIONS, PRIMARILY USING TYPESCRIPT. - BUILD ROBUST AND SCALABLE FRONT-END APPLICATIONS WITH MODERN FRAMEWORKS SUCH AS REACT.JS. - DEVELOP BAC-END SERVICES AND APIS USING NODE.JS AND WORK WITH DATABASES SUCH AS POSTGRESQL, AND MYSQL. - ENSURE APPLICATION PERFORMANCE, SCALABILITY, AND SECURITY BY IMPLEMENTING BEST PRACTICES FOR BOTH FRONT-END AND BACK-END CODE. - LEAD TECHNICAL DISCUSSIONS, CONTRIBUTE TO ARCHITECTURE DECISIONS, AND PROMOTE BEST CODING PRACTICES WITHIN THE TEAM. - PERFORM CODE REVIEWS AND MENTOR JUNIOR ENGINEERS TO IMPROVE THEIR SKILLS AND CODE QUALITY. - COLLABORATE WITH PRODUCT MANAGERS, UX/UI DESIGNERS, AND OTHER ENGINEERS TO DELIVER HIGH-QUALITY FEATURES IN AN AGILE ENVIRONMENT. - WRITE UNIT, INTEGRATION, AND END-TO-END TESTS TO ENSURE THE ROBUSTNESS OF THE CODEBASE. - CONTINUOUSLY IMPROVE THE DEVELOPMENT PROCESS BY SUGGESTING NEW TOOLS, TECHNIQUES, AND PROCESSES. SKILLS & QUALIFICATIONS: - PROGRESSIVE FULL-STACK DEVELOPMENT EXPERIENCE WITH A STRONG FOCUS ON TYPESCRIPT. - EXPERTISE IN FRONT-END FRAMEWORKS LIKE REACT.JS, VUE.JS, OR ANGULAR, WITH A DEEP UNDERSTANDING OF UI/UX BEST PRACTICES. - STRONG PROFICIENCY IN BACK-END DEVELOPMENT WITH NODE.JS AND WORKING KNOWLEDGE OF DATABASE MANAGEMENT SYSTEMS SUCH AS POSTGRESQL, MONGODB, OR MYSQL. - EXTENSIVE EXPERIENCE IN DESIGNING AND CONSUMING RESTFUL APIS AND GRAPHQL. - FAMILIARITY WITH CLOUD PLATFORMS SUCH AS AWS, AZURE, OR GOOGLE CLOUD FOR DEPLOYING SCALABLE APPLICATIONS. - PROFICIENT IN USING MODERN DEVELOPMENT TOOLS SUCH AS GIT, DOCKER, AND CI/CD PIPELINES. - IN-DEPTH UNDERSTANDING OF TEST-DRIVEN DEVELOPMENT (TDD), AND EXPERIENCE WITH TESTING FRAMEWORKS LIKE JEST. - EXCELLENT PROBLEM-SOLVING SKILLS, WITH A PROACTIVE MINDSET FOR IDENTIFYING AND RESOLVING TECHNICAL CHALLENGES. - STRONG KNOWLEDGE OF WEB SECURITY PRACTICES, PERFORMANCE TUNING, AND SCALING WEB APPLICATIONS. - FAMILIARITY WITH MICROSERVICES ARCHITECTURE IS PREFERRED. - EXPERIENCE WITH SERVERLESS TECHNOLOGIES AND EVENT-DRIVEN ARCHITECTURES WILL BE AN ASSET. - KNOWLEDGE OF CONTAINER ORCHESTRATION TOOLS LIKE KUBERNETES IS PREFERRED. - EXPERIENCE WITH MOBILE DEVELOPMENT FRAMEWORKS SUCH AS REACT NATIVE WILL BE AN ASSET. - FAMILIARITY WITH MODERN PHP IS PREFERRED. - LEADERSHIP EXPERIENCE, INCLUDING MENTORING AND GUIDING JUNIOR ENGINEERS. - EXPERIENCE WORKING IN AN AGILE/SCRUM DEVELOPMENT ENVIRONMENT. - MUST LIVE IN PAKISTAN, JORDAN, BRAZIL, INDONESIA THE SALARY RANGE IS EXPECTED TO BE 2000-3000 USD PER MONTH.', 'SENIOR FULL STACK ENGINEER - INDONESIA', '2025-04-20', 'HTTPS://SECURE.COLLAGE.CO/JOBS/LAUNCHGOOD/47922', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.061951+07', '2025-04-27 11:45:51.061951+07');
INSERT INTO jobs.job VALUES (59, 'a2afc9b7-0b5d-4499-af7e-a15508f3c0af', 65, 'MEDME HEALTH IS HIRING A SENIOR SOFTWARE ENGINEER (FULL STACK) FOR APAC/LATAM REGIONS. THE ROLE INVOLVES BUILDING AND MAINTAINING SERVICES IN TYPESCRIPT AND JAVA, MANAGING INTEGRATIONS, AND CONTRIBUTING TO THE ARCHITECTURE AND PRODUCT ROADMAP. THE COMPANY VALUES TECHNOLOGY PROBLEM SOLVERS AND OFFERS A REMOTE WORK ENVIRONMENT WITH A FOCUS ON INCLUSIVITY AND EQUAL OPPORTUNITY.', 'SENIOR SOFTWARE ENGINEER (FULL STACK) - APAC/LATAM', '2025-04-22', 'HTTPS://WWW.YCOMBINATOR.COM/COMPANIES/MEDME-HEALTH/JOBS/HBYIZSM-SENIOR-SOFTWARE-ENGINEER-FULL-STACK-APAC-LATAM', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.069025+07', '2025-04-27 11:45:51.069025+07');
INSERT INTO jobs.job VALUES (60, '36ad03b1-f855-435c-b280-42af2cf25ea8', 54, 'WHO YOU ARE. BS OR MS DEGREE IN A STEM MAJOR OR EQUIVALENT JOB EXPERIENCE REQUIRED 4+ YEARS EXPERIENCE IN FRONT-END DEVELOPMENT AND WRITING VERY HIGH QUALITY CODE THAT IS ROBUST AND EASY TO MAINTAIN KNOWLEDGE OF FRONT-END TECHNOLOGIES AND FRAMEWORKS (E.G., REACT, NEXTJS, CHAKRA UI) EXPERIENCE IN BUILDING RESPONSIVE AND ADAPTIVE WEB APPLICATIONS PROFICIENCY IN HTML, CSS, JAVASCRIPT, AND MODERN JAVASCRIPT FRAMEWORKS KNOWLEDGE AND EXPERIENCE IN IDENTIFYING AND SOLVING ISSUES WITH INTRICATE, LIVE SOFTWARE SYSTEMS, AS WELL AS IN-DEPTH FAMILIARITY WITH CONTEMPORARY SOFTWARE DEVELOPMENT PROCESSES SUCH AS CONTINUOUS INTEGRATION AND CONTINUOUS DEPLOYMENT PROFESSIONAL OR NATIVE ENGLISH LANGUAGE PROFICIENCY TECHNOLOGIES USED. NEXTJS, REACTJS, HTML, CSS, JAVASCRIPT (ES6+), CHAKRA UI, RESTFUL APIS, GIT, WEBPACK, BABEL WHAT YOU''LL BE DOING. DEVELOP NEW USER-FACING FEATURES AND ENSURE TECHNICAL FEASIBILITY OF UI/UX DESIGNS OPTIMIZE APPLICATIONS FOR MAXIMUM SPEED AND SCALABILITY COLLABORATE WITH BACKEND DEVELOPERS AND WEB DESIGNERS TO IMPROVE USABILITY WRITE CLEAR, TESTED, DOCUMENTED CODE CREATE AND REVIEW TECHNICAL DESIGN, CODE, AND DOCUMENTATION CONTRIBUTE TO WYND’S INFRASTRUCTURE WHICH INCLUDES MOBILE, DESKTOP, AND SERVER-SIDE APPLICATIONS', 'SENIOR SOFTWARE ENGINEER (FRONT END)', '2025-04-22', 'HTTPS://JOB-BOARDS.GREENHOUSE.IO/WYNDLABS/JOBS/4041920008', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.075339+07', '2025-04-27 11:45:51.075339+07');
INSERT INTO jobs.job VALUES (61, '18e8f7f5-51e9-4d2c-b129-a77a31cf30f8', 67, 'AUTOMATTIC IS SEEKING A SENIOR PRODUCT DESIGNER TO WORK ON PRODUCTS LIKE WORDPRESS.COM, TUMBLR, AND WOOCOMMERCE. THE ROLE INVOLVES DESIGNING USER EXPERIENCES, COLLABORATING WITH ENGINEERS, AND IMPROVING PRODUCT QUALITY. CANDIDATES SHOULD HAVE EXPERIENCE IN DESIGN SYSTEMS, USER RESEARCH, AND A STRONG PORTFOLIO. THE POSITION IS REMOTE WITH A SALARY RANGE OF $120,000-$180,000 USD.', 'SENIOR PRODUCT DESIGNER', '2025-04-25', 'HTTPS://AUTOMATTIC.COM/WORK-WITH-US/JOB/SENIOR-PRODUCT-DESIGNER/', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.082331+07', '2025-04-27 11:45:51.082331+07');
INSERT INTO jobs.job VALUES (62, '0a02d2e9-2493-4d9f-8f1c-747aa1eb3012', 68, 'INTERACTION DESIGN FOUNDATION IS SEEKING A SENIOR PHP/LARAVEL DEVELOPER TO JOIN THEIR TEAM. THE ROLE INVOLVES WORKING ON A 100% REMOTE BASIS, FOCUSING ON BUILDING AND MAINTAINING WEB APPLICATIONS USING PHP AND LARAVEL. THE CANDIDATE SHOULD HAVE STRONG EXPERIENCE IN PHP, LARAVEL, AND RELATED TECHNOLOGIES, AND BE ABLE TO WORK INDEPENDENTLY IN A REMOTE ENVIRONMENT.', 'SENIOR PHP/LARAVEL DEVELOPER', '2025-04-25', 'HTTPS://WWW.INTERACTION-DESIGN.ORG/ABOUT/CAREERS/SENIOR-PHP-LARAVEL-DEVELOPER', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.088769+07', '2025-04-27 11:45:51.088769+07');
INSERT INTO jobs.job VALUES (63, '0ed8a919-1e5a-4114-8cc3-deaadff2a8c8', 69, 'NERS ANALYTICS LIMITED IS SEEKING A QA ENGINEER / TEST-WRITING DEVELOPER TO WORK REMOTELY. THE ROLE INVOLVES WRITING AND MAINTAINING E2E TESTS, COLLABORATING WITH DEVELOPERS, AND ENSURING HIGH-QUALITY SOFTWARE DELIVERY. CANDIDATES SHOULD HAVE EXPERIENCE WITH CYPRESS, PLAYWRIGHT, OR SELENIUM, AND BE FAMILIAR WITH CI/CD PIPELINES.', 'QA ENGINEER / TEST-WRITING DEVELOPER', '2025-04-25', 'HTTPS://WEWORKREMOTELY.COM/REMOTE-JOBS/NERIS-ANALYTICS-LIMITED-QA-ENGINEER-TEST-WRITING-DEVELOPER', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.095172+07', '2025-04-27 11:45:51.095172+07');
INSERT INTO jobs.job VALUES (64, '9f158fca-3158-4fcc-80fa-b38751124e5e', 70, 'WEGO IS SEEKING A PRODUCT MANAGER TO MANAGE PRODUCT STRATEGY, DESIGN, OPTIMIZATION, AND GROWTH OF THE PRODUCT. THE ROLE INVOLVES COLLABORATING WITH INTERNAL STAKEHOLDERS, ANALYZING DATA, AND DEVELOPING PRODUCT ROADMAPS. THE IDEAL CANDIDATE SHOULD HAVE EXPERIENCE IN QUANTITATIVE TRADING, FINANCE, OR ALGORITHMIC TRADING, AND A MINIMUM OF 5 YEARS IN PRODUCT MANAGEMENT.', 'PRODUCT MANAGER', '2025-04-26', 'HTTPS://CAREERS.WEGO.COM/JOBS/5768992-PRODUCT-MANAGER', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.101642+07', '2025-04-27 11:45:51.101642+07');
INSERT INTO jobs.job VALUES (65, '26e7f3f3-808b-47dc-a6f5-e5d3f95ccf82', 70, 'THE ROLE INVOLVES ENSURING THE INTERNAL DEVELOPER PLATFORM IS STABLE AND SECURE, FOCUSING ON TECHNICAL LEADERSHIP, CLOUD INFRASTRUCTURE, MONITORING, AND INCIDENT RESPONSE. THE POSITION REQUIRES EXPERIENCE IN PLATFORM ENGINEERING, CLOUD-NATIVE TECHNOLOGIES, AND SHIFT-LEFT MINDSET.', 'SOFTWARE ENGINEER, PLATFORM ENGINEERING', '2025-04-26', 'HTTPS://CAREERS.WEGO.COM/JOBS/5839751-SOFTWARE-ENGINEER-PLATFORM-ENGINEERING', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.107939+07', '2025-04-27 11:45:51.107939+07');
INSERT INTO jobs.job VALUES (66, '2589edc2-960e-476a-a904-f70eddf53d44', 72, 'THE SENTIENT FOUNDATION IS SEEKING A WEB3-NATIVE UI/UX DESIGNER TO CREATE INTERFACES FOR AI MODELS AND CRYPTO PROTOCOLS. RESPONSIBILITIES INCLUDE DESIGNING AGENT INTERFACES, PROTOCOL DESIGN, AI INTEGRATION, AND USER RESEARCH. MUST HAVE 3+ YEARS OF EXPERIENCE IN WEB3 DESIGN AND PROFICIENCY IN MODERN DESIGN TOOLS.', 'UI/UX DESIGNER', '2025-04-26', 'HTTPS://JOBS.ASHBYHQ.COM/SENTIENT/53EAA200-9D47-407B-A5DB-026F0127E556', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.114504+07', '2025-04-27 11:45:51.114504+07');
INSERT INTO jobs.job VALUES (67, '9bf88ffa-5706-4511-95ab-d956285ebc28', 73, 'TESTLIO IS HIRING A SENIOR SOFTWARE ENGINEER TO DELIVER SOLUTIONS THAT HARNESS DATA AND AI ADVANCEMENTS FOR QUALITY SOFTWARE TESTING SERVICES. THE ROLE IS 100% REMOTE, FOCUSING ON BUILDING SCALABLE, QUALITY PRODUCTS AND CONTRIBUTING TO TEAM GOALS. CANDIDATES SHOULD HAVE 5-10 YEARS OF FULL-STACK CODING EXPERIENCE AND FAMILIARITY WITH REACT, TYPESCRIPT, NODEJS, GRAPHQL, PHP, MYSQL, AWS, AND KAFKA.', 'STAFF ENGINEER', '2025-04-26', 'HTTPS://JOB-BOARDS.GREENHOUSE.IO/TESTLIO/JOBS/6706911', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.120838+07', '2025-04-27 11:45:51.120838+07');
INSERT INTO jobs.job VALUES (68, '121a6d04-a145-4579-b599-9c73ed101dda', 73, 'TESTLIO IS HIRING A SENIOR SOFTWARE ENGINEER TO DELIVER SOLUTIONS THAT HARNESS DATA AND AI ADVANCEMENTS FOR QUALITY SOFTWARE TESTING SERVICES. THE ROLE IS 100% REMOTE, OPEN TO CANDIDATES IN EMEA AND APAC REGIONS, EXCLUDING HIGH-COST-OF-LIVING AREAS. TESTLIO IS A FEMALE-FOUNDED COMPANY WITH A GLOBAL PRESENCE, OFFERING A SUPPORTIVE AND INCLUSIVE WORK ENVIRONMENT.', 'SENIOR SOFTWARE ENGINEER', '2025-04-26', 'HTTPS://JOB-BOARDS.GREENHOUSE.IO/TESTLIO/JOBS/5929221', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.127081+07', '2025-04-27 11:45:51.127081+07');
INSERT INTO jobs.job VALUES (69, '2228ce2d-6898-43df-98c9-2e838c0e0fbc', 73, 'TESTLIO IS HIRING A PRINCIPAL SOFTWARE ENGINEER FOR A FULLY REMOTE POSITION WITHIN A GLOBALLY DISTRIBUTED COMPANY. THE ROLE INVOLVES DELIVERING SOLUTIONS THAT HARNESS DATA AND AI ADVANCEMENTS TO ENHANCE QUALITY SOFTWARE TESTING SERVICES. CANDIDATES SHOULD HAVE SIGNIFICANT EXPERIENCE IN ENTERPRISE ARCHITECTURE AND FULL-STACK SOLUTION ENGINEERING, WITH A STRONG AFFINITY FOR TECHNOLOGIES LIKE REACT, TYPESCRIPT, NODEJS, AND AWS. THE COMPANY VALUES DIVERSITY AND OFFERS BENEFITS LIKE STOCK OPTIONS AND AN EDUCATION BUDGET.', 'PRINCIPAL SOFTWARE ENGINEER', '2025-04-26', 'HTTPS://JOB-BOARDS.GREENHOUSE.IO/TESTLIO/JOBS/6038262', NULL, NULL, 'IDR', 'MONTHLY', 9997, true, '2025-04-27 11:45:51.133382+07', '2025-04-27 11:45:51.133382+07');


--
-- TOC entry 5200 (class 0 OID 18618)
-- Dependencies: 230
-- Data for Name: job_category; Type: TABLE DATA; Schema: jobs; Owner: -
--

INSERT INTO jobs.job_category VALUES (1, 'TECHNOLOGY & IT', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (2, 'MARKETING & ADVERTISING', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (3, 'BUSINESS & MANAGEMENT', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (4, 'SALES & CUSTOMER SERVICE', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (5, 'FINANCE & ACCOUNTING', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (6, 'CREATIVE & DESIGN', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (7, 'EDUCATION & TRAINING', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (8, 'HEALTHCARE & MEDICAL', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (9, 'ENGINEERING & MANUFACTURING', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (10, 'LEGAL & COMPLIANCE', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (11, 'HOSPITALITY & TOURISM', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (12, 'RETAIL & E-COMMERCE', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (13, 'LOGISTICS & SUPPLY CHAIN', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (14, 'MEDIA & COMMUNICATION', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');
INSERT INTO jobs.job_category VALUES (15, 'REMOTE & FREELANCE', '2025-04-14 00:21:01.193221+07', '2025-04-14 00:21:01.193221+07');


--
-- TOC entry 5202 (class 0 OID 18624)
-- Dependencies: 232
-- Data for Name: job_category_map; Type: TABLE DATA; Schema: jobs; Owner: -
--

INSERT INTO jobs.job_category_map VALUES (2, '5e28f050-213c-4d83-944b-572664f53840', 19, 1, '2025-04-27 11:20:06.552352+07', '2025-04-27 11:20:06.552352+07');
INSERT INTO jobs.job_category_map VALUES (3, '43862a75-1c57-4fa5-b377-69cedf95b2bb', 21, 1, '2025-04-27 11:45:20.424709+07', '2025-04-27 11:45:20.424709+07');
INSERT INTO jobs.job_category_map VALUES (4, 'cc0b4274-a990-467c-8b1f-b80296f89c8a', 22, 1, '2025-04-27 11:45:50.787684+07', '2025-04-27 11:45:50.787684+07');
INSERT INTO jobs.job_category_map VALUES (5, '0de45876-5ea6-4719-b451-892b049673be', 23, 1, '2025-04-27 11:45:50.820832+07', '2025-04-27 11:45:50.820832+07');
INSERT INTO jobs.job_category_map VALUES (6, '1a1f41a2-2e2e-44ef-b8b5-d503ffdbc455', 24, 1, '2025-04-27 11:45:50.827802+07', '2025-04-27 11:45:50.827802+07');
INSERT INTO jobs.job_category_map VALUES (7, '41d8ae42-961a-4fb1-988e-61621e7419a5', 25, 1, '2025-04-27 11:45:50.83604+07', '2025-04-27 11:45:50.83604+07');
INSERT INTO jobs.job_category_map VALUES (8, '591ddab1-8880-474b-8368-f485a368ddf5', 26, 1, '2025-04-27 11:45:50.842959+07', '2025-04-27 11:45:50.842959+07');
INSERT INTO jobs.job_category_map VALUES (9, '3b6becbd-c374-4cff-8bbf-52b567d5c1aa', 27, 1, '2025-04-27 11:45:50.849438+07', '2025-04-27 11:45:50.849438+07');
INSERT INTO jobs.job_category_map VALUES (10, '91c5c273-7e19-47b5-a267-44f33ebc45fd', 28, 1, '2025-04-27 11:45:50.85634+07', '2025-04-27 11:45:50.85634+07');
INSERT INTO jobs.job_category_map VALUES (11, '6720b381-0b8f-4fba-ba4b-9dba564fb9a9', 29, 1, '2025-04-27 11:45:50.864455+07', '2025-04-27 11:45:50.864455+07');
INSERT INTO jobs.job_category_map VALUES (12, '10bc9405-db48-45db-ac2f-772a649ee801', 30, 1, '2025-04-27 11:45:50.871311+07', '2025-04-27 11:45:50.871311+07');
INSERT INTO jobs.job_category_map VALUES (13, '2ed243d8-edef-474c-a01b-1cf4cb43c342', 31, 1, '2025-04-27 11:45:50.878289+07', '2025-04-27 11:45:50.878289+07');
INSERT INTO jobs.job_category_map VALUES (14, '53a3d47f-ff9a-4f3d-b61c-3e9cf9e1e4cd', 32, 1, '2025-04-27 11:45:50.887681+07', '2025-04-27 11:45:50.887681+07');
INSERT INTO jobs.job_category_map VALUES (15, '30e47489-08ed-478d-87dd-990128545aab', 33, 1, '2025-04-27 11:45:50.89388+07', '2025-04-27 11:45:50.89388+07');
INSERT INTO jobs.job_category_map VALUES (16, 'a4f250ba-4837-47ea-8259-0f5c28c5f968', 34, 1, '2025-04-27 11:45:50.899625+07', '2025-04-27 11:45:50.899625+07');
INSERT INTO jobs.job_category_map VALUES (17, '2b79e448-b99e-4aa2-ae6e-37e9a05d5cfd', 35, 1, '2025-04-27 11:45:50.906654+07', '2025-04-27 11:45:50.906654+07');
INSERT INTO jobs.job_category_map VALUES (18, '1b4133ba-167e-4c0b-9cbc-3010119dc573', 36, 1, '2025-04-27 11:45:50.913578+07', '2025-04-27 11:45:50.913578+07');
INSERT INTO jobs.job_category_map VALUES (19, 'a196919c-806c-4157-9ef2-03fc8f52dc69', 37, 1, '2025-04-27 11:45:50.919773+07', '2025-04-27 11:45:50.919773+07');
INSERT INTO jobs.job_category_map VALUES (20, 'f43b13c7-81cc-4ea7-a04a-38e93ff33aef', 38, 1, '2025-04-27 11:45:50.926455+07', '2025-04-27 11:45:50.926455+07');
INSERT INTO jobs.job_category_map VALUES (21, '54ad6622-23b5-4d28-bda4-efa1abe3a43f', 39, 1, '2025-04-27 11:45:50.932954+07', '2025-04-27 11:45:50.932954+07');
INSERT INTO jobs.job_category_map VALUES (22, 'ef12b636-124e-48fc-8b3e-303dea745710', 40, 1, '2025-04-27 11:45:50.93968+07', '2025-04-27 11:45:50.93968+07');
INSERT INTO jobs.job_category_map VALUES (23, 'f4231a63-39c5-426f-a227-e91f873df8ad', 41, 1, '2025-04-27 11:45:50.944709+07', '2025-04-27 11:45:50.944709+07');
INSERT INTO jobs.job_category_map VALUES (24, '4f2c64c9-f37e-43b5-9210-f3e6f1d5db21', 42, 1, '2025-04-27 11:45:50.950878+07', '2025-04-27 11:45:50.950878+07');
INSERT INTO jobs.job_category_map VALUES (25, '4bb0c3a2-38ab-4810-8521-e60aa57c0f70', 43, 1, '2025-04-27 11:45:50.957412+07', '2025-04-27 11:45:50.957412+07');
INSERT INTO jobs.job_category_map VALUES (26, '4121d66e-b519-4703-8fcc-3cd0e2864cef', 44, 1, '2025-04-27 11:45:50.963837+07', '2025-04-27 11:45:50.963837+07');
INSERT INTO jobs.job_category_map VALUES (27, 'd602a995-1417-40be-8eeb-3536bf45ed75', 45, 1, '2025-04-27 11:45:50.970704+07', '2025-04-27 11:45:50.970704+07');
INSERT INTO jobs.job_category_map VALUES (28, '129fcbfa-69b9-4917-93b3-35d77254b518', 46, 1, '2025-04-27 11:45:50.978664+07', '2025-04-27 11:45:50.978664+07');
INSERT INTO jobs.job_category_map VALUES (29, 'e7d8b29f-196a-4e4d-bd12-1f6ae93cbfe9', 47, 1, '2025-04-27 11:45:50.984751+07', '2025-04-27 11:45:50.984751+07');
INSERT INTO jobs.job_category_map VALUES (30, 'e4cf8918-c09d-48e8-b59f-3fcb1158d824', 48, 1, '2025-04-27 11:45:50.991469+07', '2025-04-27 11:45:50.991469+07');
INSERT INTO jobs.job_category_map VALUES (31, '84df20f8-9d93-42d6-b7d6-b674ab05f40d', 49, 1, '2025-04-27 11:45:51.000068+07', '2025-04-27 11:45:51.000068+07');
INSERT INTO jobs.job_category_map VALUES (32, '4f9f9540-0854-4d19-8af3-a24859a1da3d', 50, 1, '2025-04-27 11:45:51.008159+07', '2025-04-27 11:45:51.008159+07');
INSERT INTO jobs.job_category_map VALUES (33, '079a3135-d0a8-4ee8-b9bb-2e61c24f9211', 51, 1, '2025-04-27 11:45:51.015216+07', '2025-04-27 11:45:51.015216+07');
INSERT INTO jobs.job_category_map VALUES (34, '5325d7f6-8d35-4d81-9262-5f2bff61b01d', 52, 1, '2025-04-27 11:45:51.02238+07', '2025-04-27 11:45:51.02238+07');
INSERT INTO jobs.job_category_map VALUES (35, 'f280f7f6-d54a-4122-ac76-04e5366e03ca', 53, 1, '2025-04-27 11:45:51.029322+07', '2025-04-27 11:45:51.029322+07');
INSERT INTO jobs.job_category_map VALUES (36, '0224a148-63cc-4154-b46c-a03b2214cec5', 54, 1, '2025-04-27 11:45:51.037204+07', '2025-04-27 11:45:51.037204+07');
INSERT INTO jobs.job_category_map VALUES (37, '8ddf2aa5-fbde-41e7-a99a-7f1b9dc59628', 55, 1, '2025-04-27 11:45:51.043495+07', '2025-04-27 11:45:51.043495+07');
INSERT INTO jobs.job_category_map VALUES (38, 'c44a56f6-8724-4668-b896-96ca5007894a', 56, 1, '2025-04-27 11:45:51.050492+07', '2025-04-27 11:45:51.050492+07');
INSERT INTO jobs.job_category_map VALUES (39, 'cd00b035-4aee-4ce4-b682-eb94b92a4810', 57, 1, '2025-04-27 11:45:51.056422+07', '2025-04-27 11:45:51.056422+07');
INSERT INTO jobs.job_category_map VALUES (40, 'd0dcacf7-bdb9-44e1-8f6a-f84ec3593d9c', 58, 1, '2025-04-27 11:45:51.061951+07', '2025-04-27 11:45:51.061951+07');
INSERT INTO jobs.job_category_map VALUES (41, '94bd8248-f6fc-4c8f-a46b-393561fe9ab1', 59, 1, '2025-04-27 11:45:51.069025+07', '2025-04-27 11:45:51.069025+07');
INSERT INTO jobs.job_category_map VALUES (42, '14b8974e-0dd9-4e9e-a843-646335a0766e', 60, 1, '2025-04-27 11:45:51.075339+07', '2025-04-27 11:45:51.075339+07');
INSERT INTO jobs.job_category_map VALUES (43, '3cceeca4-1745-4375-9496-233b7dfdbad1', 61, 1, '2025-04-27 11:45:51.082331+07', '2025-04-27 11:45:51.082331+07');
INSERT INTO jobs.job_category_map VALUES (44, 'b35bd68a-f178-4c38-8de8-c9ffb015f692', 62, 1, '2025-04-27 11:45:51.088769+07', '2025-04-27 11:45:51.088769+07');
INSERT INTO jobs.job_category_map VALUES (45, '9740671a-e08b-4a42-9712-c9ffbf3a155b', 63, 1, '2025-04-27 11:45:51.095172+07', '2025-04-27 11:45:51.095172+07');
INSERT INTO jobs.job_category_map VALUES (46, '6aed9a69-4dd2-4f7c-8cc2-4d5b5d7cd1eb', 64, 1, '2025-04-27 11:45:51.101642+07', '2025-04-27 11:45:51.101642+07');
INSERT INTO jobs.job_category_map VALUES (47, 'b9be79a3-4d03-4dcc-85c5-79f6718815d8', 65, 1, '2025-04-27 11:45:51.107939+07', '2025-04-27 11:45:51.107939+07');
INSERT INTO jobs.job_category_map VALUES (48, '7d46e353-5854-4c4f-ac00-66a8e3f374a1', 66, 1, '2025-04-27 11:45:51.114504+07', '2025-04-27 11:45:51.114504+07');
INSERT INTO jobs.job_category_map VALUES (49, '0c63dc56-d990-424b-9b36-540510d09335', 67, 1, '2025-04-27 11:45:51.120838+07', '2025-04-27 11:45:51.120838+07');
INSERT INTO jobs.job_category_map VALUES (50, '28580038-1fc3-4284-b0bb-2e98015af390', 68, 1, '2025-04-27 11:45:51.127081+07', '2025-04-27 11:45:51.127081+07');
INSERT INTO jobs.job_category_map VALUES (51, '1f58d63c-194d-449f-898e-83313a4d6669', 69, 1, '2025-04-27 11:45:51.133382+07', '2025-04-27 11:45:51.133382+07');


--
-- TOC entry 5205 (class 0 OID 18631)
-- Dependencies: 235
-- Data for Name: job_salary; Type: TABLE DATA; Schema: jobs; Owner: -
--

INSERT INTO jobs.job_salary VALUES (1, 'NEGOTIABLE', '2025-04-22 11:01:27.522204+07', '2025-04-22 11:01:27.522204+07');
INSERT INTO jobs.job_salary VALUES (2, 'FIX', '2025-04-22 11:01:27.522204+07', '2025-04-22 11:01:27.522204+07');
INSERT INTO jobs.job_salary VALUES (3, 'RANGE', '2025-04-22 11:01:27.522204+07', '2025-04-22 11:01:27.522204+07');
INSERT INTO jobs.job_salary VALUES (6, 'FIXED', '2025-04-27 11:20:06.552352+07', '2025-04-27 11:20:06.552352+07');


--
-- TOC entry 5207 (class 0 OID 18637)
-- Dependencies: 237
-- Data for Name: job_salary_map; Type: TABLE DATA; Schema: jobs; Owner: -
--

INSERT INTO jobs.job_salary_map VALUES (3, 'ee899936-9870-4b4f-808d-bb067967a2f2', 19, 6, '2025-04-27 11:20:06.552352+07', '2025-04-27 11:20:06.552352+07');
INSERT INTO jobs.job_salary_map VALUES (4, 'f5e9b9f4-668f-489b-b56d-02bd00e6ffb8', 21, 6, '2025-04-27 11:45:20.424709+07', '2025-04-27 11:45:20.424709+07');
INSERT INTO jobs.job_salary_map VALUES (5, '22f5f496-d183-4f46-a3e2-9d4178dda44a', 22, 6, '2025-04-27 11:45:50.787684+07', '2025-04-27 11:45:50.787684+07');
INSERT INTO jobs.job_salary_map VALUES (6, '2dba1f77-bc2f-4643-a86d-5cf092e20e6b', 23, 6, '2025-04-27 11:45:50.820832+07', '2025-04-27 11:45:50.820832+07');
INSERT INTO jobs.job_salary_map VALUES (7, '2c788395-ed6e-4e70-a157-a41fc2808043', 24, 6, '2025-04-27 11:45:50.827802+07', '2025-04-27 11:45:50.827802+07');
INSERT INTO jobs.job_salary_map VALUES (8, '61e807c1-3997-4c15-82cc-17539f2241a2', 25, 6, '2025-04-27 11:45:50.83604+07', '2025-04-27 11:45:50.83604+07');
INSERT INTO jobs.job_salary_map VALUES (9, 'e943483f-c892-446a-85b7-a83e82a65cd1', 26, 6, '2025-04-27 11:45:50.842959+07', '2025-04-27 11:45:50.842959+07');
INSERT INTO jobs.job_salary_map VALUES (10, 'f7f78ceb-a3c6-4801-ada6-bff1298612b8', 27, 6, '2025-04-27 11:45:50.849438+07', '2025-04-27 11:45:50.849438+07');
INSERT INTO jobs.job_salary_map VALUES (11, '623efedf-3134-4336-b7d1-ae55fe6e2834', 28, 6, '2025-04-27 11:45:50.85634+07', '2025-04-27 11:45:50.85634+07');
INSERT INTO jobs.job_salary_map VALUES (12, 'd77424ec-ad99-4e20-91a4-cb39e00b9e86', 29, 6, '2025-04-27 11:45:50.864455+07', '2025-04-27 11:45:50.864455+07');
INSERT INTO jobs.job_salary_map VALUES (13, '0cfb4bd9-469a-4d8c-aa92-5c077fb38c30', 30, 6, '2025-04-27 11:45:50.871311+07', '2025-04-27 11:45:50.871311+07');
INSERT INTO jobs.job_salary_map VALUES (14, '2fca4f0c-aed7-4983-adee-a13466ee3eb8', 31, 6, '2025-04-27 11:45:50.878289+07', '2025-04-27 11:45:50.878289+07');
INSERT INTO jobs.job_salary_map VALUES (15, 'cde120ae-b8a6-4cca-ac64-02cb8cc4378b', 32, 6, '2025-04-27 11:45:50.887681+07', '2025-04-27 11:45:50.887681+07');
INSERT INTO jobs.job_salary_map VALUES (16, '743e32a6-18fc-4c43-b54f-c63f8ccb7c00', 33, 6, '2025-04-27 11:45:50.89388+07', '2025-04-27 11:45:50.89388+07');
INSERT INTO jobs.job_salary_map VALUES (17, 'ecfc24b1-9683-4a1c-a1c1-5f237daac4bf', 34, 6, '2025-04-27 11:45:50.899625+07', '2025-04-27 11:45:50.899625+07');
INSERT INTO jobs.job_salary_map VALUES (18, '92e91f21-985c-4e4b-9be1-7352aeb75743', 35, 6, '2025-04-27 11:45:50.906654+07', '2025-04-27 11:45:50.906654+07');
INSERT INTO jobs.job_salary_map VALUES (19, 'a2ac84b5-bff4-4494-907e-37ea6edc6c46', 36, 6, '2025-04-27 11:45:50.913578+07', '2025-04-27 11:45:50.913578+07');
INSERT INTO jobs.job_salary_map VALUES (20, 'ccf91efb-f4fd-4090-8895-9fc24c4ece34', 37, 6, '2025-04-27 11:45:50.919773+07', '2025-04-27 11:45:50.919773+07');
INSERT INTO jobs.job_salary_map VALUES (21, '3647da7b-3088-4aa1-93a7-7d77c91260a4', 38, 6, '2025-04-27 11:45:50.926455+07', '2025-04-27 11:45:50.926455+07');
INSERT INTO jobs.job_salary_map VALUES (22, '3ee16a7e-f8ec-43e7-bc0d-f29f290aaa94', 39, 6, '2025-04-27 11:45:50.932954+07', '2025-04-27 11:45:50.932954+07');
INSERT INTO jobs.job_salary_map VALUES (23, '2d53669c-3706-4272-a917-3cc396d2f70c', 40, 6, '2025-04-27 11:45:50.93968+07', '2025-04-27 11:45:50.93968+07');
INSERT INTO jobs.job_salary_map VALUES (24, '62239a23-87f3-4cf9-9302-0eb70a3efd91', 41, 6, '2025-04-27 11:45:50.944709+07', '2025-04-27 11:45:50.944709+07');
INSERT INTO jobs.job_salary_map VALUES (25, '9e0e3a5a-1ec2-4039-958e-a9fd478a2150', 42, 6, '2025-04-27 11:45:50.950878+07', '2025-04-27 11:45:50.950878+07');
INSERT INTO jobs.job_salary_map VALUES (26, 'bf4fc3cc-5133-4edb-a66c-ad220ebbaa73', 43, 6, '2025-04-27 11:45:50.957412+07', '2025-04-27 11:45:50.957412+07');
INSERT INTO jobs.job_salary_map VALUES (27, '3e6f86d2-0872-4fb0-9c22-e5c6aecd8c40', 44, 6, '2025-04-27 11:45:50.963837+07', '2025-04-27 11:45:50.963837+07');
INSERT INTO jobs.job_salary_map VALUES (28, '0eae7e86-a80c-41ba-b413-27ab2877291a', 45, 6, '2025-04-27 11:45:50.970704+07', '2025-04-27 11:45:50.970704+07');
INSERT INTO jobs.job_salary_map VALUES (29, '4788edca-33c2-4fec-8097-2f2f6ad9e382', 46, 6, '2025-04-27 11:45:50.978664+07', '2025-04-27 11:45:50.978664+07');
INSERT INTO jobs.job_salary_map VALUES (30, 'fcca5445-6977-49ca-8b80-cfd839bf7088', 47, 6, '2025-04-27 11:45:50.984751+07', '2025-04-27 11:45:50.984751+07');
INSERT INTO jobs.job_salary_map VALUES (31, 'f1189002-e392-4468-bee6-feb91760a354', 48, 6, '2025-04-27 11:45:50.991469+07', '2025-04-27 11:45:50.991469+07');
INSERT INTO jobs.job_salary_map VALUES (32, '5c84f41e-cbd1-485c-acdd-80ad3074fc75', 49, 6, '2025-04-27 11:45:51.000068+07', '2025-04-27 11:45:51.000068+07');
INSERT INTO jobs.job_salary_map VALUES (33, '7ab6ae37-5fa0-45fb-ae62-464b81e2bf17', 50, 6, '2025-04-27 11:45:51.008159+07', '2025-04-27 11:45:51.008159+07');
INSERT INTO jobs.job_salary_map VALUES (34, 'd2d12d45-f72e-4e6a-9676-76416ed5138e', 51, 6, '2025-04-27 11:45:51.015216+07', '2025-04-27 11:45:51.015216+07');
INSERT INTO jobs.job_salary_map VALUES (35, 'fbef1825-2541-4c48-b869-6a397c1bb9fa', 52, 6, '2025-04-27 11:45:51.02238+07', '2025-04-27 11:45:51.02238+07');
INSERT INTO jobs.job_salary_map VALUES (36, '93bcfbf4-fbc9-478e-bde1-e0dc20d81ab7', 53, 6, '2025-04-27 11:45:51.029322+07', '2025-04-27 11:45:51.029322+07');
INSERT INTO jobs.job_salary_map VALUES (37, 'ee047973-3282-400d-808c-c9ce65d83bd6', 54, 6, '2025-04-27 11:45:51.037204+07', '2025-04-27 11:45:51.037204+07');
INSERT INTO jobs.job_salary_map VALUES (38, '529331ff-b51b-44ec-b6dd-3a2bb4000ecd', 55, 6, '2025-04-27 11:45:51.043495+07', '2025-04-27 11:45:51.043495+07');
INSERT INTO jobs.job_salary_map VALUES (39, '14ff7ac6-7905-4c10-ad58-b2c8034de9da', 56, 6, '2025-04-27 11:45:51.050492+07', '2025-04-27 11:45:51.050492+07');
INSERT INTO jobs.job_salary_map VALUES (40, 'f87bcbe6-b5de-4be2-aba3-54caf2c78095', 57, 6, '2025-04-27 11:45:51.056422+07', '2025-04-27 11:45:51.056422+07');
INSERT INTO jobs.job_salary_map VALUES (41, '566e08e0-8a7b-402b-a835-6ef4ba2ba9db', 58, 6, '2025-04-27 11:45:51.061951+07', '2025-04-27 11:45:51.061951+07');
INSERT INTO jobs.job_salary_map VALUES (42, '2587a0b5-a1cf-4757-b9b9-2178ac4e67e7', 59, 6, '2025-04-27 11:45:51.069025+07', '2025-04-27 11:45:51.069025+07');
INSERT INTO jobs.job_salary_map VALUES (43, '82453070-e90c-456d-9324-56405e5293cf', 60, 6, '2025-04-27 11:45:51.075339+07', '2025-04-27 11:45:51.075339+07');
INSERT INTO jobs.job_salary_map VALUES (44, '6acecd58-fa29-423e-a8fc-08ae0790f75e', 61, 6, '2025-04-27 11:45:51.082331+07', '2025-04-27 11:45:51.082331+07');
INSERT INTO jobs.job_salary_map VALUES (45, '2e9b497f-4ccc-4692-af93-ad1cb3105046', 62, 6, '2025-04-27 11:45:51.088769+07', '2025-04-27 11:45:51.088769+07');
INSERT INTO jobs.job_salary_map VALUES (46, '31b99c86-ff1d-4316-94d8-7fcf25b1579a', 63, 6, '2025-04-27 11:45:51.095172+07', '2025-04-27 11:45:51.095172+07');
INSERT INTO jobs.job_salary_map VALUES (47, '0dcacb8f-3fa4-4979-a531-f1428ac5bb82', 64, 6, '2025-04-27 11:45:51.101642+07', '2025-04-27 11:45:51.101642+07');
INSERT INTO jobs.job_salary_map VALUES (48, '0287864e-b132-4dbd-8725-7b4c11f5dcd7', 65, 6, '2025-04-27 11:45:51.107939+07', '2025-04-27 11:45:51.107939+07');
INSERT INTO jobs.job_salary_map VALUES (49, '74e8ce8f-1d36-42ef-9afb-c2c94bf7faa9', 66, 6, '2025-04-27 11:45:51.114504+07', '2025-04-27 11:45:51.114504+07');
INSERT INTO jobs.job_salary_map VALUES (50, '40afc7ab-51e2-4153-8103-1483c4f0578b', 67, 6, '2025-04-27 11:45:51.120838+07', '2025-04-27 11:45:51.120838+07');
INSERT INTO jobs.job_salary_map VALUES (51, '02ed92ff-be09-4b45-a38c-e3e41bf21171', 68, 6, '2025-04-27 11:45:51.127081+07', '2025-04-27 11:45:51.127081+07');
INSERT INTO jobs.job_salary_map VALUES (52, '12539fc0-65dd-468b-ae37-8f422ee2a7f4', 69, 6, '2025-04-27 11:45:51.133382+07', '2025-04-27 11:45:51.133382+07');


--
-- TOC entry 5209 (class 0 OID 18643)
-- Dependencies: 239
-- Data for Name: job_schedule; Type: TABLE DATA; Schema: jobs; Owner: -
--

INSERT INTO jobs.job_schedule VALUES (1, 'FULLTIME', '2025-04-22 11:02:59.532548+07', '2025-04-22 11:02:59.532548+07');
INSERT INTO jobs.job_schedule VALUES (2, 'PARTTIME', '2025-04-22 11:02:59.532548+07', '2025-04-22 11:02:59.532548+07');
INSERT INTO jobs.job_schedule VALUES (3, 'FREELANCE', '2025-04-22 11:02:59.532548+07', '2025-04-22 11:02:59.532548+07');
INSERT INTO jobs.job_schedule VALUES (4, 'INTERNSHIP', '2025-04-22 11:02:59.532548+07', '2025-04-22 11:02:59.532548+07');


--
-- TOC entry 5211 (class 0 OID 18649)
-- Dependencies: 241
-- Data for Name: job_schedule_map; Type: TABLE DATA; Schema: jobs; Owner: -
--

INSERT INTO jobs.job_schedule_map VALUES (6, '9bd6d8ef-3185-450d-8f9f-53d4008744d9', 19, 1, '2025-04-27 11:20:06.552352+07', '2025-04-27 11:20:06.552352+07');
INSERT INTO jobs.job_schedule_map VALUES (7, '6559ecb7-61dd-4da3-b5f9-fb06952b0420', 21, 1, '2025-04-27 11:45:20.424709+07', '2025-04-27 11:45:20.424709+07');
INSERT INTO jobs.job_schedule_map VALUES (8, 'd93dd38c-2a58-4619-86d5-3b710104cf6a', 22, 1, '2025-04-27 11:45:50.787684+07', '2025-04-27 11:45:50.787684+07');
INSERT INTO jobs.job_schedule_map VALUES (9, 'c0bcd9d2-ad7f-4459-bd31-f3bcb5eed165', 23, 1, '2025-04-27 11:45:50.820832+07', '2025-04-27 11:45:50.820832+07');
INSERT INTO jobs.job_schedule_map VALUES (10, '2d5ca5c6-e6c0-45ec-8677-2407005f439e', 24, 1, '2025-04-27 11:45:50.827802+07', '2025-04-27 11:45:50.827802+07');
INSERT INTO jobs.job_schedule_map VALUES (11, '20ff665b-a08f-48d9-b760-ee85f24d0065', 25, 1, '2025-04-27 11:45:50.83604+07', '2025-04-27 11:45:50.83604+07');
INSERT INTO jobs.job_schedule_map VALUES (12, '53f2a132-b890-4a9f-a4e3-7972c8bcfea7', 26, 1, '2025-04-27 11:45:50.842959+07', '2025-04-27 11:45:50.842959+07');
INSERT INTO jobs.job_schedule_map VALUES (13, 'c0b0c597-4d2b-4326-8221-2cca9eee28de', 27, 1, '2025-04-27 11:45:50.849438+07', '2025-04-27 11:45:50.849438+07');
INSERT INTO jobs.job_schedule_map VALUES (14, 'a506a5b1-6a9c-4cdc-8f1a-797b47f87bc9', 28, 1, '2025-04-27 11:45:50.85634+07', '2025-04-27 11:45:50.85634+07');
INSERT INTO jobs.job_schedule_map VALUES (15, 'cc18780a-fc1f-4a16-8395-4c082788e9f2', 29, 1, '2025-04-27 11:45:50.864455+07', '2025-04-27 11:45:50.864455+07');
INSERT INTO jobs.job_schedule_map VALUES (16, '7efbac89-bcc8-45d8-9337-7285065f0ab1', 30, 1, '2025-04-27 11:45:50.871311+07', '2025-04-27 11:45:50.871311+07');
INSERT INTO jobs.job_schedule_map VALUES (17, 'e3d7d2e5-6b1c-4aec-9d6c-cdc2cfd0fc94', 31, 1, '2025-04-27 11:45:50.878289+07', '2025-04-27 11:45:50.878289+07');
INSERT INTO jobs.job_schedule_map VALUES (18, '30134cc2-bb68-4ec4-b54f-79910a9834d4', 32, 1, '2025-04-27 11:45:50.887681+07', '2025-04-27 11:45:50.887681+07');
INSERT INTO jobs.job_schedule_map VALUES (19, '86e39990-3290-4df2-9825-ca119b9c2332', 33, 1, '2025-04-27 11:45:50.89388+07', '2025-04-27 11:45:50.89388+07');
INSERT INTO jobs.job_schedule_map VALUES (20, '7ab2f35d-2c0c-41d9-a723-671e4570adc2', 34, 1, '2025-04-27 11:45:50.899625+07', '2025-04-27 11:45:50.899625+07');
INSERT INTO jobs.job_schedule_map VALUES (21, '8d6cc691-bad0-4f5d-a37f-a613b7b4804d', 35, 1, '2025-04-27 11:45:50.906654+07', '2025-04-27 11:45:50.906654+07');
INSERT INTO jobs.job_schedule_map VALUES (22, 'a5def065-1c14-4d12-b3ef-80f82d2932c9', 36, 1, '2025-04-27 11:45:50.913578+07', '2025-04-27 11:45:50.913578+07');
INSERT INTO jobs.job_schedule_map VALUES (23, 'ba576707-be15-4f33-a5f8-931a850cfe48', 37, 1, '2025-04-27 11:45:50.919773+07', '2025-04-27 11:45:50.919773+07');
INSERT INTO jobs.job_schedule_map VALUES (24, 'a08d9794-e069-41d8-8714-ea3853d7645a', 38, 1, '2025-04-27 11:45:50.926455+07', '2025-04-27 11:45:50.926455+07');
INSERT INTO jobs.job_schedule_map VALUES (25, '2b1d8f78-2c86-4224-a2de-f75e0db39e80', 39, 1, '2025-04-27 11:45:50.932954+07', '2025-04-27 11:45:50.932954+07');
INSERT INTO jobs.job_schedule_map VALUES (26, 'e6f01c15-d0dc-4e18-bb5d-74e4f31c629a', 40, 1, '2025-04-27 11:45:50.93968+07', '2025-04-27 11:45:50.93968+07');
INSERT INTO jobs.job_schedule_map VALUES (27, '27bfa3ba-8ea5-484a-9e87-0283a366fc9f', 41, 1, '2025-04-27 11:45:50.944709+07', '2025-04-27 11:45:50.944709+07');
INSERT INTO jobs.job_schedule_map VALUES (28, '124161cd-c2e7-4f66-a305-94f93ff72105', 42, 1, '2025-04-27 11:45:50.950878+07', '2025-04-27 11:45:50.950878+07');
INSERT INTO jobs.job_schedule_map VALUES (29, '422d4e9c-a7d7-44c7-88d4-afb294a572cd', 43, 1, '2025-04-27 11:45:50.957412+07', '2025-04-27 11:45:50.957412+07');
INSERT INTO jobs.job_schedule_map VALUES (30, 'f67fe47e-79ad-44b4-b631-238808afb021', 44, 1, '2025-04-27 11:45:50.963837+07', '2025-04-27 11:45:50.963837+07');
INSERT INTO jobs.job_schedule_map VALUES (31, '118d0913-6f59-49af-82a6-91ed2c4faa0e', 45, 1, '2025-04-27 11:45:50.970704+07', '2025-04-27 11:45:50.970704+07');
INSERT INTO jobs.job_schedule_map VALUES (32, 'c05937bb-5b71-44b5-9abd-bd340d114d3b', 46, 1, '2025-04-27 11:45:50.978664+07', '2025-04-27 11:45:50.978664+07');
INSERT INTO jobs.job_schedule_map VALUES (33, '1623ee02-a749-4332-948b-cc74d27ee20d', 47, 1, '2025-04-27 11:45:50.984751+07', '2025-04-27 11:45:50.984751+07');
INSERT INTO jobs.job_schedule_map VALUES (34, 'c3fc907e-ac9d-460e-8c0b-42c609298786', 48, 1, '2025-04-27 11:45:50.991469+07', '2025-04-27 11:45:50.991469+07');
INSERT INTO jobs.job_schedule_map VALUES (35, 'a749934f-ab7a-4e1f-954e-46f88e136d95', 49, 1, '2025-04-27 11:45:51.000068+07', '2025-04-27 11:45:51.000068+07');
INSERT INTO jobs.job_schedule_map VALUES (36, 'c59e8be4-b0f5-4494-b0d5-1c1e6ce0a511', 50, 1, '2025-04-27 11:45:51.008159+07', '2025-04-27 11:45:51.008159+07');
INSERT INTO jobs.job_schedule_map VALUES (37, '15f44dc4-2377-4485-8e08-7281d104a971', 51, 1, '2025-04-27 11:45:51.015216+07', '2025-04-27 11:45:51.015216+07');
INSERT INTO jobs.job_schedule_map VALUES (38, '780ecc29-1830-4a9f-86aa-b8c4982a3500', 52, 1, '2025-04-27 11:45:51.02238+07', '2025-04-27 11:45:51.02238+07');
INSERT INTO jobs.job_schedule_map VALUES (39, '7e0b1aa8-6903-40e5-a539-999cc4ae5081', 53, 1, '2025-04-27 11:45:51.029322+07', '2025-04-27 11:45:51.029322+07');
INSERT INTO jobs.job_schedule_map VALUES (40, 'd827211c-2212-4747-a182-4d4e2dcb0d50', 54, 1, '2025-04-27 11:45:51.037204+07', '2025-04-27 11:45:51.037204+07');
INSERT INTO jobs.job_schedule_map VALUES (41, '1d69a766-a022-4ea3-ab12-e6327315a784', 55, 1, '2025-04-27 11:45:51.043495+07', '2025-04-27 11:45:51.043495+07');
INSERT INTO jobs.job_schedule_map VALUES (42, 'ebe9f673-18f7-4731-93b9-6a143f1af4b3', 56, 1, '2025-04-27 11:45:51.050492+07', '2025-04-27 11:45:51.050492+07');
INSERT INTO jobs.job_schedule_map VALUES (43, '29fa69a4-74b4-4b1c-ad16-9e73c22a56c3', 57, 1, '2025-04-27 11:45:51.056422+07', '2025-04-27 11:45:51.056422+07');
INSERT INTO jobs.job_schedule_map VALUES (44, 'fac71d73-8053-4c5e-8316-cc7a2b87136d', 58, 1, '2025-04-27 11:45:51.061951+07', '2025-04-27 11:45:51.061951+07');
INSERT INTO jobs.job_schedule_map VALUES (45, 'c3ffdc25-6c51-470f-bd1f-fd09b80d184e', 59, 1, '2025-04-27 11:45:51.069025+07', '2025-04-27 11:45:51.069025+07');
INSERT INTO jobs.job_schedule_map VALUES (46, '50819d8f-69e7-4242-8d86-354a1e75b593', 60, 1, '2025-04-27 11:45:51.075339+07', '2025-04-27 11:45:51.075339+07');
INSERT INTO jobs.job_schedule_map VALUES (47, '986ed813-4418-4011-a903-8298658602c6', 61, 1, '2025-04-27 11:45:51.082331+07', '2025-04-27 11:45:51.082331+07');
INSERT INTO jobs.job_schedule_map VALUES (48, '5233a377-3880-4c6f-90a3-f2ae81c8307d', 62, 1, '2025-04-27 11:45:51.088769+07', '2025-04-27 11:45:51.088769+07');
INSERT INTO jobs.job_schedule_map VALUES (49, 'ed698bb5-bb63-4d9a-bd86-eb11a33fd1ef', 63, 1, '2025-04-27 11:45:51.095172+07', '2025-04-27 11:45:51.095172+07');
INSERT INTO jobs.job_schedule_map VALUES (50, '47606caa-5c86-4901-9564-2232794baba1', 64, 1, '2025-04-27 11:45:51.101642+07', '2025-04-27 11:45:51.101642+07');
INSERT INTO jobs.job_schedule_map VALUES (51, '3b51ec9b-b340-4ae1-9a9e-024ee0d49d21', 65, 1, '2025-04-27 11:45:51.107939+07', '2025-04-27 11:45:51.107939+07');
INSERT INTO jobs.job_schedule_map VALUES (52, '052a93af-519b-448a-b1db-20cbf7208e43', 66, 1, '2025-04-27 11:45:51.114504+07', '2025-04-27 11:45:51.114504+07');
INSERT INTO jobs.job_schedule_map VALUES (53, 'bd6f598a-e0b5-4b0a-8f2e-cda4ef775709', 67, 1, '2025-04-27 11:45:51.120838+07', '2025-04-27 11:45:51.120838+07');
INSERT INTO jobs.job_schedule_map VALUES (54, 'af576bd0-5297-48da-a057-33991300664a', 68, 1, '2025-04-27 11:45:51.127081+07', '2025-04-27 11:45:51.127081+07');
INSERT INTO jobs.job_schedule_map VALUES (55, 'e254aabe-cd70-4060-9b40-9cc1d332994a', 69, 1, '2025-04-27 11:45:51.133382+07', '2025-04-27 11:45:51.133382+07');


--
-- TOC entry 5224 (class 0 OID 18859)
-- Dependencies: 254
-- Data for Name: job_skill; Type: TABLE DATA; Schema: jobs; Owner: -
--

INSERT INTO jobs.job_skill VALUES (1, 'Teaching', '2025-04-25 23:15:46.282662', '2025-04-25 23:15:46.282662');
INSERT INTO jobs.job_skill VALUES (2, 'Communication', '2025-04-25 23:15:46.282662', '2025-04-25 23:15:46.282662');
INSERT INTO jobs.job_skill VALUES (3, 'Problem Solving', '2025-04-25 23:15:46.282662', '2025-04-25 23:15:46.282662');
INSERT INTO jobs.job_skill VALUES (4, 'Teamwork', '2025-04-25 23:15:46.282662', '2025-04-25 23:15:46.282662');
INSERT INTO jobs.job_skill VALUES (5, 'Leadership', '2025-04-25 23:15:46.282662', '2025-04-25 23:15:46.282662');
INSERT INTO jobs.job_skill VALUES (6, 'Time Management', '2025-04-25 23:15:46.282662', '2025-04-25 23:15:46.282662');
INSERT INTO jobs.job_skill VALUES (7, 'Creativity', '2025-04-25 23:15:46.282662', '2025-04-25 23:15:46.282662');
INSERT INTO jobs.job_skill VALUES (8, 'Critical Thinking', '2025-04-25 23:15:46.282662', '2025-04-25 23:15:46.282662');
INSERT INTO jobs.job_skill VALUES (9, 'Adaptability', '2025-04-25 23:15:46.282662', '2025-04-25 23:15:46.282662');
INSERT INTO jobs.job_skill VALUES (10, 'Technical Writing', '2025-04-25 23:15:46.282662', '2025-04-25 23:15:46.282662');
INSERT INTO jobs.job_skill VALUES (68, 'FRONTEND DEVELOPMENT', '2025-04-27 11:20:06.552352', '2025-04-27 11:20:06.552352');
INSERT INTO jobs.job_skill VALUES (69, 'BACKEND DEVELOPMENT', '2025-04-27 11:20:06.552352', '2025-04-27 11:20:06.552352');
INSERT INTO jobs.job_skill VALUES (70, 'FULL-STACK DEVELOPMENT', '2025-04-27 11:20:06.552352', '2025-04-27 11:20:06.552352');
INSERT INTO jobs.job_skill VALUES (72, 'QA AUTOMATION', '2025-04-27 11:45:20.424709', '2025-04-27 11:45:20.424709');
INSERT INTO jobs.job_skill VALUES (73, 'WEB TESTING', '2025-04-27 11:45:20.424709', '2025-04-27 11:45:20.424709');
INSERT INTO jobs.job_skill VALUES (75, 'HEALTHTECH', '2025-04-27 11:45:20.424709', '2025-04-27 11:45:20.424709');
INSERT INTO jobs.job_skill VALUES (76, 'FULL-STACK DEVELOPER', '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill VALUES (77, 'REACT', '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill VALUES (78, 'VUE.JS', '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill VALUES (82, 'AI INTEGRATION', '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill VALUES (83, 'RESTFUL API', '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill VALUES (84, 'MICROSERVICES', '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill VALUES (85, 'CLOUD PLATFORMS', '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill VALUES (88, 'AI ENGINEERING', '2025-04-27 11:45:50.820832', '2025-04-27 11:45:50.820832');
INSERT INTO jobs.job_skill VALUES (174, 'RESEARCH', '2025-04-27 11:45:50.950878', '2025-04-27 11:45:50.950878');
INSERT INTO jobs.job_skill VALUES (91, 'BUSINESS DEVELOPMENT', '2025-04-27 11:45:50.827802', '2025-04-27 11:45:50.827802');
INSERT INTO jobs.job_skill VALUES (94, 'CLIENT RELATIONS', '2025-04-27 11:45:50.827802', '2025-04-27 11:45:50.827802');
INSERT INTO jobs.job_skill VALUES (95, 'RELATIONSHIP MANAGEMENT', '2025-04-27 11:45:50.827802', '2025-04-27 11:45:50.827802');
INSERT INTO jobs.job_skill VALUES (96, 'CUSTOMER SUPPORT', '2025-04-27 11:45:50.83604', '2025-04-27 11:45:50.83604');
INSERT INTO jobs.job_skill VALUES (99, 'ENTERPRISE SOFTWARE', '2025-04-27 11:45:50.83604', '2025-04-27 11:45:50.83604');
INSERT INTO jobs.job_skill VALUES (100, 'DEVOPS', '2025-04-27 11:45:50.842959', '2025-04-27 11:45:50.842959');
INSERT INTO jobs.job_skill VALUES (103, 'GCP', '2025-04-27 11:45:50.842959', '2025-04-27 11:45:50.842959');
INSERT INTO jobs.job_skill VALUES (104, 'TERRAFORM', '2025-04-27 11:45:50.842959', '2025-04-27 11:45:50.842959');
INSERT INTO jobs.job_skill VALUES (175, 'REPORT WRITING', '2025-04-27 11:45:50.950878', '2025-04-27 11:45:50.950878');
INSERT INTO jobs.job_skill VALUES (106, 'QUALITY ENGINEERING', '2025-04-27 11:45:50.849438', '2025-04-27 11:45:50.849438');
INSERT INTO jobs.job_skill VALUES (98, 'ODOO', '2025-04-27 11:45:50.83604', '2025-04-27 11:45:50.83604');
INSERT INTO jobs.job_skill VALUES (176, 'STAKEHOLDER ENGAGEMENT', '2025-04-27 11:45:50.950878', '2025-04-27 11:45:50.950878');
INSERT INTO jobs.job_skill VALUES (110, 'CLOUD SUPPORT', '2025-04-27 11:45:50.85634', '2025-04-27 11:45:50.85634');
INSERT INTO jobs.job_skill VALUES (206, 'FREELANCE', '2025-04-27 11:45:51.000068', '2025-04-27 11:45:51.000068');
INSERT INTO jobs.job_skill VALUES (114, 'INFORMATION TECHNOLOGY', '2025-04-27 11:45:50.85634', '2025-04-27 11:45:50.85634');
INSERT INTO jobs.job_skill VALUES (97, 'TROUBLESHOOTING', '2025-04-27 11:45:50.83604', '2025-04-27 11:45:50.83604');
INSERT INTO jobs.job_skill VALUES (112, 'GENAI', '2025-04-27 11:45:50.85634', '2025-04-27 11:45:50.85634');
INSERT INTO jobs.job_skill VALUES (207, 'BLENDER', '2025-04-27 11:45:51.000068', '2025-04-27 11:45:51.000068');
INSERT INTO jobs.job_skill VALUES (123, 'STARTUP', '2025-04-27 11:45:50.871311', '2025-04-27 11:45:50.871311');
INSERT INTO jobs.job_skill VALUES (124, 'COFOUNDER MATCHING', '2025-04-27 11:45:50.871311', '2025-04-27 11:45:50.871311');
INSERT INTO jobs.job_skill VALUES (125, 'LINUX', '2025-04-27 11:45:50.878289', '2025-04-27 11:45:50.878289');
INSERT INTO jobs.job_skill VALUES (126, 'INFRASTRUCTURE', '2025-04-27 11:45:50.878289', '2025-04-27 11:45:50.878289');
INSERT INTO jobs.job_skill VALUES (208, 'CINEMA 4D', '2025-04-27 11:45:51.000068', '2025-04-27 11:45:51.000068');
INSERT INTO jobs.job_skill VALUES (129, 'NETWORKING', '2025-04-27 11:45:50.878289', '2025-04-27 11:45:50.878289');
INSERT INTO jobs.job_skill VALUES (177, 'FRONTEND', '2025-04-27 11:45:50.957412', '2025-04-27 11:45:50.957412');
INSERT INTO jobs.job_skill VALUES (132, 'INDONESIA', '2025-04-27 11:45:50.887681', '2025-04-27 11:45:50.887681');
INSERT INTO jobs.job_skill VALUES (179, 'ANGULAR', '2025-04-27 11:45:50.957412', '2025-04-27 11:45:50.957412');
INSERT INTO jobs.job_skill VALUES (115, 'FULL STACK', '2025-04-27 11:45:50.864455', '2025-04-27 11:45:50.864455');
INSERT INTO jobs.job_skill VALUES (258, 'REACTJS', '2025-04-27 11:45:51.075339', '2025-04-27 11:45:51.075339');
INSERT INTO jobs.job_skill VALUES (242, 'BLOCKCHAIN', '2025-04-27 11:45:51.050492', '2025-04-27 11:45:51.050492');
INSERT INTO jobs.job_skill VALUES (67, 'SOFTWARE ENGINEERING', '2025-04-27 11:20:06.552352', '2025-04-27 11:20:06.552352');
INSERT INTO jobs.job_skill VALUES (140, 'ACCOUNT EXECUTIVE', '2025-04-27 11:45:50.899625', '2025-04-27 11:45:50.899625');
INSERT INTO jobs.job_skill VALUES (221, 'LLMS', '2025-04-27 11:45:51.02238', '2025-04-27 11:45:51.02238');
INSERT INTO jobs.job_skill VALUES (187, 'PROJECT MANAGEMENT', '2025-04-27 11:45:50.970704', '2025-04-27 11:45:50.970704');
INSERT INTO jobs.job_skill VALUES (188, 'SOFTWARE IMPLEMENTATION', '2025-04-27 11:45:50.970704', '2025-04-27 11:45:50.970704');
INSERT INTO jobs.job_skill VALUES (189, 'ELECTRIC UTILITIES', '2025-04-27 11:45:50.970704', '2025-04-27 11:45:50.970704');
INSERT INTO jobs.job_skill VALUES (181, 'UI/UX', '2025-04-27 11:45:50.957412', '2025-04-27 11:45:50.957412');
INSERT INTO jobs.job_skill VALUES (148, 'DISTRIBUTED SYSTEMS', '2025-04-27 11:45:50.913578', '2025-04-27 11:45:50.913578');
INSERT INTO jobs.job_skill VALUES (149, 'OPEN-SOURCE', '2025-04-27 11:45:50.913578', '2025-04-27 11:45:50.913578');
INSERT INTO jobs.job_skill VALUES (150, 'APACHE FLINK', '2025-04-27 11:45:50.913578', '2025-04-27 11:45:50.913578');
INSERT INTO jobs.job_skill VALUES (151, 'PRODUCT DEVELOPMENT', '2025-04-27 11:45:50.919773', '2025-04-27 11:45:50.919773');
INSERT INTO jobs.job_skill VALUES (92, 'ANALYSIS', '2025-04-27 11:45:50.827802', '2025-04-27 11:45:50.827802');
INSERT INTO jobs.job_skill VALUES (121, 'SOFTWARE ENGINEER', '2025-04-27 11:45:50.871311', '2025-04-27 11:45:50.871311');
INSERT INTO jobs.job_skill VALUES (86, 'PYTHON', '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill VALUES (211, 'SWIFT', '2025-04-27 11:45:51.008159', '2025-04-27 11:45:51.008159');
INSERT INTO jobs.job_skill VALUES (190, 'STAKEHOLDER MANAGEMENT', '2025-04-27 11:45:50.970704', '2025-04-27 11:45:50.970704');
INSERT INTO jobs.job_skill VALUES (160, 'DEVSECOPS', '2025-04-27 11:45:50.932954', '2025-04-27 11:45:50.932954');
INSERT INTO jobs.job_skill VALUES (71, 'SAAS', '2025-04-27 11:20:06.552352', '2025-04-27 11:20:06.552352');
INSERT INTO jobs.job_skill VALUES (162, 'PARTNER MANAGEMENT', '2025-04-27 11:45:50.932954', '2025-04-27 11:45:50.932954');
INSERT INTO jobs.job_skill VALUES (139, 'APAC', '2025-04-27 11:45:50.899625', '2025-04-27 11:45:50.899625');
INSERT INTO jobs.job_skill VALUES (87, 'NODE.JS', '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill VALUES (136, 'SALES', '2025-04-27 11:45:50.899625', '2025-04-27 11:45:50.899625');
INSERT INTO jobs.job_skill VALUES (166, 'JAKARTA', '2025-04-27 11:45:50.93968', '2025-04-27 11:45:50.93968');
INSERT INTO jobs.job_skill VALUES (213, 'DEVELOPER', '2025-04-27 11:45:51.008159', '2025-04-27 11:45:51.008159');
INSERT INTO jobs.job_skill VALUES (169, 'EXCEL', '2025-04-27 11:45:50.944709', '2025-04-27 11:45:50.944709');
INSERT INTO jobs.job_skill VALUES (170, 'COMMUNICATION', '2025-04-27 11:45:50.944709', '2025-04-27 11:45:50.944709');
INSERT INTO jobs.job_skill VALUES (171, 'TEAMWORK', '2025-04-27 11:45:50.944709', '2025-04-27 11:45:50.944709');
INSERT INTO jobs.job_skill VALUES (172, 'ENERGY TRANSITION', '2025-04-27 11:45:50.950878', '2025-04-27 11:45:50.950878');
INSERT INTO jobs.job_skill VALUES (173, 'DATA ANALYSIS', '2025-04-27 11:45:50.950878', '2025-04-27 11:45:50.950878');
INSERT INTO jobs.job_skill VALUES (157, 'HTML', '2025-04-27 11:45:50.926455', '2025-04-27 11:45:50.926455');
INSERT INTO jobs.job_skill VALUES (193, 'KUBERNETES', '2025-04-27 11:45:50.978664', '2025-04-27 11:45:50.978664');
INSERT INTO jobs.job_skill VALUES (214, 'SWIFTUI', '2025-04-27 11:45:51.008159', '2025-04-27 11:45:51.008159');
INSERT INTO jobs.job_skill VALUES (196, 'CLOUD', '2025-04-27 11:45:50.978664', '2025-04-27 11:45:50.978664');
INSERT INTO jobs.job_skill VALUES (197, 'LEAD TEST ENGINEER', '2025-04-27 11:45:50.984751', '2025-04-27 11:45:50.984751');
INSERT INTO jobs.job_skill VALUES (198, 'TEST AUTOMATION', '2025-04-27 11:45:50.984751', '2025-04-27 11:45:50.984751');
INSERT INTO jobs.job_skill VALUES (199, 'PRODUCT R&D', '2025-04-27 11:45:50.984751', '2025-04-27 11:45:50.984751');
INSERT INTO jobs.job_skill VALUES (223, 'AUTONOMOUS CODING', '2025-04-27 11:45:51.02238', '2025-04-27 11:45:51.02238');
INSERT INTO jobs.job_skill VALUES (128, 'ENGINEER', '2025-04-27 11:45:50.878289', '2025-04-27 11:45:50.878289');
INSERT INTO jobs.job_skill VALUES (224, 'PROBLEM-SOLVING', '2025-04-27 11:45:51.02238', '2025-04-27 11:45:51.02238');
INSERT INTO jobs.job_skill VALUES (204, 'DATA SCIENCE', '2025-04-27 11:45:50.991469', '2025-04-27 11:45:50.991469');
INSERT INTO jobs.job_skill VALUES (205, '3D DESIGN', '2025-04-27 11:45:51.000068', '2025-04-27 11:45:51.000068');
INSERT INTO jobs.job_skill VALUES (74, 'MOBILE TESTING', '2025-04-27 11:45:20.424709', '2025-04-27 11:45:20.424709');
INSERT INTO jobs.job_skill VALUES (215, 'QA', '2025-04-27 11:45:51.015216', '2025-04-27 11:45:51.015216');
INSERT INTO jobs.job_skill VALUES (210, 'IOS', '2025-04-27 11:45:51.008159', '2025-04-27 11:45:51.008159');
INSERT INTO jobs.job_skill VALUES (93, 'AI', '2025-04-27 11:45:50.827802', '2025-04-27 11:45:50.827802');
INSERT INTO jobs.job_skill VALUES (225, 'DATA ENGINEER', '2025-04-27 11:45:51.029322', '2025-04-27 11:45:51.029322');
INSERT INTO jobs.job_skill VALUES (226, 'APACHE AIRFLOW', '2025-04-27 11:45:51.029322', '2025-04-27 11:45:51.029322');
INSERT INTO jobs.job_skill VALUES (228, 'DATA ENGINEERING', '2025-04-27 11:45:51.029322', '2025-04-27 11:45:51.029322');
INSERT INTO jobs.job_skill VALUES (167, 'PRODUCT MANAGEMENT', '2025-04-27 11:45:50.944709', '2025-04-27 11:45:50.944709');
INSERT INTO jobs.job_skill VALUES (80, 'DATABASE', '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill VALUES (264, 'WORDPRESS', '2025-04-27 11:45:51.082331', '2025-04-27 11:45:51.082331');
INSERT INTO jobs.job_skill VALUES (81, 'SQL', '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill VALUES (235, 'NOSQL', '2025-04-27 11:45:51.037204', '2025-04-27 11:45:51.037204');
INSERT INTO jobs.job_skill VALUES (247, 'TYPESCRIPT', '2025-04-27 11:45:51.061951', '2025-04-27 11:45:51.061951');
INSERT INTO jobs.job_skill VALUES (113, 'SOFTWARE DEVELOPMENT', '2025-04-27 11:45:50.85634', '2025-04-27 11:45:50.85634');
INSERT INTO jobs.job_skill VALUES (147, 'JAVA', '2025-04-27 11:45:50.913578', '2025-04-27 11:45:50.913578');
INSERT INTO jobs.job_skill VALUES (102, 'AZURE', '2025-04-27 11:45:50.842959', '2025-04-27 11:45:50.842959');
INSERT INTO jobs.job_skill VALUES (79, 'PHP', '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill VALUES (256, 'HEALTHCARE', '2025-04-27 11:45:51.069025', '2025-04-27 11:45:51.069025');
INSERT INTO jobs.job_skill VALUES (257, 'NEXTJS', '2025-04-27 11:45:51.075339', '2025-04-27 11:45:51.075339');
INSERT INTO jobs.job_skill VALUES (239, 'CSS', '2025-04-27 11:45:51.043495', '2025-04-27 11:45:51.043495');
INSERT INTO jobs.job_skill VALUES (90, 'JAVASCRIPT', '2025-04-27 11:45:50.820832', '2025-04-27 11:45:50.820832');
INSERT INTO jobs.job_skill VALUES (262, 'PRODUCT DESIGN', '2025-04-27 11:45:51.082331', '2025-04-27 11:45:51.082331');
INSERT INTO jobs.job_skill VALUES (265, 'USER EXPERIENCE', '2025-04-27 11:45:51.082331', '2025-04-27 11:45:51.082331');
INSERT INTO jobs.job_skill VALUES (266, 'DESIGN SYSTEMS', '2025-04-27 11:45:51.082331', '2025-04-27 11:45:51.082331');
INSERT INTO jobs.job_skill VALUES (268, 'LARAVEL', '2025-04-27 11:45:51.088769', '2025-04-27 11:45:51.088769');
INSERT INTO jobs.job_skill VALUES (120, 'FULL-STACK', '2025-04-27 11:45:50.871311', '2025-04-27 11:45:50.871311');
INSERT INTO jobs.job_skill VALUES (152, 'REMOTE WORK', '2025-04-27 11:45:50.919773', '2025-04-27 11:45:50.919773');
INSERT INTO jobs.job_skill VALUES (270, 'WEB DEVELOPMENT', '2025-04-27 11:45:51.088769', '2025-04-27 11:45:51.088769');
INSERT INTO jobs.job_skill VALUES (271, 'SENIOR DEVELOPER', '2025-04-27 11:45:51.088769', '2025-04-27 11:45:51.088769');
INSERT INTO jobs.job_skill VALUES (273, 'TEST-WRITING', '2025-04-27 11:45:51.095172', '2025-04-27 11:45:51.095172');
INSERT INTO jobs.job_skill VALUES (275, 'CYPRESS', '2025-04-27 11:45:51.095172', '2025-04-27 11:45:51.095172');
INSERT INTO jobs.job_skill VALUES (276, 'SELENIUM', '2025-04-27 11:45:51.095172', '2025-04-27 11:45:51.095172');
INSERT INTO jobs.job_skill VALUES (278, 'QUANTITATIVE ANALYSIS', '2025-04-27 11:45:51.101642', '2025-04-27 11:45:51.101642');
INSERT INTO jobs.job_skill VALUES (279, 'STRATEGY', '2025-04-27 11:45:51.101642', '2025-04-27 11:45:51.101642');
INSERT INTO jobs.job_skill VALUES (280, 'TECHNOLOGY', '2025-04-27 11:45:51.101642', '2025-04-27 11:45:51.101642');
INSERT INTO jobs.job_skill VALUES (281, 'GROWTH MINDSET', '2025-04-27 11:45:51.101642', '2025-04-27 11:45:51.101642');
INSERT INTO jobs.job_skill VALUES (283, 'PLATFORM ENGINEERING', '2025-04-27 11:45:51.107939', '2025-04-27 11:45:51.107939');
INSERT INTO jobs.job_skill VALUES (101, 'AWS', '2025-04-27 11:45:50.842959', '2025-04-27 11:45:50.842959');
INSERT INTO jobs.job_skill VALUES (285, 'CLOUD-NATIVE', '2025-04-27 11:45:51.107939', '2025-04-27 11:45:51.107939');
INSERT INTO jobs.job_skill VALUES (286, 'SECURITY', '2025-04-27 11:45:51.107939', '2025-04-27 11:45:51.107939');
INSERT INTO jobs.job_skill VALUES (288, 'WEB3', '2025-04-27 11:45:51.114504', '2025-04-27 11:45:51.114504');
INSERT INTO jobs.job_skill VALUES (291, 'DESIGN', '2025-04-27 11:45:51.114504', '2025-04-27 11:45:51.114504');
INSERT INTO jobs.job_skill VALUES (119, 'REMOTE', '2025-04-27 11:45:50.864455', '2025-04-27 11:45:50.864455');
INSERT INTO jobs.job_skill VALUES (296, 'QUALITY ASSURANCE', '2025-04-27 11:45:51.120838', '2025-04-27 11:45:51.120838');


--
-- TOC entry 5226 (class 0 OID 18880)
-- Dependencies: 256
-- Data for Name: job_skill_map; Type: TABLE DATA; Schema: jobs; Owner: -
--

INSERT INTO jobs.job_skill_map VALUES (56, 19, 67, '2025-04-27 11:20:06.552352', '2025-04-27 11:20:06.552352');
INSERT INTO jobs.job_skill_map VALUES (57, 19, 68, '2025-04-27 11:20:06.552352', '2025-04-27 11:20:06.552352');
INSERT INTO jobs.job_skill_map VALUES (58, 19, 69, '2025-04-27 11:20:06.552352', '2025-04-27 11:20:06.552352');
INSERT INTO jobs.job_skill_map VALUES (59, 19, 70, '2025-04-27 11:20:06.552352', '2025-04-27 11:20:06.552352');
INSERT INTO jobs.job_skill_map VALUES (60, 19, 71, '2025-04-27 11:20:06.552352', '2025-04-27 11:20:06.552352');
INSERT INTO jobs.job_skill_map VALUES (61, 21, 72, '2025-04-27 11:45:20.424709', '2025-04-27 11:45:20.424709');
INSERT INTO jobs.job_skill_map VALUES (62, 21, 73, '2025-04-27 11:45:20.424709', '2025-04-27 11:45:20.424709');
INSERT INTO jobs.job_skill_map VALUES (63, 21, 74, '2025-04-27 11:45:20.424709', '2025-04-27 11:45:20.424709');
INSERT INTO jobs.job_skill_map VALUES (64, 21, 75, '2025-04-27 11:45:20.424709', '2025-04-27 11:45:20.424709');
INSERT INTO jobs.job_skill_map VALUES (65, 22, 76, '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill_map VALUES (66, 22, 77, '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill_map VALUES (67, 22, 78, '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill_map VALUES (68, 22, 79, '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill_map VALUES (69, 22, 80, '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill_map VALUES (70, 22, 81, '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill_map VALUES (71, 22, 82, '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill_map VALUES (72, 22, 83, '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill_map VALUES (73, 22, 84, '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill_map VALUES (74, 22, 85, '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill_map VALUES (75, 22, 86, '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill_map VALUES (76, 22, 87, '2025-04-27 11:45:50.787684', '2025-04-27 11:45:50.787684');
INSERT INTO jobs.job_skill_map VALUES (77, 23, 88, '2025-04-27 11:45:50.820832', '2025-04-27 11:45:50.820832');
INSERT INTO jobs.job_skill_map VALUES (78, 23, 86, '2025-04-27 11:45:50.820832', '2025-04-27 11:45:50.820832');
INSERT INTO jobs.job_skill_map VALUES (79, 23, 90, '2025-04-27 11:45:50.820832', '2025-04-27 11:45:50.820832');
INSERT INTO jobs.job_skill_map VALUES (80, 24, 91, '2025-04-27 11:45:50.827802', '2025-04-27 11:45:50.827802');
INSERT INTO jobs.job_skill_map VALUES (81, 24, 92, '2025-04-27 11:45:50.827802', '2025-04-27 11:45:50.827802');
INSERT INTO jobs.job_skill_map VALUES (82, 24, 93, '2025-04-27 11:45:50.827802', '2025-04-27 11:45:50.827802');
INSERT INTO jobs.job_skill_map VALUES (83, 24, 94, '2025-04-27 11:45:50.827802', '2025-04-27 11:45:50.827802');
INSERT INTO jobs.job_skill_map VALUES (84, 24, 95, '2025-04-27 11:45:50.827802', '2025-04-27 11:45:50.827802');
INSERT INTO jobs.job_skill_map VALUES (85, 25, 96, '2025-04-27 11:45:50.83604', '2025-04-27 11:45:50.83604');
INSERT INTO jobs.job_skill_map VALUES (86, 25, 97, '2025-04-27 11:45:50.83604', '2025-04-27 11:45:50.83604');
INSERT INTO jobs.job_skill_map VALUES (87, 25, 98, '2025-04-27 11:45:50.83604', '2025-04-27 11:45:50.83604');
INSERT INTO jobs.job_skill_map VALUES (88, 25, 99, '2025-04-27 11:45:50.83604', '2025-04-27 11:45:50.83604');
INSERT INTO jobs.job_skill_map VALUES (89, 26, 100, '2025-04-27 11:45:50.842959', '2025-04-27 11:45:50.842959');
INSERT INTO jobs.job_skill_map VALUES (90, 26, 101, '2025-04-27 11:45:50.842959', '2025-04-27 11:45:50.842959');
INSERT INTO jobs.job_skill_map VALUES (91, 26, 102, '2025-04-27 11:45:50.842959', '2025-04-27 11:45:50.842959');
INSERT INTO jobs.job_skill_map VALUES (92, 26, 103, '2025-04-27 11:45:50.842959', '2025-04-27 11:45:50.842959');
INSERT INTO jobs.job_skill_map VALUES (93, 26, 104, '2025-04-27 11:45:50.842959', '2025-04-27 11:45:50.842959');
INSERT INTO jobs.job_skill_map VALUES (94, 26, 86, '2025-04-27 11:45:50.842959', '2025-04-27 11:45:50.842959');
INSERT INTO jobs.job_skill_map VALUES (95, 27, 106, '2025-04-27 11:45:50.849438', '2025-04-27 11:45:50.849438');
INSERT INTO jobs.job_skill_map VALUES (96, 27, 98, '2025-04-27 11:45:50.849438', '2025-04-27 11:45:50.849438');
INSERT INTO jobs.job_skill_map VALUES (97, 27, 86, '2025-04-27 11:45:50.849438', '2025-04-27 11:45:50.849438');
INSERT INTO jobs.job_skill_map VALUES (98, 27, 90, '2025-04-27 11:45:50.849438', '2025-04-27 11:45:50.849438');
INSERT INTO jobs.job_skill_map VALUES (99, 28, 110, '2025-04-27 11:45:50.85634', '2025-04-27 11:45:50.85634');
INSERT INTO jobs.job_skill_map VALUES (100, 28, 93, '2025-04-27 11:45:50.85634', '2025-04-27 11:45:50.85634');
INSERT INTO jobs.job_skill_map VALUES (101, 28, 112, '2025-04-27 11:45:50.85634', '2025-04-27 11:45:50.85634');
INSERT INTO jobs.job_skill_map VALUES (102, 28, 113, '2025-04-27 11:45:50.85634', '2025-04-27 11:45:50.85634');
INSERT INTO jobs.job_skill_map VALUES (103, 28, 114, '2025-04-27 11:45:50.85634', '2025-04-27 11:45:50.85634');
INSERT INTO jobs.job_skill_map VALUES (104, 29, 115, '2025-04-27 11:45:50.864455', '2025-04-27 11:45:50.864455');
INSERT INTO jobs.job_skill_map VALUES (105, 29, 93, '2025-04-27 11:45:50.864455', '2025-04-27 11:45:50.864455');
INSERT INTO jobs.job_skill_map VALUES (106, 29, 112, '2025-04-27 11:45:50.864455', '2025-04-27 11:45:50.864455');
INSERT INTO jobs.job_skill_map VALUES (107, 29, 113, '2025-04-27 11:45:50.864455', '2025-04-27 11:45:50.864455');
INSERT INTO jobs.job_skill_map VALUES (108, 29, 119, '2025-04-27 11:45:50.864455', '2025-04-27 11:45:50.864455');
INSERT INTO jobs.job_skill_map VALUES (109, 30, 120, '2025-04-27 11:45:50.871311', '2025-04-27 11:45:50.871311');
INSERT INTO jobs.job_skill_map VALUES (110, 30, 121, '2025-04-27 11:45:50.871311', '2025-04-27 11:45:50.871311');
INSERT INTO jobs.job_skill_map VALUES (111, 30, 119, '2025-04-27 11:45:50.871311', '2025-04-27 11:45:50.871311');
INSERT INTO jobs.job_skill_map VALUES (112, 30, 123, '2025-04-27 11:45:50.871311', '2025-04-27 11:45:50.871311');
INSERT INTO jobs.job_skill_map VALUES (113, 30, 124, '2025-04-27 11:45:50.871311', '2025-04-27 11:45:50.871311');
INSERT INTO jobs.job_skill_map VALUES (114, 31, 125, '2025-04-27 11:45:50.878289', '2025-04-27 11:45:50.878289');
INSERT INTO jobs.job_skill_map VALUES (115, 31, 126, '2025-04-27 11:45:50.878289', '2025-04-27 11:45:50.878289');
INSERT INTO jobs.job_skill_map VALUES (116, 31, 119, '2025-04-27 11:45:50.878289', '2025-04-27 11:45:50.878289');
INSERT INTO jobs.job_skill_map VALUES (117, 31, 128, '2025-04-27 11:45:50.878289', '2025-04-27 11:45:50.878289');
INSERT INTO jobs.job_skill_map VALUES (118, 31, 129, '2025-04-27 11:45:50.878289', '2025-04-27 11:45:50.878289');
INSERT INTO jobs.job_skill_map VALUES (119, 32, 119, '2025-04-27 11:45:50.887681', '2025-04-27 11:45:50.887681');
INSERT INTO jobs.job_skill_map VALUES (120, 32, 128, '2025-04-27 11:45:50.887681', '2025-04-27 11:45:50.887681');
INSERT INTO jobs.job_skill_map VALUES (121, 32, 132, '2025-04-27 11:45:50.887681', '2025-04-27 11:45:50.887681');
INSERT INTO jobs.job_skill_map VALUES (122, 33, 119, '2025-04-27 11:45:50.89388', '2025-04-27 11:45:50.89388');
INSERT INTO jobs.job_skill_map VALUES (123, 33, 128, '2025-04-27 11:45:50.89388', '2025-04-27 11:45:50.89388');
INSERT INTO jobs.job_skill_map VALUES (124, 33, 80, '2025-04-27 11:45:50.89388', '2025-04-27 11:45:50.89388');
INSERT INTO jobs.job_skill_map VALUES (125, 34, 136, '2025-04-27 11:45:50.899625', '2025-04-27 11:45:50.899625');
INSERT INTO jobs.job_skill_map VALUES (126, 34, 71, '2025-04-27 11:45:50.899625', '2025-04-27 11:45:50.899625');
INSERT INTO jobs.job_skill_map VALUES (127, 34, 119, '2025-04-27 11:45:50.899625', '2025-04-27 11:45:50.899625');
INSERT INTO jobs.job_skill_map VALUES (128, 34, 139, '2025-04-27 11:45:50.899625', '2025-04-27 11:45:50.899625');
INSERT INTO jobs.job_skill_map VALUES (129, 34, 140, '2025-04-27 11:45:50.899625', '2025-04-27 11:45:50.899625');
INSERT INTO jobs.job_skill_map VALUES (130, 35, 140, '2025-04-27 11:45:50.906654', '2025-04-27 11:45:50.906654');
INSERT INTO jobs.job_skill_map VALUES (131, 35, 119, '2025-04-27 11:45:50.906654', '2025-04-27 11:45:50.906654');
INSERT INTO jobs.job_skill_map VALUES (132, 35, 136, '2025-04-27 11:45:50.906654', '2025-04-27 11:45:50.906654');
INSERT INTO jobs.job_skill_map VALUES (133, 35, 71, '2025-04-27 11:45:50.906654', '2025-04-27 11:45:50.906654');
INSERT INTO jobs.job_skill_map VALUES (134, 35, 139, '2025-04-27 11:45:50.906654', '2025-04-27 11:45:50.906654');
INSERT INTO jobs.job_skill_map VALUES (135, 36, 67, '2025-04-27 11:45:50.913578', '2025-04-27 11:45:50.913578');
INSERT INTO jobs.job_skill_map VALUES (136, 36, 147, '2025-04-27 11:45:50.913578', '2025-04-27 11:45:50.913578');
INSERT INTO jobs.job_skill_map VALUES (137, 36, 148, '2025-04-27 11:45:50.913578', '2025-04-27 11:45:50.913578');
INSERT INTO jobs.job_skill_map VALUES (138, 36, 149, '2025-04-27 11:45:50.913578', '2025-04-27 11:45:50.913578');
INSERT INTO jobs.job_skill_map VALUES (139, 36, 150, '2025-04-27 11:45:50.913578', '2025-04-27 11:45:50.913578');
INSERT INTO jobs.job_skill_map VALUES (140, 37, 151, '2025-04-27 11:45:50.919773', '2025-04-27 11:45:50.919773');
INSERT INTO jobs.job_skill_map VALUES (141, 37, 152, '2025-04-27 11:45:50.919773', '2025-04-27 11:45:50.919773');
INSERT INTO jobs.job_skill_map VALUES (142, 37, 92, '2025-04-27 11:45:50.919773', '2025-04-27 11:45:50.919773');
INSERT INTO jobs.job_skill_map VALUES (143, 38, 121, '2025-04-27 11:45:50.926455', '2025-04-27 11:45:50.926455');
INSERT INTO jobs.job_skill_map VALUES (144, 38, 87, '2025-04-27 11:45:50.926455', '2025-04-27 11:45:50.926455');
INSERT INTO jobs.job_skill_map VALUES (145, 38, 86, '2025-04-27 11:45:50.926455', '2025-04-27 11:45:50.926455');
INSERT INTO jobs.job_skill_map VALUES (146, 38, 157, '2025-04-27 11:45:50.926455', '2025-04-27 11:45:50.926455');
INSERT INTO jobs.job_skill_map VALUES (147, 38, 90, '2025-04-27 11:45:50.926455', '2025-04-27 11:45:50.926455');
INSERT INTO jobs.job_skill_map VALUES (148, 39, 119, '2025-04-27 11:45:50.932954', '2025-04-27 11:45:50.932954');
INSERT INTO jobs.job_skill_map VALUES (149, 39, 160, '2025-04-27 11:45:50.932954', '2025-04-27 11:45:50.932954');
INSERT INTO jobs.job_skill_map VALUES (150, 39, 71, '2025-04-27 11:45:50.932954', '2025-04-27 11:45:50.932954');
INSERT INTO jobs.job_skill_map VALUES (151, 39, 162, '2025-04-27 11:45:50.932954', '2025-04-27 11:45:50.932954');
INSERT INTO jobs.job_skill_map VALUES (152, 39, 139, '2025-04-27 11:45:50.932954', '2025-04-27 11:45:50.932954');
INSERT INTO jobs.job_skill_map VALUES (153, 40, 119, '2025-04-27 11:45:50.93968', '2025-04-27 11:45:50.93968');
INSERT INTO jobs.job_skill_map VALUES (154, 40, 136, '2025-04-27 11:45:50.93968', '2025-04-27 11:45:50.93968');
INSERT INTO jobs.job_skill_map VALUES (155, 40, 166, '2025-04-27 11:45:50.93968', '2025-04-27 11:45:50.93968');
INSERT INTO jobs.job_skill_map VALUES (156, 41, 167, '2025-04-27 11:45:50.944709', '2025-04-27 11:45:50.944709');
INSERT INTO jobs.job_skill_map VALUES (157, 41, 119, '2025-04-27 11:45:50.944709', '2025-04-27 11:45:50.944709');
INSERT INTO jobs.job_skill_map VALUES (158, 41, 169, '2025-04-27 11:45:50.944709', '2025-04-27 11:45:50.944709');
INSERT INTO jobs.job_skill_map VALUES (159, 41, 170, '2025-04-27 11:45:50.944709', '2025-04-27 11:45:50.944709');
INSERT INTO jobs.job_skill_map VALUES (160, 41, 171, '2025-04-27 11:45:50.944709', '2025-04-27 11:45:50.944709');
INSERT INTO jobs.job_skill_map VALUES (161, 42, 172, '2025-04-27 11:45:50.950878', '2025-04-27 11:45:50.950878');
INSERT INTO jobs.job_skill_map VALUES (162, 42, 173, '2025-04-27 11:45:50.950878', '2025-04-27 11:45:50.950878');
INSERT INTO jobs.job_skill_map VALUES (163, 42, 174, '2025-04-27 11:45:50.950878', '2025-04-27 11:45:50.950878');
INSERT INTO jobs.job_skill_map VALUES (164, 42, 175, '2025-04-27 11:45:50.950878', '2025-04-27 11:45:50.950878');
INSERT INTO jobs.job_skill_map VALUES (165, 42, 176, '2025-04-27 11:45:50.950878', '2025-04-27 11:45:50.950878');
INSERT INTO jobs.job_skill_map VALUES (166, 43, 177, '2025-04-27 11:45:50.957412', '2025-04-27 11:45:50.957412');
INSERT INTO jobs.job_skill_map VALUES (167, 43, 90, '2025-04-27 11:45:50.957412', '2025-04-27 11:45:50.957412');
INSERT INTO jobs.job_skill_map VALUES (168, 43, 179, '2025-04-27 11:45:50.957412', '2025-04-27 11:45:50.957412');
INSERT INTO jobs.job_skill_map VALUES (169, 43, 119, '2025-04-27 11:45:50.957412', '2025-04-27 11:45:50.957412');
INSERT INTO jobs.job_skill_map VALUES (170, 43, 181, '2025-04-27 11:45:50.957412', '2025-04-27 11:45:50.957412');
INSERT INTO jobs.job_skill_map VALUES (171, 44, 177, '2025-04-27 11:45:50.963837', '2025-04-27 11:45:50.963837');
INSERT INTO jobs.job_skill_map VALUES (172, 44, 179, '2025-04-27 11:45:50.963837', '2025-04-27 11:45:50.963837');
INSERT INTO jobs.job_skill_map VALUES (173, 44, 90, '2025-04-27 11:45:50.963837', '2025-04-27 11:45:50.963837');
INSERT INTO jobs.job_skill_map VALUES (174, 44, 181, '2025-04-27 11:45:50.963837', '2025-04-27 11:45:50.963837');
INSERT INTO jobs.job_skill_map VALUES (175, 44, 119, '2025-04-27 11:45:50.963837', '2025-04-27 11:45:50.963837');
INSERT INTO jobs.job_skill_map VALUES (176, 45, 187, '2025-04-27 11:45:50.970704', '2025-04-27 11:45:50.970704');
INSERT INTO jobs.job_skill_map VALUES (177, 45, 188, '2025-04-27 11:45:50.970704', '2025-04-27 11:45:50.970704');
INSERT INTO jobs.job_skill_map VALUES (178, 45, 189, '2025-04-27 11:45:50.970704', '2025-04-27 11:45:50.970704');
INSERT INTO jobs.job_skill_map VALUES (179, 45, 190, '2025-04-27 11:45:50.970704', '2025-04-27 11:45:50.970704');
INSERT INTO jobs.job_skill_map VALUES (180, 45, 152, '2025-04-27 11:45:50.970704', '2025-04-27 11:45:50.970704');
INSERT INTO jobs.job_skill_map VALUES (181, 46, 147, '2025-04-27 11:45:50.978664', '2025-04-27 11:45:50.978664');
INSERT INTO jobs.job_skill_map VALUES (182, 46, 193, '2025-04-27 11:45:50.978664', '2025-04-27 11:45:50.978664');
INSERT INTO jobs.job_skill_map VALUES (183, 46, 113, '2025-04-27 11:45:50.978664', '2025-04-27 11:45:50.978664');
INSERT INTO jobs.job_skill_map VALUES (184, 46, 119, '2025-04-27 11:45:50.978664', '2025-04-27 11:45:50.978664');
INSERT INTO jobs.job_skill_map VALUES (185, 46, 196, '2025-04-27 11:45:50.978664', '2025-04-27 11:45:50.978664');
INSERT INTO jobs.job_skill_map VALUES (186, 47, 197, '2025-04-27 11:45:50.984751', '2025-04-27 11:45:50.984751');
INSERT INTO jobs.job_skill_map VALUES (187, 47, 198, '2025-04-27 11:45:50.984751', '2025-04-27 11:45:50.984751');
INSERT INTO jobs.job_skill_map VALUES (188, 47, 199, '2025-04-27 11:45:50.984751', '2025-04-27 11:45:50.984751');
INSERT INTO jobs.job_skill_map VALUES (189, 47, 152, '2025-04-27 11:45:50.984751', '2025-04-27 11:45:50.984751');
INSERT INTO jobs.job_skill_map VALUES (190, 47, 113, '2025-04-27 11:45:50.984751', '2025-04-27 11:45:50.984751');
INSERT INTO jobs.job_skill_map VALUES (191, 48, 86, '2025-04-27 11:45:50.991469', '2025-04-27 11:45:50.991469');
INSERT INTO jobs.job_skill_map VALUES (192, 48, 119, '2025-04-27 11:45:50.991469', '2025-04-27 11:45:50.991469');
INSERT INTO jobs.job_skill_map VALUES (193, 48, 204, '2025-04-27 11:45:50.991469', '2025-04-27 11:45:50.991469');
INSERT INTO jobs.job_skill_map VALUES (194, 49, 205, '2025-04-27 11:45:51.000068', '2025-04-27 11:45:51.000068');
INSERT INTO jobs.job_skill_map VALUES (195, 49, 206, '2025-04-27 11:45:51.000068', '2025-04-27 11:45:51.000068');
INSERT INTO jobs.job_skill_map VALUES (196, 49, 207, '2025-04-27 11:45:51.000068', '2025-04-27 11:45:51.000068');
INSERT INTO jobs.job_skill_map VALUES (197, 49, 208, '2025-04-27 11:45:51.000068', '2025-04-27 11:45:51.000068');
INSERT INTO jobs.job_skill_map VALUES (198, 49, 152, '2025-04-27 11:45:51.000068', '2025-04-27 11:45:51.000068');
INSERT INTO jobs.job_skill_map VALUES (199, 50, 210, '2025-04-27 11:45:51.008159', '2025-04-27 11:45:51.008159');
INSERT INTO jobs.job_skill_map VALUES (200, 50, 211, '2025-04-27 11:45:51.008159', '2025-04-27 11:45:51.008159');
INSERT INTO jobs.job_skill_map VALUES (201, 50, 119, '2025-04-27 11:45:51.008159', '2025-04-27 11:45:51.008159');
INSERT INTO jobs.job_skill_map VALUES (202, 50, 213, '2025-04-27 11:45:51.008159', '2025-04-27 11:45:51.008159');
INSERT INTO jobs.job_skill_map VALUES (203, 50, 214, '2025-04-27 11:45:51.008159', '2025-04-27 11:45:51.008159');
INSERT INTO jobs.job_skill_map VALUES (204, 51, 215, '2025-04-27 11:45:51.015216', '2025-04-27 11:45:51.015216');
INSERT INTO jobs.job_skill_map VALUES (205, 51, 74, '2025-04-27 11:45:51.015216', '2025-04-27 11:45:51.015216');
INSERT INTO jobs.job_skill_map VALUES (206, 51, 152, '2025-04-27 11:45:51.015216', '2025-04-27 11:45:51.015216');
INSERT INTO jobs.job_skill_map VALUES (207, 51, 210, '2025-04-27 11:45:51.015216', '2025-04-27 11:45:51.015216');
INSERT INTO jobs.job_skill_map VALUES (208, 51, 113, '2025-04-27 11:45:51.015216', '2025-04-27 11:45:51.015216');
INSERT INTO jobs.job_skill_map VALUES (209, 52, 93, '2025-04-27 11:45:51.02238', '2025-04-27 11:45:51.02238');
INSERT INTO jobs.job_skill_map VALUES (210, 52, 221, '2025-04-27 11:45:51.02238', '2025-04-27 11:45:51.02238');
INSERT INTO jobs.job_skill_map VALUES (211, 52, 120, '2025-04-27 11:45:51.02238', '2025-04-27 11:45:51.02238');
INSERT INTO jobs.job_skill_map VALUES (212, 52, 223, '2025-04-27 11:45:51.02238', '2025-04-27 11:45:51.02238');
INSERT INTO jobs.job_skill_map VALUES (213, 52, 224, '2025-04-27 11:45:51.02238', '2025-04-27 11:45:51.02238');
INSERT INTO jobs.job_skill_map VALUES (214, 53, 225, '2025-04-27 11:45:51.029322', '2025-04-27 11:45:51.029322');
INSERT INTO jobs.job_skill_map VALUES (215, 53, 226, '2025-04-27 11:45:51.029322', '2025-04-27 11:45:51.029322');
INSERT INTO jobs.job_skill_map VALUES (216, 53, 101, '2025-04-27 11:45:51.029322', '2025-04-27 11:45:51.029322');
INSERT INTO jobs.job_skill_map VALUES (217, 53, 228, '2025-04-27 11:45:51.029322', '2025-04-27 11:45:51.029322');
INSERT INTO jobs.job_skill_map VALUES (218, 53, 119, '2025-04-27 11:45:51.029322', '2025-04-27 11:45:51.029322');
INSERT INTO jobs.job_skill_map VALUES (219, 53, 80, '2025-04-27 11:45:51.029322', '2025-04-27 11:45:51.029322');
INSERT INTO jobs.job_skill_map VALUES (220, 53, 81, '2025-04-27 11:45:51.029322', '2025-04-27 11:45:51.029322');
INSERT INTO jobs.job_skill_map VALUES (221, 54, 87, '2025-04-27 11:45:51.037204', '2025-04-27 11:45:51.037204');
INSERT INTO jobs.job_skill_map VALUES (222, 54, 119, '2025-04-27 11:45:51.037204', '2025-04-27 11:45:51.037204');
INSERT INTO jobs.job_skill_map VALUES (223, 54, 81, '2025-04-27 11:45:51.037204', '2025-04-27 11:45:51.037204');
INSERT INTO jobs.job_skill_map VALUES (224, 54, 235, '2025-04-27 11:45:51.037204', '2025-04-27 11:45:51.037204');
INSERT INTO jobs.job_skill_map VALUES (225, 55, 86, '2025-04-27 11:45:51.043495', '2025-04-27 11:45:51.043495');
INSERT INTO jobs.job_skill_map VALUES (226, 55, 90, '2025-04-27 11:45:51.043495', '2025-04-27 11:45:51.043495');
INSERT INTO jobs.job_skill_map VALUES (227, 55, 157, '2025-04-27 11:45:51.043495', '2025-04-27 11:45:51.043495');
INSERT INTO jobs.job_skill_map VALUES (228, 55, 239, '2025-04-27 11:45:51.043495', '2025-04-27 11:45:51.043495');
INSERT INTO jobs.job_skill_map VALUES (229, 55, 101, '2025-04-27 11:45:51.043495', '2025-04-27 11:45:51.043495');
INSERT INTO jobs.job_skill_map VALUES (230, 56, 97, '2025-04-27 11:45:51.050492', '2025-04-27 11:45:51.050492');
INSERT INTO jobs.job_skill_map VALUES (231, 56, 242, '2025-04-27 11:45:51.050492', '2025-04-27 11:45:51.050492');
INSERT INTO jobs.job_skill_map VALUES (232, 56, 119, '2025-04-27 11:45:51.050492', '2025-04-27 11:45:51.050492');
INSERT INTO jobs.job_skill_map VALUES (233, 57, 87, '2025-04-27 11:45:51.056422', '2025-04-27 11:45:51.056422');
INSERT INTO jobs.job_skill_map VALUES (234, 57, 113, '2025-04-27 11:45:51.056422', '2025-04-27 11:45:51.056422');
INSERT INTO jobs.job_skill_map VALUES (235, 57, 119, '2025-04-27 11:45:51.056422', '2025-04-27 11:45:51.056422');
INSERT INTO jobs.job_skill_map VALUES (236, 58, 247, '2025-04-27 11:45:51.061951', '2025-04-27 11:45:51.061951');
INSERT INTO jobs.job_skill_map VALUES (237, 58, 119, '2025-04-27 11:45:51.061951', '2025-04-27 11:45:51.061951');
INSERT INTO jobs.job_skill_map VALUES (238, 58, 128, '2025-04-27 11:45:51.061951', '2025-04-27 11:45:51.061951');
INSERT INTO jobs.job_skill_map VALUES (239, 58, 101, '2025-04-27 11:45:51.061951', '2025-04-27 11:45:51.061951');
INSERT INTO jobs.job_skill_map VALUES (240, 58, 102, '2025-04-27 11:45:51.061951', '2025-04-27 11:45:51.061951');
INSERT INTO jobs.job_skill_map VALUES (241, 59, 115, '2025-04-27 11:45:51.069025', '2025-04-27 11:45:51.069025');
INSERT INTO jobs.job_skill_map VALUES (242, 59, 247, '2025-04-27 11:45:51.069025', '2025-04-27 11:45:51.069025');
INSERT INTO jobs.job_skill_map VALUES (243, 59, 147, '2025-04-27 11:45:51.069025', '2025-04-27 11:45:51.069025');
INSERT INTO jobs.job_skill_map VALUES (244, 59, 119, '2025-04-27 11:45:51.069025', '2025-04-27 11:45:51.069025');
INSERT INTO jobs.job_skill_map VALUES (245, 59, 256, '2025-04-27 11:45:51.069025', '2025-04-27 11:45:51.069025');
INSERT INTO jobs.job_skill_map VALUES (246, 60, 257, '2025-04-27 11:45:51.075339', '2025-04-27 11:45:51.075339');
INSERT INTO jobs.job_skill_map VALUES (247, 60, 258, '2025-04-27 11:45:51.075339', '2025-04-27 11:45:51.075339');
INSERT INTO jobs.job_skill_map VALUES (248, 60, 157, '2025-04-27 11:45:51.075339', '2025-04-27 11:45:51.075339');
INSERT INTO jobs.job_skill_map VALUES (249, 60, 239, '2025-04-27 11:45:51.075339', '2025-04-27 11:45:51.075339');
INSERT INTO jobs.job_skill_map VALUES (250, 60, 90, '2025-04-27 11:45:51.075339', '2025-04-27 11:45:51.075339');
INSERT INTO jobs.job_skill_map VALUES (251, 61, 262, '2025-04-27 11:45:51.082331', '2025-04-27 11:45:51.082331');
INSERT INTO jobs.job_skill_map VALUES (252, 61, 119, '2025-04-27 11:45:51.082331', '2025-04-27 11:45:51.082331');
INSERT INTO jobs.job_skill_map VALUES (253, 61, 264, '2025-04-27 11:45:51.082331', '2025-04-27 11:45:51.082331');
INSERT INTO jobs.job_skill_map VALUES (254, 61, 265, '2025-04-27 11:45:51.082331', '2025-04-27 11:45:51.082331');
INSERT INTO jobs.job_skill_map VALUES (255, 61, 266, '2025-04-27 11:45:51.082331', '2025-04-27 11:45:51.082331');
INSERT INTO jobs.job_skill_map VALUES (256, 62, 79, '2025-04-27 11:45:51.088769', '2025-04-27 11:45:51.088769');
INSERT INTO jobs.job_skill_map VALUES (257, 62, 268, '2025-04-27 11:45:51.088769', '2025-04-27 11:45:51.088769');
INSERT INTO jobs.job_skill_map VALUES (258, 62, 152, '2025-04-27 11:45:51.088769', '2025-04-27 11:45:51.088769');
INSERT INTO jobs.job_skill_map VALUES (259, 62, 270, '2025-04-27 11:45:51.088769', '2025-04-27 11:45:51.088769');
INSERT INTO jobs.job_skill_map VALUES (260, 62, 271, '2025-04-27 11:45:51.088769', '2025-04-27 11:45:51.088769');
INSERT INTO jobs.job_skill_map VALUES (261, 63, 215, '2025-04-27 11:45:51.095172', '2025-04-27 11:45:51.095172');
INSERT INTO jobs.job_skill_map VALUES (262, 63, 273, '2025-04-27 11:45:51.095172', '2025-04-27 11:45:51.095172');
INSERT INTO jobs.job_skill_map VALUES (263, 63, 119, '2025-04-27 11:45:51.095172', '2025-04-27 11:45:51.095172');
INSERT INTO jobs.job_skill_map VALUES (264, 63, 275, '2025-04-27 11:45:51.095172', '2025-04-27 11:45:51.095172');
INSERT INTO jobs.job_skill_map VALUES (265, 63, 276, '2025-04-27 11:45:51.095172', '2025-04-27 11:45:51.095172');
INSERT INTO jobs.job_skill_map VALUES (266, 64, 167, '2025-04-27 11:45:51.101642', '2025-04-27 11:45:51.101642');
INSERT INTO jobs.job_skill_map VALUES (267, 64, 278, '2025-04-27 11:45:51.101642', '2025-04-27 11:45:51.101642');
INSERT INTO jobs.job_skill_map VALUES (268, 64, 279, '2025-04-27 11:45:51.101642', '2025-04-27 11:45:51.101642');
INSERT INTO jobs.job_skill_map VALUES (269, 64, 280, '2025-04-27 11:45:51.101642', '2025-04-27 11:45:51.101642');
INSERT INTO jobs.job_skill_map VALUES (270, 64, 281, '2025-04-27 11:45:51.101642', '2025-04-27 11:45:51.101642');
INSERT INTO jobs.job_skill_map VALUES (271, 65, 67, '2025-04-27 11:45:51.107939', '2025-04-27 11:45:51.107939');
INSERT INTO jobs.job_skill_map VALUES (272, 65, 283, '2025-04-27 11:45:51.107939', '2025-04-27 11:45:51.107939');
INSERT INTO jobs.job_skill_map VALUES (273, 65, 101, '2025-04-27 11:45:51.107939', '2025-04-27 11:45:51.107939');
INSERT INTO jobs.job_skill_map VALUES (274, 65, 285, '2025-04-27 11:45:51.107939', '2025-04-27 11:45:51.107939');
INSERT INTO jobs.job_skill_map VALUES (275, 65, 286, '2025-04-27 11:45:51.107939', '2025-04-27 11:45:51.107939');
INSERT INTO jobs.job_skill_map VALUES (276, 66, 181, '2025-04-27 11:45:51.114504', '2025-04-27 11:45:51.114504');
INSERT INTO jobs.job_skill_map VALUES (277, 66, 288, '2025-04-27 11:45:51.114504', '2025-04-27 11:45:51.114504');
INSERT INTO jobs.job_skill_map VALUES (278, 66, 93, '2025-04-27 11:45:51.114504', '2025-04-27 11:45:51.114504');
INSERT INTO jobs.job_skill_map VALUES (279, 66, 119, '2025-04-27 11:45:51.114504', '2025-04-27 11:45:51.114504');
INSERT INTO jobs.job_skill_map VALUES (280, 66, 291, '2025-04-27 11:45:51.114504', '2025-04-27 11:45:51.114504');
INSERT INTO jobs.job_skill_map VALUES (281, 67, 119, '2025-04-27 11:45:51.120838', '2025-04-27 11:45:51.120838');
INSERT INTO jobs.job_skill_map VALUES (282, 67, 67, '2025-04-27 11:45:51.120838', '2025-04-27 11:45:51.120838');
INSERT INTO jobs.job_skill_map VALUES (283, 67, 93, '2025-04-27 11:45:51.120838', '2025-04-27 11:45:51.120838');
INSERT INTO jobs.job_skill_map VALUES (284, 67, 120, '2025-04-27 11:45:51.120838', '2025-04-27 11:45:51.120838');
INSERT INTO jobs.job_skill_map VALUES (285, 67, 296, '2025-04-27 11:45:51.120838', '2025-04-27 11:45:51.120838');
INSERT INTO jobs.job_skill_map VALUES (286, 68, 119, '2025-04-27 11:45:51.127081', '2025-04-27 11:45:51.127081');
INSERT INTO jobs.job_skill_map VALUES (287, 68, 67, '2025-04-27 11:45:51.127081', '2025-04-27 11:45:51.127081');
INSERT INTO jobs.job_skill_map VALUES (288, 68, 93, '2025-04-27 11:45:51.127081', '2025-04-27 11:45:51.127081');
INSERT INTO jobs.job_skill_map VALUES (289, 68, 120, '2025-04-27 11:45:51.127081', '2025-04-27 11:45:51.127081');
INSERT INTO jobs.job_skill_map VALUES (290, 68, 296, '2025-04-27 11:45:51.127081', '2025-04-27 11:45:51.127081');
INSERT INTO jobs.job_skill_map VALUES (291, 69, 119, '2025-04-27 11:45:51.133382', '2025-04-27 11:45:51.133382');
INSERT INTO jobs.job_skill_map VALUES (292, 69, 67, '2025-04-27 11:45:51.133382', '2025-04-27 11:45:51.133382');
INSERT INTO jobs.job_skill_map VALUES (293, 69, 93, '2025-04-27 11:45:51.133382', '2025-04-27 11:45:51.133382');
INSERT INTO jobs.job_skill_map VALUES (294, 69, 120, '2025-04-27 11:45:51.133382', '2025-04-27 11:45:51.133382');
INSERT INTO jobs.job_skill_map VALUES (295, 69, 296, '2025-04-27 11:45:51.133382', '2025-04-27 11:45:51.133382');


--
-- TOC entry 5213 (class 0 OID 18655)
-- Dependencies: 243
-- Data for Name: job_type; Type: TABLE DATA; Schema: jobs; Owner: -
--

INSERT INTO jobs.job_type VALUES (1, 'REMOTE', '2025-04-22 11:03:49.29043+07', '2025-04-22 11:03:49.29043+07');
INSERT INTO jobs.job_type VALUES (2, 'HYBRID', '2025-04-22 11:03:49.29043+07', '2025-04-22 11:03:49.29043+07');
INSERT INTO jobs.job_type VALUES (3, 'OFFICE', '2025-04-22 11:03:49.29043+07', '2025-04-22 11:03:49.29043+07');


--
-- TOC entry 5215 (class 0 OID 18661)
-- Dependencies: 245
-- Data for Name: job_type_map; Type: TABLE DATA; Schema: jobs; Owner: -
--

INSERT INTO jobs.job_type_map VALUES (8, '30c892cc-90a5-454e-ac0f-6fb26e855d77', 19, 1, '2025-04-27 11:20:06.552352+07', '2025-04-27 11:20:06.552352+07');
INSERT INTO jobs.job_type_map VALUES (9, 'd0d2e2d6-3077-42bc-8194-e09bd200f346', 21, 1, '2025-04-27 11:45:20.424709+07', '2025-04-27 11:45:20.424709+07');
INSERT INTO jobs.job_type_map VALUES (10, '068714a7-725a-4024-8030-d391a6374f05', 22, 1, '2025-04-27 11:45:50.787684+07', '2025-04-27 11:45:50.787684+07');
INSERT INTO jobs.job_type_map VALUES (11, 'ca743594-55a9-4fcc-8019-d69257058d0b', 23, 1, '2025-04-27 11:45:50.820832+07', '2025-04-27 11:45:50.820832+07');
INSERT INTO jobs.job_type_map VALUES (12, '07f784c3-9f8a-49f1-8ba9-9efeb5e120e8', 24, 1, '2025-04-27 11:45:50.827802+07', '2025-04-27 11:45:50.827802+07');
INSERT INTO jobs.job_type_map VALUES (13, 'bffaaed8-5116-42fb-8b75-49ad2fb98a5b', 25, 1, '2025-04-27 11:45:50.83604+07', '2025-04-27 11:45:50.83604+07');
INSERT INTO jobs.job_type_map VALUES (14, 'c23901ed-748d-4b52-9cac-9f7f9af1a489', 26, 1, '2025-04-27 11:45:50.842959+07', '2025-04-27 11:45:50.842959+07');
INSERT INTO jobs.job_type_map VALUES (15, 'd9bc4169-9c5e-4199-99a7-3fe3933f46e2', 27, 1, '2025-04-27 11:45:50.849438+07', '2025-04-27 11:45:50.849438+07');
INSERT INTO jobs.job_type_map VALUES (16, '96c9191f-0754-4fd0-b241-72c553ec62ca', 28, 1, '2025-04-27 11:45:50.85634+07', '2025-04-27 11:45:50.85634+07');
INSERT INTO jobs.job_type_map VALUES (17, 'b3a6dbb7-9723-4b59-ab47-47d7e32c9e6a', 29, 1, '2025-04-27 11:45:50.864455+07', '2025-04-27 11:45:50.864455+07');
INSERT INTO jobs.job_type_map VALUES (18, 'bed43e88-d068-4a77-b640-fca6be49e5f6', 30, 1, '2025-04-27 11:45:50.871311+07', '2025-04-27 11:45:50.871311+07');
INSERT INTO jobs.job_type_map VALUES (19, '0d10fa7c-6a48-48fe-afd3-86632773a295', 31, 1, '2025-04-27 11:45:50.878289+07', '2025-04-27 11:45:50.878289+07');
INSERT INTO jobs.job_type_map VALUES (20, '343a29e3-1b78-492c-b125-0361b1dd2746', 32, 1, '2025-04-27 11:45:50.887681+07', '2025-04-27 11:45:50.887681+07');
INSERT INTO jobs.job_type_map VALUES (21, '7f95cccf-6108-42d4-afc2-2eb18b660633', 33, 1, '2025-04-27 11:45:50.89388+07', '2025-04-27 11:45:50.89388+07');
INSERT INTO jobs.job_type_map VALUES (22, 'd77d6838-20fa-47e8-9e3e-cdcd22f2be48', 34, 1, '2025-04-27 11:45:50.899625+07', '2025-04-27 11:45:50.899625+07');
INSERT INTO jobs.job_type_map VALUES (23, 'e6d6f8ec-9964-478f-91a4-2524fdd55e4a', 35, 1, '2025-04-27 11:45:50.906654+07', '2025-04-27 11:45:50.906654+07');
INSERT INTO jobs.job_type_map VALUES (24, 'aebb941b-e71a-487f-b1f7-11d262ca0641', 36, 1, '2025-04-27 11:45:50.913578+07', '2025-04-27 11:45:50.913578+07');
INSERT INTO jobs.job_type_map VALUES (25, 'ccb771a1-b6c1-4b21-a1dc-2bcaec53f00f', 37, 1, '2025-04-27 11:45:50.919773+07', '2025-04-27 11:45:50.919773+07');
INSERT INTO jobs.job_type_map VALUES (26, '0cea067c-3c84-4641-b5a1-2ecfaf96237b', 38, 1, '2025-04-27 11:45:50.926455+07', '2025-04-27 11:45:50.926455+07');
INSERT INTO jobs.job_type_map VALUES (27, 'f23027a0-9e62-4ab2-bcc3-705c32bedf11', 39, 1, '2025-04-27 11:45:50.932954+07', '2025-04-27 11:45:50.932954+07');
INSERT INTO jobs.job_type_map VALUES (28, '67b7a5ca-db91-46fa-840e-275a817f5932', 40, 1, '2025-04-27 11:45:50.93968+07', '2025-04-27 11:45:50.93968+07');
INSERT INTO jobs.job_type_map VALUES (29, 'ca8fecff-09cf-475a-b032-357bd41edfc7', 41, 1, '2025-04-27 11:45:50.944709+07', '2025-04-27 11:45:50.944709+07');
INSERT INTO jobs.job_type_map VALUES (30, '3946705c-5e60-4b0a-b5d6-f680cc864baa', 42, 1, '2025-04-27 11:45:50.950878+07', '2025-04-27 11:45:50.950878+07');
INSERT INTO jobs.job_type_map VALUES (31, 'b7a5a1cf-6ed6-4a2a-a4a2-b6f66ee68941', 43, 1, '2025-04-27 11:45:50.957412+07', '2025-04-27 11:45:50.957412+07');
INSERT INTO jobs.job_type_map VALUES (32, 'd15801ce-2c5f-472a-8e7c-34b2bf723a19', 44, 1, '2025-04-27 11:45:50.963837+07', '2025-04-27 11:45:50.963837+07');
INSERT INTO jobs.job_type_map VALUES (33, 'e1a7162a-89e2-4521-a032-026ca7dc261f', 45, 1, '2025-04-27 11:45:50.970704+07', '2025-04-27 11:45:50.970704+07');
INSERT INTO jobs.job_type_map VALUES (34, '1275e0bc-47c9-4d87-b086-9c2c295cc1b5', 46, 1, '2025-04-27 11:45:50.978664+07', '2025-04-27 11:45:50.978664+07');
INSERT INTO jobs.job_type_map VALUES (35, '8349cd5b-c57d-458a-b56f-8ce1101ded0c', 47, 1, '2025-04-27 11:45:50.984751+07', '2025-04-27 11:45:50.984751+07');
INSERT INTO jobs.job_type_map VALUES (36, '321c2cce-6e8c-47e6-9b33-f41f2021a7cf', 48, 1, '2025-04-27 11:45:50.991469+07', '2025-04-27 11:45:50.991469+07');
INSERT INTO jobs.job_type_map VALUES (37, '64c72975-a687-4a94-9d67-28963adb2d11', 49, 1, '2025-04-27 11:45:51.000068+07', '2025-04-27 11:45:51.000068+07');
INSERT INTO jobs.job_type_map VALUES (38, '491bde9b-48b8-43cb-9310-ffd43bc75eac', 50, 1, '2025-04-27 11:45:51.008159+07', '2025-04-27 11:45:51.008159+07');
INSERT INTO jobs.job_type_map VALUES (39, 'be1ae64d-278b-4ed4-b03e-6bd16c09eb25', 51, 1, '2025-04-27 11:45:51.015216+07', '2025-04-27 11:45:51.015216+07');
INSERT INTO jobs.job_type_map VALUES (40, 'd91aa35b-948f-466c-b25a-aa1be794b8da', 52, 1, '2025-04-27 11:45:51.02238+07', '2025-04-27 11:45:51.02238+07');
INSERT INTO jobs.job_type_map VALUES (41, 'd52797e7-735b-49cd-8f8a-c3beeccd0c85', 53, 1, '2025-04-27 11:45:51.029322+07', '2025-04-27 11:45:51.029322+07');
INSERT INTO jobs.job_type_map VALUES (42, '5170b314-5d55-46e0-927d-6769beedbedf', 54, 1, '2025-04-27 11:45:51.037204+07', '2025-04-27 11:45:51.037204+07');
INSERT INTO jobs.job_type_map VALUES (43, '04703f05-bd84-44b7-9577-64b53bf4bc3a', 55, 1, '2025-04-27 11:45:51.043495+07', '2025-04-27 11:45:51.043495+07');
INSERT INTO jobs.job_type_map VALUES (44, '5301aa07-77da-4b7e-be54-1779c6fe065a', 56, 1, '2025-04-27 11:45:51.050492+07', '2025-04-27 11:45:51.050492+07');
INSERT INTO jobs.job_type_map VALUES (45, '65e938bb-a0c7-4b4b-b51a-781394b1c994', 57, 1, '2025-04-27 11:45:51.056422+07', '2025-04-27 11:45:51.056422+07');
INSERT INTO jobs.job_type_map VALUES (46, '61228a3a-bcb2-4d7d-98d1-10a314815f39', 58, 1, '2025-04-27 11:45:51.061951+07', '2025-04-27 11:45:51.061951+07');
INSERT INTO jobs.job_type_map VALUES (47, 'e2db9309-ac65-418a-9e7e-489db70b592f', 59, 1, '2025-04-27 11:45:51.069025+07', '2025-04-27 11:45:51.069025+07');
INSERT INTO jobs.job_type_map VALUES (48, '49a5f44f-4c9f-4936-9edb-4575e3fe5a4a', 60, 1, '2025-04-27 11:45:51.075339+07', '2025-04-27 11:45:51.075339+07');
INSERT INTO jobs.job_type_map VALUES (49, 'f08efd72-54d3-4345-82a6-c30e4bc9d915', 61, 1, '2025-04-27 11:45:51.082331+07', '2025-04-27 11:45:51.082331+07');
INSERT INTO jobs.job_type_map VALUES (50, 'bfcb3c57-fb5a-424c-a5d5-2c355223f788', 62, 1, '2025-04-27 11:45:51.088769+07', '2025-04-27 11:45:51.088769+07');
INSERT INTO jobs.job_type_map VALUES (51, '9425e6bc-0849-4dd7-8f82-839ba9db0b66', 63, 1, '2025-04-27 11:45:51.095172+07', '2025-04-27 11:45:51.095172+07');
INSERT INTO jobs.job_type_map VALUES (52, '9ba6bb23-07d4-4b70-a2ed-3b5572fb0b0b', 64, 1, '2025-04-27 11:45:51.101642+07', '2025-04-27 11:45:51.101642+07');
INSERT INTO jobs.job_type_map VALUES (53, '60d6c96a-e719-4bd7-8f3f-6540a0de65de', 65, 1, '2025-04-27 11:45:51.107939+07', '2025-04-27 11:45:51.107939+07');
INSERT INTO jobs.job_type_map VALUES (54, 'ef9be414-2dc9-414b-aba7-57ee6ef2abaa', 66, 1, '2025-04-27 11:45:51.114504+07', '2025-04-27 11:45:51.114504+07');
INSERT INTO jobs.job_type_map VALUES (55, '8cd88cb4-013f-4bc9-86cc-f86f2d008590', 67, 1, '2025-04-27 11:45:51.120838+07', '2025-04-27 11:45:51.120838+07');
INSERT INTO jobs.job_type_map VALUES (56, '41827eee-ab54-420a-bdbb-5e348e5bae2f', 68, 1, '2025-04-27 11:45:51.127081+07', '2025-04-27 11:45:51.127081+07');
INSERT INTO jobs.job_type_map VALUES (57, '3271931c-c000-4c9c-a27a-581c457c6c40', 69, 1, '2025-04-27 11:45:51.133382+07', '2025-04-27 11:45:51.133382+07');


--
-- TOC entry 5217 (class 0 OID 18667)
-- Dependencies: 247
-- Data for Name: city; Type: TABLE DATA; Schema: locations; Owner: -
--

INSERT INTO locations.city VALUES (1, 'BANDA ACEH', 1, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (2, 'LANGSA', 1, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (3, 'LHOKSEUMAWE', 1, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (4, 'SABANG', 1, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (5, 'SUBULUSSALAM', 1, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (6, 'DENPASAR', 17, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (64, 'BIMA', 18, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (65, 'MATARAM', 18, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (66, 'KUPANG', 19, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (67, 'SORONG', 34, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (68, 'JAYAPURA', 38, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (69, 'DUMAI', 4, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (70, 'PEKANBARU', 4, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (71, 'MAKASSAR', 29, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (72, 'PALOPO', 29, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (73, 'PAREPARE', 29, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (74, 'PALU', 27, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (75, 'BAUBAU', 30, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (7, 'PANGKALPINANG', 8, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (8, 'CILEGON', 11, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (9, 'SERANG', 11, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (10, 'TANGERANG SELATAN', 11, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (11, 'TANGERANG', 11, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (12, 'BENGKULU', 9, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (13, 'YOGYAKARTA', 15, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (14, 'JAKARTA BARAT', 12, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (15, 'JAKARTA PUSAT', 12, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (16, 'JAKARTA SELATAN', 12, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (17, 'JAKARTA TIMUR', 12, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (18, 'JAKARTA UTARA', 12, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (19, 'GORONTALO', 26, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (20, 'SUNGAI PENUH', 6, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (21, 'JAMBI', 6, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (22, 'BANDUNG', 13, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (23, 'BEKASI', 13, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (24, 'BOGOR', 13, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (25, 'CIMAHI', 13, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (26, 'CIREBON', 13, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (27, 'DEPOK', 13, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (28, 'SUKABUMI', 13, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (29, 'TASIKMALAYA', 13, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (30, 'BANJAR', 13, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (31, 'MAGELANG', 14, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (32, 'PEKALONGAN', 14, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (33, 'SALATIGA', 14, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (76, 'KENDARI', 30, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (34, 'SEMARANG', 14, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (35, 'SURAKARTA', 14, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (77, 'BITUNG', 25, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (36, 'TEGAL', 14, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (37, 'BATU', 16, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (78, 'KOTAMOBAGU', 25, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (79, 'MANADO', 25, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (38, 'BLITAR', 16, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (39, 'KEDIRI', 16, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (80, 'TOMOHON', 25, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (40, 'MADIUN', 16, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (41, 'MALANG', 16, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (81, 'BUKITTINGGI', 3, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (42, 'MOJOKERTO', 16, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (43, 'PASURUAN', 16, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (82, 'PADANG', 3, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (44, 'PROBOLINGGO', 16, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (45, 'SURABAYA', 16, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (83, 'PADANG PANJANG', 3, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (46, 'PONTIANAK', 20, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (47, 'SINGKAWANG', 20, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (84, 'PARIAMAN', 3, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (48, 'BANJARBARU', 22, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (49, 'BANJARMASIN', 22, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (85, 'PAYAKUMBUH', 3, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (50, 'PALANGKA RAYA', 21, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (51, 'BALIKPAPAN', 23, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (86, 'SAWAHLUNTO', 3, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (52, 'BONTANG', 23, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (53, 'SAMARINDA', 23, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (87, 'SOLOK', 3, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (54, 'NUSANTARA', 23, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (55, 'TARAKAN', 24, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (88, 'LUBUKLINGGAU', 7, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (56, 'BATAM', 5, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (57, 'TANJUNGPINANG', 5, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (58, 'BANDAR LAMPUNG', 10, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (59, 'METRO', 10, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (89, 'PAGAR ALAM', 7, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (60, 'TERNATE', 32, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (61, 'TIDORE KEPULAUAN', 32, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (90, 'PALEMBANG', 7, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (62, 'AMBON', 31, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (63, 'TUAL', 31, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (91, 'PRABUMULIH', 7, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (92, 'BINJAI', 2, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (93, 'GUNUNGSITOLI', 2, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (94, 'MEDAN', 2, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (95, 'PADANGSIDIMPUAN', 2, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (96, 'PEMATANGSIANTAR', 2, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (97, 'SIBOLGA', 2, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (98, 'TANJUNGBALAI', 2, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (99, 'TEBING TINGGI', 2, '2025-04-11 00:26:51.039482+07', '2025-04-11 00:26:51.039482+07');
INSERT INTO locations.city VALUES (9997, 'UNKNOWN', 9998, '2025-04-27 11:38:07.399634+07', '2025-04-27 11:38:07.399634+07');


--
-- TOC entry 5219 (class 0 OID 18673)
-- Dependencies: 249
-- Data for Name: country; Type: TABLE DATA; Schema: locations; Owner: -
--

INSERT INTO locations.country VALUES (24, 'BERMUDA', 'BMU', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (56, 'CURAÇAO', 'CUW', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (57, 'CYPRUS', 'CYP', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (58, 'CZECHIA', 'CZE', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (59, 'CÔTE D''IVOIRE', 'CIV', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (60, 'DENMARK', 'DNK', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (61, 'DJIBOUTI', 'DJI', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (62, 'DOMINICA', 'DMA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (63, 'DOMINICAN REPUBLIC (THE)', 'DOM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (64, 'ECUADOR', 'ECU', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (65, 'EGYPT', 'EGY', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (66, 'EL SALVADOR', 'SLV', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (67, 'EQUATORIAL GUINEA', 'GNQ', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (68, 'ERITREA', 'ERI', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (69, 'ESTONIA', 'EST', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (70, 'ESWATINI', 'SWZ', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (71, 'ETHIOPIA', 'ETH', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (72, 'FALKLAND ISLANDS (THE) [MALVINAS]', 'FLK', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (73, 'FAROE ISLANDS (THE)', 'FRO', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (74, 'FIJI', 'FJI', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (75, 'FINLAND', 'FIN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (76, 'FRANCE', 'FRA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (77, 'FRENCH GUIANA', 'GUF', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (78, 'FRENCH POLYNESIA', 'PYF', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (79, 'FRENCH SOUTHERN TERRITORIES (THE)', 'ATF', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (80, 'GABON', 'GAB', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (81, 'GAMBIA (THE)', 'GMB', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (82, 'GEORGIA', 'GEO', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (83, 'GERMANY', 'DEU', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (84, 'GHANA', 'GHA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (85, 'GIBRALTAR', 'GIB', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (86, 'GREECE', 'GRC', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (87, 'GREENLAND', 'GRL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (88, 'GRENADA', 'GRD', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (89, 'GUADELOUPE', 'GLP', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (90, 'GUAM', 'GUM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (91, 'GUATEMALA', 'GTM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (92, 'GUERNSEY', 'GGY', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (93, 'GUINEA', 'GIN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (94, 'GUINEA-BISSAU', 'GNB', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (95, 'GUYANA', 'GUY', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (96, 'HAITI', 'HTI', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (97, 'HEARD ISLAND AND MCDONALD ISLANDS', 'HMD', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (98, 'HOLY SEE (THE)', 'VAT', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (99, 'HONDURAS', 'HND', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (100, 'HONG KONG', 'HKG', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (101, 'HUNGARY', 'HUN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (102, 'ICELAND', 'ISL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (103, 'INDIA', 'IND', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (104, 'INDONESIA', 'IDN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (105, 'IRAN (ISLAMIC REPUBLIC OF)', 'IRN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (106, 'IRAQ', 'IRQ', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (107, 'IRELAND', 'IRL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (108, 'ISLE OF MAN', 'IMN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (109, 'ISRAEL', 'ISR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (110, 'ITALY', 'ITA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (111, 'JAMAICA', 'JAM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (112, 'JAPAN', 'JPN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (113, 'JERSEY', 'JEY', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (114, 'JORDAN', 'JOR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (161, 'NIGERIA', 'NGA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (115, 'KAZAKHSTAN', 'KAZ', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (116, 'KENYA', 'KEN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (117, 'KIRIBATI', 'KIR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (118, 'KOREA (THE DEMOCRATIC PEOPLE''S REPUBLIC OF)', 'PRK', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (119, 'KOREA (THE REPUBLIC OF)', 'KOR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (120, 'KUWAIT', 'KWT', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (121, 'KYRGYZSTAN', 'KGZ', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (122, 'LAO PEOPLE''S DEMOCRATIC REPUBLIC (THE)', 'LAO', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (123, 'LATVIA', 'LVA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (124, 'LEBANON', 'LBN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (125, 'LESOTHO', 'LSO', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (126, 'LIBERIA', 'LBR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (127, 'LIBYA', 'LBY', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (128, 'LIECHTENSTEIN', 'LIE', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (129, 'LITHUANIA', 'LTU', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (130, 'LUXEMBOURG', 'LUX', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (131, 'MACAO', 'MAC', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (132, 'MADAGASCAR', 'MDG', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (133, 'MALAWI', 'MWI', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (134, 'MALAYSIA', 'MYS', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (135, 'MALDIVES', 'MDV', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (136, 'MALI', 'MLI', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (137, 'MALTA', 'MLT', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (138, 'MARSHALL ISLANDS (THE)', 'MHL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (139, 'MARTINIQUE', 'MTQ', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (140, 'MAURITANIA', 'MRT', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (141, 'MAURITIUS', 'MUS', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (142, 'MAYOTTE', 'MYT', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (143, 'MEXICO', 'MEX', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (144, 'MICRONESIA (FEDERATED STATES OF)', 'FSM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (145, 'MOLDOVA (THE REPUBLIC OF)', 'MDA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (146, 'MONACO', 'MCO', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (147, 'MONGOLIA', 'MNG', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (148, 'MONTENEGRO', 'MNE', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (149, 'MONTSERRAT', 'MSR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (150, 'MOROCCO', 'MAR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (151, 'MOZAMBIQUE', 'MOZ', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (152, 'MYANMAR', 'MMR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (153, 'NAMIBIA', 'NAM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (154, 'NAURU', 'NRU', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (155, 'NEPAL', 'NPL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (156, 'NETHERLANDS (KINGDOM OF THE)', 'NLD', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (157, 'NEW CALEDONIA', 'NCL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (158, 'NEW ZEALAND', 'NZL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (159, 'NICARAGUA', 'NIC', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (2, 'ALBANIA', 'ALB', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (3, 'ALGERIA', 'DZA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (46, 'CHRISTMAS ISLAND', 'CXR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (6, 'ANGOLA', 'AGO', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (5, 'ANDORRA', 'AND', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (7, 'ANGUILLA', 'AIA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (8, 'ANTARCTICA', 'ATA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (9, 'ANTIGUA AND BARBUDA', 'ATG', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (10, 'ARGENTINA', 'ARG', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (11, 'ARMENIA', 'ARM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (12, 'ARUBA', 'ABW', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (14, 'AUSTRIA', 'AUT', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (15, 'AZERBAIJAN', 'AZE', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (16, 'BAHAMAS (THE)', 'BHS', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (17, 'BAHRAIN', 'BHR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (18, 'BANGLADESH', 'BGD', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (19, 'BARBADOS', 'BRB', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (20, 'BELARUS', 'BLR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (21, 'BELGIUM', 'BEL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (22, 'BELIZE', 'BLZ', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (23, 'BENIN', 'BEN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (25, 'BHUTAN', 'BTN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (27, 'BONAIRE, SINT EUSTATIUS AND SABA', 'BES', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (28, 'BOSNIA AND HERZEGOVINA', 'BIH', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (29, 'BOTSWANA', 'BWA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (30, 'BOUVET ISLAND', 'BVT', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (31, 'BRAZIL', 'BRA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (32, 'BRITISH INDIAN OCEAN TERRITORY (THE)', 'IOT', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (33, 'BRUNEI DARUSSALAM', 'BRN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (34, 'BULGARIA', 'BGR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (35, 'BURKINA FASO', 'BFA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (36, 'BURUNDI', 'BDI', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (37, 'CABO VERDE', 'CPV', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (38, 'CAMBODIA', 'KHM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (39, 'CAMEROON', 'CMR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (40, 'CANADA', 'CAN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (41, 'CAYMAN ISLANDS (THE)', 'CYM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (43, 'CHAD', 'TCD', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (44, 'CHILE', 'CHL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (45, 'CHINA', 'CHN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (4, 'AMERICAN SAMOA', 'ASM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (47, 'COCOS (KEELING) ISLANDS (THE)', 'CCK', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (48, 'COLOMBIA', 'COL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (49, 'COMOROS (THE)', 'COM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (50, 'CONGO (THE DEMOCRATIC REPUBLIC OF THE)', 'COD', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (51, 'CONGO (THE)', 'COG', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (52, 'COOK ISLANDS (THE)', 'COK', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (53, 'COSTA RICA', 'CRI', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (54, 'CROATIA', 'HRV', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (55, 'CUBA', 'CUB', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (160, 'NIGER (THE)', 'NER', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (162, 'NIUE', 'NIU', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (163, 'NORFOLK ISLAND', 'NFK', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (164, 'NORTH MACEDONIA', 'MKD', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (165, 'NORTHERN MARIANA ISLANDS (THE)', 'MNP', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (166, 'NORWAY', 'NOR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (167, 'OMAN', 'OMN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (168, 'PAKISTAN', 'PAK', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (169, 'PALAU', 'PLW', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (170, 'PALESTINE, STATE OF', 'PSE', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (171, 'PANAMA', 'PAN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (172, 'PAPUA NEW GUINEA', 'PNG', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (173, 'PARAGUAY', 'PRY', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (174, 'PERU', 'PER', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (175, 'PHILIPPINES (THE)', 'PHL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (176, 'PITCAIRN', 'PCN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (177, 'POLAND', 'POL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (178, 'PORTUGAL', 'PRT', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (179, 'PUERTO RICO', 'PRI', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (180, 'QATAR', 'QAT', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (181, 'ROMANIA', 'ROU', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (182, 'RUSSIAN FEDERATION (THE)', 'RUS', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (183, 'RWANDA', 'RWA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (184, 'RÉUNION', 'REU', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (185, 'SAINT BARTHÉLEMY', 'BLM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (186, 'SAINT HELENA, ASCENSION AND TRISTAN DA CUNHA', 'SHN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (187, 'SAINT KITTS AND NEVIS', 'KNA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (188, 'SAINT LUCIA', 'LCA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (189, 'SAINT MARTIN (FRENCH PART)', 'MAF', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (190, 'SAINT PIERRE AND MIQUELON', 'SPM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (191, 'SAINT VINCENT AND THE GRENADINES', 'VCT', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (192, 'SAMOA', 'WSM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (193, 'SAN MARINO', 'SMR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (194, 'SAO TOME AND PRINCIPE', 'STP', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (195, 'SAUDI ARABIA', 'SAU', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (196, 'SENEGAL', 'SEN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (197, 'SERBIA', 'SRB', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (198, 'SEYCHELLES', 'SYC', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (199, 'SIERRA LEONE', 'SLE', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (200, 'SINGAPORE', 'SGP', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (201, 'SINT MAARTEN (DUTCH PART)', 'SXM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (202, 'SLOVAKIA', 'SVK', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (203, 'SLOVENIA', 'SVN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (204, 'SOLOMON ISLANDS', 'SLB', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (205, 'SOMALIA', 'SOM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (206, 'SOUTH AFRICA', 'ZAF', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (207, 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS', 'SGS', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (208, 'SOUTH SUDAN', 'SSD', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (209, 'SPAIN', 'ESP', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (210, 'SRI LANKA', 'LKA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (211, 'SUDAN (THE)', 'SDN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (212, 'SURINAME', 'SUR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (213, 'SVALBARD AND JAN MAYEN', 'SJM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (214, 'SWEDEN', 'SWE', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (215, 'SWITZERLAND', 'CHE', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (216, 'SYRIAN ARAB REPUBLIC (THE)', 'SYR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (217, 'TAIWAN (PROVINCE OF CHINA)', 'TWN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (218, 'TAJIKISTAN', 'TJK', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (219, 'TANZANIA, THE UNITED REPUBLIC OF', 'TZA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (220, 'THAILAND', 'THA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (221, 'TIMOR-LESTE', 'TLS', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (222, 'TOGO', 'TGO', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (223, 'TOKELAU', 'TKL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (224, 'TONGA', 'TON', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (225, 'TRINIDAD AND TOBAGO', 'TTO', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (226, 'TUNISIA', 'TUN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (227, 'TURKMENISTAN', 'TKM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (228, 'TURKS AND CAICOS ISLANDS (THE)', 'TCA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (229, 'TUVALU', 'TUV', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (230, 'TÜRKIYE', 'TUR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (231, 'UGANDA', 'UGA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (232, 'UKRAINE', 'UKR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (233, 'UNITED ARAB EMIRATES (THE)', 'ARE', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (234, 'UNITED KINGDOM OF GREAT BRITAIN AND NORTHERN IRELAND (THE)', 'GBR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (235, 'UNITED STATES MINOR OUTLYING ISLANDS (THE)', 'UMI', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (236, 'UNITED STATES OF AMERICA (THE)', 'USA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (237, 'URUGUAY', 'URY', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (238, 'UZBEKISTAN', 'UZB', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (239, 'VANUATU', 'VUT', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (240, 'VENEZUELA (BOLIVARIAN REPUBLIC OF)', 'VEN', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (241, 'VIET NAM', 'VNM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (242, 'VIRGIN ISLANDS (BRITISH)', 'VGB', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (243, 'VIRGIN ISLANDS (U.S.)', 'VIR', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (244, 'WALLIS AND FUTUNA', 'WLF', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (245, 'WESTERN SAHARA*', 'ESH', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (246, 'YEMEN', 'YEM', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (247, 'ZAMBIA', 'ZMB', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (248, 'ZIMBABWE', 'ZWE', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (249, 'ÅLAND ISLANDS', 'ALA', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (1, 'AFGHANISTAN', 'AFG', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (13, 'AUSTRALIA', 'AUS', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (26, 'BOLIVIA (PLURINATIONAL STATE OF)', 'BOL', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (42, 'CENTRAL AFRICAN REPUBLIC (THE)', 'CAF', '2025-04-11 00:27:38.139123+07', '2025-04-11 00:27:38.139123+07');
INSERT INTO locations.country VALUES (9999, 'UNKNOWN', 'UNK', '2025-04-27 11:34:28.715973+07', '2025-04-27 11:34:28.715973+07');


--
-- TOC entry 5221 (class 0 OID 18679)
-- Dependencies: 251
-- Data for Name: state; Type: TABLE DATA; Schema: locations; Owner: -
--

INSERT INTO locations.state VALUES (46, 'PERAK', 'MY-08', 134, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (47, 'PERLIS', 'MY-09', 134, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (48, 'SABAH', 'MY-12', 134, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (49, 'SARAWAK', 'MY-13', 134, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (50, 'SELANGOR', 'MY-10', 134, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (51, 'TERENGGANU', 'MY-11', 134, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (39, 'JOHOR', 'MY-01', 134, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (40, 'KEDAH', 'MY-02', 134, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (41, 'KELANTAN', 'MY-03', 134, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (42, 'MALACCA', 'MY-04', 134, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (43, 'NEGERI SEMBILAN', 'MY-05', 134, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (44, 'PAHANG', 'MY-06', 134, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (45, 'PENANG', 'MY-07', 134, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (1, 'ACEH', 'ID-AC', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (17, 'BALI', 'ID-BA', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (11, 'BANTEN', 'ID-BT', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (9, 'BENGKULU', 'ID-BE', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (26, 'GORONTALO', 'ID-GO', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (12, 'JAKARTA', 'ID-JK', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (6, 'JAMBI', 'ID-JA', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (13, 'JAWA BARAT', 'ID-JB', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (14, 'JAWA TENGAH', 'ID-JT', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (16, 'JAWA TIMUR', 'ID-JI', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (20, 'KALIMANTAN BARAT', 'ID-KB', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (22, 'KALIMANTAN SELATAN', 'ID-KS', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (21, 'KALIMANTAN TENGAH', 'ID-KT', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (23, 'KALIMANTAN TIMUR', 'ID-KI', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (24, 'KALIMANTAN UTARA', 'ID-KU', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (8, 'BANGKA BELITUNG ISLANDS', 'ID-BB', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (5, 'KEPULAUAN RIAU', 'ID-KR', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (10, 'LAMPUNG', 'ID-LA', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (31, 'MALUKU', 'ID-MA', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (32, 'MALUKU UTARA', 'ID-MU', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (18, 'NUSA TENGGARA BARAT', 'ID-NB', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (19, 'NUSA TENGGARA TIMUR', 'ID-NT', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (38, 'PAPUA', 'ID-PA', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (33, 'PAPUA BARAT', 'ID-PB', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (34, 'PAPUA BARAT DAYA', 'ID-PD', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (36, 'PAPUA PENGUNUNGAN', 'ID-PE', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (37, 'PAPUA SELATAN', 'ID-PS', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (35, 'PAPUA TENGAH', 'ID-PT', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (4, 'RIAU', 'ID-RI', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (15, 'YOGYAKARTA', 'ID-YO', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (28, 'SULAWESI BARAT', 'ID-SR', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (29, 'SULAWESI SELATAN', 'ID-SN', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (27, 'SULAWESI TENGAH', 'ID-ST', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (30, 'SULAWESI TENGGARA', 'ID-SG', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (25, 'SULAWESI UTARA', 'ID-SA', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (3, 'SUMATERA BARAT', 'ID-SB', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (7, 'SUMATERA SELATAN', 'ID-SS', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (2, 'SUMATERA UTARA', 'ID-SU', 104, '2025-04-11 00:28:18.347689+07', '2025-04-11 00:28:18.347689+07');
INSERT INTO locations.state VALUES (9998, 'UNKNOWN', 'UNK', 9999, '2025-04-27 11:36:19.727099+07', '2025-04-27 11:36:19.727099+07');


--
-- TOC entry 5228 (class 0 OID 18901)
-- Dependencies: 258
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 222
-- Name: company_company_id_seq1; Type: SEQUENCE SET; Schema: companies; Owner: -
--

SELECT pg_catalog.setval('companies.company_company_id_seq1', 175, true);


--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 224
-- Name: company_image_company_image_id_seq; Type: SEQUENCE SET; Schema: companies; Owner: -
--

SELECT pg_catalog.setval('companies.company_image_company_image_id_seq', 1, false);


--
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 226
-- Name: company_industry_company_industry_id_seq; Type: SEQUENCE SET; Schema: companies; Owner: -
--

SELECT pg_catalog.setval('companies.company_industry_company_industry_id_seq', 1, false);


--
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 228
-- Name: industry_category_id_seq; Type: SEQUENCE SET; Schema: companies; Owner: -
--

SELECT pg_catalog.setval('companies.industry_category_id_seq', 48, true);


--
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 231
-- Name: job_category_job_category_id_seq; Type: SEQUENCE SET; Schema: jobs; Owner: -
--

SELECT pg_catalog.setval('jobs.job_category_job_category_id_seq', 15, true);


--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 233
-- Name: job_category_map_job_category_map_id_seq; Type: SEQUENCE SET; Schema: jobs; Owner: -
--

SELECT pg_catalog.setval('jobs.job_category_map_job_category_map_id_seq', 51, true);


--
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 234
-- Name: job_job_id_seq; Type: SEQUENCE SET; Schema: jobs; Owner: -
--

SELECT pg_catalog.setval('jobs.job_job_id_seq', 169, true);


--
-- TOC entry 5265 (class 0 OID 0)
-- Dependencies: 236
-- Name: job_salary_job_salary_id_seq; Type: SEQUENCE SET; Schema: jobs; Owner: -
--

SELECT pg_catalog.setval('jobs.job_salary_job_salary_id_seq', 6, true);


--
-- TOC entry 5266 (class 0 OID 0)
-- Dependencies: 238
-- Name: job_salary_map_job_salary_map_id_seq; Type: SEQUENCE SET; Schema: jobs; Owner: -
--

SELECT pg_catalog.setval('jobs.job_salary_map_job_salary_map_id_seq', 52, true);


--
-- TOC entry 5267 (class 0 OID 0)
-- Dependencies: 240
-- Name: job_schedule_job_schedule_id_seq; Type: SEQUENCE SET; Schema: jobs; Owner: -
--

SELECT pg_catalog.setval('jobs.job_schedule_job_schedule_id_seq', 4, true);


--
-- TOC entry 5268 (class 0 OID 0)
-- Dependencies: 242
-- Name: job_schedule_map_job_schedule_map_id_seq; Type: SEQUENCE SET; Schema: jobs; Owner: -
--

SELECT pg_catalog.setval('jobs.job_schedule_map_job_schedule_map_id_seq', 55, true);


--
-- TOC entry 5269 (class 0 OID 0)
-- Dependencies: 255
-- Name: job_skill_map_job_skill_map_id_seq; Type: SEQUENCE SET; Schema: jobs; Owner: -
--

SELECT pg_catalog.setval('jobs.job_skill_map_job_skill_map_id_seq', 295, true);


--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 253
-- Name: job_skill_skill_id_seq; Type: SEQUENCE SET; Schema: jobs; Owner: -
--

SELECT pg_catalog.setval('jobs.job_skill_skill_id_seq', 306, true);


--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 244
-- Name: job_type_job_type_id_seq; Type: SEQUENCE SET; Schema: jobs; Owner: -
--

SELECT pg_catalog.setval('jobs.job_type_job_type_id_seq', 3, true);


--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 246
-- Name: job_type_map_job_type_map_id_seq; Type: SEQUENCE SET; Schema: jobs; Owner: -
--

SELECT pg_catalog.setval('jobs.job_type_map_job_type_map_id_seq', 57, true);


--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 248
-- Name: cities_city_id_seq; Type: SEQUENCE SET; Schema: locations; Owner: -
--

SELECT pg_catalog.setval('locations.cities_city_id_seq', 104, true);


--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 250
-- Name: country_country_id_seq; Type: SEQUENCE SET; Schema: locations; Owner: -
--

SELECT pg_catalog.setval('locations.country_country_id_seq', 249, true);


--
-- TOC entry 5275 (class 0 OID 0)
-- Dependencies: 252
-- Name: states_state_id_seq; Type: SEQUENCE SET; Schema: locations; Owner: -
--

SELECT pg_catalog.setval('locations.states_state_id_seq', 51, true);


--
-- TOC entry 5276 (class 0 OID 0)
-- Dependencies: 257
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);


--
-- TOC entry 4947 (class 2606 OID 18701)
-- Name: company company_company_email_check; Type: CHECK CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE companies.company
    ADD CONSTRAINT company_company_email_check CHECK (((company_email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text)) NOT VALID;


--
-- TOC entry 4950 (class 2606 OID 18703)
-- Name: company company_company_uuid_key; Type: CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company
    ADD CONSTRAINT company_company_uuid_key UNIQUE (company_uuid);


--
-- TOC entry 4957 (class 2606 OID 18705)
-- Name: company_image company_image_pkey; Type: CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company_image
    ADD CONSTRAINT company_image_pkey PRIMARY KEY (company_image_id);


--
-- TOC entry 4960 (class 2606 OID 18707)
-- Name: company_industry company_industry_company_id_industry_category_id_key; Type: CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company_industry
    ADD CONSTRAINT company_industry_company_id_industry_category_id_key UNIQUE (company_id, industry_category_id);


--
-- TOC entry 4962 (class 2606 OID 18709)
-- Name: company_industry company_industry_company_industry_uuid_key; Type: CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company_industry
    ADD CONSTRAINT company_industry_company_industry_uuid_key UNIQUE (company_industry_uuid);


--
-- TOC entry 4964 (class 2606 OID 18711)
-- Name: company_industry company_industry_pkey; Type: CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company_industry
    ADD CONSTRAINT company_industry_pkey PRIMARY KEY (company_industry_id);


--
-- TOC entry 4948 (class 2606 OID 18712)
-- Name: company company_phone_number_check; Type: CHECK CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE companies.company
    ADD CONSTRAINT company_phone_number_check CHECK (((phone_number)::text ~ '^\+?[0-9]{7,15}$'::text)) NOT VALID;


--
-- TOC entry 4952 (class 2606 OID 18714)
-- Name: company company_pkey1; Type: CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company
    ADD CONSTRAINT company_pkey1 PRIMARY KEY (company_id);


--
-- TOC entry 4968 (class 2606 OID 18716)
-- Name: industry_category industry_category_pkey; Type: CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.industry_category
    ADD CONSTRAINT industry_category_pkey PRIMARY KEY (industry_category_id);


--
-- TOC entry 4955 (class 2606 OID 18914)
-- Name: company unique_company_name; Type: CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company
    ADD CONSTRAINT unique_company_name UNIQUE (company_name);


--
-- TOC entry 4981 (class 2606 OID 18718)
-- Name: job_category_map job_category_map_job_id_category_id_key; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_category_map
    ADD CONSTRAINT job_category_map_job_id_category_id_key UNIQUE (job_id, category_id);


--
-- TOC entry 4983 (class 2606 OID 18720)
-- Name: job_category_map job_category_map_pkey; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_category_map
    ADD CONSTRAINT job_category_map_pkey PRIMARY KEY (job_category_map_id);


--
-- TOC entry 4979 (class 2606 OID 18722)
-- Name: job_category job_category_pkey; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_category
    ADD CONSTRAINT job_category_pkey PRIMARY KEY (job_category_id);


--
-- TOC entry 4973 (class 2606 OID 18724)
-- Name: job job_job_company_job_name_job_location_id_key; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job
    ADD CONSTRAINT job_job_company_job_name_job_location_id_key UNIQUE (job_company, job_name, job_location_id);


--
-- TOC entry 4975 (class 2606 OID 18726)
-- Name: job job_job_uuid_key; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job
    ADD CONSTRAINT job_job_uuid_key UNIQUE (job_uuid);


--
-- TOC entry 4977 (class 2606 OID 18728)
-- Name: job job_pkey; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job
    ADD CONSTRAINT job_pkey PRIMARY KEY (job_id);


--
-- TOC entry 4987 (class 2606 OID 18730)
-- Name: job_salary_map job_salary_map_job_id_salary_id_key; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_salary_map
    ADD CONSTRAINT job_salary_map_job_id_salary_id_key UNIQUE (job_id, salary_id);


--
-- TOC entry 4989 (class 2606 OID 18732)
-- Name: job_salary_map job_salary_map_pkey; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_salary_map
    ADD CONSTRAINT job_salary_map_pkey PRIMARY KEY (job_salary_map_id);


--
-- TOC entry 4985 (class 2606 OID 18734)
-- Name: job_salary job_salary_pkey; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_salary
    ADD CONSTRAINT job_salary_pkey PRIMARY KEY (job_salary_id);


--
-- TOC entry 4993 (class 2606 OID 18736)
-- Name: job_schedule_map job_schedule_map_job_id_schedule_id_key; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_schedule_map
    ADD CONSTRAINT job_schedule_map_job_id_schedule_id_key UNIQUE (job_id, schedule_id);


--
-- TOC entry 4995 (class 2606 OID 18738)
-- Name: job_schedule_map job_schedule_map_pkey; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_schedule_map
    ADD CONSTRAINT job_schedule_map_pkey PRIMARY KEY (job_schedule_map_id);


--
-- TOC entry 4991 (class 2606 OID 18740)
-- Name: job_schedule job_schedule_pkey; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_schedule
    ADD CONSTRAINT job_schedule_pkey PRIMARY KEY (job_schedule_id);


--
-- TOC entry 5023 (class 2606 OID 18885)
-- Name: job_skill_map job_skill_map_pkey; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_skill_map
    ADD CONSTRAINT job_skill_map_pkey PRIMARY KEY (job_skill_map_id);


--
-- TOC entry 5017 (class 2606 OID 18864)
-- Name: job_skill job_skill_pkey; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_skill
    ADD CONSTRAINT job_skill_pkey PRIMARY KEY (job_skill_id);


--
-- TOC entry 5019 (class 2606 OID 18866)
-- Name: job_skill job_skill_skill_name_key; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_skill
    ADD CONSTRAINT job_skill_skill_name_key UNIQUE (skill_name);


--
-- TOC entry 4999 (class 2606 OID 18742)
-- Name: job_type_map job_type_map_job_id_type_id_key; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_type_map
    ADD CONSTRAINT job_type_map_job_id_type_id_key UNIQUE (job_id, type_id);


--
-- TOC entry 5001 (class 2606 OID 18744)
-- Name: job_type_map job_type_map_pkey; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_type_map
    ADD CONSTRAINT job_type_map_pkey PRIMARY KEY (job_type_map_id);


--
-- TOC entry 4997 (class 2606 OID 18746)
-- Name: job_type job_type_pkey; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_type
    ADD CONSTRAINT job_type_pkey PRIMARY KEY (job_type_id);


--
-- TOC entry 5021 (class 2606 OID 18912)
-- Name: job_skill unique_skill_name; Type: CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_skill
    ADD CONSTRAINT unique_skill_name UNIQUE (skill_name);


--
-- TOC entry 5003 (class 2606 OID 18748)
-- Name: city cities_pkey; Type: CONSTRAINT; Schema: locations; Owner: -
--

ALTER TABLE ONLY locations.city
    ADD CONSTRAINT cities_pkey PRIMARY KEY (city_id);


--
-- TOC entry 5005 (class 2606 OID 18750)
-- Name: city city_city_name_state_id_key; Type: CONSTRAINT; Schema: locations; Owner: -
--

ALTER TABLE ONLY locations.city
    ADD CONSTRAINT city_city_name_state_id_key UNIQUE (city_name, state_id);


--
-- TOC entry 5008 (class 2606 OID 18752)
-- Name: country country_country_code_key; Type: CONSTRAINT; Schema: locations; Owner: -
--

ALTER TABLE ONLY locations.country
    ADD CONSTRAINT country_country_code_key UNIQUE (country_code);


--
-- TOC entry 5010 (class 2606 OID 18754)
-- Name: country country_pkey; Type: CONSTRAINT; Schema: locations; Owner: -
--

ALTER TABLE ONLY locations.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (country_id);


--
-- TOC entry 5013 (class 2606 OID 18756)
-- Name: state state_state_code_country_id_key; Type: CONSTRAINT; Schema: locations; Owner: -
--

ALTER TABLE ONLY locations.state
    ADD CONSTRAINT state_state_code_country_id_key UNIQUE (state_code, country_id);


--
-- TOC entry 5015 (class 2606 OID 18758)
-- Name: state states_pkey; Type: CONSTRAINT; Schema: locations; Owner: -
--

ALTER TABLE ONLY locations.state
    ADD CONSTRAINT states_pkey PRIMARY KEY (state_id);


--
-- TOC entry 5025 (class 2606 OID 18910)
-- Name: jobs jobs_apply_link_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_apply_link_key UNIQUE (apply_link);


--
-- TOC entry 5027 (class 2606 OID 18908)
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 4958 (class 1259 OID 18759)
-- Name: idx_company_id_image; Type: INDEX; Schema: companies; Owner: -
--

CREATE INDEX idx_company_id_image ON companies.company_image USING btree (company_id) WITH (deduplicate_items='true');


--
-- TOC entry 4965 (class 1259 OID 18760)
-- Name: idx_company_industry_id; Type: INDEX; Schema: companies; Owner: -
--

CREATE INDEX idx_company_industry_id ON companies.company_industry USING btree (company_id) WITH (deduplicate_items='true');


--
-- TOC entry 4953 (class 1259 OID 18761)
-- Name: idx_company_location_id; Type: INDEX; Schema: companies; Owner: -
--

CREATE INDEX idx_company_location_id ON companies.company USING btree (company_location_id) WITH (deduplicate_items='true');


--
-- TOC entry 4966 (class 1259 OID 18762)
-- Name: idx_industry_category_id; Type: INDEX; Schema: companies; Owner: -
--

CREATE INDEX idx_industry_category_id ON companies.company_industry USING btree (industry_category_id) WITH (deduplicate_items='true');


--
-- TOC entry 4969 (class 1259 OID 18763)
-- Name: idx_job_company; Type: INDEX; Schema: jobs; Owner: -
--

CREATE INDEX idx_job_company ON jobs.job USING btree (job_company) WITH (deduplicate_items='true');


--
-- TOC entry 4970 (class 1259 OID 18764)
-- Name: idx_job_company_location; Type: INDEX; Schema: jobs; Owner: -
--

CREATE INDEX idx_job_company_location ON jobs.job USING btree (job_company, job_location_id) WITH (deduplicate_items='true');


--
-- TOC entry 4971 (class 1259 OID 18765)
-- Name: idx_job_location; Type: INDEX; Schema: jobs; Owner: -
--

CREATE INDEX idx_job_location ON jobs.job USING btree (job_location_id) WITH (deduplicate_items='true');


--
-- TOC entry 5006 (class 1259 OID 18766)
-- Name: idx_city_state_id; Type: INDEX; Schema: locations; Owner: -
--

CREATE INDEX idx_city_state_id ON locations.city USING btree (state_id) WITH (deduplicate_items='true');


--
-- TOC entry 5011 (class 1259 OID 18767)
-- Name: idx_state_country_id; Type: INDEX; Schema: locations; Owner: -
--

CREATE INDEX idx_state_country_id ON locations.state USING btree (country_id) WITH (deduplicate_items='true');


--
-- TOC entry 5028 (class 2606 OID 18768)
-- Name: company company_company_location_id_fkey; Type: FK CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company
    ADD CONSTRAINT company_company_location_id_fkey FOREIGN KEY (company_location_id) REFERENCES locations.city(city_id);


--
-- TOC entry 5029 (class 2606 OID 18773)
-- Name: company_image company_image_company_id_fkey; Type: FK CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company_image
    ADD CONSTRAINT company_image_company_id_fkey FOREIGN KEY (company_id) REFERENCES companies.company(company_id) NOT VALID;


--
-- TOC entry 5030 (class 2606 OID 18778)
-- Name: company_industry company_industry_company_id_fkey; Type: FK CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company_industry
    ADD CONSTRAINT company_industry_company_id_fkey FOREIGN KEY (company_id) REFERENCES companies.company(company_id);


--
-- TOC entry 5031 (class 2606 OID 18783)
-- Name: company_industry company_industry_industry_category_id_fkey; Type: FK CONSTRAINT; Schema: companies; Owner: -
--

ALTER TABLE ONLY companies.company_industry
    ADD CONSTRAINT company_industry_industry_category_id_fkey FOREIGN KEY (industry_category_id) REFERENCES companies.industry_category(industry_category_id);


--
-- TOC entry 5034 (class 2606 OID 18788)
-- Name: job_category_map job_category_map_category_id_fkey; Type: FK CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_category_map
    ADD CONSTRAINT job_category_map_category_id_fkey FOREIGN KEY (category_id) REFERENCES jobs.job_category(job_category_id) ON DELETE CASCADE;


--
-- TOC entry 5035 (class 2606 OID 18793)
-- Name: job_category_map job_category_map_job_id_fkey; Type: FK CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_category_map
    ADD CONSTRAINT job_category_map_job_id_fkey FOREIGN KEY (job_id) REFERENCES jobs.job(job_id) ON DELETE CASCADE;


--
-- TOC entry 5032 (class 2606 OID 18798)
-- Name: job job_job_company_fkey; Type: FK CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job
    ADD CONSTRAINT job_job_company_fkey FOREIGN KEY (job_company) REFERENCES companies.company(company_id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 5033 (class 2606 OID 18803)
-- Name: job job_job_location_id_fkey; Type: FK CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job
    ADD CONSTRAINT job_job_location_id_fkey FOREIGN KEY (job_location_id) REFERENCES locations.city(city_id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 5036 (class 2606 OID 18808)
-- Name: job_salary_map job_salary_map_job_id_fkey; Type: FK CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_salary_map
    ADD CONSTRAINT job_salary_map_job_id_fkey FOREIGN KEY (job_id) REFERENCES jobs.job(job_id) ON DELETE CASCADE;


--
-- TOC entry 5037 (class 2606 OID 18813)
-- Name: job_salary_map job_salary_map_salary_id_fkey; Type: FK CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_salary_map
    ADD CONSTRAINT job_salary_map_salary_id_fkey FOREIGN KEY (salary_id) REFERENCES jobs.job_salary(job_salary_id) ON DELETE SET NULL;


--
-- TOC entry 5038 (class 2606 OID 18818)
-- Name: job_schedule_map job_schedule_map_job_id_fkey; Type: FK CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_schedule_map
    ADD CONSTRAINT job_schedule_map_job_id_fkey FOREIGN KEY (job_id) REFERENCES jobs.job(job_id) ON DELETE CASCADE;


--
-- TOC entry 5039 (class 2606 OID 18823)
-- Name: job_schedule_map job_schedule_map_schedule_id_fkey; Type: FK CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_schedule_map
    ADD CONSTRAINT job_schedule_map_schedule_id_fkey FOREIGN KEY (schedule_id) REFERENCES jobs.job_schedule(job_schedule_id) ON DELETE CASCADE;


--
-- TOC entry 5044 (class 2606 OID 18886)
-- Name: job_skill_map job_skill_map_job_id_fkey; Type: FK CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_skill_map
    ADD CONSTRAINT job_skill_map_job_id_fkey FOREIGN KEY (job_id) REFERENCES jobs.job(job_id);


--
-- TOC entry 5045 (class 2606 OID 18891)
-- Name: job_skill_map job_skill_map_skill_id_fkey; Type: FK CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_skill_map
    ADD CONSTRAINT job_skill_map_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES jobs.job_skill(job_skill_id);


--
-- TOC entry 5040 (class 2606 OID 18828)
-- Name: job_type_map job_type_map_job_id_fkey; Type: FK CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_type_map
    ADD CONSTRAINT job_type_map_job_id_fkey FOREIGN KEY (job_id) REFERENCES jobs.job(job_id) ON DELETE CASCADE;


--
-- TOC entry 5041 (class 2606 OID 18833)
-- Name: job_type_map job_type_map_type_id_fkey; Type: FK CONSTRAINT; Schema: jobs; Owner: -
--

ALTER TABLE ONLY jobs.job_type_map
    ADD CONSTRAINT job_type_map_type_id_fkey FOREIGN KEY (type_id) REFERENCES jobs.job_type(job_type_id) ON DELETE CASCADE;


--
-- TOC entry 5042 (class 2606 OID 18838)
-- Name: city cities_state_id_fkey; Type: FK CONSTRAINT; Schema: locations; Owner: -
--

ALTER TABLE ONLY locations.city
    ADD CONSTRAINT cities_state_id_fkey FOREIGN KEY (state_id) REFERENCES locations.state(state_id) ON DELETE CASCADE;


--
-- TOC entry 5043 (class 2606 OID 18843)
-- Name: state states_country_id_fkey; Type: FK CONSTRAINT; Schema: locations; Owner: -
--

ALTER TABLE ONLY locations.state
    ADD CONSTRAINT states_country_id_fkey FOREIGN KEY (country_id) REFERENCES locations.country(country_id) ON DELETE CASCADE NOT VALID;


-- Completed on 2025-04-27 14:44:28

--
-- PostgreSQL database dump complete
--

