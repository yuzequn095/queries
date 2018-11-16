/*
 * Name: Zequn Yu
 * Login: zey031
 */

/*
 * A.
 */

/*
 * create table student (sid text PRIMARY KEY);
 * create table course (cid text PRIMARY KEY);
 * create table prerequisite (cid text PRIMARY KEY FOREIGN KEY REFERENCES
 *                            course(cid), pre_cid text PRIMARY KEY FOREIGN KEY  *                            REFERENCES course(cid));
 * create table record (sid text PRIMARY KEY FOREIGN KEY REFERENCES
 *                      student(sid), cid text PRIMARY KEY FOREIGN KEY
 *                      REFERENCES course(cid), qtr text PRIMARY KEY,
 *                      year integer PRIMARY KEY, grade integer);
 */

 /*
  * B.
  */

/* 
 * 1.Compute the GPA
 */
SELECT sid, AVG(grade) AS gpa FROM record
WHERE (qtr = 'F' AND year = 2015) OR((qtr = 'W' OR qtr = 'S') AND year = 2016)
GROUP BY sid;

/*
 2.
 */
 SELECT s1.sid, s2.sid
 FROM record s1, record s2
 WHERE (s1.year=2016 AND s2.year=2016) AND (s1.qtr='F' AND s2.qtr='F') AND (s1.cid=s2.cid) AND (s1.sid > s2.sid)
 GROUP BY s1.sid, s2.sid;

/*
 * 3.
 */
SELECT qtr,year,COUNT(cid) AS num
FROM
(SELECT qtr,year,cid
FROM record
GROUP BY qtr,year,cid
HAVING COUNT(sid)>0 AND COUNT(sid)<5)
GROUP BY qtr,year;

/*
 *4.
 */
SELECT sid, COUNT(cid) AS num
FROM record
WHERE (qtr='F') AND (year=2016)
GROUP BY sid
UNION
SELECT DISTINCT sid, 0 AS num
FROM record r
WHERE NOT EXISTS
(SELECT sid
FROM record
WHERE (sid=r.sid) AND (qtr='F') AND (year=2016));

/*
 * 5.
 */
/* NOT EXISTS */
 SELECT s.sid
 FROM student s
 WHERE NOT EXISTS
 (SELECT * FROM prerequisite p
 WHERE p.cid = 'CSE132X' AND NOT EXISTS
 (SELECT * FROM record r
 WHERE r.sid = s.sid AND r.cid = p.pre_cid and (r.grade >2 OR r.grade = 2)));
/* NOT IN */
SELECT s.sid
FROM student s
WHERE s.sid NOT IN
(SELECT sid
FROM prerequisite p
WHERE p.cid='CSE132X' AND s.sid NOT IN
(SELECT sid
FROM record r
WHERE r.sid = s.sid AND r.cid = p.pre_cid and (r.grade >2 OR r.grade = 2)));

/*
 * 6.
 */

/*
 * 7.
 */
UPDATE record SET cid = CASE
               WHEN cid = 'CSE132A' THEN 'CSE132B'
               WHEN cid = 'CSE132B' THEN 'CSE132A'
               ELSE cid
             END
WHERE qtr = 'F' AND year = 2016;
