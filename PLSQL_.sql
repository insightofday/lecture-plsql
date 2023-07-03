set serveroutput on

declare
    v_empid employees.employee_id%type;
    v_ename varchar2(100);
begin

    select employee_id,first_name||', '||last_name
    into v_empid,v_ename
    from employees
    where employee_id=&�����ȣ;
    
    dbms_output.put_line('�����ȣ : '||v_empid);
    dbms_output.put_line('����̸� : '||v_ename);
    
end;
/
--��ɾ����Ḧ ��Ÿ��+�͸��� plsql������
--1
declare
    v_deptno departments.department_id%type;
    v_comm employees.commission_pct%type:=0.1;
begin
    select department_id
    into v_deptno
    from employees
    where employee_id=&�����ȣ;
    
    insert into employees (employee_id, last_name, email,hire_date,job_id,department_id)
    values(1000,'Hong','hkd@google.com',sysdate,'IT_PROG',v_deptno);
    
    update employees
    set salary=(salary+10000)*v_comm
    where employee_id=1000;
    
end;
/
--2
select* from employees where employee_id=1000;
--3
declare v_empid employees.employee_id%type;
begin
    select employee_id
    into v_empid
    from employees
    where salary is null;
    
    delete from employees
    where employee_id=v_empid;
end;
/
--4
declare
    v_deptno departments.department_id%type;
    v_comm employees.commission_pct%type:=0.1;
begin
    select department_id
    into v_deptno
    from employees
    where employee_id=&�����ȣ;
    
    insert into employees (employee_id, last_name, email,hire_date,job_id,department_id)
    values(1000,'Hong','hkd@google.com',sysdate,'IT_PROG',v_deptno);
    
    update employees
    set salary=(nvl(salary,0)+10000)*v_comm
    where employee_id=1000;
    
end;
/
create table test_employees
as
    select*from employees;
begin
    delete from test_employees
    where employee_id=0;
    if sql%rowcount=0 then
    dbms_output.put_line('�ش����� �������� �ʽ��ϴ�.');
    end if;
    
    update test_employees
    set salary=salary*1.1
    where employee_id=&�����ȣ;
    
    if sql%rowcount=0 then   
                        --sql���·� �����ϴ°�:�Ͻ���Ŀ��, �����ǿ� ���� ó��x������ ������ ����
        dbms_output.put_line('�ش����� �������� �ʽ��ϴ�.');
    end if;
    --dbms_output.put_line('������, '||sql%rowCount||' �� �� �����Ǿ����ϴ�.');
end;
/


declare
    v_empid employees.employee_id%type;
    v_ename varchar2(50);
    v_dname varchar2(100);
    v_deptid varchar2(100);
begin
    --join�� Ȱ���� ���
    --select employee_id, first_name, department_name
    --into v_empid, v_ename, v_dname
    --from employees e join departments d using(department_id)
    --where employee_id=&�����ȣ;
    
    --select�̿��� ���
    select
    employee_id,first_name,department_id
    into v_empid,v_ename,v_deptid
    from employees
    where employee_id=&�����ȣ;
    
    select department_name
    into v_dname
    from departments
    where department_id=v_deptid;
    
    dbms_output.put_line('�����ȣ'||v_empid||' �� �ش��ϴ� �̸��� '||v_ename||' �� �ٹ��ϴ� �μ��� '||v_dname);
end;
/


declare
    v_ename employees.first_name%type;
    v_salary employees.salary%type;
    v_ysalary employees.salary%type;
begin
    select first_name,salary,(salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12))
                            --�������ϴ°���
    into v_ename, v_salary,v_ysalary
    from employees
    where employee_id=&�����ȣ;
    
    dbms_output.put_line(v_ename||'  '||v_salary||'  '||v_ysalary);
end;
/
--������������� ó���ϱ�
declare
    v_ename employees.first_name%type;
    v_sal employees.salary%type;
    v_comm employees.commission_pct%type;
    v_annual v_sal%type;
begin 
    select first_name, salary,commission_pct
    into v_ename,v_sal,v_comm
    from employees
    where employee_id=&�����ȣ;
    
    v_annual:=v_sal*12+nvl(v_sal,0)*nvl(v_comm,0)*12;
     dbms_output.put_line(v_ename||'  '||v_sal||'  '||v_anuual);
end;
/