DROP TYPE pws.elb_log_record CASCADE;

CREATE TYPE pws.elb_log_record AS 
(
	LogId uuid,
	LogTimestamp timestamptz,
	ELBName text,
	RequestIP inet,
	RequestPort int,
	BackendIP inet,
	BackendPort int,
	RequestProcessingTime float,
	BackendProcessingTime float,
	ClientResponseTime float,
	ELBResponseCode text,
	BackendResponseCode text,
	ReceivedBytes bigint,
	SentBytes bigint,
	RequestVerb text,
	URL text,
	Protocol text,
	ELBExtraInfo text,
	CipherSuite text,
	TLSVersion text
);
