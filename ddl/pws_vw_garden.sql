DROP VIEW IF EXISTS pws.pws_vw_garden;

CREATE OR REPLACE VIEW pws.pws_vw_garden AS 
SELECT syslogFacility,
	syslogSeverity,
	sysLogEventTime,
	sysLogHostIp,
	syslogComponent,
	syslogJob,
	syslogIndex,
	extMsg->>'timestamp' AS extMsgEpoch,
	extMsg->>'source' AS extMsgSource,
	extMsg->>'message'AS extMsgMessage,
	extMsg->>'log_level' AS extMsgLogLevel,
	extMsg->>'data' AS extMsgDataJson,
	extMsg#>>'{data,handle}' AS extMsgHandle,
	extMsg#>>'{data,id}' AS extMsgId,
	extMsg#>>'{data,path}' AS extMsgPath,
	extMsg#>>'{data,imageID}' AS extMsgImageId,
	extMsg#>>'{data,session}' AS extMsgSession,
	extMsg#>>'{data,namespaced}' AS extMsgNamespace,
	extMsg#>>'{data,original_timestamp}' AS extMsgOriginalTS,
	extMsg#>'{data,spec}' AS extMsgSpec,
	extMsg->>'rawrecord' AS extMsgException
FROM
	pws.pws_garden_parsed_sqlregexp;
