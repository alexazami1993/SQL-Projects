# problem 1 task solution
USE employees_mod;
SELECT
	YEAR(d.from_date) AS calendar_year,
    e.gender,
    COUNT(e.emp_no) AS num_of_employees
FROM
	t_employees e
JOIN
	t_dept_emp d ON d.emp_no = e.emp_no
    GROUP BY calendar_year, e.gender
    HAVING calendar_year >= 1990;
    
    -- problem 2 --

SELECT 
	d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calendar_year,
    CASE
		WHEN YEAR(dm.to_date) >= e.calendar_year AND YEAR(dm.from_date) <= e.calendar_year THEN 1 ELSE 0 END AS ACTIVE 
	FROM 
		(SELECT 
			YEAR(hire_date) AS calendar_year
		FROM
			t_employees
		GROUP BY calendar_year) e
			CROSS JOIN
		t_dept_manager dm
			JOIN
		t_departments d ON dm.dept_no = d.dept_no
			JOIN
		t_employees ee ON dm.emp_no = ee.emp_no
	ORDER BY dm.emp_no, calendar_year;
    
    
    
-- 3 -- 
SELECT 
    e.gender,
    d.dept_name,
    ROUND(AVG(s.salary), 2) AS salary,
    YEAR(s.from_date) AS calendar_year
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON e.emp_no = de.emp_no
        JOIN
    t_departments d ON de.dept_no = d.dept_no
GROUP BY d.dept_no , e.gender , calendar_year
HAVING calendar_year <= 2002
ORDER BY d.dept_no;




-- 4 --
DROP PROCEDURE IF EXISTS filter_salary;
DELIMITER $$
CREATE PROCEDURE filter_salary (IN p_min_salary FLOAT, IN p_max_salary FLOAT)
BEGIN
	SELECT e.gender, d.dept_name, AVG(s.salary) as average_salary
FROM 
	t_employees e JOIN t_salaries s ON s.emp_no = e.emp_no
	JOIN t_dept_emp de ON de.emp_no = s.emp_no
    JOIN t_departments d ON d.dept_no = de.dept_no
    WHERE s.salary BETWEEN p_min_salary AND p_max_salary
    GROUP BY d.dept_no, e.gender;
END $$

DELIMITER ;

CALL filter_salary(50000, 90000);

USE employees_mod;

SELECT d.dept_name, e.emp_no, e.from_date, e.to_date
FROM t_departments d JOIN t_dept_emp e ON d.dept_no = e.dept_no;


-- subquery -- 

SELECT 
    *
FROM
    t_departments
WHERE
    dept_no IN (SELECT 
            dept_no
        FROM
            t_dept_emp
        WHERE
            dept_no = 'd009');

