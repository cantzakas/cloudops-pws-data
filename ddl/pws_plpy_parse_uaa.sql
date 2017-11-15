DROP FUNCTION pws.plpy_parse_uaa(text);

CREATE FUNCTION pws.plpy_parse_uaa(rawrecord text) 
RETURNS pws.uaa_syslog_record
AS $$
	import sys
	import re
	import uuid
	
	cleaner = lambda s: s.strip('"').replace(r'\"', r'"')
	
	SYSLOG_BASE = "<(\d+)>([^ ]+) +([^ ]+) +([^ ]+) +\[([^\]]+)+\].*"; # +";
	
	TIMESTAMP = "\[([^\]]+)\] uaa \- \d+ \[([^\]]+)\] +\.\.\.\. +([A-Z]+) +\-\-\- +([^:]+): ";
	EVENT_TYPE_LIST = ["ClientAuthenticationFailure",
		"ClientAuthenticationSuccess",
		"ClientDeleteSuccess",
		"Handling",
		"Login",
		"PrincipalAuthenticationFailure",
		"TokenIssuedEvent",
		"UserAuthenticationSuccess",
		"Java stacktrace strings"];

	EVENT_TYPE = "(?:" + "({})".format("|".join(EVENT_TYPE_LIST)) + " )";
	ENTITLEMENTS = "\(['\"]([^\)]+?)['\"]\):\"? ";
	PRINCIPAL = "principal\=([^,]+?), ";
	ORIGIN = "origin\=\[([^\]]+?)\], ";
	IDENTITY_ZONE = "identityZoneId\=\[([^\]]+?)\]";
	CATCH_ALL = "([^$]+)?";
	
	MSG_REGEX = SYSLOG_BASE + TIMESTAMP + EVENT_TYPE + ENTITLEMENTS + PRINCIPAL + ORIGIN + IDENTITY_ZONE + CATCH_ALL;
	
	m = re.compile(MSG_REGEX)
	
	try:
		g = m.match(cleaner(rawrecord)).groups()
	except AttributeError:
		return None
		
	result = [str(uuid.uuid1())] + list(g)
	
	return result
$$
LANGUAGE plpythonu IMMUTABLE;
