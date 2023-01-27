-- #1. Find out the details with grade of the second maximum salary holder.
SELECT * FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal
  AND sal IN (SELECT MAX(sal) FROM emp WHERE sal < (SELECT MAX(sal) FROM emp));

-- #2. Find the grade 2 mgr who belong from dep 10 or 20.
SELECT emp.*, grade, dname FROM emp, dept, salgrade
WHERE emp.deptno = dept.deptno
  AND sal BETWEEN losal AND hisal
  AND emp.deptno IN (10, 20)
  AND grade = 2
  AND empno IN (SELECT mgr FROM emp);

-- #3. Find the highest paid Analyst of the Finance department who belong from the grade 2 and 3.
SELECT * FROM emp WHERE sal IN
    (SELECT MAX(sal) FROM emp, dept, salgrade
     WHERE emp.deptno = dept.deptno
     AND sal BETWEEN losal AND hisal
     AND job = 'ANALYST'
     AND dname = 'FINANCE'
     AND grade IN (2, 3));

-- #4. Find out the dname with the most senior employee.
SELECT dname, emp.* FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND hiredate IN (SELECT MIN(hiredate) FROM emp);

-- #5. List out the Name, Job, Salary, grade of the emps in the department with the highest no of employees.
SELECT ename, job, sal, grade, deptno
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal
  AND deptno IN
    (SELECT deptno FROM emp
     GROUP BY deptno HAVING COUNT(*) IN
        (SELECT MAX(COUNT(*)) FROM emp GROUP BY deptno));

-- #6. Find out the grade with maximum number of salesman.
SELECT grade FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal AND job = 'SALESMAN'
GROUP BY grade HAVING COUNT(*) IN
    (SELECT MAX(COUNT(*)) FROM emp, salgrade
     WHERE sal BETWEEN losal AND hisal
     AND job = 'SALESMAN' GROUP BY grade);

-- #7. List all the Grade2 and Grade 3 salesman who belong from the Chicago and Dallas.
SELECT grade, loc, emp.* FROM emp, dept, salgrade
WHERE emp.deptno = dept.deptno AND sal BETWEEN losal AND hisal
  AND job = 'SALESMAN' AND grade IN (2, 3) AND loc IN ('CHICAGO', 'DALLAS');

-- #8. List THE Name of loc where highest no. of emps are working.
SELECT deptno, loc FROM dept
WHERE deptno IN 
    (SELECT deptno FROM emp GROUP BY deptno
     HAVING COUNT(*) IN (SELECT MAX(COUNT(*)) FROM emp GROUP BY deptno));

-- #9. Find out the grade of all mgrs.
SELECT grade, emp.* FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal
  AND empno IN (SELECT mgr FROM emp);

-- #11. Find out the mgr who lives in DALLAS and belong from grade 3 and 4.
SELECT emp.*, loc, grade FROM emp, dept, salgrade
WHERE emp.deptno = dept.deptno AND sal BETWEEN losal AND hisal
  AND loc = 'DALLAS' AND grade IN (3, 4)
  AND empno IN (SELECT mgr FROM emp);

-- #13. Find out the details of the SALESMAN whose location is same as Miller and grad is same like CLARK. (Without using subquery)
SELECT e.*
FROM emp e, emp em, emp ec, dept d, dept dm, dept dc, salgrade s, salgrade sm, salgrade sc
WHERE e.deptno = d.deptno AND em.deptno = dm.deptno AND ec.deptno = dc.deptno
AND e.sal BETWEEN s.losal AND s.hisal AND ec.sal BETWEEN sc.losal AND sc.hisal
AND e.job = 'SALESMAN' AND em.ename = 'MILLER' AND ec.job = 'CLARK'
AND s.grade = sc.grade AND d.loc = dm.loc;