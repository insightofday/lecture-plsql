select employee_id, first_name, last_name, email, phone_number, hire_date, job_id from employees where 02<=substr(hire_date,1,2) and  upper(job_id)='ST_CLERK' order by hire_date;
--hire_date>to_date('2002/12/31','yyyy/mm/dd')>2002������x or to_char(hire_date,'yyyy')>'2006'



select * from employees;
--2
select last_name, job_id, salary, commission_pct from employees where commission_pct is not null order by salary desc;
--3
select ('The salary of '||first_name||'after a 10% raise is '||round(salary*1.1)) as "New Salary" from employees where commission_pct is null;
--4
select trunc(months_between(sysdate,hire_date)/12)from employees;--round���� �ȵ� 12�γ������� ���� ���
select trunc(mod(months_between(sysdate,hire_date),12))from employees;--12�γ��������������´޼�

select sysdate from dual;
select last_name, round(months_between(sysdate,hire_date)) years, (round(substr(sysdate,1,2)-substr(hire_date,1,2)*12substr() months from employees;--�𸣰ٴٸ𸣰ٴ�

--5
select last_name  from employees where upper(last_name) like ('J%') or  upper(last_name) like ('K%') or  upper(last_name) like ('L%') or  upper(last_name) like ('M%') ;
select last_name from employees where upper(substr(last_name,1,1)) in('J','K','L','M');--���� �Ʒ��� �Ȱ���. in�̶� like���ÿ� ���� �� �ȵ�

--6
select last_name, salary, NVL2((select commission_pct from employees),'Yes','No') com from employees ;--�̰žʵ�
select last_name, salary, NVL2(commission_pct,'Yes','No') com from employees ;
--�׳� nvl�� ��ü�Ǵ� ���� �ڷ����� ���ƾ� ��

select last_name,salary,--���� �Ȱ���
case when commission_pct is null 
then 'no' 
else 'yes'
end as commission from employees;

select last_name,salary,--decode�� ����Ŭ������!!
decode(commission_pct,null,'NO','YES')commission from employees;

--7
select d.department_name,d.location_id,e.last_name,e.salary,e.job_id
from employees e join departments d on(e.department_id=d.department_id) where d.location_id=1800;

--8
select count(*) from employees where lower(last_name) like'%n';
select count(*) from employees where lower(substr(last_name,-1))='n';

--9(outerjoin)
select d.department_name,d.location_id,count(e.employee_id)from departments d left outer join employees e
on(e.department_id=d.department_id)
group by d.department_name,d.location_id;
--count�� ����, �׷��Լ��� null���� ����, �׷���...! count�� *�� ���� null����
--�� ���ÿ����� group by�� �׷�ȭ�� �س��ұ� ������ �� ��ü�� �ٸ��� ������,,, �׷��� ���ζ�
--fullouter�� ǥ�ؿ��� ����


--10
select distinct job_id from employees where department_id in(10,20);-- select distinct job_id,employee_id�� �� �÷��� ���տ��� �ߺ��� ������, �÷��� �ߺ����žƴ�


--11
select e.job_id, count(e.job_id) as frequency from employees e
join departments d
on(e.department_id=d.department_id)
where lower(d.department_name) in('administration','executive') --initcap(d.department_name)ù ���ڳ� ���� �� ù ���ڸ� �������� �빮��
--where department_id in(select department_id from departments where initcap(department_name) in('Administration','Executive'))�� ����
group by e.job_id order by 2 desc;
--or������ ��ȣ�� �����



--12
select last_name,hire_date from employees
where to_char(hire_date,'DD')<'16';--todate����ȵ�(todate�µ��������������̰����Ǿ�����)



--13
select last_name,salary,trunc(salary,-3)/1000 thousands from employees;--trunc�� ������ �����θ� �����ڴ� �� -3�� õ���������� ǥ���Ѵ� ��


--14�������Ǳ޿���15000�̻��� ����� �÷���(...)�� �ְ�޿����� ǥ��
select w.last_name,m.last_name manager,m.salary,j.max_salary from employees w join employees m on (w.manager_id=m.employee_id) join jobs j on (m.job_id=j.job_id) where m.salary>15000;



--15
select department_id,min(salary)   from employees group by department_id having avg(salary)=(select max(avg(salary)) from employees group by department_id);--max,avg���� �׷��Լ��� ��ø�ؼ� ��뤡��
