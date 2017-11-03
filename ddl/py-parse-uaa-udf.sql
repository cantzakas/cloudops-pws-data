DROP FUNCTION public.pyparse_uaa(text);

CREATE OR REPLACE FUNCTION public.pyparse_uaa (IN _row TEXT) RETURNS TEXT[] AS $$
import re

types = ['ClientAuthenticationFailure','ClientAuthenticationSuccess','ClientDeleteSuccess','Handling','Login','PrincipalAuthenticationFailure','TokenIssuedEvent','UserAuthenticationSuccess','Java stacktrace strings' ]

lgBasePattern = '\<(\d+)\>([^ ]+) ([^ ]+) ([^ ]+) \[([^\]]+)+\]';
uaaTimestamp = '  (?:\[([^\]]+)+\] uaa \- \d+ \[([^\]]+)+\] \.\.\.\.  ([A-Z]+) \-\-\- Audit: )?'
eventType = '"?({0})? ?'.format("|".join(types))
entitlements = '\(?\'?\[?([^\] ]+)?\]?\'?\)?\:?"?'
principal = '(?: principal\=([^,]+),)?'
origin = '(?: origin\=\[([^\]]+)\])?'
identityZone = '(?:\, identityZoneId\=\[([^\]]+)\])?'
catchAll = '([^$]+)?'

pat = lgBasePattern + uaaTimestamp + eventType + entitlements + principal + origin + identityZone + catchAll

m = re.compile(pat)
return m.match(_row).groups() 
$$ 
LANGUAGE 'plpythonu';
