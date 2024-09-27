/*
    프로시저 PROCEDURE
    함수와 달라 서버에서 DB서버에서 실행되며 리턴이 0~N 가능
    실행 속도가 빨라 대용량 데이터 처리 및배치작없에 사용됨.
*/
CREATE OR REPLACE PROCEDURE my_job_proc(P_job_id IN jobs.job_id%TYPE        -- IN 변수
                                        ,p_job_title jobs.job_title%TYPE
                                        ,p_min jobs.min_salary%TYPE :=10
                                        ,p_max jobs.max_salary%TYPE :=100000)   -- 디폴트 값
IS
BEGIN
    INSERT INTO jobs(job_id,job_title,min_salary, max_salary
                    , create_date ,update_date)
    VALUES (p_job_id, p_job_title, p_min, p_max , SYSDATE, SYSDATE);
    COMMIT;
    END;
    
-- 프로시져 호출
EXEC my_job_proc('TECH_JOB1','SAMPLE JOB1',2000,6000);
EXECUTE my_job_proc('TECH_JOB2','SAMPLE_JOB2');



SELECT* FROM JOBS;
-- IN : 내부에서만 사용 ,OUT:리턴으로만 사용,INOUT: 내부 리턴 둘 다 사용
CREATE OR REPLACE PROCEDURE input_test_proc(
                            p_var1 VARCHAR2
                            ,p_var2 OUT VARCHAR2
                            ,p_var3 IN OUT VARCHAR2)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('input_test_proc 내부 : p_var1:' || p_var1);
    DBMS_OUTPUT.PUT_LINE('input_test_proc 내부 : p_var2:' || p_var2);
    DBMS_OUTPUT.PUT_LINE('input_test_proc 내부 : p_var3:' || p_var3);
    p_var2 := 'var2변경';
    p_var3 := 'var3변경';
    

DECLARE 
    var1 VARCHAR2(100) := 'A';
    var2 VARCHAR2(100) := 'B';
    var3 VARCHAR2(100) := 'C';
    
BEGIN
    input_test_proc(var1,var2,var3);
    DBMS_OUTPUT.PUT_LINE('외부 호출 var2:' || var2);
    DBMS_OUTPUT.PUT_LINE('외부 호출 var3:' || var3);
END;



-- 시스템 예외

CREATE OR REPLACE PROCEDURE no_exception_proc
IS
    vi_num NUMBER :=0;
BEGIN
    vi_num :=10/0;
    DBMS_OUTPUT.PUT_LINE('SUCCESS!');
END;
BEGIN
    no_exception_proc;  -- 해당 프로시져 오류로 정상 종료 안됨. 중단됨
    DBMS_OUTPUT.PUT_LINE('종료');
END;





CREATE OR REPLACE PROCEDURE exception_proc
IS
    vi_num NUMBER :=0;
BEGIN
    vi_num :=10/0;
    DBMS_OUTPUT.PUT_LINE('SUCCESS!');
    EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('오류 처리');
END;
BEGIN
    exception_proc;  -- 해당 프로시저에서 문제가 일어나도 예외 처리를 했기 때문에 다음단계로 넘어감
    DBMS_OUTPUT.PUT_LINE('종료');
END;

abcdefghijklmnopqrstuwxyz
            
n qtaj dtz






