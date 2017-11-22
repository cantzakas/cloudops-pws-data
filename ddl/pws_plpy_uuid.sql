CREATE OR REPLACE FUNCTION pws.plpy_uuid()
RETURNS text
AS $$
	import uuid
	return str(uuid.uuid1())
$$
LANGUAGE plpythonu IMMUTABLE;
