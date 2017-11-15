DROP FUNCTION IF EXISTS pws.plpy_parse_garden(text);

CREATE OR REPLACE FUNCTION pws.plpy_parse_garden(rawrecord text) 
RETURNS pws.garden_syslog_record
AS $$
	import sys
	import re
	import uuid
	
	cleaner = lambda s: s.strip('"').replace(r'\"', r'"')
	
	SYSLOG_BASE = "<(\d+)>([^ ]+) +([^ ]+) +([^ ]+) +\[job=([^\s]+)\s+index=([^]]*)]\s+"
	EXTMSG = "({.*}{2,})*"

	MSG_REGEX = SYSLOG_BASE + EXTMSG
	
	m = re.compile(MSG_REGEX)
	
	try:
		g = m.match(cleaner(rawrecord)).groups()
	except AttributeError:
		return None
		
	result = [str(uuid.uuid1())] + list(g)
	
	return result
$$
LANGUAGE plpythonu IMMUTABLE;
