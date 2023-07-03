set serveroutput on

begin
    delete from test_employees
    where employee_id=&�����ȣ;
    
    if sql%rowcount=0 then
        dbms_output.put_line('nonenonenonenonenonenonenonenonenone');
        end if;
end;
/

--ifelse��(������������==������ΰ���?
declare
    v_count employees.employee_id%type;
begin
    select count(employee_id)
    into v_count
    from employees
    where manager_id=&�����ȣ;
    
    if v_count=0 then
        dbms_output.put_line('�Ϲݻ���̿�');
    else
        dbms_output.put_line('���������ս��̴�');
    end if;
end;
/
--if elsif else:����
declare
    v_hdate number;
begin
    select trunc(months_between(sysdate,hire_date)/12)
    --monthbetween�� ����:literal
    --trunc,round �� �� ���� �ܿ� dateŸ�Կ��� �� �� ����
    into v_hdate
    from employees
    where employee_id=&�����ȣ;
    
    if v_hdate<1 then
        dbms_output.put_line('�оƸ�');
    elsif  v_hdate<3 then
      dbms_output.put_line('�ߴ�');
    elsif v_hdate<5 then
        dbms_output.put_line('���');
    else
        dbms_output.put_line('����');
    END IF;
end;
/

 select to_char(hire_date,'YY') a from employees where 'a'>'11';



declare
    --v_id employees.employee_id%type;
    v_hd employees.hire_date%type;
    v_message varchar2(20);
begin
    select hire_date
    into v_hd
    from employees
    where employee_id=&�����ȣ; 
       
    if to_char(v_hd,'yyyy')>'2004' then
        v_message:='NewEmployee';
    else
        v_message:='Career employee';
    end if;
    dbms_output.put_line(v_message);
end;
/

create table emp00(empid, ename, hiredate)
as
  select employee_id, first_name, hire_date
  from   employees
  where  employee_id = 0;--���� �������� �ʴ� id�� �Է������μ� ������ ����



declare
    --v_id employees.employee_id%type;
    v_empid employees.employee_id%type:=&�����ȣ;
    v_hd varchar2(10);
begin
    select to_char(hire_date,'YY') 
    into v_hd
    from employees
    where employee_id=v_empid; 
    if v_hd<05 then
        dbms_output.put_line('Career employee');
    else
        dbms_output.put_line(v_hd||'New employee');
    end if;
end;
/

/*
4. 
�����ȣ�� �Է�(ġȯ����& ���)�� ���
�μ����� �����Ͽ� ������ ���̺� �Է��ϴ� PL/SQL ����� �ۼ��Ͻÿ�.
��, �ش� �μ��� ���� ����� emp00 ���̺� �Է��Ͻÿ�.
   : �μ���ȣ10->emp10, �μ���ȣ20->emp20 ....

create table emp10(empid, ename, hiredate)
as
  select employee_id, first_name, hire_date
  from   employees
  where  employee_id = 0;

emp20
emp30
emp40
emp50
emp00
*/

declare
    v_empid employees.employee_id%type:=&�����ȣ;
    v_ename employees.first_name%type;
    v_hdate employees.hire_date%type;
    v_deptid employees.department_id%type;
begin
    select first_name,hire_date,department_id
    into v_ename,v_hdate,v_deptid
    from employees
    where employee_id=v_empid;   
    
    if v_deptid=10 then
        insert into emp10 values(v_empid,v_ename,v_hdate);
    elsif  v_deptid=20 then
        insert into emp20 values(v_empid,v_ename,v_hdate);
    elsif  v_deptid=30 then
        insert into emp30 values(v_empid,v_ename,v_hdate);
    elsif  v_deptid=40 then
        insert into emp40 values(v_empid,v_ename,v_hdate);
    elsif  v_deptid=50 then
        insert into emp50 values(v_empid,v_ename,v_hdate);
    else 
        insert into emp00 values(v_empid,v_ename,v_hdate);
    end if;
        
end;
/
select * from emp00;


--��������
declare
    v_empid employees.employee_id%type:=&�����ȣ;
    v_ename employees.first_name%type;
    v_hdate employees.hire_date%type;
    v_deptid employees.department_id%type;
    v_sql varchar2(100);
begin
    select first_name,hire_date,trunc(department_id/10)
    into v_ename,v_hdate,v_deptid
    from employees
    where employee_id=v_empid;   
    
    if v_deptid between 1 and 5 then
        v_sql:='insert into emp'||(v_deptid*10);
        v_sql:=v_sql||' values('||v_empid||','''||v_ename||''','''||v_hdate||''')';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        --����sql�����ϴ� ����
    else 
        insert into emp00 values(v_empid,v_ename,v_hdate);
    end if;
end;
/
/*
5.
�޿���  5000�����̸� 20% �λ�� �޿�
�޿��� 10000�����̸� 15% �λ�� �޿�
�޿��� 15000�����̸� 10% �λ�� �޿�
�޿��� 15001�̻��̸� �޿� �λ����

�����ȣ�� �Է�(ġȯ����)�ϸ� ����̸�, �޿�, �λ�� �޿��� ��µǵ��� PL/SQL ����� �����Ͻÿ�.
*/
declare
    v_ename employees.first_name%type;
    v_sal employees.salary%type;
    v_raise number:=0;
begin
    select first_name,salary
    into v_ename,v_sal
    from employees
    where employee_id=&�����ȣ;
    if v_sal<=5000 then
        v_raise:=20;
    elsif v_sal<=10000 then
        v_raise:=15;
    elsif v_sal<=15000 then
        v_raise:=10;
    end if;
    
    dbms_output.put_line('����̸� ;'||v_ename);
      dbms_output.put_line('�޿� ;'||v_sal||' �λ�� �޿� :'||v_sal*(v_raise/100));
end;
/
