set serveroutput on

--2
declare
    v_name departments.department_name%type;
    v_id employees.job_id%type;
    v_salary employees.salary%type;
    v_ysalary employees.salary%type;
begin
    select department_name,job_id,nvl(salary,0) salary,(salary*12+nvl(salary,0)*nvl(commission_pct,0)*12) y_sal
    into v_name,v_id,v_salary,v_ysalary
    from employees e join departments d on e.department_id=d.department_id where e.employee_id=&사원번호;
    dbms_output.put_line(v_name||','||v_id||','||v_salary||','||v_ysalary);
end;
/


--3
select * from employees order by hire_date desc;

declare
    v_hd employees.hire_date%type;
begin
    select hire_date into v_hd from employees where employee_id=&사원번호;
    if to_char(v_hd,'yyyy')>2005 then
          dbms_output.put_line('New employee');
    else
          dbms_output.put_line('Career employee');
    end if;
end;
/


--4
begin
    for counter in 1..9 loop
       for second in 1..9 loop
            if mod(counter,2)<>0 then
                 dbms_output.put_line(counter||'*'||second||'='||counter*second);
            else
                continue;
            end if;
       end loop;
       dbms_output.put_line(counter||'단!!!!!!!!!!!!');
    end loop;
end;
/


--5
declare
    cursor emp_cursor is
        select employee_id, first_name, salary from employees where department_id=&부서번호;
    emp_info emp_cursor%rowtype;
begin
    for emp_record in emp_cursor loop
        dbms_output.put_line(emp_record.employee_id||','||emp_record.first_name||','||emp_record.salary);
        --dbms_output.put_line(emp_cursor%rowcount);--검수를위한코드
    end loop;
end;
/
 select employee_id, first_name, salary from employees where department_id=50;


--6
create or replace procedure psalary
(p_eid in employees.employee_id%type, p_percent number)
is
    s_eid employees.employee_id%type;
begin
    select employee_id into s_eid from employees where employee_id=p_eid;
    update employees set salary=salary+salary*p_percent/100 where employee_id=p_eid;
exception
    when no_data_found then
        dbms_output.put_line('No Search employee!!');
end;
/
execute psalary(0,10);
select * from employees where employee_id=202;


--7
select substr(sysdate,1,2) from dual;

select to_number(to_char(sysdate,'yy'),'99')from dual;
select to_number(to_char(sysdate,'yyyy'),'9999') from dual;

select to_char(sysdate,'yy') from dual;


create or replace procedure identify
(p_iden varchar2)
is
    age number;
    gender varchar2(10):='';
begin
    if substr(p_iden,1,1)='0' or substr(p_iden,1,1)='2' or substr(p_iden,1,1)='1' then
        age:=to_number(to_char(sysdate,'yy'),'99')-to_number(substr(p_iden,1,2));
        if substr(p_iden,7,7)='3' then
            gender:='남자';
            dbms_output.put_line(age||gender);
        elsif to_number(substr(p_iden,7,7))=4 then
            gender:='여자';
            dbms_output.put_line(age||gender);
        else
            dbms_output.put_line('wrong11');
        end if;
    else
         age:=to_number(to_char(sysdate,'yyyy'),'9999')-to_number(1900+substr(p_iden,1,2));
        if substr(p_iden,7,7)='1' then
            gender:='남자';
            dbms_output.put_line(age||gender);
        elsif substr(p_iden,7,7)='2' then
            gender:='여자';
            dbms_output.put_line(age||gender);
        else
            dbms_output.put_line('wrong1');
        end if;
    end if;
end;
/
execute identify('0211023234567');

--8function
create or replace function work
(f_num number)
return  number
is
    hd employees.hire_date%type;
begin
    select hire_date into hd from employees where employee_id=f_num;
    if substr(hd,1,2)='0' or substr(hd,1,2)='1' or substr(hd,1,2)='2' then
        return to_number(to_char(sysdate,'yy'),'99')-to_number(substr(hd,1,2));
    else
        return to_number(to_char(sysdate,'yyyy'),'9999')-to_number(1900+substr(hd,1,2));
    end if;
end;
/
execute dbms_output.put_line(work(205));
select * from employees order by hire_date;
insert into employees (employee_id,hire_date,last_name,email,job_id) values (888,'95-03-03','test','sldjf@','IT_PROG');

--9
create function manager
(f_dname varchar2)
return varchar2
is
   
begin
    select manager_id(first_name from employees where manager_id )  from departments where department_name=f_dname;
end;
/

--10
select name,text 
from user_source 
where type in('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY');
