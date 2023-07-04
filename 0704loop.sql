set serveroutput on

declare
    v_num number(2,0):=1;
    v_result number(2,0):=0;
begin
    
    loop
        v_result:=v_result+v_num;
        v_num:=v_num+1;
        exit when v_num>10;
        --exit when직전 혹은 직후에 증감식을 두는 것이 좋대
    end loop;
    dbms_output.put_line(v_result);
end;
/

--for.loop
begin
    for num in reverse -5..-1 loop
        dbms_output.put_line(num);
    end loop;
end;
/
declare
    v_result number(2,0):=0;
begin
    for num in 1..10 loop
        v_result:=v_result+num;
        dbms_output.put_line(v_result);
    end loop;
end;
/

--whileloop
declare
    v_num number(2,0):=1;
    v_result number(2,0):=0;
begin
    while v_num<=10 loop
        v_result:=v_result+v_num;
        v_num:=v_num+1;
        dbms_output.put_line('result '||v_num||' '||v_result);
    end loop;
end;
/

declare
    v_num number(2,0):=0;
    v_result number(2,0):=0;
begin
    while v_num<10 loop
        v_num:=v_num+1;
        v_result:=v_result+v_num;
        dbms_output.put_line('result '||v_num||' '||v_result);
    end loop;
end;
/

--별찍기ㅋㅋagain
declare
    v_star varchar(100):='*';
    v_count number(1):=0;
begin
    dbms_output.put_line(v_star);
    loop
        v_star:=(v_star||v_star);
        v_count:=v_count+1;
       
        if(v_count=2) then
            v_star:='***';
        elsif(v_count=1)then
            v_star:='**';
        elsif(v_count=3)then
            v_star:='****';
        else
            v_star:='*****';
        end if;
        dbms_output.put_line(v_star);
    exit when v_count=4;
    end loop;
end;
/
--forloop1
declare
 v_star varchar2(10):='*';
begin
    for star in reverse 1..5 loop
        dbms_output.put_line(v_star);
        v_star:=v_star||'*';
    end loop;
end;
/
--forloop2중for문
begin
    for counter in 1..5 loop
        for i in 1..counter loop
            dbms_output.put('*');
            --가로로 출력
        end loop;
        dbms_output.put_line('');
    end loop;
end;
/

declare
     v_star varchar2(10):='*';
     v_count number(2):=0;
begin
    while v_count<5 loop
        --dbms_output.put_line(v_count);
        dbms_output.put_line(v_star);
        v_star:=v_star||'*';
        v_count:=v_count+1;
        dbms_output.put_line(v_count);
    end loop;
end;
/

declare
    first number(5):=&몇단할래용;
    second number(5):=1;
    answer number(30);
begin
    loop
        dbms_output.put_line(first||'*'||second||'='||first*second);
        second:=second+1;
        exit when second=10;
    end loop;
end;
/
declare
    first number(5):=&몇단할래용;
begin
    for counter in 1..9 loop
            dbms_output.put_line(first||'*'||counter||'='||first*counter);
    end loop;
end;
/

declare
    first number(5):=&몇단할래용;
    second number(5):=1;
begin
    while  second<10 loop
        dbms_output.put_line(first||'*'||second||'='||first*second);
        second:=second+1;
    end loop;
end;
/

--구구단2~9단출력
begin 
    for first in 2..9 loop
        for second in 1..9 loop
            dbms_output.put_line(first||'*'||second||'='||first*second);
            end loop;
            dbms_output.put_line('~~~~~~~~~~~~~~~'||first||'단~~~~~~~~~~~~~~~');
    end loop;
end;
/

declare
    first number(10):=2;
    second number(20):=1;
begin
    loop
        loop
             dbms_output.put_line(first||'*'||second||'='||first*second);
             second:=second+1;
             exit when second=10;
        end loop;
        dbms_output.put_line('~~~~~~~~~~~~~~~'||first||'단~~~~~~~~~~~~~~~');
        second:=1;
        first:=first+1;
        exit when first=10;
    end loop;
end;
/

declare
    first number(10):=2;
    second number(20):=1;
begin
    while first<10 loop
        while second<10 loop
            dbms_output.put_line(first||'*'||second||'='||first*second);
            second:=second+1;
            end loop;
        dbms_output.put_line('~~~~~~~~~~~~~~~'||first||'단~~~~~~~~~~~~~~~');
        second:=1;
        first:=first+1;
    end loop;
end;
/


begin
    for first in 1..9 loop
            if(mod(first,2)=0) then
               continue;
            else
                for second in 1..9 loop
                    dbms_output.put_line(first||'*'||second||'='||first*second);
                end loop;
                dbms_output.put_line('~~~~~~~~~~~~~~~'||first||'단~~~~~~~~~~~~~~~');
        end if;              
    end loop;
end;
/
