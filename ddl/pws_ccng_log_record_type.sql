DROP TYPE pws.ccng_syslog_record CASCADE ;

CREATE TYPE pws.ccng_syslog_record AS 
(
	logId uuid,
	syslogPriority int,
	syslogEventTime timestamptz,
	syslogHostIp inet,
	syslogComponentString text,
	syslogJobString text,
	syslogIndexString text,
	extmsgTimestamp timestamp,
	extmsgMessage text,
	extmsgLevel text,
	extmsgSource text,
	extmsgData text, 
	extmsgThreadId text,
	extmsgFiberId text,
	extmsgProcessId text,
	extmsgFile text,
	extmsgLineNo text,
	extmsgMethod text
);
