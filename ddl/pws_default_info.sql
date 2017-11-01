DROP VIEW public.pws_default_info;

CREATE OR REPLACE VIEW public.pws_default_info AS
SELECT log_header[1]::bigint AS log_master_id
, log_header[2]::timestamp AS log_dtts
, TO_CHAR(log_header[2]::timestamp, 'DD/MM/YYYY') AS log_dt
, TO_CHAR(log_header[2]::timestamp, 'HH24:MM:SS.US') AS log_tm
, log_header[3]::inet AS log_ip
, log_header[4]::text AS log_other
, SUBSTRING(log_header[5] FROM 5)::text AS log_job
, SUBSTRING(log_header[6] FROM 7)::int AS log_index
, log_details
FROM (
SELECT regexp_split_to_array(regexp_replace(replace(split_part(rawrecord, '  ', 1), '>', ' '), '["<[\]]', '', 'g'), E'\\s+') AS log_header, split_part(rawrecord, '  ', 2) AS log_details
FROM public.pws_default
) A;
