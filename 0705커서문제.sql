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
���(employees) ���̺���
����� �����ȣ, ����̸�, �Ի翬���� 
���� ���ؿ� �°� ���� test01, test02�� �Է��Ͻÿ�.
�Ի�⵵�� 2005��(����) ���� �Ի��� ����� test01 ���̺� �Է�
�Ի�⵵�� 2005�� ���� �Ի��� ����� test02 ���̺� �Է�
1-1) ����� Ŀ�� + �⺻ LOOP ���
1-2) Ŀ�� FOR LOOP ���
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
            ---emp_record�� �����Ϸ��� table�� ������ �Ȱ��� ������ �׳� �̷��� ���⸸ �ص� ��
     end if;
    end loop;
end;
/


/*
2.
�μ���ȣ�� �Է��� ���(&ġȯ���� ���)
�ش��ϴ� �μ��� ����̸�, �Ի�����, �μ����� ����Ͻÿ�.
(��, cursor ���)
*/

declare
    cursor emp_cursor is
        select first_name,hire_date,department_name from employees e join departments d
        on e.department_id=d.department_id
        where d.department_id=&�μ���ȣ;
        
        
        --------�̷��Ե� ����
    v_deptid departments.department_id%type:=&�μ���ȣ;
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
        
	