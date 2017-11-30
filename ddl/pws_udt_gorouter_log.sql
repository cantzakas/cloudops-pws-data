DROP TABLE pws.pws_router_parsed_6mil ;

CREATE TABLE pws.pws_router_parsed_6mil
WITH (appendonly=true, compresstype=zlib, orientation=column, compresslevel=5) AS

WITH filtered AS ( 
    SELECT t.rawrecord FROM (
        SELECT 
            regexp_replace(rawrecord, '\\"', '"', 'g') as rawrecord
        FROM
            pws.pws_default
        WHERE 
            rawrecord not ilike '%route-emitter%' and
            rawrecord ilike '%x_b3_parentspanid%' and
            rawrecord ilike '%response_time%' and
            rawrecord ilike '%router%'
    ) t
),

parsed AS (
    SELECT regexp_matches(rawrecord, '<(\d+)>' ||            -- syslog severity
                       '([^\s]+)? +' ||                      -- syslog event time
                       '(\d+.{1}\d+.{1}\d+.{1}\d+) +' ||     -- syslog host ip
                       '([^\s+]*) +' ||                      -- syslog component
                       '\[job=(\w+) +?' ||                   -- syslog job string
                       'index=(\w+)\] +?' ||                 -- syslog index
                       '([^ ]+) - ' ||                       -- request host
                       '\[([0-9\:\-T\\+\.]+)\] +' ||         -- request timestamp
                       '"([^"])+" +' ||                      -- request string
                       '([0-9]+|-) +' ||                     -- request status code
                       '([0-9]+|-) +' ||                     -- bytes sent
                       '([0-9]+|-) +' ||                     -- bytes received
                       '"?([^"]+?|-)"? +' ||                 -- user agent
                       '"?([^"]+?|-)"? +' ||                 -- referrer      
                       '"(?:([0-9.]+):' ||                   -- source host
                       '(\d+)|-)" +' ||                      -- source port
                       '"(?:([0-9.-]+):' ||                  -- destination host
                       '(\d+)|-)" +' ||                      -- destination port
                       '[^:]+:"([^"]*)" +' ||                -- x_forwarded_for [host]
                       '[^:]+:"([^"]*)" +' ||                -- x_fordward_protocol
                       '[^:]+:"([^"]*)" +' ||                -- vcap request id
                       '[^:]+:([0-9.]+) +' ||                -- response time
                       '[^:]+:"?([^"]*)"? +' ||              -- application [gu]id
                       '[^:]+:"?([^"]*)"? +' ||              -- application index
                       '[^:]+:"?([^"]*)"? +' ||              -- x_b_3_traceId
                       '[^:]+:"?([^"]*)"? +' ||              -- x_b_3_spanId
                       '[^:]+:"?([^"]*)"?'                   -- x_b_3_parentSpanId
                      ) AS fields
    FROM
        filtered
),

structured AS (
    SELECT 
    
    --rawrecord,
    fields[1]::int AS syslogPriority,      
    fields[2]::text AS syslogEventTime,
    fields[3]::text AS syslogHostIp,
    fields[4]::text AS syslogComponent,
    fields[5]::text AS syslogJob,
    fields[6]::int AS syslogIndex,

    fields[7]::text AS requestingHost,

    fields[8]::text AS requestTimestamp,

    fields[9]::text AS requestString,

    fields[10]::text AS status,

    fields[11]::text AS bytesRecv,

    fields[12]::text AS bytesSent,

    fields[13]::text AS referrer,

    fields[14]::text AS userAgent,

    fields[15]::text AS sourceAddress,

    fields[16]::text AS sourcePort,

    fields[17]::text AS destinationAddress,

    fields[18]::text AS destinationPort,

    fields[19]::text AS xForwardedFor,

    fields[20]::text AS xForwardedProtol,

    fields[21]::text AS vcapRequestId,

    fields[22]::float AS responseTime,

    fields[23]::text AS applicationId,

    fields[24]::text AS applicationIndex,

    fields[25]::text AS x_b_3_traceId,

    fields[26]::text AS x_b_3_spanId,

    fields[27]::text AS x_b_3_parentSpanId

    FROM parsed
    LIMIT 6000000
)

--SELECT * FROM (
--    SELECT rawrecord FROM filtered limit 2
--) t
--UNION ALL

SELECT 
* 
FROM structured 
DISTRIBUTED RANDOMLY

-- output:
-- 6000000 rows affected.
-- CPU times: user 222 ms, sys: 166 ms, total: 388 ms
-- Wall time: 2h 14min 14s  
