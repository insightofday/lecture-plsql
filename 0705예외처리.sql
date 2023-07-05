set serveroutput on
--예외상황1..
declare
    v_ename employees.first_name%type;
begin
    select first_name into v_ename
    from employees where department_id=&departmentId;
    dbms_output.put_line(v_ename);
    --예외가 발생한 코드 다음 줄의 것은 실행되지 않음 따라서 반드시 실행되어야 하는 것은 exception안에 넣도록 하라
exception
    when no_data_found then
        dbms_output.put_line('there is no employee');
    when too_many_rows then
        dbms_output.put_line('there are too many data');
        dbms_output.put_line('end of a block');
end;
/


--예외상황2..
declare
    e_emps_remaining exception;
    pragma exception_init(e_emps_remaining, -02292);-- 에러숫자와 이름을 매핑
begin
    delete from departments where department_id=&id;
    dbms_output.put_line('deleted :');
exception
    when e_emps_remaining then
    dbms_output.put_line('foreign key');
end;
/

--예외상황3(사용자정의예외)예:update,delete,insert
declare
    e_dept_del_fail exception;
begin
    delete from departments where department_id=&id;
    if sql%rowcount=0 then
        raise e_dept_del_fail;
    end if;
exception
    when e_dept_del_fail then
        dbms_output.put_line('that id does not exists');
end;
/


--예외트랩함수
declare
    e_too_many exception;
    v_ex_code number;
    v_ex_msg varchar2(400);
    emp_info employees%rowtype;
begin
    select * into emp_info from employees where department_id=&deptId;

    if emp_info.salary<(emp_info.salary*emp_info.commission_pct+10000) then
        raise e_too_many;
    end if;
exception
    when e_too_many then
        dbms_output.put_line('customize error');
    when others then
         v_ex_code:=sqlcode;
         v_ex_msg:=sqlerrm;
         dbms_output.put_line('ORA'||v_ex_code);
         dbms_output.put_line(' ? '||v_ex_msg);
end;
/

--testemployees를사용,선택된 사원을 삭제하는 plsql작성: 단, 치환변수사용+사원이 없으면 없다고 띄우기
declare
    e_no exception;
begin
     delete test_employees where employee_id=&id;
      if sql%rowcount=0 then
        raise e_no;
    end if;
exception
    when e_no then
        dbms_output.put_line('해당사원이 업슴미다');
end;
/



--!!!!!!!!!!!!!!!nodatafound, manyrows예외는 모두 select(암시적커서),테이블,커서와 관련한 예외