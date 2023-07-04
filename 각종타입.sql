set serveroutput on
--record
declare
    type emp_record_type is record
        (empno number(6)not null:=100,
        ename employees.first_name%type,
        sal employees.salary%type);
    emp_info emp_record_type;
    emp_record emp_record_type;
begin
    dbms_output.put_line('number; '||emp_info.empno);
    dbms_output.put_line('number; '||emp_record.empno);
    dbms_output.put_line('number; '||emp_record.ename);
    
    select employee_id,first_name,salary
    into emp_info
    from employees
    where employee_id=&�����ȣ;
    
    dbms_output.put(' number;'||emp_info.empno);
    dbms_output.put(' name;'||emp_info.ename);
    dbms_output.put_line(' sal;'||emp_info.sal);
    
end;
/
declare
    emp_record employees%rowtype;
begin
    select*
    into emp_record
    from employees
    where employee_id=&�����ȣ;
    dbms_output.put_line(emp_record.employee_id);
    dbms_output.put_line(emp_record.last_name);
    dbms_output.put_line(emp_record.job_id);
end;
/

------------------------------------------------------------------------------------------------���̺�
declare
    type num_table_type is table of number
        index by pls_integer;
        
    num_info num_table_type;
begin
    num_info(10):=1000;
    --ũ�Ⱑ �������� �����Ǳ�(����, ��� �� ������ ������ �� ����) ������ �޼ҵ�� �����ؾ� ��
    dbms_output.put_line(num_info(10));
    
    for idx in 1..10 loop
        num_info(trunc(idx/2)):=idx;
    end loop;
    dbms_output.put_line('');
    dbms_output.put_line(num_info(0));
    dbms_output.put_line(num_info(1));
end;
/

declare
    type num_table_type is table of number
        index by binary_integer;
    num_table num_table_type;
    v_total number(2);
begin
    --���� 1����50���̿��ִ�2�ǹ���� num_table������������
    for idx in 1..50 loop
        if mod(idx,2)<>0 then
            continue;
        end if;
        num_table(idx):=idx;
        
    end loop;
    
    v_total:=num_table.count;
    dbms_output.put_line(v_total);
    dbms_output.put_line('');
    
    for idx in num_table.first .. num_table.last loop
        if num_table.exists(idx) then
            --3�� ����� ����
            if mod(num_table(idx),3)=0 then
                num_table.delete(idx);
            else
                dbms_output.put_line(num_table(idx));
            end if;
        end if;

    end loop;
end;
/
---------------------table����
DECLARE
    v_min employees.employee_id%TYPE; --�������������ȣ
    v_MAX employees.employee_id%TYPE; --����ū������ȣ
    v_result NUMBER(1,0);       --�������������
    emp_record employees%ROWTYPE; --employees�����࿡����
    
    TYPE emp_table_type IS TABLE OF emp_record%TYPE --������ �Ҵ��� ���� type�Ӽ�����
        INDEX BY PLS_INTEGER;
    
    emp_table emp_table_type;
BEGIN
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)--plsql���� 0������ ������ ����
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN
            CONTINUE;
        END IF;
        
        SELECT *
        INTO emp_record
        FROM employees
        WHERE employee_id = eid;
        
        emp_table(eid) := emp_record;
    END LOOP;
    
    
END;
/
