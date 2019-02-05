create table Course(
	course_cd char(5),
	course_name varchar(30) not null,
	credits int not null,
	PRIMARY KEY(course_cd)
);
insert into Course values("CS101", "PDS", 3);
insert into Course values("PH101", "Physics 1", 3);
insert into Course values("MA101", "Maths 1", 3);
insert into Course values("ME101", "Mechanics", 3);
insert into Course values("CS201", "Algorithms", 4);
insert into Course values("CS301", "DBMS", 5);
create table Department(
	dept_cd char(2),
	dept_name varchar(30) not null,
	no_of_faculty_memebers int not null,
	year_of_establishment int not null,
	PRIMARY KEY(dept_cd)
);
insert into Department values("CS", "Computer Science", 40, 1980);
insert into Department values("PH", "Physics", 50, 1960);
insert into Department values("MA", "Mathematics", 20, 1993);
insert into Department values("ME", "Mechanical", 35, 1954);
create table State(
	state_cd char(2),
	state_name varchar(30) not null,
	no_of_districts int not null,
	PRIMARY KEY(state_cd)
);
insert into State values("GA", "Goa", 3);
insert into State values("CA", "California", 10);
insert into State values("KA", "Karnataka", 6);
insert into State values("TN", "Tamil Nadu", 2);
insert into State values("KL", "Kerala", 7);
insert into State values("WB", "West Bengal", 10);


create table Student(
	roll_no int,
	student_name varchar(30 ) not null,
	date_of_joining date not null,
	date_of_passing_out date,
	dept_cd char(2) not null,
	cgpa numeric(5, 2),
	state_cd char(2),
	PRIMARY KEY(roll_no),
	FOREIGN KEY fk_dept1(dept_cd) REFERENCES Department(dept_cd),
	FOREIGN KEY fk_state1(state_cd) REFERENCES State(state_cd)
);
insert into Student values(1, "Sankalp", "2016-05-20", "2021-05-01", "CS", null, "GA");
insert into Student values(2, "Shubam", "2016-05-21", "2021-05-01", "CS", null, "CA");
insert into Student values(3, "Nikhil", "2016-05-20", "2021-05-01", "CS", null, "KA");
insert into Student values(4, "Nilly", "2016-05-20", "2021-05-01", "PH", null, "KA");
insert into Student values(5, "Vineet", "2016-05-20","2021-05-01", "MA", null, "TN");
insert into Student values(6, "Lilly", "2016-05-20","2021-05-01", "ME", null, "KL");
insert into Student values(7, "Shoumabo", "2016-05-20","2021-05-01", "ME", null, "WB");
insert into Student values(8, "Sham", "2016-05-20","2021-05-01", "MA", null, "WB");

create table Department_Course(
	course_cd char(5),
	dept_cd char(2),
	PRIMARY KEY(course_cd, dept_cd),
	FOREIGN KEY fk_dept2(dept_cd) REFERENCES Department(dept_cd),
	FOREIGN KEY fk_course1(course_cd) REFERENCES Course(course_cd)
);
insert into Department_Course values("CS101", "CS");
insert into Department_Course values("CS101", "MA");
insert into Department_Course values("CS201", "CS");
insert into Department_Course values("CS301", "CS");
insert into Department_Course values("MA101", "MA");
insert into Department_Course values("ME101", "ME");
insert into Department_Course values("PH101", "PH");
create table Registration(
	roll_no int,
	course_cd char(5),
	grade_point int,
	PRIMARY KEY(roll_no, course_cd),
	FOREIGN KEY fk_course2(course_cd) REFERENCES Course(course_cd),
	FOREIGN KEY fk_roll(roll_no) REFERENCES Student(roll_no)
);
insert into Registration values(1, "CS101", 10);
insert into Registration values(2, "CS101", 8);
insert into Registration values(3, "CS101", 9);
insert into Registration values(4, "CS101", 7);
insert into Registration values(5, "CS101", 10);
insert into Registration values(1, "CS201", 6);
insert into Registration values(1, "CS301", 5);
insert into Registration values(1, "PH101", 10);
insert into Registration values(6, "ME101", 10);
insert into Registration values(7, "ME101", 8);
insert into Registration values(7, "MA101", 8);

1] update Student as S,
	(select roll_no, sum(grade_point * credits) / sum(credits) as cgpa
	from Course as C inner join Registration as R
	ON C.course_cd = R.course_cd
	group by roll_no) as X
	set S.cgpa = X.cgpa
	where S.roll_no = X.roll_no AND S.state_cd = "WB";	

2] insert into State
	select "MH", "Maharashtra", count(*)
	from Course 
	where course_name like "_C_" or course_name like "_C";

3] delete from State where
	State.state_cd not in (select DISTINCT state_cd from Student);

4] with X as (select D.dept_cd, dept_name, students/no_of_faculty_memebers as r
	from Department as D, (select dept_cd, count(*) as students from Student
	where date_of_passing_out > "2019-02-05" or date_of_passing_out is null
	group by dept_cd) as S
	where S.dept_cd = D.dept_cd)
	select X.dept_cd, dept_name
	from X
	where X.r = (select max(r) from X);

5] select C.course_cd, course_name
	from Course as C, (select course_cd
	from Department_Course
	group by course_cd
	having count(*) > 1) as A
	where C.course_cd = A.course_cd AND
	C.course_cd in (with X as (select distinct course_cd, dept_cd
	from Registration as R inner join Student as S
	on R.roll_no = S.roll_no)
	select course_cd
	from X
	group by course_cd having count(*) >= 3);

6] with X as (select distinct course_cd, dept_cd
	from Registration as R inner join Student as S
	on R.roll_no = S.roll_no)
	select C.course_cd, course_name
	from Course as C, X, Department_Course as DC
	where C.course_cd = X.course_cd and C.course_cd = DC.course_cd and  X.dept_cd <> DC.dept_cd;

7] select state_cd, state_name
	from State as St, Student as S
	where St.no_of_districts < 5 and S.state_cd = St.state_cd and 

8] with CG as (select distinct cgpa	from Student)
	select roll_no, student_name
	from Student as S, (select cgpa from CG order by cgpa desc limit 4, 1) as X
	where S.cgpa = X.cgpa ;

9] select S.state_cd, state_name, count(*)
	from State as St, Student as S
	where St.state_cd = S.state_cd
	group by state_cd;

10] select C.course_cd, course_name
	from Course as C, Department_Course as DC, Department as D 
	where C.course_cd = DC.course_cd and D.dept_cd = DC.dept_cd AND D.year_of_establishment > (select max(date_of_joining) from Student);
	