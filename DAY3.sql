USE DAY3;

SELECT * FROM COUNTRIES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM EMPLOYEE;
SELECT * FROM LOCATIONS;
SELECT * FROM REGIONS;
SELECT * FROM JOBS;
SELECT * FROM JOB_HISTORY;

--QUESTION 1: Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy

SELECT SUM(E.SALARY) AS TOTAL_SALARY FROM EMPLOYEE E
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
WHERE L.CITY = 'Seattle' AND E.FIRST_NAME != 'Nancy';


-- QUSETION 2: Fetch all details of employees who has salary more than the avg salary by each department.

SELECT * FROM EMPLOYEE E JOIN (SELECT DEPARTMENT_ID,AVG(SALARY) AS AVG_SALARY FROM  EMPLOYEE E
GROUP BY DEPARTMENT_ID) D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.SALARY > D.AVG_SALARY;


-- QUESTION 3:Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 70000 and less than 100000

SELECT COUNT(E.EMPLOYEE_ID) AS TOTAL_EMPLOYEES,L.CITY FROM EMPLOYEE E JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
WHERE E.SALARY >= 7000 AND E.SALARY < 10000
GROUP BY L.CITY;



-- QUESTION 4:Fetch max salary, min salary and avg salary by job and department. Info: grouped by department id and job id ordered by department id and max salary

SELECT DEPARTMENT_ID,JOB_ID, MAX(SALARY), MIN(SALARY), AVG(SALARY) 
FROM EMPLOYEE 
GROUP BY DEPARTMENT_ID,JOB_ID 
ORDER BY DEPARTMENT_ID, MAX(SALARY);



-- QUESTION 5:Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy

SELECT SUM(SALARY) FROM EMPLOYEE 
JOIN DEPARTMENTS ON EMPLOYEE.DEPARTMENT_ID=DEPARTMENTS.DEPARTMENT_ID
JOIN LOCATIONS ON LOCATIONS.LOCATION_ID=DEPARTMENTS.LOCATION_ID WHERE FIRST_NAME!='NANCY' AND COUNTRY_ID='US';



-- QUESTION 6:Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.

SELECT JOB_ID,DEPARTMENT_ID,MAX(EMPLOYEE.SALARY),MIN(EMPLOYEE.SALARY),AVG(EMPLOYEE.SALARY) FROM EMPLOYEE
JOIN (SELECT EMPLOYEE_ID,COUNT(EMPLOYEE_ID)AS EMP_COUNT FROM JOB_HISTORY GROUP BY DEPARTMENT_ID,EMPLOYEE_ID HAVING EMP_COUNT > 1) AS E
ON E.EMPLOYEE_ID = EMPLOYEE.EMPLOYEE_ID
GROUP BY JOB_ID,DEPARTMENT_ID ORDER BY DEPARTMENT_ID;


-- QUESTION 7:Display the employee count in each department and also in the same result.  
-- Info: * the total employee count categorized as "Total"
-- •	the null department count categorized as "-" *

SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) AS TOTAL FROM EMPLOYEE GROUP BY DEPARTMENT_ID ORDER BY DEPARTMENT_ID ;



--  QUESTION 8:Display the jobs held and the employee count. 
-- Hint: every employee is part of at least 1 job 
-- Hint: use the previous questions answer
-- Sample
-- JobsHeld EmpCount
-- 1	100
-- 2	4

SELECT J.JOBS_HELD , COUNT(EMP_ID) AS EMP_COUNT FROM(
SELECT E.EMPLOYEE_ID AS EMP_ID , COUNT(*) AS JOBS_HELD FROM
(SELECT EMPLOYEE_ID ,JOB_ID FROM EMPLOYEE UNION ALL SELECT EMPLOYEE_ID ,JOB_ID
FROM JOB_HISTORY ORDER BY EMPLOYEE_ID) AS E GROUP BY E.EMPLOYEE_ID) AS J GROUP BY JOBS_HELD ORDER BY JOBS_HELD;



