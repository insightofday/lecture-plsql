set serveroutput on
--���ܻ�Ȳ1..
declare
    v_ename employees.first_name%type;
begin
    select first_name into v_ename
    from employees where department_id=&departmentId;
    dbms_output.put_line(v_ename);
    --���ܰ� �߻��� �ڵ� ���� ���� ���� ������� ���� ���� �ݵ�� ����Ǿ�� �ϴ� ���� exception�ȿ� �ֵ��� �϶�
exception
    when no_data_found then
        dbms_output.put_line('there is no employee');
    when too_many_rows then
        dbms_output.put_line('there are too many data');
        dbms_output.put_line('end of a block');
end;
/


--���ܻ�Ȳ2..
declare
    e_emps_remaining exception;
    pragma exception_init(e_emps_remaining, -02292);-- �������ڿ� �̸��� ����
begin
    delete from departments where department_id=&id;
    dbms_output.put_line('deleted :');
exception
    when e_emps_remaining then
    dbms_output.put_line('foreign key');
end;
/

--���ܻ�Ȳ3(��������ǿ���)��:update,delete,insert
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


--����Ʈ���Լ�
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

--testemployees�����,���õ� ����� �����ϴ� plsql�ۼ�: ��, ġȯ�������+����� ������ ���ٰ� ����
declare
    e_no exception;
begin
     delete test_employees where employee_id=&id;
      if sql%rowcount=0 then
        raise e_no;
    end if;
exception
    when e_no then
        dbms_output.put_line('�ش����� �����̴�');
end;
/



--!!!!!!!!!!!!!!!nodatafound, manyrows���ܴ� ��� select(�Ͻ���Ŀ��),���̺�,Ŀ���� ������ ����