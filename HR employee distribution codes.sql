-- 1. What is the gender breakdown of employees in the company?
select gender, count(*) as count 
from hr 
where age>=18 and termdate = '0000-00-00'
group by gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
select race, count(*) as population
from hr
where age>=18 and termdate = '0000-00-00'
group by race
order by race desc;

-- 3. What is the age distribution of employees in the company?

select
min(age)as youngest,
max(age) as oldest

from hr
where age >=18 and termdate = '0000,00,00';

select
 case
 when age>= 18 and age<25 then "between 18 to 25"
 when age>=26 and age<35 then "between 26 and 35"
 when age>=36 and age<45 then "between 36 and 45"
 when age>= 46 and age< 55 then "between 46 and 55"
 when age>55 then "old"
 end as age_group,
 count(*) as "number of emp in age group"
 from hr
 where age>=18 and termdate = '0000-00-00'
 group by age_group
 order by age_group;
 
 -- 4. How many employees work at headquarters versus remote locations?
 select location,
 count(*) as count
 from hr 
 where age>=18 and termdate = '0000-00-00'
 group by location;
 
  -- 5. What is the average length of employment for employees who have been terminated?
 select 
 avg(datediff(termdate,hire_date))/365 as "avg span of employee in co"
 from hr
 where termdate <= curdate() and termdate != "0000-00-00" and age>=18;

-- 6. How does the gender distribution vary across departments and job titles?
 select department, gender, count(*) as count
 from hr
 where age>=18 and termdate = '0000-00-00'
 group by department, gender
 order by department;
 
  -- 7. What is the distribution of job titles across the company?
 select jobtitle, count(*) as count
 from hr
where age>=18 and termdate = '0000-00-00'
 group by jobtitle
 order by jobtitle desc;
 
 -- 8. Which department has the highest turnover rate?
 select department,
 terminated_count,
 total_count,
 terminated_count/total_count AS termination_rate
 FROM (SELECT department,
	COUNT(*) AS total_count,
    SUM(CASE WHEN termdate <= curdate() AND termdate = '0000-00-00' THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age >= 18
    GROUP BY department) AS subquery
    order by termination_rate;
    
    -- 9. What is the distribution of employees across locations by city and state?

select location_state, count(*) as count
from hr
where age>=18
group by location_state;

-- 10. How has the company's employee count changed over time based on hire and term dates?
select 
year,terminations,hires,
hires - terminations as net_change,
((hires - terminations)/hires)*100 as percentage_net_change
from(
select
year (hire_date) as year,
count(*)  as hires,
 SUM(CASE WHEN termdate <= curdate() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) AS terminations
from hr
where age >= 18 
group by year(hire_date)
) as subquery
order by year asc;
