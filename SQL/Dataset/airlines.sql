-- -------------------------------------
-- CSV Lint plug-in v0.4.6.4
-- File: airlines.csv
-- Date: 29-May-2023 21:55
-- SQL type: PostgreSQL
-- -------------------------------------
CREATE TABLE AIRLINES (
	IATA_CODE varchar(2) PRIMARY KEY,
	AIRLINE varchar(28)
);

-- -------------------------------------
-- insert records 1 - 14
-- -------------------------------------
insert into AIRLINES (
	IATA_CODE,
	AIRLINE
) values
('UA', 'United Air Lines Inc.'),
('AA', 'American Airlines Inc.'),
('US', 'US Airways Inc.'),
('F9', 'Frontier Airlines Inc.'),
('B6', 'JetBlue Airways'),
('OO', 'Skywest Airlines Inc.'),
('AS', 'Alaska Airlines Inc.'),
('NK', 'Spirit Air Lines'),
('WN', 'Southwest Airlines Co.'),
('DL', 'Delta Air Lines Inc.'),
('EV', 'Atlantic Southeast Airlines'),
('HA', 'Hawaiian Airlines Inc.'),
('MQ', 'American Eagle Airlines Inc.'),
('VX', 'Virgin America');
