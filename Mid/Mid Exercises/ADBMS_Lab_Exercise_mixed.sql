-- #1 Find the highest paid employee of the sales department who belong from the grade 2 and 3.
SELECT grade, dname, emp.*
FROM emp, dept, salgrade
WHERE emp.deptno = dept.deptno
  AND sal BETWEEN losal AND hisal AND sal =
    (SELECT MAX(sal) FROM emp, salgrade
     WHERE emp.deptno = dept.deptno
     AND sal BETWEEN losal AND hisal
     AND dname = 'SALES' AND grade IN (2, 3));

-- #2 Find out the grade with the maximum No of employees.
SELECT grade, COUNT(*) AS no_of_employees
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal
GROUP BY grade HAVING COUNT(*) =
    (SELECT MAX(COUNT(*)) FROM emp, salgrade
     WHERE sal BETWEEN losal AND hisal
     GROUP BY grade);

-- #3 List out the Name, Job, Salary, grade of the emps in the department with the highest average salary.
SELECT ename, job, sal, grade, deptno
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal AND deptno =
    (SELECT deptno FROM emp
     GROUP BY deptno HAVING AVG(sal) =
        (SELECT MAX(AVG(sal)) FROM emp GROUP BY deptno));

-- #4 Write a query to display the department name, location name and number of employees and their rounded average salary for all employees as department name wise and location wise.
SELECT dname, loc, COUNT(*), ROUND(AVG(sal))
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY dname, loc;

-- #5 Find out the location with maximum no of average salary.
SELECT loc, ROUND(AVG(sal)) FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY loc HAVING AVG(sal) =
    (SELECT MAX(AVG(sal)) FROM emp, dept
     WHERE emp.deptno = dept.deptno
     GROUP BY loc);

-- #6 List all the Grade 2 and Grade 3 emps who belong from the Chicago.
SELECT ename, grade, loc FROM emp, dept, salgrade
WHERE emp.deptno = dept.deptno
  AND sal BETWEEN losal AND hisal
  AND grade IN (2, 3) AND loc = 'CHICAGO';

-- #7 List the name, job, sal, dname and grade of the loc where highest no. of emps are working.
SELECT ename, job, sal, dname, grade
FROM emp, dept, salgrade
WHERE emp.deptno = dept.deptno
  AND sal BETWEEN losal AND hisal AND loc =
    (SELECT loc FROM emp, dept
     WHERE emp.deptno = dept.deptno
     GROUP BY loc HAVING COUNT(*) =
        (SELECT MAX(COUNT(*)) FROM emp, dept
         WHERE emp.deptno = dept.deptno
         GROUP BY loc));


-- #8 List the employee Name, Job, Annual Salary, deptno, Dept name and grade who earn 36000 a year or who are not CLERKS.
SELECT ename, job, sal * 12 AS anual_salary, emp.deptno, dname, grade
FROM emp, dept, salgrade
WHERE emp.deptno = dept.deptno
  AND sal BETWEEN losal AND hisal
  AND (sal * 12 = 36000 OR job != 'CLERK');

-- #9 Find out the grade of all mgrs.
SELECT ename, grade FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal
  AND empno IN (SELECT mgr FROM emp);

-- #10 Find out the mgr who lives in DALLAS and belong from grade 3 and 4.
SELECT * FROM emp, dept, salgrade
WHERE emp.deptno = dept.deptno
  AND sal BETWEEN losal AND hisal
  AND empno IN (SELECT mgr FROM emp)
  AND loc = 'DALLAS'
  AND grade IN (3, 4);

-- #11 Find out the employee details of the grade which has the maximum number of the employees who belong from the sales department.
SELECT grade, dname, emp.*
FROM emp, salgrade, dept
WHERE sal BETWEEN losal AND hisal
  AND emp.deptno = dept.deptno
  AND dname = 'SALES' AND grade IN
    (SELECT grade FROM emp, salgrade, dept
     WHERE sal BETWEEN losal AND hisal
     AND emp.deptno = dept.deptno AND dname = 'SALES'
     GROUP BY grade HAVING COUNT(*) =
        (SELECT MAX(COUNT(*)) FROM emp, salgrade, dept
         WHERE sal BETWEEN losal AND hisal
         AND emp.deptno = dept.deptno AND dname = 'SALES'
         GROUP BY grade));

-- #12 List the highest paid emp of Chicago joined before the most recently hired emp of grade 2.
SELECT * FROM emp WHERE sal =
    (SELECT MAX(sal) FROM emp, dept
     WHERE emp.deptno = dept.deptno
     AND loc = 'CHICAGO' AND hiredate <
        (SELECT MAX(hiredate) FROM emp, salgrade
         WHERE sal BETWEEN losal AND hisal AND grade = 2));

-- #13 Increment the salary of the employees to 7% who belong from grade 2.
UPDATE emp SET sal = sal + sal * 0.07
WHERE sal IN
    (SELECT sal FROM emp, salgrade
     WHERE sal BETWEEN losal AND hisal
     AND grade = 2);

-- #14 Update the loc of all employees to Washington from Chicago.
UPDATE dept SET loc = 'CHICAGO'
WHERE loc = 'WASHINGTON';

-- #15 Delete the most senior employee.
DELETE FROM emp WHERE hiredate =
    (SELECT MIN(hiredate) FROM emp);

-- #16 Delete the maximum salary holders from the sales department.
DELETE FROM emp WHERE sal =
    (SELECT MAX(sal) FROM emp WHERE deptno =
        (SELECT deptno FROM dept WHERE dname = 'SALES'));