set serveroutput on

create function y_sum
(p_x in number,
p_y number)-- function������ ���������� in�� ��������
return  number
is
    v_result number;
begin
    v_result:=p_x+p_y;
    return v_result;
end;
/

execute dbms_output.put_line( y_sum(2,4));

variable result number;
execute :result:=y_sum(3,2);
print result;

select y_sum(20,1)from dual;


----------------------------------------------------t�����ȣ�������������ӻ���̸����
create or replace function get_mgr
(p_eid employees.employee_id%type)
return varchar2
is
    v_mgr_name employees.first_name%type;
begin
    select m.first_name into v_mgr_name
    from employees e join employees m on e.manager_id=m.employee_id
    where e.employee_id=p_eid;
    
    return v_mgr_name;
    
exception
---���ܵ� return���� �޾���� �� (����� return���� ���� �ڷ�������)
    when no_data_found then
        return 'he/she has no manager';
end;
/
select employee_id,first_name, get_mgr(employee_id) manager from employees order by employee_id;



create or replace function y_factorial
(p_num number)
return number
is
    v_sum number:=0;    
    e_num_null exception;
begin
    if p_num is null then
        raise e_num_null;
    end if;    
    for idx in 1..p_num loop
        v_sum:=v_sum+idx;
    end loop;
    return v_sum;
    if v_sum>0 then
        return v_sum;
    end if;
    return v_sum;--if�ܿ��� return �ʿ���
exception
    when e_num_null then
        return -1;
end;
/
select y_factorial(3) from dual;

----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
/*
1.
�����ȣ�� �Է��ϸ�
last_name + first_name �� ��µǴ� 
y_yedam �Լ��� �����Ͻÿ�.

����) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
��� ��)  Abel Ellen

SELECT employee_id, y_yedam(employee_id)
FROM   employees;
*/
create or replace function y_yedam
(f_id number)
return varchar2
is
    p_last_name employees.last_name%type;
    p_first_name employees.first_name%type;
begin
    select first_name, last_name into p_last_name,p_first_name from employees where employee_id=f_id;
    return p_last_name||' '||p_first_name;
end;
/
execute dbms_output.put_line(y_yedam(120));



/*
2.
�����ȣ�� �Է��� ��� ���� ������ �����ϴ� ����� ��µǴ� ydinc �Լ��� �����Ͻÿ�.
- �޿��� 5000 �����̸� 20% �λ�� �޿� ���
- �޿��� 10000 �����̸� 15% �λ�� �޿� ���
- �޿��� 20000 �����̸� 10% �λ�� �޿� ���
- �޿��� 20000 �̻��̸� �޿� �״�� ���
����) SELECT last_name, salary, YDINC(employee_id)
     FROM   employees;
*/
drop function ydinc;
create or replace function ydinc
(p_id number)
return number
is
    final_salary employees.salary%type:=0;
    p_salary number;
begin
        select salary into p_salary from employees
        where employee_id=p_id;
        if(p_salary <=5000) then
            final_salary:=p_salary *1.2;
             return final_salary;
        elsif (p_salary <=10000) then
             final_salary:=p_salary *1.15;
             return final_salary;
        elsif (p_salary<=20000) then
             final_salary:=p_salary*1.1;
             return final_salary;
        else 
             final_salary:=p_salary;
             return final_salary;
        end if;
         return 0;
end;
/
SELECT last_name, salary, YDINC(employee_id)
     FROM   employees;



/*
3.
�����ȣ�� �Է��ϸ� �ش� ����� ������ ��µǴ� yd_func �Լ��� �����Ͻÿ�.
->������� : (�޿�+(�޿�*�μ�Ƽ���ۼ�Ʈ))*12
����) SELECT last_name, salary, YD_FUNC(employee_id)
     FROM   employees;
*/
CREATE OR REPLACE FUNCTION yd_func
(p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
    v_annual employees.salary%TYPE;
BEGIN
    SELECT (salary + (salary * NVL(commission_pct, 0)))*12
    INTO v_annual
    FROM employees
    WHERE employee_id = p_eid;
    
    RETURN v_annual;
END;
/

SELECT last_name, salary, YD_FUNC(employee_id)
FROM   employees;








/*
4. 
SELECT last_name, subname(last_name)
FROM   employees;

LAST_NAME     SUBNAME(LA
------------ ------------
King         K***
Smith        S****
...
������ ���� ��µǴ� subname �Լ��� �ۼ��Ͻÿ�.
*/
CREATE FUNCTION subname
(p_name VARCHAR2)
RETURN VARCHAR2
IS

BEGIN
    RETURN RPAD(SUBSTR(p_name,1,1), LENGTH(p_name), '*');
END;
/

SELECT last_name, subname(last_name)
FROM   employees;

/*
5. 
�����ȣ�� �Է��ϸ� �Ҽ� �μ��� ����ϴ� y_dept �Լ��� �����Ͻÿ�.
(��, ������ ���� ��� ����ó��(exception)
 �Էµ� ����� ���ų� �Ҽ� �μ��� ���� ��� -> ����� �ƴϰų� �Ҽ� �μ��� �����ϴ�.)

    �Էµ� ����� ���� ��� -> ����� �ƴմϴ�.
    �Ҽ� �μ��� ���� ��� -> �Ҽ� �μ��� �����ϴ�. )

����) EXECUTE DBMS_OUTPUT.PUT_LINE(y_dept(178))
���) Executive
SELECT employee_id, y_dept(employee_id)
FROM   employees;
*/
-- 1) SELECT�� * 2��
CREATE OR REPLACE FUNCTION y_dept
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_deptno departments.department_id%TYPE;
    v_deptname departments.department_name%TYPE;
    
    e_no_dept  EXCEPTION;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id = p_eid;
    
    IF v_deptno IS NULL THEN
        RAISE e_no_dept;
    END IF;
    
    SELECT department_name
    INTO v_deptname
    FROM departments
    WHERE department_id = v_deptno;
    
    RETURN v_deptname;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '����� �ƴմϴ�.';
    WHEN e_no_dept THEN
        RETURN '�Ҽ� �μ��� �����ϴ�.';        
