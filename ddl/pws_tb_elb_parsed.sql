CREATE TABLE pws.pws_elb_parsed_250K
WITH (appendonly=true, compresstype=zlib, orientation=column, compresslevel=5) 
AS SELECT
	LogId,
	LogTimestamp,
	ELBName,
	RequestIP,
	RequestPort,
	BackendIP,
	BackendPort,
	RequestProcessingTime,
	BackendProcessingTime,
	ClientResponseTime,
	DECODE(ELBResponseCode, '-', NULL)::int AS ELBResponseCode,
	DECODE(BackendResponseCode, '-', NULL)::int AS BackendResponseCode, 
	ReceivedBytes,
	SentBytes,
	DECODE(RequestVerb, '-', NULL)::int AS RequestVerb,
	DECODE(URL, '-', NULL)::int AS URL,
	DECODE(Protocol, '-', NULL)::int AS Protocol,
	DECODE(ELBExtraInfo, '-', NULL)::int AS ELBExtraInfo,
	CipherSuite,
	TLSVersion
FROM (
	SELECT (pws.plpy_parse_elb(rawrecord)).* FROM pws.pws_elb LIMIT 250000)) A
DISTRIBUTED BY (LogId);
