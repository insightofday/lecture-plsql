set serveroutput on

--in모드
create or replace procedure raise_salary--create or replace!!
(p_eid in employees.employee_id%type)--raise_salary의 파라미터
is
--여기까지가 헤더
--선언문이 존재하나 procedure에서는 declare선언부(커서,변수,예외,type..)가 생략됨
    v_pre_sal employees.salary%type;
begin
    select salary into v_pre_sal from employees where employee_id=p_eid;
    dbms_output.put_line('salary before: '||v_pre_sal);

    update employees set salary=salary*1.1 where employee_id=p_eid;
end;
/
begin
    raise_salary(100);
end;
/
select * from employees where employee_id=100;




create or replace procedure test_pro
(p_num in number, p_result out number)
is
    v_sum number;    
begin
    v_sum:=p_num+p_result;
    p_result:=v_sum;
    p_num:=9876;--안됨. 인모드는 상수라서
end;
/
-----------------------------out 과 inout차이구분

create or replace procedure test_pro
(p_num in number, p_result in out number)
is
    v_sum number;    
begin
    v_sum:=p_num+p_result;
    p_result:=v_sum;
end;
/

declare
    v_result number:=1234;
begin
    test_pro(1000,v_result);
    dbms_output.put_line('djljsf?? '||v_result);
end;
/



---out매개변수
create or replace procedure select_emp
(p_eid in employees.employee_id%type,
p_ename out employees.first_name%type,
p_sal out employees.salary%type,
p_comm out employees.commission_pct%type)
is

begin
    select first_name,salary,commission_pct
    into p_ename,p_sal,p_comm from employees
    where employee_id=p_eid;
end;
/

declare
    v_name varchar2(100 char);
    v_sal number;
    v_comm number;
    v_eid number:=&number;
begin
    select_emp(v_eid,v_name,v_sal,v_comm);
    dbms_output.put(v_eid||',');
    dbms_output.put(v_name||',');
    dbms_output.put(v_sal||',');
    dbms_output.put_line(v_comm);
end;
/


---inout매개변수
create or replace procedure format_phone
(p_phone_no in out varchar2
)--'05355555555'를건네받으면 (국번)000-0000 형식으로 돌려줌
is
begin
    p_phone_no:='('||substr(p_phone_no,1,3)||')'||
                substr(p_phone_no,4,3)||
                '-'||substr(p_phone_no,7);
end;
/

variable g_phone_no varchar2(100);
execute :g_phone_no:='0531231234'; --블럭 축소판:execute
print g_phone_no;

execute format_phone(:g_phone_no);

--procedure는 중첩해서 사용ㄱㄴ

--create 반대급부:drop::create로생성한거는 drop으로 삭제가능