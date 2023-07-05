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
        select employee_id, first_name, salary, commission_pct annual
        from employees
        where department_id in (50,80);
    v_eid employees.employee_id%type;
    v_name employees.first_name%type;
    v_salary employees.salary%type;
    v_annual v_salary%type;
begin
    open emp_cursor;
    loop
        fetch emp_cursor into v_eid, v_name,v_salary,v_annual;
        exit when emp_cursor%notfound;
        v_annual:=nvl(v_salary,0)*12+nvl(v_annual,0)*12;
         dbms_output.put_line(v_eid||v_name||','||v_salary||','||v_annual);
    end loop;
    close emp_cursor;
end;
/




-----------------커서forloop(커서에 데이터가 있다는 것이 확실하다면 이걸 쓰면 더 편리하징)
declare
    cursor emp_cursor is
        select employee_id,last_name
        from employees;
        
    cursor dept_emp_cursor is
        select employee_id,last_name
        from employees
        where department_id=&ㅄ번호;
begin
    for emp_record in emp_cursor loop --emprecord는forloop내에서만사용가능한임시변수
        dbms_output.put_line(emp_record.employee_id||emp_record.last_name);
         dbms_output.put_line(emp_cursor%rowcount);
         --endloop전에 실행해야 실행된 횟수를 알 수 있음
    end loop;
    dbms_output.put_line('');
    
    for emp_record in dept_emp_cursor loop
        --dbms_output.put_line(dept_emp_cursor%notfound);
        dbms_output.put_line(emp_record.employee_id||emp_record.last_name);
        dbms_output.put_line(dept_emp_cursor%rowcount);
        --rowcount는 0도 나올 수 있음 (0~양의정수)
    end loop;
end;
/

--모든 사원의 사원번호,이름,부서이름 출력
declare
    cursor emp_cursor is
        select employee_id,last_name,department_name
        from employees e join departments d
            on e.department_id=d.department_id;

begin
    for emp_record in emp_cursor loop --record타입의 변수가 for~in사이에 위치함
        dbms_output.put_line(emp_record.employee_id||emp_record.last_name||', '||emp_record.department_name);
    end loop;
end;
/

declare
    cursor emp_cursor is
        select first_name, salary,nvl(salary,0)*12+nvl(salary,0)*nvl(commission_pct,0)*12 as annual
        from employees
        where department_id in(50,80);
begin
    for emp_record in emp_cursor loop
        dbms_output.put_line(emp_record.first_name||','||emp_record.salary||' 연봉:'||emp_record.annual);
        dbms_output.put_line(emp_cursor%rowcount);
    end loop;
end;
/
----------------- 간단ver-------------------------
begin
    for emp_info in(select last_name from employees) loop 
        dbms_output.put_line(emp_info.last_name);
    end loop;
    
end;
/

--매개변수를 이요한 커서
declare
    cursor emp_cursor (p_mgr employees.manager_id%type) is
        select* from employees where manager_id=p_mgr;
    emp_record emp_cursor%rowtype;
begin
    open emp_cursor(100);
    loop
        fetch emp_cursor into emp_record;
        exit when emp_cursor%notfound;
        
        dbms_output.put_line(emp_record.employee_id||','||emp_record.first_name);
    end loop;
    close emp_cursor;
    
    dbms_output.put_line('');   
   
    for emp_info in emp_cursor(149)loop
         dbms_output.put_line(emp_info.employee_id||','||emp_info.first_name);
    end loop;
    -----1
     dbms_output.put_line('');   
    ---------2 1이랑 2랑 똑같음 
    open emp_cursor(149);
    loop
        fetch emp_cursor into emp_record;
        exit when emp_cursor%notfound;
        
        dbms_output.put_line(emp_record.employee_id||','||emp_record.first_name);
    end loop;
    close emp_cursor;
    
end;
/

--forupdte,wherecurrentof
declare
    cursor sal_info_cursor is
        select salary,commission_pct from employees
        where department_id=30
        --for update nowait;
        for update of salary,commission_pct nowait;--<<of붙이면 특정column에 해당하는 것만 잠금 이 방식을 ㅊㅊ
begin
    for sal_info in sal_info_cursor loop
        if sal_info.commission_pct is null then
            update employees set salary=sal_info.salary*1.1
            where current of sal_info_cursor;
        else
            update employees set salary=sal_info.salary+sal_info.commission_pct
            where current of sal_info_cursor;
        end if;
    end loop;
end;
/


--커서를 사용해서 employees의 모든 정보를 한 변수에 담아보귕
declare
    cursor emp_cursor is
        select * from employees;
    emp_record emp_cursor%rowtype;
    
    type emp_table_type is table of emp_cursor%rowtype
        index by pls_integer;
    emp_table emp_table_type;    
begin
    open emp_cursor;
    loop
        fetch emp_cursor into emp_record;
        exit when emp_cursor%notfound;
        emp_table(emp_record.employee_id):=emp_record;
    end loop;
    close emp_cursor;
    dbms_output.put_line(emp_table.count);
    dbms_output.put_line('');
    
    for idx in emp_table.first..emp_table.last loop--table의 내용을 확인하기 때문에 cursor for loop아님
        if not emp_table.exists(idx)then
            continue;
        end if;
        emp_record:=emp_table(idx);
        dbms_output.put_line(emp_record.employee_id||','||emp_record.first_name);
    end loop;
end;
/
