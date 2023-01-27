-- #1 Display all the managers & clerks name, id along with their department details who work in Accounts and Marketing departments.
SELECT empno, ename, dept.* FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND job IN ('MANAGER', 'CLERK')
  AND dname IN ('ACCOUNTING', 'SALES');

-- #2 Display all the salesmen’s name, job, dname and loc who are not located at DALLAS.
SELECT ename, job, dname, loc FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND job = 'SALESMAN'
  AND loc != 'DALLAS';

-- #3 Select department name & location of all the employees working for CLARK.
SELECT dname, loc FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND ename = 'CLARK';

-- #4 Select all the departmental information for all the managers (Manager is not a job).
SELECT dept.* FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND empno IN (SELECT mgr FROM emp);

-- #5 Select all the employees who work in DALLAS.
SELECT emp.* FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND loc = 'DALLAS';

-- #6 Find the highest paid employee of sales department (Show his empno, ename, dname, sal, loc).
SELECT empno, ename, dept.dname, sal, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND dept.dname = 'SALES' AND emp.sal =
        (SELECT MAX(sal) FROM emp
         WHERE emp.deptno = dept.deptno
         AND dept.dname = 'SALES');

-- #7 List the emps  with departmental information Whose Jobs are same as MILLER or Sal is more than ALLEN.
SELECT * FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND (job = (SELECT job FROM emp WHERE ename = 'MILLER')
       OR sal > (SELECT sal FROM emp WHERE ename = 'ALLEN'));

-- #8 Find out the employees who are working in CHICAGO and DALLAS.
SELECT emp.* FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND loc IN ('CHICAGO', 'DALLAS');

-- #9 List all the Grade 2 and Grade 3 emps.
SELECT grade, emp.* FROM emp, salgrade
WHERE sal BETWEEN salgrade.losal AND salgrade.hisal
  AND salgrade.grade IN (2, 3);

-- #10 Display all Grade 4, 5 Analyst and Manager.
SELECT grade, emp.* FROM emp, salgrade
WHERE sal BETWEEN salgrade.losal AND salgrade.hisal
  AND salgrade.grade IN (4, 5)
  AND job IN ('ANALYST', 'MANAGER');

-- #11 List all the Grade 2 and Grade 3 emps who belong from the Chicago.
SELECT grade, loc, emp.* FROM emp, salgrade, dept
WHERE sal BETWEEN losal AND hisal
  AND emp.deptno = dept.deptno
  AND grade IN (2, 3)
  AND loc = 'CHICAGO';

-- #12 Find the highest paid employee of sales department (Show his empno, ename, dname, sal, loc).
SELECT empno, ename, dname, sal, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND dname = 'SALES'
  AND sal = (SELECT MAX(sal) FROM emp
             JOIN dept ON emp.deptno = dept.deptno
             WHERE dname = 'SALES');

-- #13 Find out the mgr who lives in DALLAS and belong from grade 3 and 4.
SELECT grade, loc, emp.* FROM emp, salgrade, dept
WHERE emp.deptno = dept.deptno
  AND sal BETWEEN losal AND hisal
  AND grade IN (3, 4)
  AND loc = 'DALLAS'
  AND empno IN (SELECT mgr FROM emp);

-- #14 Find out the grade of all mgrs.
SELECT grade, emp.* FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal
  AND empno IN (SELECT mgr FROM emp);