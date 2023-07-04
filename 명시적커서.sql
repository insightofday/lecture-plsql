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
        fetch emp_cursor into  v_eid,v_ename;--����Ŀ���� ����Ű�� �� load�ؼ� ������ ����
        exit when emp_cursor%notfound;    --���������� fetch������ ���̱�
         --exit when emp_cursor%rowcount>10;  --�Ǵٸ� ��������
        dbms_output.put_line(v_eid||', '||v_ename);
    end loop;
    
    dbms_output.put_line('');
    fetch emp_cursor into  v_eid,v_ename;
    dbms_output.put_line(v_eid||', '||v_ename);
    --���̻� ���ο� �����Ͱ� ��� loop���� fetch������ loop������ Ŀ���� �̵����� ���� ä�� �����(��������2������)
    
    
    
    dbms_output.put_line('');
    dbms_output.put_line(emp_cursor%rowcount);
    --rowcountĿ���� ��ȯ�� Ƚ���� ������ ���� fetch�� ������ ��ġ�� ����
    close emp_cursor;
    --  dbms_output.put_line(emp_cursor%rowcount); rowcount���� close�ڿ� ���� �ȵ�
end;
/

--��� ����� �����ȣ �̸� �μ��̸� ���
--Ŀ���� join subquery��밡��
--�⺻������ �켱������ �Ʒζ�~~
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


--�μ���ȣ��50�̰ų�80�� ������� �̸�,�޿�,���� ���
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
--Ŀ���� ����:����̸�, �޿�, Ŀ�̼����� ������ ��, ���� ������ Ǯ��ƶ�
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