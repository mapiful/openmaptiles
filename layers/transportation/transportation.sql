CREATE OR REPLACE FUNCTION highway_is_link(highway text) RETURNS boolean AS
$$
SELECT highway LIKE '%_link';
$$ LANGUAGE SQL IMMUTABLE
                STRICT
                PARALLEL SAFE;


-- etldoc: layer_transportation[shape=record fillcolor=lightpink, style="rounded,filled",
-- etldoc:     label="<sql> layer_transportation |<z4> z4 |<z5> z5 |<z6> z6 |<z7> z7 |<z8> z8 |<z9> z9 |<z10> z10 |<z11> z11 |<z12> z12|<z13> z13|<z14_> z14+" ] ;
DROP FUNCTION IF EXISTS layer_transportation(geometry,integer);
CREATE FUNCTION layer_transportation(bbox geometry, zoom_level int)
    RETURNS TABLE
            (
                osm_id     bigint,
                geometry   geometry,
                class      text,
                ramp       int,
                oneway     int,
                brunnel    text,
                service    text
            )
AS
$$

SELECT osm_id,
   geometry,
   class,
   ramp,
   oneway,
   brunnel,
   service
FROM public.osm_transportation_z1_z3 AS t

WHERE geometry && bbox AND zoom_level IN (1, 2, 3)

UNION ALL

SELECT osm_id,
   geometry,
   class,
   ramp,
   oneway,
   brunnel,
   service
FROM public.osm_transportation_z4_z7 AS t

WHERE geometry && bbox AND zoom_level IN (4, 5, 6, 7)

UNION ALL

SELECT osm_id,
   geometry,
   class,
   ramp,
   oneway,
   brunnel,
   service
FROM public.osm_transportation_z8_z9 AS t

WHERE geometry && bbox AND zoom_level IN (8, 9)

UNION ALL

SELECT osm_id,
   geometry,
   class,
   ramp,
   oneway,
   brunnel,
   service
FROM public.osm_transportation_z10_plus AS t

WHERE geometry && bbox AND zoom_level >= 10
$$ LANGUAGE SQL STABLE
                -- STRICT
                PARALLEL SAFE;
