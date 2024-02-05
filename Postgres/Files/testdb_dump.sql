--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

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
-- Name: post; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.post AS ENUM (
    'worker',
    'admin'
);


ALTER TYPE public.post OWNER TO postgres;

--
-- Name: get_employ_info(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_employ_info(employ_id integer) RETURNS TABLE(name text, post text)
    LANGUAGE sql
    AS $$
    SELECT
        CONCAT(firstname, ' ', lastname) AS name,
        employ.post::TEXT as post
    FROM
        employ
    WHERE
        employ.id = employ_id;
$$;


ALTER FUNCTION public.get_employ_info(employ_id integer) OWNER TO postgres;

--
-- Name: get_employee_info_uppercase(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_employee_info_uppercase() RETURNS TABLE(lastname_upper text, salary numeric)
    LANGUAGE sql
    AS $$
    SELECT
        UPPER(employ.lastname) AS lastname_upper,
        employ.salary
    FROM
        employ;
$$;


ALTER FUNCTION public.get_employee_info_uppercase() OWNER TO postgres;

--
-- Name: get_employees_by_salary(numeric, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_employees_by_salary(min_salary numeric, max_salary numeric) RETURNS TABLE(id integer, firstname text, lastname text, salary numeric)
    LANGUAGE sql
    AS $$
    SELECT
        employ.id,
        employ.firstname,
        employ.lastname,
        employ.salary
    FROM
        employ
    WHERE
        employ.salary BETWEEN min_salary AND max_salary;
$$;


ALTER FUNCTION public.get_employees_by_salary(min_salary numeric, max_salary numeric) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: employ; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employ (
    id integer NOT NULL,
    firstname text,
    lastname text,
    workdays integer[],
    post public.post,
    salary numeric(7,2),
    vacation_startdate date,
    vacation_duration integer,
    birthdate date
);


ALTER TABLE public.employ OWNER TO postgres;

--
-- Name: employ_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employ_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employ_id_seq OWNER TO postgres;

--
-- Name: employ_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employ_id_seq OWNED BY public.employ.id;


--
-- Name: geo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geo (
    id integer NOT NULL,
    parent_id integer,
    name character varying(1000)
);


ALTER TABLE public.geo OWNER TO postgres;

--
-- Name: table1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.table1 (
    id integer,
    name character(8)
);


ALTER TABLE public.table1 OWNER TO postgres;

--
-- Name: table2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.table2 (
    id integer,
    name character(8)
);


ALTER TABLE public.table2 OWNER TO postgres;

--
-- Name: tran_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tran_table (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.tran_table OWNER TO postgres;

--
-- Name: tran_table_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tran_table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tran_table_id_seq OWNER TO postgres;

--
-- Name: tran_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tran_table_id_seq OWNED BY public.tran_table.id;


--
-- Name: employ id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employ ALTER COLUMN id SET DEFAULT nextval('public.employ_id_seq'::regclass);


--
-- Name: tran_table id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tran_table ALTER COLUMN id SET DEFAULT nextval('public.tran_table_id_seq'::regclass);


--
-- Data for Name: employ; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employ (id, firstname, lastname, workdays, post, salary, vacation_startdate, vacation_duration, birthdate) FROM stdin;
1	Alice	Smith	{1,1,1,1,1,0,0}	worker	5500.00	2023-03-01	14	1992-03-01
6	Frank	Miller	{1,1,1,0,1,1,0}	worker	6200.00	2023-07-01	7	1997-07-01
3	Charlie	Williams	{1,1,1,1,1,1,0}	worker	7000.00	2023-04-15	7	1993-04-01
2	Bob	Johnson	{1,0,1,0,1,1,0}	admin	6000.00	2023-03-15	10	1992-10-15
4	David	Brown	{1,1,0,1,1,1,0}	admin	5000.00	2023-05-01	21	1995-05-01
5	Eva	Davis	{1,0,1,0,1,0,1}	admin	5800.00	2023-06-01	14	1996-06-01
7	Grace	Anderson	{1,1,1,1,1,0,0}	admin	6800.00	2023-08-01	14	1998-08-01
9	Ivy	Johnson	{1,1,1,1,1,0,0}	admin	5200.00	2023-10-01	14	2000-10-01
10	Jack	Harris	{1,1,1,1,1,0,0}	admin	7500.00	2023-11-01	14	2001-11-01
8	Harry	White	{1,1,1,1,1,0,0}	worker	6200.00	2023-09-01	14	1999-09-01
\.


--
-- Data for Name: geo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.geo (id, parent_id, name) FROM stdin;
1	\N	Планета Земля
2	1	Континент Евразия
3	1	Континент Северная Америка
4	2	Европа
5	4	Россия
6	4	Германия
7	5	Москва
8	5	Санкт-Петербург
9	6	Берлин
\.


--
-- Data for Name: table1; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.table1 (id, name) FROM stdin;
1	fff     
2	ddd     
3	aaa     
\.


--
-- Data for Name: table2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.table2 (id, name) FROM stdin;
\.


--
-- Data for Name: tran_table; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tran_table (id, name) FROM stdin;
1	DENIS KUKOYAKA
\.


--
-- Name: employ_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employ_id_seq', 10, true);


--
-- Name: tran_table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tran_table_id_seq', 9, true);


--
-- Name: geo geo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo
    ADD CONSTRAINT geo_pkey PRIMARY KEY (id);


--
-- Name: geo geo_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo
    ADD CONSTRAINT geo_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.geo(id);


--
-- PostgreSQL database dump complete
--

