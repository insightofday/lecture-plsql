set serveroutput on

--in���
create or replace procedure raise_salary--create or replace!!
(p_eid in employees.employee_id%type)--raise_salary�� �Ķ����
is
--��������� ���
--������ �����ϳ� procedure������ ���ο��� ����ϴ� declare�����(Ŀ��,����,����,type..)�� ������
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




/*
1.
�ֹε�Ϲ�ȣ�� �Է��ϸ� 
������ ���� ��µǵ��� yedam_ju ���ν����� �ۼ��Ͻÿ�.

EXECUTE yedam_ju(9501011667777)
EXECUTE yedam_ju(1511013689977)

  -> 950101-1******
  */
--in���� �����ؾ� ��
create procedure yedam_ju
(p_ssn in varchar2)--0���� �����ϴ� �ֹι��� ������ numberŸ�ԺҰ���
is
    v_result varchar2(100);
begin
    --v_result:=substr(p_ssn,1,6)||'-'||substr(p_ssn,7,1)||'******';
            --���� �Ʒ��� �Ȱ���
    v_result:=substr(p_ssn,1,6)||'-'||rpad(substr(p_ssn,7,1),7,'*');
    dbms_output.put_line(v_result);
end;
/
execute yedam_ju('0223457894532');


/*  
2.
�����ȣ�� �Է��� ���
�����ϴ� TEST_PRO ���ν����� �����Ͻÿ�.
��, �ش����� ���� ��� "�ش����� �����ϴ�." ���
��) EXECUTE TEST_PRO(176)
*/
--��������ǿ��ܻ���ϴ� ���
create or replace procedure test_pro
()
is

begin

end;
/

execute test_pro(0);

--��¸� �ϱ�
create or replace procedure test_pro
(p_eid employees.employee_id%type)
is

begin
    delete test_employees where employee_id=p_eid;
    if sql%rowcount=0 then
        dbms_output.put_line('�ش����� �����ϴ�');
    end if;
end;
/

/*
3.
������ ���� PL/SQL ����� ������ ��� 
�����ȣ�� �Է��� ��� ����� �̸�(last_name)�� ù��° ���ڸ� �����ϰ��
'*'�� ��µǵ��� yedam_emp ���ν����� �����Ͻÿ�.

����) EXECUTE yedam_emp(176)
������) TAYLOR -> T*****  <- �̸� ũ�⸸ŭ ��ǥ(*) ���
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
�μ���ȣ�� �Է��� ��� >>>>>>>>>�����ȣ�ƴԤ���������������
�ش�μ��� �ٹ��ϴ� ����� �����ȣ, ����̸�(last_name)�� ����ϴ� get_emp ���ν����� �����Ͻÿ�. 
(cursor ����ؾ� ��)
��, ����� ���� ��� "�ش� �μ����� ����� �����ϴ�."��� ���(exception ���)
����) EXECUTE get_emp(30)
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

---------�μ���ȣ�� �Ϸ��� Ŀ���� �ʿ� ����(�̹����� cursorforloop����ȵȤ���>rowcountüũ����)
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
�������� ���, �޿� ����ġ�� �Է��ϸ� Employees���̺� ���� ����� �޿��� ������ �� �ִ� y_update ���ν����� �ۼ��ϼ���. 
���� �Է��� ����� ���� ��쿡�� ��No search employee!!����� �޽����� ����ϼ���.(����ó��)
����) EXECUTE y_update(200, 10)
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
�μ���ȣ�� �Է��ϸ� ����� �߿��� �Ի�⵵�� 2005�� ���� �Ի��� ����� yedam01 ���̺� �Է��ϰ�,
�Ի�⵵�� 2005��(����) ���� �Ի��� ����� yedam02 ���̺� �Է��ϴ� y_proc ���ν����� �����Ͻÿ�.

6-2.
1. ��, �μ���ȣ�� ���� ��� "�ش�μ��� �����ϴ�" ����ó��
2. ��, �ش��ϴ� �μ��� ����� ���� ��� "�ش�μ��� ����� �����ϴ�" ����ó��
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
        DBMS_OUTPUT.PUT_LINE('�ش� �μ����� ����� �����ϴ�.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�ش� �μ��� �������� �ʽ��ϴ�.');
END;
/
