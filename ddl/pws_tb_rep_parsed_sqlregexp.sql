DROP TABLE IF EXISTS pws.pws_rep_parsed_sqlregexp;

CREATE TABLE pws.pws_rep_parsed_sqlregexp
WITH (appendonly=true, compresstype=zlib, orientation=column, compresslevel=5) AS	
	SELECT pws.plpy_uuid() AS syslogId,
		trunc(lgBase[1]::int/8) AS syslogFacility,
		lgBase[1]::int % 8 AS syslogSeverity,
		lgBase[2]::timestamptz AS sysLogEventTime,
		lgBase[3]::inet AS sysLogHostIp,
		lgBase[4]::text AS syslogComponent,
		lgBase[5]::text AS syslogJob,
		lgBase[6]::int AS syslogIndex,
		lgExtended[1]::float AS syslogEpoch,
		lgExtended[2]::text AS syslogSrc,
		lgExtended[3]::text AS syslogMsg,
		lgExtended[4]::int AS syslogLogLevel,
		lgKeyValues AS lgKV
	FROM (
	SELECT (SELECT regexp_matches(rawrecord, '\<(\d+)\>([^ ]+) ([^ ]+) ([^ ]+) \[[^=]*=([^ ]*) [^=]*=([^ ]*)\]')) AS lgBase,
		(SELECT regexp_matches(regexp_replace(rawrecord, '[\\]+"', '"', 'g'), '{\"timestamp\":\"([^\"]+)?\",\"source\":\"([^\"]+)?\",\"message\":\"([^\"]+)?\",\"log_level\":([^,]+),?')) AS lgExtended,
		CASE WHEN 
			(SELECT regexp_matches(rawrecord, '(Type)+|(''\\\\\\\")+|(\\\\\\\"'')+')) IS NULL 
		THEN 
			('{' || (SELECT regexp_matches(regexp_replace(rawrecord, '[\\]+"', '"', 'g'), '\"data\":{(.*)}}'))[1] || '}')::json 
		ELSE
			('{"rawrecord":"' || (SELECT regexp_matches(regexp_replace(rawrecord, '[\\]+|['']+|[\"]+', '', 'g'), ']\s*(.*)'))[1] || '"}')::json
		END AS lgKeyValues
	FROM pws.pws_rep
	LIMIT 5000000
	) A
DISTRIBUTED BY (syslogId);
