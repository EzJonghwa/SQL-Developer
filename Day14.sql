/*
    ���ν��� PROCEDURE
    �Լ��� �޶� �������� DB�������� ����Ǹ� ������ 0~N ����
    ���� �ӵ��� ���� ��뷮 ������ ó�� �׹�ġ�۾��� ����.
*/
CREATE OR REPLACE PROCEDURE my_job_proc(P_job_id IN jobs.job_id%TYPE        -- IN ����
                                        ,p_job_title jobs.job_title%TYPE
                                        ,p_min jobs.min_salary%TYPE :=10
                                        ,p_max jobs.max_salary%TYPE :=100000)   -- ����Ʈ ��
IS
BEGIN
    INSERT INTO jobs(job_id,job_title,min_salary, max_salary
                    , create_date ,update_date)
    VALUES (p_job_id, p_job_title, p_min, p_max , SYSDATE, SYSDATE);
    COMMIT;
    END;
    
-- ���ν��� ȣ��
EXEC my_job_proc('TECH_JOB1','SAMPLE JOB1',2000,6000);
EXECUTE my_job_proc('TECH_JOB2','SAMPLE_JOB2');



SELECT* FROM JOBS;
-- IN : ���ο����� ��� ,OUT:�������θ� ���,INOUT: ���� ���� �� �� ���
CREATE OR REPLACE PROCEDURE input_test_proc(
                            p_var1 VARCHAR2
                            ,p_var2 OUT VARCHAR2
                            ,p_var3 IN OUT VARCHAR2)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('input_test_proc ���� : p_var1:' || p_var1);
    DBMS_OUTPUT.PUT_LINE('input_test_proc ���� : p_var2:' || p_var2);
    DBMS_OUTPUT.PUT_LINE('input_test_proc ���� : p_var3:' || p_var3);
    p_var2 := 'var2����';
    p_var3 := 'var3����';
    

DECLARE 
    var1 VARCHAR2(100) := 'A';
    var2 VARCHAR2(100) := 'B';
    var3 VARCHAR2(100) := 'C';
    
BEGIN
    input_test_proc(var1,var2,var3);
    DBMS_OUTPUT.PUT_LINE('�ܺ� ȣ�� var2:' || var2);
    DBMS_OUTPUT.PUT_LINE('�ܺ� ȣ�� var3:' || var3);
END;



-- �ý��� ����

CREATE OR REPLACE PROCEDURE no_exception_proc
IS
    vi_num NUMBER :=0;
BEGIN
    vi_num :=10/0;
    DBMS_OUTPUT.PUT_LINE('SUCCESS!');
END;
BEGIN
    no_exception_proc;  -- �ش� ���ν��� ������ ���� ���� �ȵ�. �ߴܵ�
    DBMS_OUTPUT.PUT_LINE('����');
END;





CREATE OR REPLACE PROCEDURE exception_proc
IS
    vi_num NUMBER :=0;
BEGIN
    vi_num :=10/0;
    DBMS_OUTPUT.PUT_LINE('SUCCESS!');
    EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('���� ó��');
END;
BEGIN
    exception_proc;  -- �ش� ���ν������� ������ �Ͼ�� ���� ó���� �߱� ������ �����ܰ�� �Ѿ
    DBMS_OUTPUT.PUT_LINE('����');
END;

abcdefghijklmnopqrstuwxyz
            
n qtaj dtz






