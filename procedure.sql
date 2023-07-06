set serveroutput on

--in모드
create or replace procedure raise_salary--create or replace!!
(p_eid in employees.employee_id%type)--raise_salary의 파라미터
is
--여기까지가 헤더
--선언문이 존재하나 procedure에서는 내부에서 사용하는 declare선언부(커서,변수,예외,type..)가 생략됨
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




/*
1.
주민등록번호를 입력하면 
다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.

EXECUTE yedam_ju(9501011667777)
EXECUTE yedam_ju(1511013689977)

  -> 950101-1******
  */
--in모드로 접근해야 함
create procedure yedam_ju
(p_ssn in varchar2)--0으로 시작하는 주민버노 때문에 number타입불가능
is
    v_result varchar2(100);
begin
    --v_result:=substr(p_ssn,1,6)||'-'||substr(p_ssn,7,1)||'******';
            --위랑 아래랑 똑같음
    v_result:=substr(p_ssn,1,6)||'-'||rpad(substr(p_ssn,7,1),7,'*');
    dbms_output.put_line(v_result);
end;
/
execute yedam_ju('0223457894532');


/*  
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176)
*/
--사용자정의예외사용하는 방법
create or replace procedure test_pro
()
is

begin

end;
/

execute test_pro(0);

--출력만 하기
create or replace procedure test_pro
(p_eid employees.employee_id%type)
is

begin
    delete test_employees where employee_id=p_eid;
    if sql%rowcount=0 then
        dbms_output.put_line('해당사원이 없습니다');
    end if;
end;
/

/*
3.
다음과 같이 PL/SQL 블록을 실행할 경우 
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오.

실행) EXECUTE yedam_emp(176)
실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
*/
create or replace procedure yedam_emp
(p_id in number)
is
p_name varchar2(50);
begin
    select last_name into p_name from employees where employee_id=p_id;
    dbms_output.put_line(p_name||'->'||rpad(substr(p_name,1,1),length(p_name),'*'));
end;
/
execute yedam_emp(127);

/*
4.
부서번호를 입력할 경우 >>>>>>>>>사원번호아님ㅋㅋㅋㅋㅋㅋㅋㅋ
해당부서에 근무하는 사원의 사원번호, 사원이름(last_name)을 출력하는 get_emp 프로시저를 생성하시오. 
(cursor 사용해야 함)
단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용)
실행) EXECUTE get_emp(30)
*/
create or replace procedure get_emp
(p_id number)
is
    v_id number;
    v_name employees.last_name%type;
   
begin
    select employee_id, last_name into v_id,v_name from employees where employee_id=p_id;
    dbms_output.put_line(v_id||','||v_name);    
exception
    when no_data_found then
         dbms_output.put_line('there is no employee');     
end;
/

execute get_emp(100);

---------부서번호로 하려면 커서가 필요 ㅋㅋ(이문제는 cursorforloop쓰면안된ㄷㅐ>rowcount체크못함)
create or replace procedure get_emp
(p_deptno in number)
is
    e_no_emp exception;
    cursor dept_cursor is
        select employee_id,last_name from employees
        where department_id=p_deptno;
    emp_info dept_cursor%rowtype;
begin
    open dept_cursor;
    loop
        fetch dept_cursor into emp_info;
        exit when dept_cursor%notfound;
            dbms_output.put_line(emp_info.employee_id||emp_info.last_name);
    end loop;
    if dept_cursor%rowcount=0 then
        raise e_no_emp;
    end if;
    close dept_cursor;
exception
    when e_no_emp then
          dbms_output.put_line('there is no employee');
end;
/




/*
5.
직원들의 사번, 급여 증가치만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
실행) EXECUTE y_update(200, 10)
*/
create or replace procedure y_update
(p_eid employees.employee_id%type,
p_raise in number)
is
    e_no_emp exception;
begin
    update employees set salary=salary+salary*(p_raise/100) where employee_id=p_eid;
    if sql%rowcount=0 then
        raise e_no_emp;
    end if;
exception
    WHEN e_no_emp then
        dbms_output.put_line('No search employee!!');
end;
/
select * from employees where employee_id=200;
execute y_update(0,10);



create table yedam01
(y_id number(10),
 y_name varchar2(20));

create table yedam02
(y_id number(10),
 y_name varchar2(20));
 
/*6-1.
부서번호를 입력하면 사원들 중에서 입사년도가 2005년 이전 입사한 사원은 yedam01 테이블에 입력하고,
입사년도가 2005년(포함) 이후 입사한 사원은 yedam02 테이블에 입력하는 y_proc 프로시저를 생성하시오.

6-2.
1. 단, 부서번호가 없을 경우 "해당부서가 없습니다" 예외처리
2. 단, 해당하는 부서에 사원이 없을 경우 "해당부서에 사원이 없습니다" 예외처리
*/
CREATE PROCEDURE y_proc
(p_deptno IN departments.department_id%TYPE)
IS
    CURSOR dept_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees
        WHERE department_id = p_deptno;
        
    emp_info dept_cursor%ROWTYPE;
    v_deptno departments.department_id%TYPE;
    
    e_no_emp EXCEPTION;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM departments
    WHERE department_id = p_deptno;
    
    OPEN dept_cursor;
    
    LOOP
        FETCH dept_cursor INTO emp_info;
        EXIT WHEN dept_cursor%NOTFOUND;
        
        IF emp_info.hire_date < TO_DATE('05/01/01', 'rr/MM/dd') THEN
            INSERT INTO yedam01
            VALUES (emp_info.employee_id, emp_info.last_name);
        ELSE
            INSERT INTO yedam02
            VALUES (emp_info.employee_id, emp_info.last_name);
        END IF;
       
    END LOOP;
    
    IF dept_cursor%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;
    
    CLOSE dept_cursor;   
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서는 존재하지 않습니다.');
END;
/
