set serveroutput on
--dbms�� ������ �����ϴ� ��

--declare:��������
declare  --transaction����, ��ġ�� end�� transaction�� ���Ḧ �ǹ����� ����(���κ����� commit,rollback����)
    v_sal number(7,2):=60000;--�̸�,type:=�ʱ�ȭ�� ��
    V_COMM V_SAL%TYPE :=V_SAL*.20;
    v_message varchar2(255):='eligible for commission';
begin
    dbms_output.put_line('v_sal'||v_sal);--����ϴ� �Լ�. �̰� �����Ϸ��� set serveroutput on�ʿ�
    dbms_output.put_line('v_comm'||v_comm);
    dbms_output.put_line('v_message'||v_message);
    dbms_output.put_line('=======================================================');
    declare
        v_sal number(7,2):=50000;
        v_comm v_sal%type:=0;
        v_total_comp number(7,2):=v_sal+v_comm;
    begin
        dbms_output.put_line('v_sal'||v_sal);--����ϴ� �Լ�. �̰� �����Ϸ��� set serveroutput on�ʿ�
        dbms_output.put_line('v_comm'||v_comm);
        dbms_output.put_line('v_message'||v_message);
        dbms_output.put_line('v_total_comp'||v_total_comp);
        dbms_output.put_line('=======================================================');
        v_message:='CLERK not'||v_message;
        v_comm:=v_sal*.30;
    end;
    dbms_output.put_line('v_sal'||v_sal);--����ϴ� �Լ�. �̰� �����Ϸ��� set serveroutput on�ʿ�
    dbms_output.put_line('v_comm'||v_comm);
    dbms_output.put_line('v_message'||v_message);
    dbms_output.put_line('=======================================================');
    v_message:='SALESMAN'||v_message;
    dbms_output.put_line('v_message'||v_message);
end;