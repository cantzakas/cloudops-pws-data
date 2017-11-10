DROP FUNCTION IF EXISTS pws.plpy_parse_elb(text);

CREATE OR REPLACE FUNCTION pws.plpy_parse_elb(rawrecord text) 
RETURNS pws.elb_log_record
AS $$

import sys
import re
import uuid

cleaner = lambda s: s.strip('"').replace(r'\"', r'"')

MSG_REGEX = "([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*):([0-9]*) ([.0-9]*) ([.0-9]*) ([.0-9]*) (-|[0-9]*) (-|[0-9]*) ([-0-9]*) ([-0-9]*) \"([^ ]*) ([^ ]*) (- |[^ ]*)\" \"([^ ].*)\" (- |[^ ]*) (- |[^ ]*)"

m = re.compile(MSG_REGEX)

try:
	g = m.match(cleaner(rawrecord)).groups()
except AttributeError:
return None
 
result = [str(uuid.uuid1())] + list(g)

return result
$$
LANGUAGE plpythonu IMMUTABLE;
