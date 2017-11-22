DROP VIEW IF EXISTS pws.pws_vw_rep;

CREATE OR REPLACE VIEW pws.pws_vw_rep AS 
SELECT syslogId,
	syslogFacility,
	syslogSeverity,
	sysLogEventTime,
	sysLogHostIp,
	syslogComponent,
	syslogJob,
	syslogIndex,
	syslogEpoch,
	syslogSrc,
	syslogMsg,
	syslogLogLevel,
	lgKV AS extMsgDataJson,
	lgKV->>'cancelled' AS kvCancelled,
	lgKV->>'container-guid' AS kvContainerGuid,
	lgKV->>'container-state' AS kvContainerState,
	lgKV->>'guid' AS kvGuid,
	lgKV->>'lrp-instance-key' AS kvLrpInstanceKey,
	lgKV->>'lrp-key' AS kvLrpKey,
	lgKV->>'method' AS kvMethod,
	lgKV->>'request' AS kvRequest,
	lgKV->>'session' AS kvSession,
	lgKV->>'rawrecord' AS syslogRawrecord
FROM
	pws.pws_rep_parsed_sqlregexp;
