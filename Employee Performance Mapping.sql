create database employee;

use employee ;

select * from emp_record_table ;

select emp_id, 
first_name, 
last_name, 
gender,
dept
from emp_record_table ;


select emp_id, first_name, last_name, gender, dept, emp_rating
from emp_record_table where emp_rating < 2;

select emp_id, first_name, last_name, gender, dept, emp_rating
from emp_record_table where emp_rating > 4 ;

select emp_id, first_name, last_name, gender, dept, emp_rating
from emp_record_table where emp_rating between 2 and 4 ;


select first_name, last_name, concat(first_name, last_name) as Name from emp_record_table
where dept = 'Finance';


select emp_id, first_name from emp_record_table where role = 'Manager' ;

select e.emp_id, e.first_name, count(r.emp_id) as number_of_reporters
from emp_record_table e
join 
    emp_record_table r ON e.emp_id = r.manager_id
group by 1,2 ;


select emp_id, first_name, dept from emp_record_table where dept = 'Healthcare'
union
select emp_id, first_name, dept from emp_record_table where dept = 'Finance' ;


Select emp_id, first_name, last_name, role, dept, emp_rating,
max(emp_rating) over (partition by dept) as max_dept_rating
from emp_record_table;


select role,
    min(salary) as min_salary,
    max(salary) as max_salary
from emp_record_table
group by role;


select emp_id, first_name, role, exp,
rank() over (order by exp desc) as experience_rank
from emp_record_table;


create view high_salary as select emp_id, first_name, last_name, country,
salary from emp_record_table where salary > 6000 order by country;

select * from high_salary;


select emp_id, first_name, last_name, role, exp
from emp_record_table
where emp_id in (
    select emp_id 
    where exp > 10
);



delimiter //
create procedure ExpGreaterThanThreeYear()
begin
    select emp_id, first_name, last_name, exp
    from emp_record_table
    where exp > 3;
end//
delimiter ;

call ExpGreaterThanThreeYear() ;



delimiter //
create function Check_Job_Profile(exp int)
returns varchar(50)
deterministic
begin
    declare profile varchar(50);

    if exp <= 2 then
        set profile = 'JUNIOR DATA SCIENTIST';
    elseif exp > 2 and exp <= 5 then
        set profile = 'ASSOCIATE DATA SCIENTIST';
    elseif exp > 5 and exp <= 10 then
        set profile = 'SENIOR DATA SCIENTIST';
    elseif exp > 10 and exp <= 12 then
        set profile = 'LEAD DATA SCIENTIST';
    elseif exp > 12 and exp <= 16 then
        set profile = 'MANAGER';
    else
        set profile = 'UNKNOWN';
    end if;
  return profile;
end //
delimiter ;


select 
    emp_id, first_name, exp,
    role as assigned_profile,
    Check_Job_Profile(exp) as expected_profile,
    case 
        when role = Check_Job_Profile(exp) then 'MATCH'
        else 'MISMATCH'
    end as status
from 
    data_science_team ;


select * from emp_record_table 
where first_name = 'Eric';

create index  idx_first_name on emp_record_table(first_name(50)); 

explain select * from emp_record_table where first_name = 'Eric';



select emp_id, first_name, last_name,
salary, emp_rating,
(0.05 * salary * emp_rating) as bonus
from emp_record_table;



select continent, country, avg(salary) as average_salary
from emp_record_table
group by 
    continent, country
order by 
    continent, country;


