#Table1
CREATE TABLE `date_ymd` (
  `date_id` int(11) NOT NULL AUTO_INCREMENT,
  `year` int(11) DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `day` int(11) DEFAULT NULL,
  PRIMARY KEY (`date_id`)
);

#Table2
CREATE TABLE `state_details` (
  `state_id` int(11) NOT NULL AUTO_INCREMENT,
  `state_name` varchar(100) NOT NULL,
  PRIMARY KEY (`state_id`)
);

#Table3
CREATE TABLE `county_details` (
  `county_id` int(11) NOT NULL AUTO_INCREMENT,
  `county_name` varchar(100) NOT NULL,
  PRIMARY KEY (`county_id`)
);

#Table4
CREATE TABLE `city_details` (
  `city_id` int(11) NOT NULL AUTO_INCREMENT,
  `city_name` varchar(45) NOT NULL,
  PRIMARY KEY (`city_id`)
);

#Table5
CREATE TABLE `norm_ny_abstract_withIDs` (
  `date_id` int(11) DEFAULT NULL,
  `abstract` varchar(5000) DEFAULT NULL,
  `keywords` varchar(500) DEFAULT NULL,
  `doc_type` varchar(45) DEFAULT NULL,
  `material_type` varchar(45) DEFAULT NULL,
  `news_desk` varchar(45) DEFAULT NULL,
  `abstract_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`abstract_id`),
  KEY `date_id` (`date_id`),
  CONSTRAINT `norm_ny_abstract_withIDs_ibfk_1` FOREIGN KEY (`date_id`) REFERENCES `date_ymd` (`date_id`)
);

#Table6
CREATE TABLE `norm_twitter_1000_bigrams` (
  `term` varchar(200) NOT NULL,
  `count` int(11) DEFAULT NULL,
  `date_id` int(11) NOT NULL,
  PRIMARY KEY (`date_id`,`term`),
  CONSTRAINT `norm_twitter_1000_bigrams_ibfk_1` FOREIGN KEY (`date_id`) REFERENCES `date_ymd` (`date_id`)
);

#Table7
CREATE TABLE `norm_twitter_1000_terms` (
  `term` varchar(200) NOT NULL,
  `count` int(11) DEFAULT NULL,
  `date_id` int(11) NOT NULL,
  PRIMARY KEY (`date_id`,`term`),
  CONSTRAINT `norm_twitter_1000_terms_ibfk_1` FOREIGN KEY (`date_id`) REFERENCES `date_ymd` (`date_id`)
);

#Table8
CREATE TABLE `norm_ny_US_county_level` (
  `date_id` int(11) NOT NULL,
  `county_id` int(11) NOT NULL,
  `state_id` int(11) NOT NULL,
  `fips` int(11) DEFAULT NULL,
  `cases` int(11) DEFAULT NULL,
  `deaths` int(11) DEFAULT NULL,
  PRIMARY KEY (`date_id`,`county_id`,`state_id`),
  KEY `county_id` (`county_id`),
  KEY `state_id` (`state_id`),
  CONSTRAINT `norm_ny_US_county_level_ibfk_1` FOREIGN KEY (`date_id`) REFERENCES `date_ymd` (`date_id`),
  CONSTRAINT `norm_ny_US_county_level_ibfk_2` FOREIGN KEY (`county_id`) REFERENCES `county_details` (`county_id`),
  CONSTRAINT `norm_ny_US_county_level_ibfk_3` FOREIGN KEY (`state_id`) REFERENCES `state_details` (`state_id`)
);

#Table9
CREATE TABLE `norm_ny_US_colleges_univ` (
  `state_id` int(11) DEFAULT NULL,
  `county_id` int(11) DEFAULT NULL,
  `city_id` int(11) DEFAULT NULL,
  `ipeds_id` int(11) NOT NULL,
  `college` varchar(500) DEFAULT NULL,
  `cases` int(11) DEFAULT NULL,
  `cases_2021` decimal(10,2) DEFAULT NULL,
  `notes` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`ipeds_id`),
  KEY `city_id` (`city_id`),
  KEY `county_id` (`county_id`),
  KEY `state_id` (`state_id`),
  CONSTRAINT `norm_ny_US_colleges_univ_ibfk_1` FOREIGN KEY (`city_id`) REFERENCES `city_details` (`city_id`),
  CONSTRAINT `norm_ny_US_colleges_univ_ibfk_2` FOREIGN KEY (`county_id`) REFERENCES `county_details` (`county_id`),
  CONSTRAINT `norm_ny_US_colleges_univ_ibfk_3` FOREIGN KEY (`state_id`) REFERENCES `state_details` (`state_id`)
);

#Table10
CREATE TABLE `norm_ny_US_excessDeaths_byAllCauses` (
  `country` varchar(45) DEFAULT NULL,
  `frequency` varchar(45) DEFAULT NULL,
  `start_date_id` int(11) NOT NULL,
  `end_date_id` int(11) NOT NULL,
  `year` int(11) DEFAULT NULL,
  `month` int(11) DEFAULT NULL,
  `week` int(11) DEFAULT NULL,
  `deaths` int(11) DEFAULT NULL,
  `expected_deaths` int(11) DEFAULT NULL,
  `excess_deaths` int(11) DEFAULT NULL,
  `baseline` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`start_date_id`,`end_date_id`),
  KEY `end_date_id` (`end_date_id`),
  CONSTRAINT `norm_ny_US_excessDeaths_byAllCauses_ibfk_1` FOREIGN KEY (`start_date_id`) REFERENCES `date_ymd` (`date_id`),
  CONSTRAINT `norm_ny_US_excessDeaths_byAllCauses_ibfk_2` FOREIGN KEY (`end_date_id`) REFERENCES `date_ymd` (`date_id`)
);

#Table11
CREATE TABLE `norm_ny_US_mask_survey` (
  `COUNTYFP` int(11) NOT NULL,
  `NEVER` decimal(5,5) DEFAULT NULL,
  `RARELY` decimal(5,5) DEFAULT NULL,
  `SOMETIMES` decimal(5,5) DEFAULT NULL,
  `FREQUENTLY` decimal(5,5) DEFAULT NULL,
  `ALWAYS` decimal(5,5) DEFAULT NULL,
  PRIMARY KEY (`COUNTYFP`)
);

#Table12
CREATE TABLE `county_fips_mapping` (
  `countyid` int(11) NOT NULL,
  `fips` int(11) NOT NULL,
  `countyfp` int(11) NOT NULL,
  KEY `fips_idx` (`fips`),
  KEY `countyfp_idx` (`countyfp`),
  CONSTRAINT `countyfp` FOREIGN KEY (`countyfp`) REFERENCES `norm_ny_US_mask_survey` (`COUNTYFP`),
  CONSTRAINT `fips` FOREIGN KEY (`fips`) REFERENCES `norm_ny_US_county_level` (`fips`)
);


