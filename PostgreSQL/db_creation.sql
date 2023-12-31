
----------------------------------------------------------
----------------- Import EOD (End of Day) Quotes ---------
----------------------------------------------------------

/*
-- LIFELINE
-- DROP TABLE public.eod_quotes;

CREATE TABLE public.eod_quotes
(
    ticker character varying(16) COLLATE pg_catalog."default" NOT NULL,
    date date NOT NULL,
    adj_open real,
    adj_high real,
    adj_low real,
    adj_close real,
    adj_volume numeric,
    CONSTRAINT eod_quotes_pkey PRIMARY KEY (ticker, date)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eod_quotes
    OWNER to postgres;
*/

-- Check
SELECT * FROM eod_quotes LIMIT 10;
SELECT COUNT(*) FROM eod_quotes; 
SELECT MIN(date), MAX(date) FROM eod_quotes; -- Project date range 01/01/2016 - 03/26/2021


-------------------------------------------------------------------------
------------------ Import daily index data ------------------------------
-------------------------------------------------------------------------

/*

LIFELINE:

-- DROP TABLE public.eod_indices;

CREATE TABLE public.eod_indices
(
    symbol character varying(16) COLLATE pg_catalog."default" NOT NULL,
    date date NOT NULL,
    open real,
    high real,
    low real,
    close real,
    adj_close real,
    volume double precision,
    CONSTRAINT eod_indices_pkey PRIMARY KEY (symbol, date)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eod_indices
    OWNER to postgres;

*/

-- Check
SELECT * FROM eod_indices LIMIT 10;

-----------------------------------------------------------------------------------
---------------- Create and upload a custom trading day calendar  ------------------
------------------------------------------------------------------------------------
/*
LIFELINE:
-- DROP TABLE public.custom_calendar;

CREATE TABLE public.custom_calendar
(
    date date NOT NULL,
    y integer,
    m integer,
    d integer,
    dow character varying(3) COLLATE pg_catalog."default",
    trading smallint,
    CONSTRAINT custom_calendar_pkey PRIMARY KEY (date)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.custom_calendar
    OWNER to postgres;
*/
-- CHECK:
SELECT * FROM custom_calendar LIMIT 10;

-- Creating a column to be used later: prev_trading_day
/*
-- LIFELINE
ALTER TABLE public.custom_calendar
    ADD COLUMN eom smallint;

ALTER TABLE public.custom_calendar
    ADD COLUMN prev_trading_day date;
*/
-- CHECK:
SELECT * FROM custom_calendar LIMIT 10;

-- Identify trading days
SELECT * FROM custom_calendar WHERE trading=1;
-- Identify previous trading days via a nested query
SELECT date, (SELECT MAX(CC.date) FROM custom_calendar CC 
			  WHERE CC.trading=1 AND CC.date<custom_calendar.date) ptd 
			  FROM custom_calendar;
-- Update the table with new data 
UPDATE custom_calendar
SET prev_trading_day = PTD.ptd
FROM (SELECT date, (SELECT MAX(CC.date) FROM custom_calendar CC WHERE CC.trading=1 AND CC.date<custom_calendar.date) ptd FROM custom_calendar) PTD
WHERE custom_calendar.date = PTD.date;
-- CHECK
SELECT * FROM custom_calendar ORDER BY date;
-- Add the last trading day of 2015 as the end of the month
INSERT INTO custom_calendar VALUES('2015-12-31',2015,12,31,'Thu',1,1,NULL);
-- Re-run the update
-- CHECK again
SELECT * FROM custom_calendar ORDER BY date;


-------------------------------------------
-- Create a role for the database  --------
-------------------------------------------
-- rolename: rolename
-- password: password

/*
-- LIFELINE:
-- REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM rolename;
-- DROP USER rolename;

CREATE USER rolename WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	PASSWORD 'password';
*/

GRANT SELECT ON ALL TABLES IN SCHEMA public TO rolename;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
   GRANT SELECT ON TABLES TO rolename;

