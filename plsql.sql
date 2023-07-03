set serveroutput on
--dbms의 설정을 실행하는 것

--declare:변수선언
declare  --transaction시작, 그치만 end가 transaction의 종료를 의미하지 않음(내부블럭에서 commit,rollback가능)
    v_sal number(7,2):=60000;--이름,type:=초기화할 값
    V_COMM V_SAL%TYPE :=V_SAL*.20;
    v_message varchar2(255):='eligible for commission';
begin
    dbms_output.put_line('v_sal'||v_sal);--출력하는 함수. 이걸 실행하려면 set serveroutput on필요
    dbms_output.put_line('v_comm'||v_comm);
    dbms_output.put_line('v_message'||v_message);
    dbms_output.put_line('=======================================================');
    declare
        v_sal number(7,2):=50000;
        v_comm v_sal%type:=0;
        v_total_comp number(7,2):=v_sal+v_comm;
    begin
        dbms_output.put_line('v_sal'||v_sal);--출력하는 함수. 이걸 실행하려면 set serveroutput on필요
        dbms_output.put_line('v_comm'||v_comm);
        dbms_output.put_line('v_message'||v_message);
        dbms_output.put_line('v_total_comp'||v_total_comp);
        dbms_output.put_line('=======================================================');
        v_message:='CLERK not'||v_message;
        v_comm:=v_sal*.30;
    end;
    dbms_output.put_line('v_sal'||v_sal);--출력하는 함수. 이걸 실행하려면 set serveroutput on필요
    dbms_output.put_line('v_comm'||v_comm);
    dbms_output.put_line('v_message'||v_message);
    dbms_output.put_line('=======================================================');
    v_message:='SALESMAN'||v_message;
    dbms_output.put_line('v_message'||v_message);
end;