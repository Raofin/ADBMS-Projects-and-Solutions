-- 1. Find the train arrival time and total cost of a first-class train schedule with a destination of Dhaka.
SELECT arrival_time, cost FROM schedule, train_class
WHERE cost BETWEEN min_cost AND max_cost
AND destination = 'Dhaka' AND class = 'First Class';

-- 2. Find the passenger who booked the maximum number of train schedules.
SELECT pass_name FROM passenger
WHERE pass_id IN 
  (SELECT p.pass_id FROM passenger p, schedule s, book b
   WHERE p.pass_id = b.pass_id AND b.sch_id = s.sch_id
   GROUP BY p.pass_id HAVING COUNT(p.pass_id) IN 
     (SELECT MAX(COUNT(p.pass_id)) FROM passenger p, schedule s, book b       
      WHERE p.pass_id = b.pass_id AND b.sch_id = s.sch_id 
      GROUP BY p.pass_id));

-- 3. Find the total number of tickets booked for each train schedules.
SELECT schedule.sch_id, SUM(ticket.total_ticket) 
FROM schedule, ticket, orders
WHERE ticket.ticket_id = orders.ticket_id 
AND orders.sche_id = schedule.sch_id
GROUP BY schedule.sch_id;

-- 4. Find out the passengers who is going to Noakhali and when their train arrives.
SELECT pass_name, arrival_time FROM passenger c, schedule f, book b
WHERE c.pass_id = b.pass_id AND b.sch_id = f.sch_id 
AND destination = 'Noakhali';

-- 5. Find the departure time of the cheapest first-class train schedule.
SELECT * FROM schedule, train_class
WHERE cost BETWEEN min_cost AND max_cost AND cost IN 
   (SELECT MIN(cost) FROM schedule, train_class
    WHERE cost BETWEEN min_cost AND max_cost AND class = 'First Class');

-- 6. Find the manager who managed the maximum train schedules.
SELECT * FROM manager WHERE mgr_id IN 
   (SELECT m.mgr_id FROM manager m, schedule s WHERE m.mgr_id = s.mgr_id
    GROUP BY m.mgr_id HAVING COUNT(m.mgr_id) IN 
        (SELECT MAX(COUNT(m.mgr_id)) FROM manager m, schedule s
         WHERE m.mgr_id = s.mgr_id GROUP BY m.mgr_id));

-- 7. Find departure, destination, and cost of the train schedules for second and third classes managed by manager 3.
SELECT departure, destination, cost FROM manager, schedule, train_class
WHERE cost BETWEEN min_cost AND max_cost
AND manager.mgr_id = schedule.mgr_id AND manager.mgr_id = 3 AND class IN 
   (SELECT class FROM schedule, train_class 
    WHERE cost BETWEEN min_cost AND max_cost
    AND class IN ('Second Class', 'Third Class'));

-- 8. Find the destination with the average cost in second class train schedules.
SELECT destination, ROUND(AVG(cost)) FROM schedule, train_class
WHERE cost BETWEEN min_cost AND max_cost 
GROUP BY destination HAVING AVG(cost) = 
   (SELECT MAX(AVG(cost)) FROM schedule, train_class
    WHERE cost BETWEEN min_cost AND max_cost GROUP BY destination);

-- 9. Find the train schedule with maximum cost.
SELECT * FROM schedule
WHERE cost = (SELECT MAX(cost) FROM schedule);

-- 10. Find all train schedule information that has the most tickets booked.
SELECT * FROM schedule WHERE sch_id IN 
   (SELECT s.sch_id FROM schedule s, ticket t, orders o
    WHERE t.ticket_id = o.ticket_id AND o.sche_id = s.sch_id
    AND ticket_status = 'Booked'
    GROUP BY s.sch_id HAVING SUM(t.total_ticket) IN
       (SELECT MAX(SUM(t.total_ticket)) 
        FROM schedule f, ticket t, orders o
        WHERE t.ticket_id = o.ticket_id AND o.sche_id = s.sch_id
        AND ticket_status = 'Booked' GROUP BY s.sch_id));
