#Insert Normal form tables

#1. Date details
insert into NF_covid_data.date_ymd(year, month, day)
select year(date) as year, month(date) as month, day(date) as day
from (select distinct date from ny_US_county_level
union
select distinct date from ny_abstract_withIDs
union
select distinct start_date from ny_US_excessDeaths_byAllCauses
union
select distinct end_date from ny_US_excessDeaths_byAllCauses
union
select distinct date from twitter_1000_bigrams
union
select distinct date from twitter_1000_terms) as d;

#2. City details
insert into NF_covid_data.city_details (city_name) select distinct city from raw_covid_data.ny_US_colleges_univ;

#3. County details
insert into NF_covid_data.county_details (county_name) select distinct county from ny_US_county_level;

#4. State details
insert into NF_covid_data.state_details (state_name) select distinct state from ny_US_county_level;

#5. Mask survey
insert into norm_ny_US_mask_survey (COUNTYFP, NEVER,RARELY, SOMETIMES, FREQUENTLY, ALWAYS) select * from raw_covid_data.ny_US_mask_survey;

#6. Twitter terms
insert into  NF_covid_data.norm_twitter_1000_terms (term, count, date_id) select term, count, 
(select date_id from date_ymd where year = year(twitter_1000_terms.Date) and month= month(twitter_1000_terms.Date) 
and day= day(twitter_1000_terms.Date)) from raw_covid_data.twitter_1000_terms;

#7. Twitter bigrams
insert into  NF_covid_data.norm_twitter_1000_bigrams (term, count, date_id) select term, count, 
(select date_id from date_ymd where year = year(twitter_1000_bigrams.Date) and month= month(twitter_1000_bigrams.Date) 
and day= day(twitter_1000_bigrams.Date)) from raw_covid_data.twitter_1000_bigrams;

#8. County level
insert into  NF_covid_data.norm_ny_US_county_level (date_id,county_id, state_id, fips, cases, deaths) 
select (select date_id from date_ymd where year = year(ny_US_county_level.Date) and month= month(ny_US_county_level.Date) 
and day= day(ny_US_county_level.Date)),
(select county_id from county_details where county_name = county),
(select state_id from state_details where state_name=state) , fips, cases, deaths from raw_covid_data.ny_US_county_level;

#9. Colleges and Universities
insert into  NF_covid_data.norm_ny_US_colleges_univ (state_id, county_id, city_id, ipeds_id, college, cases, cases_2021, notes) 
select (select state_id from state_details where state_name = state),
(select county_id from county_details where county_name = county),
(select city_id from city_details where city_name = city), ipeds_id, college, cases, cases_2021, notes from raw_covid_data.ny_US_colleges_univ;

#10. News Abstracts
insert into  NF_covid_data.norm_ny_abstract_withIDs (date_id, abstract, keywords, doc_type, material_type, news_desk, abstract_id) 
select (select date_id from date_ymd where year = year(ny_abstract_withIDs.Date) and month = month(ny_abstract_withIDs.Date) 
and day= day(ny_abstract_withIDs.Date)), abstract, keywords, doc_type, material_type, news_desk, abstract_id from raw_covid_data.ny_abstract_withIDs;

#11. US excess deaths by All Causes
insert into  NF_covid_data.norm_ny_US_excessDeaths_byAllCauses (country, frequency, start_date_id, end_date_id, year, month, week, deaths, expected_deaths, excess_deaths, baseline) 
select country, frequency, 
(select date_id from date_ymd where year = year(ny_US_excessDeaths_byAllCauses.start_date) and month = month(ny_US_excessDeaths_byAllCauses.start_date) 
and day= day(ny_US_excessDeaths_byAllCauses.start_date)), 
(select date_id from date_ymd where year = year(ny_US_excessDeaths_byAllCauses.end_date) and month = month(ny_US_excessDeaths_byAllCauses.end_date) 
and day= day(ny_US_excessDeaths_byAllCauses.end_date)), 
year, month, week, deaths, expected_deaths, excess_deaths, baseline from raw_covid_data.ny_US_excessDeaths_byAllCauses;

#12. County and FIPS mapping
INSERT INTO `NF_covid_data`.`county_fips_mapping`(`countyid`,`fips`,`countyfp`) 
select county_id,fips,COUNTYFP from norm_ny_US_mask_survey m join norm_ny_US_county_level c on m.countyfp = c.fips;