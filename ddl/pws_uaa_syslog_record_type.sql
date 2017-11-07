DROP TYPE pws.uaa_syslog_record CASCADE ;

CREATE TYPE pws.uaa_syslog_record AS 
(
	logId uuid,
	syslogPriority int,
	syslogEventTime timestamptz,
	syslogHostIp inet,
	syslogComponentString text,
	syslogJobString text,
	messageTime timestamp,
	logMessagePrefix text,
	logLevel text,
	uaaLogType text,
	uaaEvent text,
	uaaEntitlements text,
	uaaPrincipal text,
	uaaOrigin text,
	uaaIdentityZone text,
	logMessageCatchAll text
);
