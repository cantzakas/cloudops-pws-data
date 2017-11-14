DROP TABLE IF EXISTS pws.pws_ccng_cef_parsed;

CREATE TABLE pws.pws_ccng_cef_parsed
WITH (appendonly=true, compresstype=zlib, orientation=column, compresslevel=5) 
AS SELECT logId,
	trunc(syslogPriority/8) AS syslogFacility,
	syslogPriority % 8 AS syslogSeverity,
	syslogEventTime,
	syslogHostIp,
	syslogComponentString,
	syslogJobString,
	syslogIndexString,
	extmsgCef,
	extmsgCloudFoundry,
	extmsgCFController, 
	extmsgValue1, 
	extmsgRT, 
	extmsgSUID, 
	extmsgRequest, 
	extmsgRequestMethod, 
	extmsgSource, 
	extmsgDestination, 
	extmsgCS1Label, 
	extmsgCS1, 
	extmsgCS2Label, 
	extmsgCS2, 
	extmsgCS3Label, 
	extmsgCS3, 
	extmsgCS4Label, 
	extmsgCS4, 
	extmsgCS5Label, 
	extmsgCS51, 
	extmsgCS52, 
	extmsgCS53	
FROM (
	SELECT (pws.plpy_parse_ccng_cef(rawrecord)).* 
	FROM pws.pws_ccng
	WHERE rawrecord LIKE '%CEF%'
	) A
WHERE logId IS NOT NULL
DISTRIBUTED BY (logId);
