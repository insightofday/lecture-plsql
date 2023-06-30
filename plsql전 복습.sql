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
deptid number(10) --foreignkey�ɱ�:references department(deptid)
);
--���̺����� �ܷ�Ű�ɱ� foreign key(deptid) references department(deptid)

alter table employee add birthday date;

alter table employee modify empname not null;--notnull�� ������ ���������� �����Ұ���. drop�� ���� ������ ��
commit;

--����Ʈ�ٷ궧 to_date('12/02/02','120202')
insert into employee(empid,empname,hiredate,addr,tel,deptid)values(20121945,'�ڹμ�','20120302','�뱸','010-1111-1234',1001);
insert into employee(empid,empname,hiredate,addr,tel,deptid)values(20101817,'���ؽ�','20190901','���','010-2222-1234',1003);
insert into employee(empid,empname,hiredate,addr,tel,deptid)values(20122245,'���ƶ�','20120302','�뱸','010-3333-1222',1002);
insert into employee(empid,empname,hiredate,addr,tel,deptid)values(20121719,'�̹���','20110302','����','010-3333-4444',1001);
insert into employee(empid,empname,hiredate,addr,tel,deptid)values(20121646,'������','20120901','�λ�','010-1234-2222',1003);

insert into department(deptid,deptname,location,tel) values(1003,'������','��103ȣ','053-222-3333');

select e.empid,e.hiredate,d.deptname from employee e join department d  on d.deptid=e.deptid where deptname='�ѹ���';--ǥ��join ���������Ƚᵵ�ɶ��¾�����(���ɶ�����)

delete employee where addr='�뱸';

update employee set deptid=(select deptid from department where deptname='ȸ����') where deptid=(select deptid from department where deptname='������');


------------------------------------------------------------------------
select e.empid,e.empname,e.birthday,d.deptname from employee e join department d on(d.deptid=e.deptid) where e.hiredate>(select hiredate from employee where empid=20121729);
--�ؿ��ű��Ѿ���ȵǱ���
create view emp_vu as select e.empname,e.addr,d.deptname from employee e join department d on d.deptid=e.deptid where d.deptname='�ѹ���';

select * from emp_vu;


select * from employee;
select* from department;
desc employee;