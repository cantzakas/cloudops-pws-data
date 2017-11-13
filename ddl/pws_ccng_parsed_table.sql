DROP TABLE IF EXISTS pws.pws_ccng_parsed_250K;

CREATE TABLE pws.pws_ccng_parsed_250K
WITH (appendonly=true, compresstype=zlib, orientation=column, compresslevel=5) 
AS SELECT logId,
	trunc(syslogPriority/8) AS syslogFacility,
	syslogPriority % 8 AS syslogSeverity,
	syslogEventTime,
	syslogHostIp,
	syslogComponentString,
	syslogJobString,
	syslogIndexString,
	extmsgTimestamp,
	extmsgMessage,
	extmsgLevel,
	extmsgSource,
	extmsgData, 
	extmsgThreadId,
	extmsgFiberId,
	extmsgProcessId,
	extmsgFile,
	extmsgLineNo,
	extmsgMethod
FROM (
	SELECT (pws.plpy_parse_ccng(rawrecord)).* FROM pws.pws_ccng LIMIT 250000
	) A
DISTRIBUTED BY (logId);
