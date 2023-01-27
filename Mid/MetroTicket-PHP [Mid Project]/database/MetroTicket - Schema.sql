-- DROP USER METROTICKET CASCADE;

CREATE USER METROTICKET IDENTIFIED BY "123";

GRANT CREATE VIEW, CONNECT, RESOURCE, UNLIMITED TABLESPACE TO METROTICKET;

-- manager table
CREATE TABLE manager
(
    mgr_id    number(10) PRIMARY KEY,
    mgr_name  varchar2(20),
    mgr_pass  varchar2(20),
    mgr_email varchar2(50),
    mgr_phone varchar2(20)
);

CREATE SEQUENCE mgr_seq START WITH 1;

INSERT INTO manager VALUES (mgr_seq.nextval, 'Zaid', 'zaid1986', 'zaid@email.com', '0123649849810');
INSERT INTO manager VALUES (mgr_seq.nextval, 'Mgr2', 'mgr2123', 'mgr2@email.com', '0123649849810');
INSERT INTO manager VALUES (mgr_seq.nextval, 'Mgr3', 'mgr3123', 'mgr3@email.com', '0123649849810');
INSERT INTO manager VALUES (mgr_seq.nextval, 'Mgr4', 'mgr4123', 'mgr4@email.com', '0123649849810');
INSERT INTO manager VALUES (mgr_seq.nextval, 'Mgr5', 'mgr5123', 'mgr5@email.com', '0123649849810');


-- passenger table
CREATE TABLE passenger
(
    pass_id       number(10) PRIMARY KEY,
    pass_name     varchar2(20),
    pass_password varchar2(20),
    pass_email    varchar2(50),
    pass_phone    varchar2(20),
    mgr_id        number(10),
    FOREIGN KEY (mgr_id) REFERENCES manager (mgr_id)
);

CREATE SEQUENCE pass_seq START WITH 1;

INSERT INTO passenger VALUES (pass_seq.nextval, 'Raofin', 'raofin123', 'raofin@hotmail.com', '01234567890', 1);
INSERT INTO passenger VALUES (pass_seq.nextval, 'Passenger2', 'passenger2986', 'passenger2@email.com', '01541236140', 3);
INSERT INTO passenger VALUES (pass_seq.nextval, 'Passenger3', 'passenger3986', 'passenger3@email.com', '01234162530', 2);
INSERT INTO passenger VALUES (pass_seq.nextval, 'Passenger4', 'passenger4986', 'passenger4@email.com', '01653416230', 1);
INSERT INTO passenger VALUES (pass_seq.nextval, 'Passenger5', 'passenger5986', 'passenger5@email.com', '01673516360', 3);

-- ticket table
CREATE TABLE ticket
(
    ticket_id     number(10) PRIMARY KEY,
    total_ticket  number(1),
    ticket_status varchar2(10),
    pass_id       number(10),
    FOREIGN KEY (pass_id) REFERENCES passenger (pass_id)
);

CREATE SEQUENCE ticket_seq START WITH 1;

INSERT INTO ticket VALUES (ticket_seq.nextval, 2, 'Booked', 1);
INSERT INTO ticket VALUES (ticket_seq.nextval, 6, 'Available', 3);
INSERT INTO ticket VALUES (ticket_seq.nextval, 5, 'Booked', 2);
INSERT INTO ticket VALUES (ticket_seq.nextval, 2, 'Available', 2);
INSERT INTO ticket VALUES (ticket_seq.nextval, 3, 'Available', 5);


-- schedule table
CREATE TABLE schedule
(
    sch_id         number(10) PRIMARY KEY,
    departure      varchar2(20),
    destination    varchar2(20),
    departure_time date,
    arrival_time   date,
    cost      number(10, 2),
    mgr_id         number(10),
    FOREIGN KEY (mgr_id) REFERENCES manager (mgr_id)
);

CREATE SEQUENCE sche_seq START WITH 1;

INSERT INTO schedule VALUES (sche_seq.nextval, 'Dhaka', 'Noakhali', TO_DATE('07-11-22 11:59 a.m.','dd-mm-yy hh:mi a.m.'), TO_DATE('07-11-22 11:30 a.m.','dd-mm-yy hh:mi a.m.'), 9600, 2);
INSERT INTO schedule VALUES (sche_seq.nextval, 'Rajshahi', 'Dhaka', TO_DATE('08-11-22 10:59 a.m.','dd-mm-yy hh:mi a.m.'), TO_DATE('08-11-22 10:30 a.m.','dd-mm-yy hh:mi a.m.'), 6050, 3);
INSERT INTO schedule VALUES (sche_seq.nextval, 'Chittagong', 'Dhaka', TO_DATE('10-11-22 9:59 a.m.','dd-mm-yy hh:mi a.m.'), TO_DATE('10-11-22 9:30 a.m.','dd-mm-yy hh:mi a.m.'), 4538, 3);
INSERT INTO schedule VALUES (sche_seq.nextval, 'Khulna', 'Pabna', TO_DATE('15-11-22 8:59 a.m.','dd-mm-yy hh:mi a.m.'), TO_DATE('15-11-22 8:30 a.m.','dd-mm-yy hh:mi a.m.'), 1500, 2);
INSERT INTO schedule VALUES (sche_seq.nextval, 'Noakhali', 'Chittagong', TO_DATE('19-11-22 7:59 a.m.','dd-mm-yy hh:mi a.m.'), TO_DATE('09-11-22 7:59 a.m.','dd-mm-yy hh:mi a.m.'), 8601, 5);


-- booking table
CREATE TABLE book
(
    book_id number(10) PRIMARY KEY,
    pass_id number(10),
    sch_id  number(10),
    FOREIGN KEY (pass_id) REFERENCES passenger (pass_id),
    FOREIGN KEY (sch_id) REFERENCES schedule (sch_id)
);

CREATE SEQUENCE book_seq START WITH 1;

INSERT INTO book VALUES (book_seq.nextval, 1, 1);
INSERT INTO book VALUES (book_seq.nextval, 2, 1);
INSERT INTO book VALUES (book_seq.nextval, 3, 3);
INSERT INTO book VALUES (book_seq.nextval, 4, 3);
INSERT INTO book VALUES (book_seq.nextval, 5, 2);

-- order table
CREATE TABLE orders
(
    order_id    number(10) PRIMARY KEY,
    ticket_id   number(10),
    sche_id number(10),
    FOREIGN KEY (ticket_id) REFERENCES ticket (ticket_id),
    FOREIGN KEY (sche_id) REFERENCES schedule (sch_id)
);

CREATE SEQUENCE order_seq START WITH 1;

INSERT INTO orders VALUES (order_seq.nextval, 2, 1);
INSERT INTO orders VALUES (order_seq.nextval, 5, 3);
INSERT INTO orders VALUES (order_seq.nextval, 3, 5);
INSERT INTO orders VALUES (order_seq.nextval, 4, 4);
INSERT INTO orders VALUES (order_seq.nextval, 1, 1);

-- train_class table
CREATE TABLE train_class
(
    class_id number(10) PRIMARY KEY,
    class    varchar2(20),
    min_cost number(10),
    max_cost number(10)
);

CREATE SEQUENCE train_class_seq START WITH 1;

INSERT INTO train_class VALUES (train_class_seq.nextval, 'First Class', 6001, 9999);
INSERT INTO train_class VALUES (train_class_seq.nextval, 'Second Class', 3001, 6000);
INSERT INTO train_class VALUES (train_class_seq.nextval, 'Third Class', 0, 3000);