set serveroutput on

declare
    cursor emp_cursor is
        select employee_id,last_name
        from employees;
    v_eid employees.employee_id%type;
    v_ename employees.last_name%type;
begin
    open emp_cursor;
    loop
        fetch emp_cursor into  v_eid,v_ename;--현재커서가 가리키는 행 load해서 변수에 대입
        exit when emp_cursor%notfound;    --종료조건은 fetch다음에 붙이기
         --exit when emp_cursor%rowcount>10;  --또다른 종료조건
        dbms_output.put_line(v_eid||', '||v_ename);
    end loop;
    
    dbms_output.put_line('');
    fetch emp_cursor into  v_eid,v_ename;
    dbms_output.put_line(v_eid||', '||v_ename);
    --더이상 새로운 데이터가 없어서 loop내의 fetch끝나서 loop끝나고 커서는 이동하지 않은 채로 실행됨(마지막행2번실행)
    
    
    
    dbms_output.put_line('');
    dbms_output.put_line(emp_cursor%rowcount);
    --rowcount커서가 반환된 횟수기 때문에 위의 fetch가 영향을 미치지 못함
    close emp_cursor;
    --  dbms_output.put_line(emp_cursor%rowcount); rowcount등은 close뒤에 오면 안됨
end;
/

--모든 사원의 사원번호 이름 부서이름 출력
--커서는 join subquery사용가능
--기본루프를 우선적으로 아로라~~
declare
    cursor emp_cursor is
        select employee_id,first_name,department_name
        from employees e join departments d
        on e.department_id=d.department_id;
    v_eid employees.employee_id%type;
    v_ename employees.first_name%type;
    v_dept_name departments.department_name%type;
    
begin
    OPEN emp_cursor;
    loop
        fetch emp_cursor into v_eid, v_ename, v_dept_name;
        exit when emp_cursor%notfound;
        dbms_output.put_line(v_eid||': '||v_ename||', '||v_dept_name);
    end loop;
    close emp_cursor;
end;
/


--부서번호가50이거나80인 사원들의 이름,급여,연봉 출력
declare
    cursor emp_cursor is
        select first_name, salary, nvl(salary,0)*12+nvl(salary,0)*nvl(commission_pct,0)*12 annual
        from employees
        where department_id in(50,80);
    emp_info emp_cursor%rowtype;
begin
    open emp_cursor;
    loop
        fetch emp_cursor into emp_info;
        exit when emp_cursor%notfound;
        dbms_output.put_line(emp_info.first_name||','||emp_info.salary||','||emp_info.annual);
    end loop;
    close emp_cursor;
end;
/
--커서의 내용:사원이름, 급여, 커미션으로 제한할 때, 위의 문제를 풀어보아라
declare
    cursor emp_cursor is
        select first_name, salary, commission_pct annual
        from employees
        where department_id in (50,80);
    v_name employees.first_name%type;
    v_salary employees.salary%type;
    v_annual employees.salary%type:=nvl(employees.salary,0)*12+nvl(employees.salary,0)*nvl(employees.commission_pct,0)*12;
begin
    open emp_cursor;
    loop
        fetch emp_cursor into v_name,v_salary,v_annual;
        exit when emp_cursor%notfound;
         dbms_output.put_line(v_name||','||v_salary||','||v_annual);
    end loop;
    close emp_cursor;
end;
/