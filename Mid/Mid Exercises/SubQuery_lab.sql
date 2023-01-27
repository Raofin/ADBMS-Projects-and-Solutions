-- #1 Show the details of the min salary holder of the employee table.
SELECT * FROM emp
WHERE sal = (SELECT MIN(sal) FROM emp);

-- #2 Find the details of the most senior employee.
SELECT * FROM emp
WHERE hiredate = (SELECT MIN(hiredate) FROM emp);

-- #3 Select all the employees who are earning same as BLAKE.
SELECT * FROM emp
WHERE sal = (SELECT sal FROM emp WHERE ename = 'BLAKE');

-- #4 Display all the employees who have joined after FORD.
SELECT * FROM emp
WHERE hiredate > (SELECT hiredate FROM emp WHERE ename = 'FORD');

-- #5 List all the employees who are earning more than SMITH and less then KING.
SELECT * FROM emp
WHERE sal > (SELECT sal FROM emp WHERE ename = 'SMITH')
  AND sal < (SELECT sal FROM emp WHERE ename = 'KING');

-- #6 Find the employees who work in the same department with BLAKE.
SELECT * FROM emp
WHERE deptno = (SELECT deptno FROM emp WHERE ename = 'BLAKE');

-- #7 Display all the salesmen who are not located at DALLAS.
SELECT * FROM emp
WHERE job = 'SALESMAN'
  AND deptno != (SELECT deptno FROM dept WHERE loc = 'DALLAS');

-- #8 Select department name & location of all the employees working for CLARK.
SELECT dname, loc FROM dept
WHERE deptno = (SELECT deptno FROM emp WHERE mgr = (SELECT empno FROM emp WHERE ename = 'CLARK'));

-- #9 Select all the departmental information for all the managers.
SELECT * FROM dept
WHERE deptno IN (SELECT deptno FROM emp WHERE job = 'MANAGER');

-- #10 Display all the managers & clerks who work in Accounts and Marketing departments.
SELECT * FROM emp
WHERE job IN ('MANAGER', 'CLERK')
  AND deptno IN (SELECT deptno FROM dept WHERE dname IN ('ACCOUNTING', 'MARKETING'));

-- #11 Select all the employees who work in DALLAS.
SELECT * FROM emp
WHERE deptno = (SELECT deptno FROM dept WHERE loc = 'DALLAS');