END;
/

-- 2) JOIN��
CREATE OR REPLACE FUNCTION y_dept
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_deptno departments.department_id%TYPE;
    v_deptname departments.department_name%TYPE;
    
    e_no_dept  EXCEPTION;
BEGIN
    SELECT department_name
    INTO v_deptname
    FROM employees LEFT OUTER JOIN departments
         USING(department_id)
    WHERE employee_id = p_eid;
    
    IF v_deptname IS NULL THEN
        RAISE e_no_dept;
    END IF;
    
    RETURN v_deptname;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '����� �ƴմϴ�.';
    WHEN e_no_dept THEN
        RETURN '�Ҽ� �μ��� �����ϴ�.'; 
END;
/



create or replace function y_dept
(f_id number)
return varchar2
is
    f_no departments.department_id%type;
    f_dname departments.department_name%type;
    e_no_emp exception;
    cursor employee_cursor is
        select employee_id from employees where employee_id=f_id;
    emp_record employee_cursor%rowtype;
begin
    select department_name into f_dname from departments d right outer join employees e on e.employee_id=f_id;----------------null�� ����ؾ��ؾ��ϱ� ������ �ƿ�������!!
    if sql%rowcount=0 then
        return '�Ҽ� �μ��� �����ϴ�';
    end if;
    loop
        fetch employee_cursor into emp_record;
        exit when employee_cursor%notfound;
    end loop;
    if employee_cursor%rowcount=0 then
        raise e_no_emp;
    end if;
exception
    when e_no_emp then
         return '����� �ƴմϴ�..';
end;
/

SELECT employee_id, y_dept(employee_id)
FROM   employees;



/*
6.
��������� �Է��ϸ� "��"�� ��µǴ� y_ddi �Լ��� �����Ͻÿ�
(��� ����, �� ���� ���ڸ��� 00~23�̸� 2000���, 24~99�̸� 1900���� ����)
����) EXECUTE DBMS_OUTPUT.PUT_LINE(y_ddi('980901'))
*/
CREATE OR REPLACE FUNCTION y_ddi
(p_birth VARCHAR2)
RETURN VARCHAR2
IS
    v_year VARCHAR2(10);
    v_seq NUMBER;
    v_ddi VARCHAR2(10);
BEGIN
    v_year := SUBSTR(p_birth, 1, 2);
    IF TO_NUMBER(v_year, '99') < 24 THEN
        v_year := '19' || v_year;
    ELSE
        v_year := '20' || v_year;
    END IF;
    
    v_seq := MOD(TO_NUMBER(v_year, '9999'), 12);
    
    IF v_seq = 1 THEN
        v_ddi := '�߶�';
    ELSIF v_seq = 2 THEN
        v_ddi := '����';
    ELSIF v_seq = 3 THEN
        v_ddi := '������';
    ELSIF v_seq = 4 THEN
        v_ddi := '���';
    ELSIF v_seq = 5 THEN
        v_ddi := '�Ҷ�';
    ELSIF v_seq = 6 THEN
        v_ddi := 'ȣ���̶�';
    ELSIF v_seq = 7 THEN
        v_ddi := '�䳢��';
    ELSIF v_seq = 8 THEN
        v_ddi := '���';
    ELSIF v_seq = 9 THEN
        v_ddi := '���';
    ELSIF v_seq = 10 THEN
        v_ddi := '����';
    ELSIF v_seq = 11 THEN
        v_ddi := '���';
    ELSE
        v_ddi := '�����̶�';
    END IF;
    
    RETURN v_ddi;
END;
/