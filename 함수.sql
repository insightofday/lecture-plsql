set serveroutput on

create function y_sum
(p_x in number,
p_y number)-- function에서도 마찬가지로 in은 생략가능
return  number
is
    v_result number;
begin
    v_result:=p_x+p_y;
    return v_result;
end;
/

execute dbms_output.put_line( y_sum(2,4));

variable result number;
execute :result:=y_sum(3,2);
print result;

select y_sum(20,1)from dual;


----------------------------------------------------t사원번호를기준으로직속상사이름출력
create or replace function get_mgr
(p_eid employees.employee_id%type)
return varchar2
is
    v_mgr_name employees.first_name%type;
begin
    select m.first_name into v_mgr_name
    from employees e join employees m on e.manager_id=m.employee_id
    where e.employee_id=p_eid;
    
    return v_mgr_name;
    
exception
---예외도 return으로 받아줘야 함 (상단의 return값과 같은 자료형으로)
    when no_data_found then
        return 'he/she has no manager';
end;
/
select employee_id,first_name, get_mgr(employee_id) manager from employees order by employee_id;



create or replace function y_factorial
(p_num number)
return number
is
    v_sum number:=0;    
    e_num_null exception;
begin
    if p_num is null then
        raise e_num_null;
    end if;    
    for idx in 1..p_num loop
        v_sum:=v_sum+idx;
    end loop;
    return v_sum;
    if v_sum>0 then
        return v_sum;
    end if;
    return v_sum;--if외에도 return 필요함
exception
    when e_num_null then
        return -1;
end;
/
select y_factorial(3) from dual;

----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
/*
1.
사원번호를 입력하면
last_name + first_name 이 출력되는 
y_yedam 함수를 생성하시오.

실행) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
출력 예)  Abel Ellen

SELECT employee_id, y_yedam(employee_id)
FROM   employees;
*/
create or replace function y_yedam
(f_id number)
return varchar2
is
    p_last_name employees.last_name%type;
    p_first_name employees.first_name%type;
begin
    select first_name, last_name into p_last_name,p_first_name from employees where employee_id=f_id;
    return p_last_name||' '||p_first_name;
end;
/
execute dbms_output.put_line(y_yedam(120));



/*
2.
사원번호를 입력할 경우 다음 조건을 만족하는 결과가 출력되는 ydinc 함수를 생성하시오.
- 급여가 5000 이하이면 20% 인상된 급여 출력
- 급여가 10000 이하이면 15% 인상된 급여 출력
- 급여가 20000 이하이면 10% 인상된 급여 출력
- 급여가 20000 이상이면 급여 그대로 출력
실행) SELECT last_name, salary, YDINC(employee_id)
     FROM   employees;
*/
drop function ydinc;
create or replace function ydinc
(p_id number)
return number
is
    final_salary employees.salary%type:=0;
    p_salary number;
begin
        select salary into p_salary from employees
        where employee_id=p_id;
        if(p_salary <=5000) then
            final_salary:=p_salary *1.2;
             return final_salary;
        elsif (p_salary <=10000) then
             final_salary:=p_salary *1.15;
             return final_salary;
        elsif (p_salary<=20000) then
             final_salary:=p_salary*1.1;
             return final_salary;
        else 
             final_salary:=p_salary;
             return final_salary;
        end if;
         return 0;
end;
/
SELECT last_name, salary, YDINC(employee_id)
     FROM   employees;



/*
3.
사원번호를 입력하면 해당 사원의 연봉이 출력되는 yd_func 함수를 생성하시오.
->연봉계산 : (급여+(급여*인센티브퍼센트))*12
실행) SELECT last_name, salary, YD_FUNC(employee_id)
     FROM   employees;
*/
CREATE OR REPLACE FUNCTION yd_func
(p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
    v_annual employees.salary%TYPE;
BEGIN
    SELECT (salary + (salary * NVL(commission_pct, 0)))*12
    INTO v_annual
    FROM employees
    WHERE employee_id = p_eid;
    
    RETURN v_annual;
END;
/

SELECT last_name, salary, YD_FUNC(employee_id)
FROM   employees;








/*
4. 
SELECT last_name, subname(last_name)
FROM   employees;

LAST_NAME     SUBNAME(LA
------------ ------------
King         K***
Smith        S****
...
예제와 같이 출력되는 subname 함수를 작성하시오.
*/
CREATE FUNCTION subname
(p_name VARCHAR2)
RETURN VARCHAR2
IS

BEGIN
    RETURN RPAD(SUBSTR(p_name,1,1), LENGTH(p_name), '*');
END;
/

SELECT last_name, subname(last_name)
FROM   employees;

/*
5. 
사원번호를 입력하면 소속 부서명를 출력하는 y_dept 함수를 생성하시오.
(단, 다음과 같은 경우 예외처리(exception)
 입력된 사원이 없거나 소속 부서가 없는 경우 -> 사원이 아니거나 소속 부서가 없습니다.)

    입력된 사원이 없는 경우 -> 사원이 아닙니다.
    소속 부서가 없는 경우 -> 소속 부서가 없습니다. )

실행) EXECUTE DBMS_OUTPUT.PUT_LINE(y_dept(178))
출력) Executive
SELECT employee_id, y_dept(employee_id)
FROM   employees;
*/
-- 1) SELECT문 * 2개
CREATE OR REPLACE FUNCTION y_dept
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_deptno departments.department_id%TYPE;
    v_deptname departments.department_name%TYPE;
    
    e_no_dept  EXCEPTION;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id = p_eid;
    
    IF v_deptno IS NULL THEN
        RAISE e_no_dept;
    END IF;
    
    SELECT department_name
    INTO v_deptname
    FROM departments
    WHERE department_id = v_deptno;
    
    RETURN v_deptname;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '사원이 아닙니다.';
    WHEN e_no_dept THEN
        RETURN '소속 부서가 없습니다.';        
