CREATE OR REPLACE VIEW pws.vw_lkup_facility AS (
SELECT '0'::int AS code,  'kernel messages' AS desc UNION
SELECT '1'::int AS code,  'user-lever messages' AS desc UNION
SELECT '2'::int AS code,  'mail system' AS desc UNION
SELECT '3'::int AS code,  'system daemons' AS desc UNION
SELECT '4'::int AS code,  'security/authorization messages' AS desc UNION
SELECT '5'::int AS code,  'messages generated internally by syslog' AS desc UNION
SELECT '6'::int AS code,  'line printer subsystem' AS desc UNION
SELECT '7'::int AS code,  'network news subsystem' AS desc UNION
SELECT '8'::int AS code,  'UUCP subsystem' AS desc UNION
SELECT '9'::int AS code,  'clock daemon' AS desc UNION
SELECT '10'::int AS code, 'security/authorization messages' AS desc UNION
SELECT '11'::int AS code, 'FTP daemon' AS desc UNION
SELECT '12'::int AS code, 'NTP subsystem' AS desc UNION
SELECT '13'::int AS code, 'log audit' AS desc UNION
SELECT '14'::int AS code, 'log alert' AS desc UNION
SELECT '15'::int AS code, 'clock daemon (note 2)' AS desc UNION
SELECT '16'::int AS code, 'local use 0  (local0)' AS desc UNION
SELECT '17'::int AS code, 'local use 1  (local1)' AS desc UNION
SELECT '18'::int AS code, 'local use 2  (local2)' AS desc UNION
SELECT '19'::int AS code, 'local use 3  (local3)' AS desc UNION
SELECT '20'::int AS code, 'local use 4  (local4)' AS desc UNION
SELECT '21'::int AS code, 'local use 5  (local5)' AS desc UNION
SELECT '22'::int AS code, 'local use 6  (local6)' AS desc UNION
SELECT '23'::int AS code, 'local use 7  (local7)' AS desc)
