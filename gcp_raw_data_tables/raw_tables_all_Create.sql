#US mask survey
CREATE TABLE `ny_US_mask_survey` (
  `COUNTYFP` int NOT NULL,
  `NEVER` decimal(5,5) DEFAULT NULL,
  `RARELY` decimal(5,5) DEFAULT NULL,
  `SOMETIMES` decimal(5,5) DEFAULT NULL,
  `FREQUENTLY` decimal(5,5) DEFAULT NULL,
  `ALWAYS` decimal(5,5) DEFAULT NULL,
  PRIMARY KEY (`COUNTYFP`)
);

#US national level
CREATE TABLE `ny_US_national_level` (
  `date` datetime NOT NULL,
  `cases` int DEFAULT NULL,
  `deaths` int DEFAULT NULL,
  PRIMARY KEY (`date`)
);

#US state level
CREATE TABLE `ny_US_state_level` (
  `date` datetime NOT NULL,
  `state` varchar(45) DEFAULT NULL,
  `fips` int NOT NULL,
  `cases` int DEFAULT NULL,
  `deaths` int DEFAULT NULL,
  PRIMARY KEY (`date`,`fips`)
);

#US county level
CREATE TABLE `ny_US_county_level` (
  `date` datetime NOT NULL,
  `county` varchar(45) NOT NULL,
  `state` varchar(45) NOT NULL,
  `fips` int DEFAULT NULL,
  `cases` int DEFAULT NULL,
  `deaths` int DEFAULT NULL,
  PRIMARY KEY (`date`,`county`,`state`)
);

#US county recent
CREATE TABLE `ny_US_county_recent` (
  `date` datetime NOT NULL,
  `county` varchar(45) NOT NULL,
  `state` varchar(45) NOT NULL,
  `fips` int DEFAULT NULL,
  `cases` int DEFAULT NULL,
  `deaths` int DEFAULT NULL,
  PRIMARY KEY (`date`,`county`,`state`)
);

#US colleges and universities
CREATE TABLE `ny_US_colleges_univ` (
  `date` datetime NOT NULL,
  `state` varchar(45) DEFAULT NULL,
  `county` varchar(45) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  `ipeds_id` int NOT NULL,
  `college` varchar(500) DEFAULT NULL,
  `cases` int DEFAULT NULL,
  `cases_2021` decimal(10,2) DEFAULT NULL,
  `notes` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`date`,`ipeds_id`)
);

#US excess deaths by all causes
CREATE TABLE `ny_US_excessDeaths_byAllCauses` (
  `country` varchar(45) DEFAULT NULL,
  `frequency` varchar(45) DEFAULT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `year` int DEFAULT NULL,
  `month` int DEFAULT NULL,
  `week` int DEFAULT NULL,
  `deaths` int DEFAULT NULL,
  `expected_deaths` int DEFAULT NULL,
  `excess_deaths` int(11) DEFAULT NULL,,
  `baseline` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`start_date`,`end_date`)
);

#twitter 1000 terms
CREATE TABLE `twitter_1000_terms` (
  `term` varchar(200) NOT NULL,
  `count` int DEFAULT NULL,
  `Date` datetime NOT NULL,
  PRIMARY KEY (`Date`,`term`)
);

#twitter 1000 bigrams
CREATE TABLE `twitter_1000_bigrams` (
  `term` varchar(200) NOT NULL,
  `count` int DEFAULT NULL,
  `Date` datetime NOT NULL,
  PRIMARY KEY (`Date`,`term`)
);

#abstract table
CREATE TABLE `ny_abstract_withIDs` (
  `abstract_id` bigint NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `abstract` varchar(5000) DEFAULT NULL,
  `keywords` varchar(500) DEFAULT NULL,
  `doc_type` varchar(45) DEFAULT NULL,
  `material_type` varchar(45) DEFAULT NULL,
  `news_desk` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`abstract_id`)
);





