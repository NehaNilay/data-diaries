create database healthcare ;

use healthcare ;

select * from hosp ;

select * from med_ex ;

/* 1. To gain a comprehensive understanding of the factors influencing hospitalization costs -
a. Merge the two tables by first identifying the columns in the data tables that will help you in merging.
b. In both tables, add a Primary Key constraint for these columns. */

select `Customer ID` , count(*) as ct from hosp
group by `Customer ID`
order by ct desc ;

# Remove Rows Where Customer ID = ?

SET SQL_SAFE_UPDATES = 0 ;

delete from hosp
where `Customer ID` ="?" ;

# Making Cust ID Not Null

alter table hosp
modify  `Customer ID` varchar(10) not null ;

# Making It A Primary Key

alter table hosp
add primary key ( `Customer ID`) ;

# Repeating With Medical Examination Table

alter table med_ex
modify  `Customer ID` varchar(10) not null ;


alter table med_ex
add primary key ( `Customer ID`) ;

SET SQL_SAFE_UPDATES = 1 ;

select `Customer ID` , count(*) as ct from hosp
group by `Customer ID`
order by ct desc ;

/* 2. Retrieve information about people who are diabetic and have heart problems with their average 
age, the average number of dependent children, average BMI, and average hospitalization costs. */

SELECT 
    m.diabetes,
    m.`Heart Issues`,
    round(AVG(h.age),0) AS avg_age,
    round(AVG(h.children),0) AS avg_child_dep,
    round(AVG(m.BMI),2) AS avg_bmi,
    round(AVG(h.charges),2) AS avg_charges
FROM
    (select * , 2022 - year AS age
    from hosp) h,
    (SELECT 
        *,
            CASE
                WHEN HBA1C > 6.5 THEN 'Yes'
                ELSE 'No'
            END AS diabetes
    FROM
        med_ex) m
	where h.`Customer ID` = m.`Customer ID`
GROUP BY m.diabetes , m.`Heart Issues` ;

 /*3. Find the average hospitalization cost for each hospital tier and each city level. */
 
select `Hospital tier`,count(*) as ct
from hosp
group by `Hospital tier`
order by ct ;

select `City tier`,count(*) as ct
from hosp
group by `City tier`
order by ct ;

# Replace "?" With Mode Values

SET SQL_SAFE_UPDATES = 0 ;
 
update hosp
set `Hospital tier` = "tier - 2"
where `Hospital tier` = "?" ;

update hosp
set `City tier` = "tier - 2"
where `City tier` = "?" ;

SET SQL_SAFE_UPDATES = 1 ;

select `Hospital tier`, `City tier` , avg(charges) as avg_charges
from  hosp
group by `Hospital tier`,`City tier` ;

/* 4. Determine the number of people who have had major surgery with a history of cancer. */

select `Cancer history`, surgery, count(*) as count_pat
from (
select *, 
case 
when NumberOfMajorSurgeries>= 1 then "Yes"
else "No"
end as surgery
from  med_ex) m
group by `Cancer history`, surgery
having `Cancer history` = "yes" ;

/*  5. Determine the number of tier-1 hospitals in each state. */

# replace "?" in state id with mode value

select * from hosp ;

select `State ID` , count(*) as ct
from hosp
group by `State ID`
order by ct desc ;

SET SQL_SAFE_UPDATES = 0 ;

update hosp
set `Hospital tier` = "tier - 2"
where `Hospital tier` = "?" ;

select `State ID`, `Hospital tier` , count(*) as hosp_count
from hosp
group by `State ID`, `Hospital tier`
having `Hospital tier` = "tier - 1" ;