-- QUESTION 9: Display average salary by department and country

SELECT EMPLOYEE.DEPARTMENT_ID,LOCATIONS.COUNTRY_ID, AVG(SALARY) AS AVERAGE_SALARY FROM EMPLOYEE JOIN 
DEPARTMENTS ON EMPLOYEE.DEPARTMENT_ID=DEPARTMENTS.DEPARTMENT_ID JOIN LOCATIONS ON DEPARTMENTS.LOCATION_ID=LOCATIONS.LOCATION_ID GROUP BY EMPLOYEE.DEPARTMENT_ID,LOCATIONS.COUNTRY_ID ORDER BY EMPLOYEE.DEPARTMENT_ID;




-- QUESTION 10: Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country)

SELECT DEPARTMENTS.MANAGER_ID,LOCATIONS.COUNTRY_ID,COUNT(*) AS TOTAL_EMPLOYEES FROM EMPLOYEE 
JOIN DEPARTMENTS ON EMPLOYEE.DEPARTMENT_ID=DEPARTMENTS.DEPARTMENT_ID JOIN 
LOCATIONS ON LOCATIONS.LOCATION_ID=DEPARTMENTS.LOCATION_ID
GROUP BY DEPARTMENTS.MANAGER_ID,LOCATIONS.COUNTRY_ID ;




-- QUESTION 11:	 Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. (Like the previous question) but now group by department and categorize it like below.
-- Eg : 
-- DEPT ID 0-10000 10000-20000
-- 50          2               10
-- 60          6                5

SELECT DEPARTMENT_ID,
  COUNT(CASE WHEN SALARY BETWEEN 0 AND 10000 THEN 1 END) AS "0-10000",
  COUNT(CASE WHEN SALARY BETWEEN 10001 AND 20000 THEN 1 END) AS "10000-20000",
  COUNT(CASE WHEN SALARY BETWEEN 20001 AND 30000 THEN 1 END) AS "20000-30000",
  COUNT(CASE WHEN SALARY >= 30000 THEN 1 END) ">=30000"
FROM EMPLOYEE
GROUP BY DEPARTMENT_ID ORDER BY DEPARTMENT_ID ;





-- QUESTION 12.	 Display employee count by country and the avg salary 
-- Eg : 
-- Emp Count       Country        Avg Salary
-- 10                     Germany      34242.8

SELECT COUNT(*) AS EMP_COUNT,COUNTRIES.COUNTRY_NAME AS COUNTRY,AVG(SALARY) AS AVG_SALARY FROM EMPLOYEE
 JOIN DEPARTMENTS ON DEPARTMENTS.DEPARTMENT_ID=EMPLOYEE.DEPARTMENT_ID 
 JOIN LOCATIONS ON LOCATIONS.LOCATION_ID=DEPARTMENTS.LOCATION_ID
 JOIN COUNTRIES ON LOCATIONS.COUNTRY_ID=COUNTRIES.COUNTRY_ID
 GROUP BY COUNTRIES.COUNTRY_NAME;



 
 -- 13.	 Display region and the number of employees by department
-- Eg : 
-- Dept ID   America   Europe  Asia
-- 10            22               -            -
-- 40             -                 34  

SELECT EMPLOYEE.DEPARTMENT_ID,REGIONS.REGION_NAME, COUNT(COUNTRIES.REGION_ID) AS TOTAL_EMPLOYEES FROM EMPLOYEE JOIN 
DEPARTMENTS ON EMPLOYEE.DEPARTMENT_ID=DEPARTMENTS.DEPARTMENT_ID JOIN LOCATIONS ON LOCATIONS.LOCATION_ID=DEPARTMENTS.LOCATION_ID  JOIN
COUNTRIES ON COUNTRIES.COUNTRY_ID=LOCATIONS.COUNTRY_ID JOIN REGIONS ON REGIONS.REGION_ID=COUNTRIES.REGION_ID
GROUP BY EMPLOYEE.DEPARTMENT_ID, COUNTRIES.REGION_ID,REGIONS.REGION_NAME;




