set serveroutput on
CREATE TAble test01
AS
	SELECT employee_id, first_name, hire_date
	FROM employees
	WHERE employee_id = 0;
CREATE TAble test02
AS
	SELECT employee_id, first_name, hire_date
	FROM employees
	WHERE employee_id = 0;


/*
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를 
다음 기준에 맞게 각각 test01, test02에 입력하시오.
입사년도가 2005년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2005년 이후 입사한 사원은 test02 테이블에 입력
1-1) 명시적 커서 + 기본 LOOP 사용
1-2) 커서 FOR LOOP 사용
*/
declare
    cursor emp_cursor is
        select employee_id,first_name,hire_date from employees;
    v_eid employees.employee_id%type;
    v_ename employees.first_name%type;
    v_hiredate employees.hire_date%type;
begin
    open emp_cursor; 
    loop
        fetch
            emp_cursor into v_eid,v_ename,v_hiredate;
            exit when emp_cursor%notfound;
            if(to_char(v_hiredate,'yyyy')<=2005) then
                insert into test01 values(v_eid,v_ename,v_hiredate);
            else
                insert into test02 values(v_eid,v_ename,v_hiredate);
            end if;
    end loop;
    close emp_cursor;
end;
/
delete test01;
select * from test01 order by hire_date desc;
delete test02;
select * from test02 order by hire_date desc;
    

declare
    cursor emp_cursor is
        select employee_id,first_name,hire_date from employees;
    --v_eid employees.employee_id%type;
    --v_ename employees.first_name%type;
    --v_hiredate employees.hire_date%type;
begin
    for emp_record in emp_cursor loop
      if(to_char(emp_record.hire_date,'yyyy')<=2005) then
            insert into test01 values(emp_record.employee_id,emp_record.first_name,emp_record.hire_date);
      else
            insert into test02 values emp_record;
            ---emp_record와 삽입하려는 table의 구조가 똑같기 때문에 그냥 이렇게 적기만 해도 됨
     end if;
    end loop;
end;
/


/*
2.
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
(단, cursor 사용)
*/

declare
    cursor emp_cursor is
        select first_name,hire_date,department_name from employees e join departments d
        on e.department_id=d.department_id
        where d.department_id=&부서번호;
        
        
        --------이렇게도 가능
    v_deptid departments.department_id%type:=&부서번호;
    cursor dept_emp_cursor is
        select first_name,hire_date,department_name from employees e join departments d
        on e.department_id=d.department_id
        where d.department_id=v_deptid;
    --dept_info dept_emp_cursor%rowtype;
    
begin
    for emp_record in emp_cursor loop
    dbms_output.put_line(emp_record.first_name||','||emp_record.hire_date||','||emp_record.department_name);
    end loop;
    
    dbms_output.put_line('');
    
     for emp_record in dept_emp_cursor loop
    dbms_output.put_line(emp_record.first_name||','||emp_record.hire_date||','||emp_record.department_name);
    end loop;
end;
/
        
	