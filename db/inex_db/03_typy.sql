-- Type: country_t

-- DROP TYPE country_t;

CREATE TYPE country_t AS
   (co_id character varying(8),
    co_name character varying(32),
    co_continent character varying(16));
ALTER TYPE country_t OWNER TO inex;



-- Type: workcamp_intention_t

-- DROP TYPE workcamp_intention_t;

CREATE TYPE workcamp_intention_t AS
   (wi_id character varying(16),
    wi_namecz character varying(128));
ALTER TYPE workcamp_intention_t OWNER TO inex;
