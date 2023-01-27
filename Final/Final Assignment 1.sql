-- #Schema
CREATE TABLE student
(
    snum     number(10) PRIMARY KEY,
    sname    varchar2(20),
    standing number(10),
    gpa      float(2)
);
INSERT INTO student VALUES (111, 'Andy', 4, NULL);
INSERT INTO student VALUES (222, 'Betty', 2, NULL);
INSERT INTO student VALUES (333, 'Cindy', 3, NULL);

CREATE TABLE course
(
    cnum     number(10) PRIMARY KEY,
    ctitle   varchar2(20),
    crhr     varchar2(20),
    standing number(10),
    capacity number(10)
);
INSERT INTO course VALUES (240, 'Intro to MIS', 3, 2, 5);
INSERT INTO course VALUES (301, 'Statistics', 3, 3, 5);
INSERT INTO course VALUES (380, 'Database', 3, 3, 3);

CREATE TABLE enroll
(
    eid   number(10) PRIMARY KEY,
    s#    number(10),
    c#    number(10),
    grade varchar2(2)
);
CREATE SEQUENCE enroll_seq START WITH 1;
INSERT INTO enroll VALUES (enroll_seq.nextval, 111, 240, 'A');
INSERT INTO enroll VALUES (enroll_seq.nextval, 333, 240, 'B');
---------------------------------------------------------------------

-- #1
DECLARE
    v_snum student.snum%type := :snum;
    v_tcr  number(3);
BEGIN
    SELECT COUNT(c#) * 3 INTO v_tcr FROM enroll WHERE s# = v_snum;
    IF v_tcr BETWEEN 0 AND 30 THEN
        UPDATE student SET standing = 1 WHERE snum = v_snum;
    ELSIF v_tcr BETWEEN 31 AND 60 THEN
        UPDATE student SET standing = 2 WHERE snum = v_snum;
    ELSIF v_tcr BETWEEN 61 AND 90 THEN
        UPDATE student SET standing = 3 WHERE snum = v_snum;
    ELSIF v_tcr > 91 THEN
        UPDATE student SET standing = 4 WHERE snum = v_snum;
    END IF;
END;
---------------------------------------------------------------------


-- #2
CREATE OR REPLACE FUNCTION checkValidStudent(psnum student.snum%type)
RETURN boolean
IS
    v_snum student.snum%type := 0;
BEGIN
    SELECT COUNT(snum) INTO v_snum FROM student WHERE snum = psnum;
    IF v_snum = 0 THEN RETURN FALSE;
    ELSE RETURN TRUE;
    END IF;
END;

CREATE OR REPLACE FUNCTION checkValidCourse(pcnum course.cnum%type)
RETURN boolean
IS
    v_cnum course.cnum%type := 0;
BEGIN
    SELECT COUNT(cnum) INTO v_cnum FROM course WHERE cnum = pcnum;
    IF v_cnum = 0 THEN RETURN FALSE;
    ELSE RETURN TRUE;
    END IF;
END;

CREATE OR REPLACE FUNCTION checkStanding(
        psnum student.snum%type, pcnum course.cnum%type)
RETURN boolean
IS
    v_stu_sta student.standing%type;
    v_cou_sta course.standing%type;
BEGIN
    SELECT standing INTO v_stu_sta FROM student WHERE snum = psnum;
    SELECT standing INTO v_cou_sta FROM course WHERE cnum = pcnum;
    IF v_stu_sta >= v_cou_sta THEN RETURN TRUE;
    ELSE RETURN FALSE;
    END IF;
END;

CREATE OR REPLACE FUNCTION checkClassCapacity(pcnum course.cnum%type)
RETURN boolean
IS
    v_cou_capacity course.capacity%type;
    v_enr_count course.capacity%type;
BEGIN
    SELECT capacity INTO v_cou_capacity FROM course WHERE cnum = pcnum;
    SELECT COUNT(*) INTO v_enr_count FROM enroll WHERE c# = pcnum;
    IF v_cou_capacity > v_enr_count THEN RETURN TRUE;
    ELSE RETURN FALSE;
    END IF;
END;

CREATE OR REPLACE PROCEDURE AddCourse(
        psnum IN student.snum%type, pcnum IN course.cnum%type)
IS
    is_stu_valid  boolean;
    is_cou_valid  boolean;
    is_sta_valid  boolean;
    is_cap_valid  boolean;
    is_enrolled   number(2);
    t_enr_credits number(2);
BEGIN
    is_stu_valid := checkValidStudent(psnum);
    is_cou_valid := checkValidCourse(pcnum);
    is_sta_valid := checkStanding(psnum, pcnum);
    is_cap_valid := checkClassCapacity(pcnum);

    SELECT COUNT(*) * 3 INTO t_enr_credits FROM enroll
    WHERE grade IS NOT NULL AND s# = psnum;

    SELECT COUNT(*) INTO is_enrolled FROM ENROLL
    WHERE s# = psnum AND c# = pcnum;

    IF is_stu_valid AND is_cou_valid AND is_sta_valid AND
       is_cap_valid AND is_enrolled = 0 AND t_enr_credits <= 15 THEN
        INSERT INTO enroll VALUES (enroll_seq.nextval, psnum, pcnum, NULL);
        DBMS_OUTPUT.PUT_LINE('The course has been added.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Unable to add the course.');
    END IF;
END;

DECLARE
    v_snum student.snum%type := :snum;
    v_cnum course.cnum%type := :cnum;
BEGIN
    AddCourse(v_snum, v_cnum);
END;
---------------------------------------------------------------------