END;
/

-- 2) JOIN문
CREATE OR REPLACE FUNCTION y_dept
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_deptno departments.department_id%TYPE;
    v_deptname departments.department_name%TYPE;
    
    e_no_dept  EXCEPTION;
BEGIN
    SELECT department_name
    INTO v_deptname
    FROM employees LEFT OUTER JOIN departments
         USING(department_id)
    WHERE employee_id = p_eid;
    
    IF v_deptname IS NULL THEN
        RAISE e_no_dept;
    END IF;
    
    RETURN v_deptname;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '사원이 아닙니다.';
    WHEN e_no_dept THEN
        RETURN '소속 부서가 없습니다.'; 
END;
/



create or replace function y_dept
(f_id number)
return varchar2
is
    f_no departments.department_id%type;
    f_dname departments.department_name%type;
    e_no_emp exception;
    cursor employee_cursor is
        select employee_id from employees where employee_id=f_id;
    emp_record employee_cursor%rowtype;
begin
    select department_name into f_dname from departments d right outer join employees e on e.employee_id=f_id;----------------null도 출력해야해야하기 때문에 아우터조인!!
    if sql%rowcount=0 then
        return '소속 부서가 없습니다';
    end if;
    loop
        fetch employee_cursor into emp_record;
        exit when employee_cursor%notfound;
    end loop;
    if employee_cursor%rowcount=0 then
        raise e_no_emp;
    end if;
exception
    when e_no_emp then
         return '사원이 아닙니다..';
end;
/

SELECT employee_id, y_dept(employee_id)
FROM   employees;



/*
6.
생년월일을 입력하면 "띠"가 출력되는 y_ddi 함수를 생성하시오
(양력 기준, 앞 연도 두자리가 00~23이면 2000년대, 24~99이면 1900년대로 가정)
실행) EXECUTE DBMS_OUTPUT.PUT_LINE(y_ddi('980901'))
*/
CREATE OR REPLACE FUNCTION y_ddi
(p_birth VARCHAR2)
RETURN VARCHAR2
IS
    v_year VARCHAR2(10);
    v_seq NUMBER;
    v_ddi VARCHAR2(10);
BEGIN
    v_year := SUBSTR(p_birth, 1, 2);
    IF TO_NUMBER(v_year, '99') < 24 THEN
        v_year := '19' || v_year;
    ELSE
        v_year := '20' || v_year;
    END IF;
    
    v_seq := MOD(TO_NUMBER(v_year, '9999'), 12);
    
    IF v_seq = 1 THEN
        v_ddi := '닭띠';
    ELSIF v_seq = 2 THEN
        v_ddi := '개띠';
    ELSIF v_seq = 3 THEN
        v_ddi := '돼지띠';
    ELSIF v_seq = 4 THEN
        v_ddi := '쥐띠';
    ELSIF v_seq = 5 THEN
        v_ddi := '소띠';
    ELSIF v_seq = 6 THEN
        v_ddi := '호랑이띠';
    ELSIF v_seq = 7 THEN
        v_ddi := '토끼띠';
    ELSIF v_seq = 8 THEN
        v_ddi := '용띠';
    ELSIF v_seq = 9 THEN
        v_ddi := '뱀띠';
    ELSIF v_seq = 10 THEN
        v_ddi := '말띠';
    ELSIF v_seq = 11 THEN
        v_ddi := '양띠';
    ELSE
        v_ddi := '원숭이띠';
    END IF;
    
    RETURN v_ddi;
END;
/