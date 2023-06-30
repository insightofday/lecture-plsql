create table department(
deptid number(10) not null ,
deptname varchar2(10),
location varchar2(10),
tel varchar2(15)
);


sELECT VALUE FROM NLS_SESSION_PARAMETERS WHERE PARAMETER = 'NLS_DATE_FORMAT';
alter session set nls_date_format=yyyymmdd;

create table employee(
empid number(10) not null,
empname varchar2(10),
hiredate date,
addr varchar2(12),
tel varchar2(15),
deptid number(10) --foreignkey걸기:references department(deptid)
);
--테이블레벨로 외래키걸기 foreign key(deptid) references department(deptid)

alter table employee add birthday date;

alter table employee modify empname not null;--notnull을 제외한 제약조건은 삭제불가함. drop후 새로 만들어야 함
commit;

--데이트다룰때 to_date('12/02/02','120202')
insert into employee(empid,empname,hiredate,addr,tel,deptid)values(20121945,'박민수','20120302','대구','010-1111-1234',1001);
insert into employee(empid,empname,hiredate,addr,tel,deptid)values(20101817,'박준식','20190901','경산','010-2222-1234',1003);
insert into employee(empid,empname,hiredate,addr,tel,deptid)values(20122245,'선아라','20120302','대구','010-3333-1222',1002);
insert into employee(empid,empname,hiredate,addr,tel,deptid)values(20121719,'이범수','20110302','서울','010-3333-4444',1001);
insert into employee(empid,empname,hiredate,addr,tel,deptid)values(20121646,'이융희','20120901','부산','010-1234-2222',1003);

insert into department(deptid,deptname,location,tel) values(1003,'영업팀','본103호','053-222-3333');

select e.empid,e.hiredate,d.deptname from employee e join department d  on d.deptid=e.deptid where deptname='총무팀';--표준join 서브쿼리안써도될때는쓰지마(성능떠러져)

delete employee where addr='대구';

update employee set deptid=(select deptid from department where deptname='회계팀') where deptid=(select deptid from department where deptname='영업팀');


------------------------------------------------------------------------
select e.empid,e.empname,e.birthday,d.deptname from employee e join department d on(d.deptid=e.deptid) where e.hiredate>(select hiredate from employee where empid=20121729);
--밑에거권한없어서안되긴함
create view emp_vu as select e.empname,e.addr,d.deptname from employee e join department d on d.deptid=e.deptid where d.deptname='총무팀';

select * from emp_vu;


select * from employee;
select* from department;
desc employee;