set serveroutput on

--in���
create or replace procedure raise_salary--create or replace!!
(p_eid in employees.employee_id%type)--raise_salary�� �Ķ����
is
--��������� ���
--������ �����ϳ� procedure������ declare�����(Ŀ��,����,����,type..)�� ������
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
    p_num:=9876;--�ȵ�. �θ��� �����
end;
/
-----------------------------out �� inout���̱���

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



---out�Ű�����
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


---inout�Ű�����
create or replace procedure format_phone
(p_phone_no in out varchar2
)--'05355555555'���ǳ׹����� (����)000-0000 �������� ������
is
begin
    p_phone_no:='('||substr(p_phone_no,1,3)||')'||
                substr(p_phone_no,4,3)||
                '-'||substr(p_phone_no,7);
end;
/

variable g_phone_no varchar2(100);
execute :g_phone_no:='0531231234'; --�� �����:execute
print g_phone_no;

execute format_phone(:g_phone_no);

--procedure�� ��ø�ؼ� ��뤡��

--create �ݴ�޺�:drop::create�λ����ѰŴ� drop���� ��������