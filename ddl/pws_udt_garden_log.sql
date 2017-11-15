DROP TYPE IF EXISTS pws.garden_syslog_record CASCADE;

CREATE TYPE pws.garden_syslog_record AS 
(
	logId uuid,
	sysLogPriority int,
	sysLogEventTime timestamptz,
	sysLogHostIp inet,
	sysLogComponentString text,
	sysLogJobString text,
	sysLogIndexString text,
	extMsg json
);
