
## 1.Create the database and schema. Populate the Schema:
create database if not exists e_learning_db ;
use e_learning_db;

create table if not exists learners(learner_id int primary key, 
Full_name varchar(100),
Country varchar(50));

create table if not exists courses(course_id int primary key,
course_name varchar(100),
category varchar(50),
unit_price int);

create table if not exists purchases(purchase_id int primary key,
learner_id int,
course_id int ,
quantity int,
purchase_date date,
foreign key (learner_id) references learners(learner_id),
foreign key (course_id) references courses(course_id)
);

insert into learners( learner_id, full_name, country) 
values (1001," Mark Davidson", "United States"),
(1002,"Jessica Parker", "Russia"),
(1003,"David Scanner","United Kingdom"),
(1004, "Louis Berkman","United Kingdom"),
(1005,"Franklin Fernando", "Germany"),
(1006,"Bill Clinton","United states"),
(1007,"Megan Jones","France"),
(1008,"Ananya Chopra", "India");

insert into courses(course_id, course_name,category,Unit_price)
values(101, 'SQL Fundamentals', 'Database', 49),
(102, 'Advanced SQL Queries', 'Database', 99),
(103, 'Python for Data Analysis', 'Programming', 79),
(104, 'Power BI for Beginners', 'Data Visualization', 59),
(105, 'Excel for Business Analysis', 'Productivity', 39),
(106, 'Web Development Basics', 'Web Development', 69),
(107, 'Machine Learning Intro', 'Data Science', 129),
(108, 'HR Analytics using SQL', 'Analytics', 89);

insert into purchases(purchase_id,learner_id,course_id,quantity,purchase_date)
values(2001, 1001, 101, 1, '2025-01-10'),
(2002, 1002, 102, 1, '2025-01-12'),
(2003, 1003, 103, 2, '2025-01-15'),
(2004, 1004, 104, 1, '2025-01-18'),
(2005, 1005, 105, 3, '2025-01-20'),
(2006, 1006, 106, 1, '2025-01-22'),
(2007, 1007, 107, 1, '2025-01-25'),
(2008, 1008, 108, 2, '2025-02-01');

### 2. Data Exploration Using Joins

select format(unit_price,2) as formatted_price
from courses;

select Sum(unit_price) as total_revenue
from courses;

select course_name ,unit_price
from courses
order by unit_price desc;

###Display each learner’s purchase details (course name, category, quantity, total amount, and purchase date).

select Full_name as learners_name, c.course_name, c.category, p.quantity * c.unit_price As Total_Amount, p.purchase_date 
from purchases p
inner join learners l on  l.learner_id=p.learner_id
inner join courses c on c.course_id=p.course_id;

### 3. Analytical Queries
##Q1. Display each learner’s total spending (quantity × unit_price) along with their country
Select Full_name As Learners_name, p.quantity*c.unit_price As Total_spending, l.country
from purchases p
inner join learners l on  l.learner_id=p.learner_id
inner join courses c on c.course_id=p.course_id;

###Q2. Find the top 3 most purchased courses based on total quantity sold.

Select Sum(p.quantity) as Total_quantity_sold, c.course_name
from purchases p
join courses c on c.course_id=p.course_id
group by course_name 
order by Total_quantity_sold desc
limit 3;

##Q3. Show each course category’s total revenue and the number of unique learners who purchased from that category.

Select c.category, Sum(p.quantity*c.unit_price) as total_revenue,
count(distinct p.learner_id) as Unique_learners
from purchases p
join courses c on p.course_id=c.course_id
group by c.category;

##Q4. List all learners who have purchased courses from more than one category.
select 
l.Full_name, l.learner_id, count(distinct c.category) as category_count 
from learners l
join purchases p on p.learner_id=l.learner_id
join courses c on p.course_id = c.course_id
group by l.learner_id, l.full_name
Having category_count > 1;

##Q5. Identify courses that have not been purchased at all.

Select c.course_name, c.course_id,c.category
from courses c
left join purchases p on p.course_id = c.course_id
where c.course_id is null ;