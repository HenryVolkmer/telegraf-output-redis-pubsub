--
-- PostgreSQL database dump                                                                                            
--

-- Dumped from database version 16.2 (Debian 16.2-1.pgdg120+2)                                               
-- Dumped by pg_dump version 16.2 (Debian 16.2-1.pgdg120+2) 

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
                                                                                                                       
SET default_tablespace = '';

SET default_table_access_method = heap;  
                                                                                                                       
--
-- Name: acue_opcua_metrics; Type: TABLE; Schema: public; Owner: henry
--

CREATE TABLE public.acue_opcua_metrics (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title character varying(250),
    value numeric,
    measurement character varying(250),
    metric_start timestamp without time zone,
    metric_end timestamp without time zone,
    asset_id uuid
);


ALTER TABLE public.acue_opcua_metrics OWNER TO henry;

--
-- Name: acue_opcua_orders; Type: TABLE; Schema: public; Owner: henry
--

CREATE TABLE public.acue_opcua_orders (
)
INHERITS (public.acue_opcua_metrics);


ALTER TABLE public.acue_opcua_orders OWNER TO henry;

--
-- Data for Name: acue_opcua_metrics; Type: TABLE DATA; Schema: public; Owner: henry
--

COPY public.acue_opcua_metrics (id, title, value, measurement, metric_start, metric_end, asset_id) FROM stdin;
\.


--
-- Data for Name: acue_opcua_orders; Type: TABLE DATA; Schema: public; Owner: henry
--

COPY public.acue_opcua_orders (id, title, value, measurement, metric_start, metric_end, asset_id) FROM stdin;
\.


--
-- Name: acue_opcua_metrics acue_opcua_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: henry
--

ALTER TABLE ONLY public.acue_opcua_metrics
    ADD CONSTRAINT acue_opcua_metrics_pkey PRIMARY KEY (id);


--
-- Name: acue_opcua_orders acue_opcua_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: henry
--

ALTER TABLE ONLY public.acue_opcua_orders
    ADD CONSTRAINT acue_opcua_orders_pkey PRIMARY KEY (id); 


--
-- PostgreSQL database dump complete
--