-- 14.	 Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM EMPLOYEE  JOIN DEPARTMENTS ON EMPLOYEE.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID;




-- 15.	write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers

SELECT EMPLOYEE_ID,FIRST_NAME,LAST_NAME, MANAGER_ID FROM EMPLOYEE;



-- 16.	write a SQL query to display the department name, city, and state province for each department.

SELECT DEPARTMENT_NAME , CITY ,STATE_PROVINCE FROM DEPARTMENTS JOIN LOCATIONS ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID;



-- 17.	write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't

SELECT FIRST_NAME , LAST_NAME ,DEPARTMENT_NAME  FROM EMPLOYEE JOIN
DEPARTMENTS ON EMPLOYEE.DEPARTMENT_ID =DEPARTMENTS.DEPARTMENT_ID;



-- 18.	The HR decides to make an analysis of the employees working in every department. Help him to determine the salary given in average per department and the total number of employees working in a department.  List the above along with the department id, department name

SELECT EMPLOYEE.DEPARTMENT_ID ,DEPARTMENTS.DEPARTMENT_NAME, COUNT(EMPLOYEE.DEPARTMENT_ID) AS TOTAL_EMPLOYEES , AVG(SALARY) FROM EMPLOYEE  JOIN DEPARTMENTS ON EMPLOYEE.DEPARTMENT_ID=DEPARTMENTS.DEPARTMENT_ID
GROUP BY EMPLOYEE.DEPARTMENT_ID ,DEPARTMENTS.DEPARTMENT_NAME ORDER BY DEPARTMENT_ID;



-- 19.	Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.
SELECT * FROM EMPLOYEE 
CROSS JOIN 
JOBS;



--20.  Write a query to display first_name, last_name, and email of employees who are from Europe and Asia

SELECT E.FIRST_NAME, E.LAST_NAME, E.EMAIL
FROM EMPLOYEE E JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
JOIN COUNTRIES C ON L.COUNTRY_ID = C.COUNTRY_ID JOIN REGIONS R ON C.REGION_ID = R.REGION_ID
WHERE R.REGION_NAME IN ('Europe', 'Asia');




-- 21. Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department.

SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS FULL_NAME 
FROM EMPLOYEE E JOIN DEPARTMENTS D ON E.DEPARTMENT_ID= D.DEPARTMENT_ID
JOIN LOCATIONS L ON D.LOCATION_ID= L.LOCATION_ID WHERE L.CITY='Oxford' AND SUBSTR(E.LAST_NAME,-2,1)='e'
AND E.DEPARTMENT_ID NOT IN (
    SELECT DEPARTMENT_ID
    FROM DEPARTMENTS
    WHERE DEPARTMENT_NAME IN ('Finance', 'Shipping')
);



-- 22. Display the first name and phone number of employees who have less than 50 months of experience

SELECT FIRST_NAME, PHONE_NUMBER FROM EMPLOYEE WHERE DATEDIFF(MONTH,HIRE_DATE,CURRENT_DATE)>50;



-- 23. Display Employee id, first_name, last name, hire_date and salary for employees who has the highest salary for each hiring year. (For eg: John and Deepika joined on year 2023, and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).

SELECT EMPLOYEE_ID , FIRST_NAME , LAST_NAME , HIRE_DATE , SALARY FROM EMPLOYEE WHERE (EXTRACT(YEAR FROM HIRE_DATE),SALARY) IN(
SELECT HIRE_YEAR, MAX(SALARY) FROM (SELECT EXTRACT(YEAR FROM HIRE_DATE) AS HIRE_YEAR, SALARY FROM EMPLOYEE) GROUP BY HIRE_YEAR) ORDER BY HIRE_DATE;