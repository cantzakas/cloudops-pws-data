DROP FUNCTION IF EXISTS pws.plpy_parse_ccng(text);

CREATE OR REPLACE FUNCTION pws.plpy_parse_ccng(rawrecord text) 
RETURNS pws.ccng_syslog_record
AS $$
	import sys
	import re
	import uuid
	
	cleaner = lambda s: s.strip('"').replace(r'\"', r'"')
	
	SYSLOG_BASE		=	"<(\d+)>([^ ]+) +([^ ]+) +([^ ]+) +\[job=([^\s]+)\s+index=([^\]])]\s+";
	EXTMSG_TS		=	"{\"timestamp\":(\d+.\d+),";
	EXTMSG_MSG		=	"\"message\":\"([^\"]+)\",";
	EXTMSG_LEVEL	=	"\"log_level\":\"(\w+)\",";
	EXTMSG_SRC		=	"\"source\":\"([^,]+)\",";
	EXTMSG_DATA		=	"\"data\":{([^}]*)},";
	EXTMSG_THREADID	=	"\"thread_id\":(\w+),";
	EXTMSG_FIBERID	=	"\"fiber_id\":(\w+),";
	EXTMSG_PROCID	=	"\"process_id\":(\w+),";
	EXTMSG_FILE		=	"\"file\":\"([^\"]+)\",";
	EXTMSG_LINENO	=	"\"lineno\":(\d+),";
	EXTMSG_METHOD	=	"\"method\":\"([^\"]+)\"}";
	
	MSG_REGEX = SYSLOG_BASE + EXTMSG_TS + EXTMSG_MSG + EXTMSG_LEVEL + EXTMSG_SRC + EXTMSG_DATA + EXTMSG_THREADID + EXTMSG_FIBERID + EXTMSG_PROCID + EXTMSG_FILE + EXTMSG_LINENO + EXTMSG_METHOD;
	
	m = re.compile(MSG_REGEX)
	
	try:
		g = m.match(cleaner(rawrecord)).groups()
	except AttributeError:
		return None

	result = [str(uuid.uuid1())] + list(g)
	
	return result
$$
LANGUAGE plpythonu IMMUTABLE;
