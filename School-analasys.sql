create database student_Data;
use student_Data;
create table students(
student_id int auto_increment primary key,
school enum('gp','ms') not null comment 'GP = Gabriel Pereira, MS = Mousinho da Silveira',
sex enum('M','F') not null comment 'M=male , F=female',
age int not null check (age between 15 and 22),
 address enum('U','R') not null comment 'U=Urban,R=Rural', 
 famsize enum ('GT3','LE3') not null  comment 'GT3 = Grater Than 3, LE3= Less then 3',
    pstatus ENUM('A', 'T') NOT NULL COMMENT 'A = Apart, T = Together',
    medu INT NOT NULL CHECK (medu BETWEEN 0 AND 4) COMMENT 'Mother education: 0-none, 1-primary, 2-4th grade, 3-5th-9th, 4-secondary',
    fedu INT NOT NULL CHECK (fedu BETWEEN 0 AND 4) COMMENT 'Father education: 0-none, 1-primary, 2-4th grade, 3-5th-9th, 4-secondary',
    mjob VARCHAR(50) NOT NULL COMMENT 'Mother job',
    fjob VARCHAR(50) NOT NULL COMMENT 'Father job',
    reason ENUM('home', 'reputation', 'course', 'other') NOT NULL COMMENT 'Reason to choose school',
    guardian ENUM('mother', 'father', 'other') NOT NULL,
    traveltime INT NOT NULL CHECK (traveltime BETWEEN 1 AND 4) COMMENT '1: <15m, 2: 15-30m, 3: 30m-1h, 4: >1h',
    studytime INT NOT NULL CHECK (studytime BETWEEN 1 AND 4) COMMENT '1: <2h, 2: 2-5h, 3: 5-10h, 4: >10h',
    failures INT NOT NULL CHECK (failures BETWEEN 0 AND 3) COMMENT 'Number of past class failures',
    schoolsup ENUM('yes', 'no') NOT NULL COMMENT 'Extra educational support',
    famsup ENUM('yes', 'no') NOT NULL COMMENT 'Family educational support',
    paid ENUM('yes', 'no') NOT NULL COMMENT 'Extra paid classes within the course subject',
    activities ENUM('yes', 'no') NOT NULL COMMENT 'Extra-curricular activities',
    nursery ENUM('yes', 'no') NOT NULL COMMENT 'Attended nursery school',
    higher ENUM('yes', 'no') NOT NULL COMMENT 'Wants to take higher education',
    internet ENUM('yes', 'no') NOT NULL COMMENT 'Internet access at home',
    famrel INT NOT NULL CHECK (famrel BETWEEN 1 AND 5) COMMENT 'Quality of family relationships (1-very bad to 5-excellent)',
    freetime INT NOT NULL CHECK (freetime BETWEEN 1 AND 5) COMMENT 'Free time after school (1-very low to 5-very high)',
    goout INT NOT NULL CHECK (goout BETWEEN 1 AND 5) COMMENT 'Going out with friends (1-very low to 5-very high)',
    dalc INT NOT NULL CHECK (dalc BETWEEN 1 AND 5) COMMENT 'Workday alcohol consumption (1-very low to 5-very high)',
    walc INT NOT NULL CHECK (walc BETWEEN 1 AND 5) COMMENT 'Weekend alcohol consumption (1-very low to 5-very high)',
    health INT NOT NULL CHECK (health BETWEEN 1 AND 5) COMMENT 'Current health status (1-very bad to 5-excellent)',
    absences INT NOT NULL CHECK (absences >= 0) COMMENT 'Number of school absences',
    G1 INT NOT NULL CHECK (G1 BETWEEN 0 AND 20) COMMENT 'First period grade',
    G2 INT NOT NULL CHECK (G2 BETWEEN 0 AND 20) COMMENT 'Second period grade',
    G3 INT NOT NULL CHECK (G3 BETWEEN 0 AND 20) COMMENT 'Final grade'
);
insert into students (school, sex, age, address, famsize, pstatus, medu, fedu, mjob, fjob, reason, guardian, traveltime, studytime, failures, schoolsup, famsup, paid, activities, nursery, higher, internet, famrel, freetime, goout, dalc, walc, health, absences, G1, G2, G3)
select 'gp',sex, age, address, famsize, pstatus, medu, fedu, mjob, fjob, reason, guardian, traveltime, studytime, failures, schoolsup, famsup, paid, activities, nursery, higher, internet, famrel, freetime, goout, dalc, walc, health, absences, G1, G2, G3
from students_gp;
insert into students (school, sex, age, address, famsize, pstatus, medu, fedu, mjob, fjob, reason, guardian, traveltime, studytime, failures, schoolsup, famsup, paid, activities, nursery, higher, internet, famrel, freetime, goout, dalc, walc, health, absences, G1, G2, G3)
select 'ms',sex, age, address, famsize, pstatus, medu, fedu, mjob, fjob, reason, guardian, traveltime, studytime, failures, schoolsup, famsup, paid, activities, nursery, higher, internet, famrel, freetime, goout, dalc, walc, health, absences, G1, G2, G3
from students_ms;
select* from students;
# Academic Performance Comparison Compared average final grades (G3) of both schools.
select school,round(avg(G3),2) as final_grades_avg from 
students 
group by school;
#Alcohol Consumption Impact Grouped students by combined alcohol consumption (DALC + WALC) into Low, Medium, High. 
select school,
case
when (DALC+WALC) between 2 and 4 then 'low'
when (DALC+WALC) between 5 and 7 then 'medium'
else 'high' 
end as alcohol_consumption_tier,
count(*) as student_count,
round(avg(G3),2) as avg_grade from students 
group by school,alcohol_consumption_tier
order by alcohol_consumption_tier;

#study-Time Effectiveness Compared grades across different study time categories.
select studytime ,
case when studytime =1 then '<2 hour'
when studytime =2 then '2 to 5 hour'
when studytime =3 then '5 to 10 hour'
else '>10 hour'
end as study_time,
count(*) as student_count,
round(avg(G3),2) as avg_grade from students 
group by studytime; 

#Family Support Impact Analyzed the effect of famsup on final grades.
select famsup as family_support,
round(avg(G3),2) as avg_grade,
count(*) as student_count
from students
group by family_support;
# absenteeism Patterns Evaluated average absences and final grades.  

select school, 
round(avg(G3),2) as avg_grade,
round(avg(absences),1) as avg_absences 
from students 
group by school;
# Urban vs Rural Performance Compared student performance based on address (Urban vs Rural).
select address ,
count(*) as student_count,
 round(avg(G3),2) as avg_grade
 from students
 group by address;
 
 
# Extracurricular Activities Impact  Compared grades of students with and without activities.
select activities as extracurricular ,
count(*) as student_count ,
round(avg(G3),2) as avg_grade
from students
group by activities;

# creat a view 
create view  student_report as 
select 
student_id,
school,
sex,
age,
(G1+G2+G3)/3 as running_gpa,
G3 as final_grade,
(dalc+walc) as total_alcohal_score,
absences,
if(G3>=10 , 'pass','fail') as final_status
from students;
select * from student_report;
# creat a stored Procedure
-- delimiter $
-- create procedure schoolperfomance_summry (in input_school varchar(2))
-- begin 
-- select count(*) as student_count ,



 


