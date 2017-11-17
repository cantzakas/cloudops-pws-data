DROP TABLE IF EXISTS pws.pws_garden_parsed_sqlregexp;

CREATE TABLE pws.pws_garden_parsed_sqlregexp
WITH (appendonly=true, compresstype=zlib, orientation=column, compresslevel=5) AS
SELECT trunc(syslogPriority/8) AS syslogFacility,
	syslogPriority % 8 AS syslogSeverity,
	sysLogEventTime,
	sysLogHostIp,
	syslogComponent,
	syslogJob,
	syslogIndex,
	extMsg
FROM (
	SELECT (SELECT regexp_matches(rawrecord, '<(\d+)>'))[1]::int AS syslogPriority,
	(SELECT regexp_matches(rawrecord, '<\d+>([^\s]+)'))[1]::timestamptz AS syslogEventTime,
	(SELECT regexp_matches(rawrecord, '\S+\s+(\d+.{1}\d+.{1}\d+.{1}\d+)'))[1]::inet AS syslogHostIp,
	(SELECT regexp_matches(rawrecord, '\S+\s+\S+\s+([^\s+]*)\s+'))[1]::text AS syslogComponent,
	(SELECT regexp_matches(rawrecord, '.+\[job=(\w+)\s'))[1]::text AS syslogJob,
	(SELECT regexp_matches(rawrecord, '.+index=(\w+)\]'))[1]::int AS syslogIndex,
	CASE WHEN character_length(regexp_replace(rawrecord, '[^{]', '', 'g')) = character_length(regexp_replace(rawrecord, '[^}]', '', 'g'))
	THEN (SELECT regexp_matches(regexp_replace(rawrecord, '\\"', '"', 'g'), '({.*{.*}{2,})'))[1]::json
	ELSE ('{"rawrecord":"' || regexp_replace((SELECT regexp_matches(rawrecord, ']\s+(.*)'))[1]::text, '\\"', '\"', 'g') || '}')::json
	END AS extMsg
	FROM pws.pws_garden
	LIMIT 5000000
) A
DISTRIBUTED RANDOMLY;
