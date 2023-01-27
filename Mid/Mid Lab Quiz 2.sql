-- #1. Find out the details with grade of the second maximum salary holder.
SELECT ename, sal, grade FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal
  AND sal IN (SELECT MAX(sal) FROM emp WHERE sal < (SELECT MAX(sal) FROM emp));

-- #2. Find the grade 2 Analyst who belong from dep 10 or 20.
SELECT * FROM emp, salgrade, dept
WHERE emp.deptno = dept.deptno
  AND sal BETWEEN losal AND hisal
  AND emp.deptno IN (10, 20)
  AND job = 'ANALYST';

-- #3. Find the Salesman of Finance department who belong from the grade 2 and 3.
SELECT * FROM emp, dept, salgrade
WHERE emp.deptno = dept.deptno
  AND sal BETWEEN losal AND hisal
  AND job = 'SALESMAN'
  AND dname = 'SALES'
  AND grade IN (2, 3);

-- #4. Find out the location with the most senior employee.
SELECT loc, emp.* FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND hiredate = (SELECT MIN(hiredate) FROM emp);

-- #5. List out the Name, Job, Salary, grade of the emps in the department with the highest no of employees.
SELECT ename, job, sal, grade, dname
FROM emp, dept, salgrade
WHERE emp.deptno = dept.deptno
  AND sal BETWEEN losal AND hisal
  AND emp.deptno =
      (SELECT emp.deptno FROM emp, dept
       WHERE emp.deptno = dept.deptno
       GROUP BY emp.deptno HAVING COUNT(*) =
            (SELECT MAX (count(*)) FROM emp, dept
             WHERE emp.deptno = dept.deptno
             GROUP BY emp.deptno));

-- #6. List all the Grade2 and Grade 3 salesman who belong from the Chicago and Dallas.
SELECT e.*, s.grade, d.loc
FROM emp e, dept d, salgrade s
WHERE e.deptno = d.deptno
  AND e.sal BETWEEN s.losal AND s.hisal
  AND e.job = 'SALESMAN'
  AND s.grade IN (2, 3)
  AND d.loc IN ('CHICAGO', 'DALLAS');

-- #7. Find the grade where highest no. of emps are working.
SELECT grade, COUNT(*) FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal
GROUP BY grade HAVING COUNT(*) =
    (SELECT MAX(COUNT(*)) FROM emp, salgrade
     WHERE sal BETWEEN losal AND hisal
     GROUP BY grade);

-- #8. Find out the grade of all mgrs.
SELECT grade, emp.* FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal
  AND empno IN (SELECT mgr FROM emp);

-- #10. Find out the lowest paid mgr of CHICAGO.
SELECT * FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND empno IN (SELECT mgr FROM emp) AND sal =
    (SELECT MIN(sal) FROM emp, dept
     WHERE emp.deptno = dept.deptno
     AND loc = 'CHICAGO' AND empno IN (SELECT mgr FROM emp));

-- #11. Find out the details of the grade 2 mgrs Who manage the maximum no of employee.
SELECT m.ename, COUNT(*) FROM emp e, emp m
WHERE e.empno = m.mgr
GROUP BY m.ename HAVING COUNT(*) =
    (SELECT MAX(COUNT(*)) FROM emp e, emp m
     WHERE e.empno = m.mgr GROUP BY m.ename)