CREATE TABLE pws.pws_uaa_parsed
WITH (appendonly=true, compresstype=zlib, orientation=column, compresslevel=5) 
AS SELECT logId,
	trunc(syslogPriority/8) AS syslogFacility,
	syslogPriority % 8 AS syslogSeverity,
	syslogEventTime,
	syslogHostIp,
	syslogComponentString,
	syslogJobString,
	messageTime,
	logMessagePrefix,
	logLevel,
	uaaLogType,
	uaaEvent,
	uaaEntitlements,
	uaaPrincipal,
	uaaOrigin,
	uaaIdentityZone,
	logMessageCatchAll
FROM (
	SELECT (pws.plpy_parse_uaa(rawrecord)).* 
	FROM pws.pws_uaa
	LIMIT 250000) A
DISTRIBUTED BY (logId) ;
