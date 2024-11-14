-- Task1
-- Project Title: Academic Management System

-- Database: "SQLB3_DB"

-- DROP DATABASE "SQLB3_DB";

CREATE DATABASE "SQLB3_DB"
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'Portuguese_Brazil.1252'
       LC_CTYPE = 'Portuguese_Brazil.1252'
       CONNECTION LIMIT = -1;

-- creating table StudentInfo
CREATE TABLE StudentInfo (
	STU_ID INT PRIMARY KEY,
	STU_NAME VARCHAR(50),
	DOB DATE,
	PHONE_NO VARCHAR(15),
	EMAIL_ID VARCHAR(100),
	ADDRESS VARCHAR(250)
);

-- creating table CoursesInfo
CREATE TABLE CoursesInfo (
	COURSE_ID INT PRIMARY KEY,
	COURSE_NAME VARCHAR(50),
	COURSE_INSTRUCTOR_NAME VARCHAR(50)
);

-- creating table EnrollmentInfo
CREATE TABLE EnrollmentInfo (
	ENROLLMENT_ID INT PRIMARY KEY,
	STU_ID INT,
	COURSE_ID INT,
	FOREIGN KEY (STU_ID) REFERENCES StudentInfo(STU_ID),
	FOREIGN KEY (COURSE_ID) REFERENCES CoursesInfo(COURSE_ID),
	ENROLL_STATUS VARCHAR(15)
	CHECK (ENROLL_STATUS IN ('Enrolled', 'Not Enrolled'))
);

-- 2.Data Creation:
-- adding values to StudentInfo table
INSERT INTO StudentInfo (STU_ID, STU_NAME, DOB, PHONE_NO, EMAIL_ID, ADDRESS)
VALUES 	(1, 'Student One', '1991-01-01','11111111111','example1@email.com','Adress 1 - n1'),
	(2, 'Student Two', '1992-02-02','22222222222','example2@email.com','Adress 2 - n2'),
	(3, 'Student Three','1993-03-03','33333333333','example3@email.com','Adress 3 - n3'),
	(4, 'Student Four', '1994-04-04','44444444444','example4@email.com','Adress 4 - n4'),
	(5, 'Student Five', '1995-05-05','5555555555','example5@email.com','Adress 5 - n5')
;

-- adding values to StudentInfo table
INSERT INTO CoursesInfo (COURSE_ID, COURSE_NAME, COURSE_INSTRUCTOR_NAME)
VALUES 	(1, 'Course1', 'Instructor Name1'),
	(2, 'Course2', 'Instructor Name2'),
	(3, 'Course3', 'Instructor Name3')
;

-- adding values to EnrollmentInfo table
INSERT INTO EnrollmentInfo (ENROLLMENT_ID, STU_ID, COURSE_ID, ENROLL_STATUS)
VALUES 	(1, 1, 1, 'Enrolled'),
	(2, 1, 2, 'Not Enrolled'),
	(3, 1, 3, 'Enrolled'),
	(4, 2, 1, 'Not Enrolled'),
	(5, 2, 2, 'Not Enrolled'),
	(6, 2, 3, 'Enrolled'),
	(7, 3, 1, 'Enrolled'),
	(8, 3, 2, 'Not Enrolled'),
	(9, 3, 3, 'Enrolled'),
	(10, 4, 1, 'Not Enrolled'),
	(11, 4, 2, 'Not Enrolled'),
	(12, 4, 3, 'Enrolled'),
	(13, 5, 1, 'Enrolled'),
	(14, 5, 2, 'Not Enrolled'),
	(15, 5, 3, 'Enrolled')
;

-- 3.Retrieve the Student Information
-- a) retrieving student name, contact informations, and Enrollment status
SELECT 
	si.STU_NAME, 
	si.PHONE_NO, 
	si.EMAIL_ID,
	ei.ENROLL_STATUS
FROM	
	StudentInfo si
LEFT JOIN
	EnrollmentInfo ei ON
	si.STU_ID = ei.STU_ID
;
	
--b) retrieving a list of courses in which a specific student is enrolled
SELECT
	si.STU_NAME,
	ci.COURSE_NAME,
	ei.ENROLL_STATUS
FROM
	StudentInfo si
LEFT JOIN 
	EnrollmentInfo ei ON
	si.STU_ID = ei.STU_ID
LEFT JOIN
	CoursesInfo ci ON
	ei.COURSE_ID = ci.COURSE_ID
WHERE
	si.STU_ID = 3 AND
	ENROLL_STATUS = 'Enrolled'
;
	
--c) retrieving course information, course name, instructor information
SELECT * FROM CoursesInfo;

--d) retrieving course information for a specific course
SELECT * FROM CoursesInfo WHERE course_id = 1;

--e) retrieving course information for multiple courses
SELECT * FROM CoursesInfo WHERE course_id IN (1,3);

-- 4. Reporting and Analytics
--a) retrieving the number of students enrolled in each course
SELECT 
	ci.COURSE_NAME,
	COUNT(ei.COURSE_ID)
FROM 
	EnrollmentInfo ei
LEFT JOIN
	CoursesInfo ci ON
	ei.COURSE_ID = ci.COURSE_ID
GROUP BY
	ci.COURSE_NAME
;

--b) retrieving the list of students enrolled in a specific course
SELECT 
	ci.COURSE_NAME,
	COUNT(ei.COURSE_ID)
FROM 
	EnrollmentInfo ei
LEFT JOIN
	CoursesInfo ci ON
	ei.COURSE_ID = ci.COURSE_ID
WHERE
	ei.COURSE_ID = 2
GROUP BY
	ci.COURSE_NAME
;

--c) retrieving the count of enrolled students for each instructor
SELECT
	ci.COURSE_INSTRUCTOR_NAME,
	COUNT(ei.ENROLL_STATUS)
FROM
	CoursesInfo ci
INNER JOIN
	EnrollmentInfo ei ON
	ci.COURSE_ID = ei.COURSE_ID
WHERE 
	ei.ENROLL_STATUS = 'Enrolled'
GROUP BY
	ci.COURSE_INSTRUCTOR_NAME

--d) retrieving the list of students who are enrolled in multiple courses
SELECT
	si.STU_NAME,
	COUNT(ei.ENROLL_STATUS)
FROM
	StudentInfo si
LEFT JOIN 
	EnrollmentInfo ei ON
	si.STU_ID = ei.STU_ID
LEFT JOIN
	CoursesInfo ci ON
	ei.COURSE_ID = ci.COURSE_ID
WHERE
	ei.ENROLL_STATUS = 'Enrolled'
GROUP BY
	si.STU_NAME
HAVING
	COUNT(ei.ENROLL_STATUS) > 1
;

--e) Write a query to retrieve the courses that have the highest number of enrolled
--   students(arranging from highest to lowest)
SELECT
	ci.COURSE_NAME,
	COUNT(ei.COURSE_ID)
FROM 
	CoursesInfo ci
LEFT JOIN
	EnrollmentInfo ei ON
	ci.COURSE_ID = ei.COURSE_ID
WHERE
	ei.ENROLL_STATUS = 'Enrolled'
GROUP BY
	ci.COURSE_NAME
ORDER BY
	COUNT(ei.COURSE_ID) DESC
