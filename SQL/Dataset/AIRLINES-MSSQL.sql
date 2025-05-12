-- -------------------------------------
-- CSV Lint plug-in v0.4.6.4
-- File: airlines.csv
-- Date: 05-Jun-2023 22:55
-- SQL type: MS-SQL
-- -------------------------------------
CREATE TABLE AIRLINES (
	_record_number 
	IATA_CODE varchar(2),
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
