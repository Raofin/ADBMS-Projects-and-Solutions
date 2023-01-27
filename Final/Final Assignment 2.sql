-- #1.
CREATE TABLE emp
(
    emp_num     NUMBER(5)    NOT NULL,
    name        VARCHAR2(30) NOT NULL,
    join_date   DATE         NOT NULL,
    designation VARCHAR2(20) NOT NULL,
    salary      NUMBER(8, 2) NOT NULL,
    dept_num    NUMBER(3)    NOT NULL
);

CREATE OR REPLACE PACKAGE pkg_employee AS
    PROCEDURE get_employee_info(p_emp_num IN NUMBER);

    FUNCTION get_dept_salary(p_dept_num IN NUMBER)
        RETURN NUMBER;
END pkg_employee;

CREATE OR REPLACE PACKAGE BODY pkg_employee AS
    PROCEDURE get_employee_info(p_emp_num IN NUMBER) AS
        v_name        emp.name%TYPE;
        v_join_date   emp.join_date%TYPE;
        v_designation emp.designation%TYPE;
    BEGIN
        SELECT name, join_date, designation
        INTO v_name, v_join_date, v_designation
        FROM emp
        WHERE emp_num = p_emp_num;

        DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Join Date: ' || v_join_date);
        DBMS_OUTPUT.PUT_LINE('Designation: ' || v_designation);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No employee found with emp_num: ' || p_emp_num);
    END get_employee_info;

    FUNCTION get_dept_salary(p_dept_num IN NUMBER) RETURN NUMBER AS
        v_dept_salary        emp.salary%TYPE;
    BEGIN
        SELECT SUM(salary) INTO v_dept_salary FROM emp
        WHERE dept_num = p_dept_num;

        RETURN v_dept_salary;
    END get_dept_salary;
END pkg_employee;

CREATE OR REPLACE PROCEDURE get_dept_salary_procedure(p_dept_num IN NUMBER) AS
    v_dept_salary emp.salary%TYPE;
BEGIN
    v_dept_salary := pkg_employee.get_dept_salary(p_dept_num);

    DBMS_OUTPUT.PUT_LINE(v_dept_salary);
END get_dept_salary_procedure;
---------------------------------------------------------------------

-- #2.
CREATE OR REPLACE TRIGGER salary_change_monitoring
    BEFORE UPDATE ON emp
    FOR EACH ROW
DECLARE
    v_max_salary emp.salary%type;
BEGIN
    SELECT :OLD.salary + (:OLD.salary * 0.2) INTO v_max_salary FROM emp;

    IF :NEW.salary > v_max_salary THEN
        RAISE_APPLICATION_ERROR(-20000, 'Salary change exceeds 20% limit');
    END IF;
END;
---------------------------------------------------------------------