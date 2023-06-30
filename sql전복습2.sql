select employee_id, first_name, last_name, email, phone_number, hire_date, job_id from employees where 02<=substr(hire_date,1,2) and  upper(job_id)='ST_CLERK' order by hire_date;
--hire_date>to_date('2002/12/31','yyyy/mm/dd')>2002년포함x or to_char(hire_date,'yyyy')>'2006'



select * from employees;
--2
select last_name, job_id, salary, commission_pct from employees where commission_pct is not null order by salary desc;
--3
select ('The salary of '||first_name||'after a 10% raise is '||round(salary*1.1)) as "New Salary" from employees where commission_pct is null;
--4
select trunc(months_between(sysdate,hire_date)/12)from employees;--round쓰면 안됨 12로나눴을때 몫은 년수
select trunc(mod(months_between(sysdate,hire_date),12))from employees;--12로나눴을때나머지는달수

select sysdate from dual;
select last_name, round(months_between(sysdate,hire_date)) years, (round(substr(sysdate,1,2)-substr(hire_date,1,2)*12substr() months from employees;--모르겟다모르겟다

--5
select last_name  from employees where upper(last_name) like ('J%') or  upper(last_name) like ('K%') or  upper(last_name) like ('L%') or  upper(last_name) like ('M%') ;
select last_name from employees where upper(substr(last_name,1,1)) in('J','K','L','M');--위랑 아래랑 똑같음. in이랑 like동시에 쓰는 건 안됨

--6
select last_name, salary, NVL2((select commission_pct from employees),'Yes','No') com from employees ;--이거않됨
select last_name, salary, NVL2(commission_pct,'Yes','No') com from employees ;
--그냥 nvl은 대체되는 값의 자료형이 같아야 함

select last_name,salary,--위랑 똑같음
case when commission_pct is null 
then 'no' 
else 'yes'
end as commission from employees;

select last_name,salary,--decode는 오라클전용임!!
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
--count를 포함, 그룹함수는 null포함 안함, 그런데...! count에 *를 쓰면 null포함
--이 예시에서는 group by로 그룹화를 해놓았기 때문에 값 자체는 다르지 않지만,,, 그로지 마로라
--fullouter는 표준에만 있음


--10
select distinct job_id from employees where department_id in(10,20);-- select distinct job_id,employee_id는 두 컬럼의 조합에서 중복을 제거함, 컬럼별 중복제거아님


--11
select e.job_id, count(e.job_id) as frequency from employees e
join departments d
on(e.department_id=d.department_id)
where lower(d.department_name) in('administration','executive') --initcap(d.department_name)첫 글자나 공백 후 첫 글자를 기준으로 대문자
--where department_id in(select department_id from departments where initcap(department_name) in('Administration','Executive'))도 가능
group by e.job_id order by 2 desc;
--or쓸때는 괄호로 묶어라



--12
select last_name,hire_date from employees
where to_char(hire_date,'DD')<'16';--todate쓰면안됨(todate는데이터포맷형식이고정되어있음)



--13
select last_name,salary,trunc(salary,-3)/1000 thousands from employees;--trunc에 음수는 정수부를 날리겠단 뜻 -3은 천단위까지만 표기한단 뜻


--14관리자의급여가15000이상인 사원의 컬럼들(...)과 최고급여까지 표시
select w.last_name,m.last_name manager,m.salary,j.max_salary from employees w join employees m on (w.manager_id=m.employee_id) join jobs j on (m.job_id=j.job_id) where m.salary>15000;



--15
select department_id,min(salary)   from employees group by department_id having avg(salary)=(select max(avg(salary)) from employees group by department_id);--max,avg같은 그룹함수는 중첩해서 사용ㄱㄴ
