set serveroutput on

begin
    delete from test_employees
    where employee_id=&사원번호;
    
    if sql%rowcount=0 then
        dbms_output.put_line('nonenonenonenonenonenonenonenonenone');
        end if;
end;
/

--ifelse문(부하직원유무==팀장급인가용?
declare
    v_count employees.employee_id%type;
begin
    select count(employee_id)
    into v_count
    from employees
    where manager_id=&사원번호;
    
    if v_count=0 then
        dbms_output.put_line('일반사원이용');
    else
        dbms_output.put_line('부하직원잇슴미다');
    end if;
end;
/
--if elsif else:연차
declare
    v_hdate number;
begin
    select trunc(months_between(sysdate,hire_date)/12)
    --monthbetween의 리턴:literal
    --trunc,round 둘 다 숫자 외에 date타입에도 쓸 수 잇음
    into v_hdate
    from employees
    where employee_id=&사원번호;
    
    if v_hdate<1 then
        dbms_output.put_line('뿅아리');
    elsif  v_hdate<3 then
      dbms_output.put_line('중닭');
    elsif v_hdate<5 then
        dbms_output.put_line('노계');
    else
        dbms_output.put_line('성인');
    END IF;
end;
/

 select to_char(hire_date,'YY') a from employees where 'a'>'11';



declare
    --v_id employees.employee_id%type;
    v_hd employees.hire_date%type;
    v_message varchar2(20);
begin
    select hire_date
    into v_hd
    from employees
    where employee_id=&사원번호; 
       
    if to_char(v_hd,'yyyy')>'2004' then
        v_message:='NewEmployee';
    else
        v_message:='Career employee';
    end if;
    dbms_output.put_line(v_message);
end;
/

create table emp00(empid, ename, hiredate)
as
  select employee_id, first_name, hire_date
  from   employees
  where  employee_id = 0;--실제 존재하지 않는 id를 입력함으로서 구조만 복사



declare
    --v_id employees.employee_id%type;
    v_empid employees.employee_id%type:=&사원번호;
    v_hd varchar2(10);
begin
    select to_char(hire_date,'YY') 
    into v_hd
    from employees
    where employee_id=v_empid; 
    if v_hd<05 then
        dbms_output.put_line('Career employee');
    else
        dbms_output.put_line(v_hd||'New employee');
    end if;
end;
/

/*
4. 
사원번호를 입력(치환변수& 사용)할 경우
부서별로 구분하여 각각의 테이블에 입력하는 PL/SQL 블록을 작성하시오.
단, 해당 부서가 없는 사원은 emp00 테이블에 입력하시오.
   : 부서번호10->emp10, 부서번호20->emp20 ....

create table emp10(empid, ename, hiredate)
as
  select employee_id, first_name, hire_date
  from   employees
  where  employee_id = 0;

emp20
emp30
emp40
emp50
emp00
*/

declare
    v_empid employees.employee_id%type:=&사원번호;
    v_ename employees.first_name%type;
    v_hdate employees.hire_date%type;
    v_deptid employees.department_id%type;
begin
    select first_name,hire_date,department_id
    into v_ename,v_hdate,v_deptid
    from employees
    where employee_id=v_empid;   
    
    if v_deptid=10 then
        insert into emp10 values(v_empid,v_ename,v_hdate);
    elsif  v_deptid=20 then
        insert into emp20 values(v_empid,v_ename,v_hdate);
    elsif  v_deptid=30 then
        insert into emp30 values(v_empid,v_ename,v_hdate);
    elsif  v_deptid=40 then
        insert into emp40 values(v_empid,v_ename,v_hdate);
    elsif  v_deptid=50 then
        insert into emp50 values(v_empid,v_ename,v_hdate);
    else 
        insert into emp00 values(v_empid,v_ename,v_hdate);
    end if;
        
end;
/
select * from emp00;


--동적쿼리
declare
    v_empid employees.employee_id%type:=&사원번호;
    v_ename employees.first_name%type;
    v_hdate employees.hire_date%type;
    v_deptid employees.department_id%type;
    v_sql varchar2(100);
begin
    select first_name,hire_date,trunc(department_id/10)
    into v_ename,v_hdate,v_deptid
    from employees
    where employee_id=v_empid;   
    
    if v_deptid between 1 and 5 then
        v_sql:='insert into emp'||(v_deptid*10);
        v_sql:=v_sql||' values('||v_empid||','''||v_ename||''','''||v_hdate||''')';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        --동적sql실행하는 문장
    else 
        insert into emp00 values(v_empid,v_ename,v_hdate);
    end if;
end;
/
/*
5.
급여가  5000이하이면 20% 인상된 급여
급여가 10000이하이면 15% 인상된 급여
급여가 15000이하이면 10% 인상된 급여
급여가 15001이상이면 급여 인상없음

사원번호를 입력(치환변수)하면 사원이름, 급여, 인상된 급여가 출력되도록 PL/SQL 블록을 생성하시오.
*/
declare
    v_ename employees.first_name%type;
    v_sal employees.salary%type;
    v_raise number:=0;
begin
    select first_name,salary
    into v_ename,v_sal
    from employees
    where employee_id=&사원번호;
    if v_sal<=5000 then
        v_raise:=20;
    elsif v_sal<=10000 then
        v_raise:=15;
    elsif v_sal<=15000 then
        v_raise:=10;
    end if;
    
    dbms_output.put_line('사원이름 ;'||v_ename);
      dbms_output.put_line('급여 ;'||v_sal||' 인상된 급여 :'||v_sal*(v_raise/100));
end;
/
