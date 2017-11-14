DROP FUNCTION IF EXISTS pws.plpy_parse_ccng_cef(text);

CREATE OR REPLACE FUNCTION pws.plpy_parse_ccng_cef(rawrecord text) 
RETURNS pws.ccng_cef_syslog_record
AS $$
	import sys
	import re
	import uuid
	
	cleaner = lambda s: s.strip('"').replace(r'\"', r'"')
	
	SYSLOG_BASE			=	"<(\d+)>([^ ]+) +([^ ]+) +([^ ]+) +\[job=([^\s]+)\s+index=([^\]])]\s+";
	EXTMSG_CEF			=	"([^\|]+)\|";
	EXTMSG_CF			=	"([^\|]+)\|";
	EXTMSG_CFC			=	"([^\|]+)\|";
	EXTMSG_VERSION		=	"([^\|]+)\|";
	EXTMSG_GET1			=	"([^\|]+)\|";
	EXTMSG_GET2			=	"([^\|]+)\|";
	EXTMSG_VAL1			=	"([^\|]+)\|";
	EXTMSG_RT			=	"\w+=(\S*)\s+";
	EXTMSG_SUSER		=	"\w+=(\S*)\s+";
	EXTMSG_SUID			=	"\w+=(\S*)\s+";
	EXTMSG_REQ			= 	"\w+=(\S*)\s+";
	EXTMSG_REQ_METHOD	=	"\w+=(\S*)\s+";
	EXTMSG_SRC			=	"\w+=(\S*)\s+";
	EXTMSG_DST			=	"\w+=(\S*)\s+";
	EXTMSG_CS1_LABEL	=	"\w+=(\S*)\s+";
	EXTMSG_CS1			=	"\w+=(\S*)\s+";
	EXTMSG_CS2_LABEL	=	"\w+=(\S*)\s+";
	EXTMSG_CS2			=	"\w+=(\S*)\s+";
	EXTMSG_CS3_LABEL	=	"\w+=(\S*)\s+";
	EXTMSG_CS3			=	"\w+=(\S*)\s+";
	EXTMSG_CS4_LABEL	=	"\w+=(\S*)\s+";
	EXTMSG_CS4			=	"\w+=(\S*)\s+";
	EXTMSG_CS5_LABEL	=	"\w+=(\S*)\s+";
	EXTMSG_CS5_1		=	"\w+=(\S*),";
	EXTMSG_CS5_2		=	"([^,]+),";
	EXTMSG_CS5_3		=	"\s+([^$]+)";
	
	MSG_REGEX = SYSLOG_BASE	+ EXTMSG_CEF + EXTMSG_CF + EXTMSG_CFC + EXTMSG_VERSION + EXTMSG_GET1 + EXTMSG_GET2 + EXTMSG_VAL1 + EXTMSG_RT + EXTMSG_SUSER + EXTMSG_SUID + EXTMSG_REQ + EXTMSG_REQ_METHOD + EXTMSG_SRC + EXTMSG_DST + EXTMSG_CS1_LABEL + EXTMSG_CS1 + EXTMSG_CS2_LABEL + EXTMSG_CS2 + EXTMSG_CS3_LABEL + EXTMSG_CS3 + EXTMSG_CS4_LABEL + EXTMSG_CS4 + EXTMSG_CS5_LABEL + EXTMSG_CS5_1 + EXTMSG_CS5_2 + EXTMSG_CS5_3	;
	
	m = re.compile(MSG_REGEX)
	
	try:
		g = m.match(cleaner(rawrecord)).groups()
	except AttributeError:
		return None
	result = [str(uuid.uuid1())] + list(g)
	
	return result
$$
LANGUAGE plpythonu IMMUTABLE;
