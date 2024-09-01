-- subquery in select
SELECT * FROM salaries

select emp_no, salary, (select avg(salary) from salaries) as AllAverageSalary
FROM salaries

-- how to do it with Partition By
SELECT emp_no, salary, avg(salary) over () as AllAvgSalary
FROM salaries
Group By emp_no, salary
order by 1,2

-- subquery in from
SELECT a.emp_no, AllAvgSalary
FROM (select emp_no, salary, avg(salary) over () as AllAvgSalary
from salaries) a

-- subquery in where
select emp_no,title
FROM titles WHERE emp_no IN (select emp_no from salaries WHERE emp_no BETWEEN '1001' AND '1009')

-- 1
SELECT emp_no
FROM (select avg(salary) as avg_salary, emp_no from salaries GROUP BY 2) a

SELECT first_name, last_name, gender, hire_date
FROM employees WHERE emp_no IN (SELECT emp_no FROM dept_manager)

SELECT 
    *
FROM
    (SELECT 
        first_name, last_name, salary
    FROM
        employees
    JOIN salaries ON employees.emp_no = salaries.emp_no)
    -- GROUP BY AVG(salary) AS average_salary)


