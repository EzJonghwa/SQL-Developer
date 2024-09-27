    /*  PL/SQL(Procedural LANGUAGE/SQL)
        ������ ���� ������ ����� Ư¡�� ��� ������ �ִ�,
        �Ϲ� ���α׷��� ���ʿ� �ٸ����� ��� �ڵ尡 DB �ȿ��� �������
        ó���ǹǷ� ����ӵ��� ������ ���鿡�� ū ������ �ִ�.
        ������ �ؼ��� ������� �����.
    */
    -- �⺻ ������ ����̶�� �ϸ� ����� �̸���, �����, �����,����ó���η� ������.
    -- 1. �̸��δ� ����� ��Ī�� ���µ� ������ ���� �͸����̵�.(�׽����� ������� ����)

SET SERVEROUTPUT ON;
DECLARE
    vi_num NUMBER;  -- ����(����ο��� ������ �� �������� ����ο��� ��밡��)
    vi_pi CONSTANT NUMBER:=3.14;   -- ���
    
BEGIN
    -- vi_pi:=1;
    DBMS_OUTPUT.PUT_LINE(vi_num); -- �ʱⰪ�� �Ҵ����� ������ Ÿ�Ի������ NULL(��ĭ)
    vi_num :=100;
    DBMS_OUTPUT.PUT_LINE(vi_num);
END;
    
    -- ������ ��� ���� ������ �� CNTR+ENTER
    -- �Ϸ� �Ǿ����ϴ�.
    -- ��� ���� ������ [���� - DBMS��� - ������� ����
    
    DECLARE
        vs_emp_name VARCHAR2(80);
        vs_dep_name departments.department_name%TYPE;
    BEGIN 
        SELECT a.emp_name , b.department_name
        INTO vs_emp_name , vs_dep_name      -- ��ȸ ����� ������ �Ҵ�(Ÿ��,��)�¾ƾ���
        FROM employees a ,departments b
        WHERE a.department_id = b.department_id
        AND a.employee_id=100;
        DBMS_OUTPUT.PUT_LINE(vs_emp_name ||':' || vs_dep_name);
        END;
        
SELECT *
FROM EMPLOYEES;
-- ������ �ʿ������ begin �� ��밡��
    BEGIN
    DBMS_OUTPUT.PUT_LINE(' 3*2= '||3*2);    --������ ��밡��
    END;
    
    -- IF �� 
    DECLARE
    vn_num1 NUMBER := 10;
    vn_num2 NUMBER := :a;
    
    BEGIN 
    IF vn_num1 > vn_num2 THEN
        DBMS_OUTPUT.PUT_LINE(vn_num1 || '�� ū ��');
    ELSIF vn_num1 = vn_num2 THEN
        DBMS_OUTPUT.PUT_LINE('����');
    ELSIF vn_num2 BETWEEN 11 AND 20 THEN
        DBMS_OUTPUT.PUT_LINE('11-20 ����');
    ELSE
        NULL; -- �ƹ��͵� ���� ������ ���� ��
    END IF;
END;



/*  ���Ի��� ���Խ��ϴ�.^^
    �Է°��� '�̸�','����'
    ���Ի��� �й��� �����Ͽ� �л� ���̺� INSERT �ϼ���
    - �й��� ���� �й��� ���ڸ��� 4�ڸ��� ���� �⵵��� + 1
    - �ƴ϶�� ���س⵵ + 000001
    
*/

--      1.���س⵵ ����
--      2.������ �й� ����
--      3.�����й� ����
--      �����
--      ������ �й� ��ȸ
--      ���ǽ� (���س⵵�� ��)
--      �л� ���̺� INSERT





DECLARE
    vn_year VARCHAR2(4) := TO_CHAR(SYSDATE,'YYYY');
    vn_make_no NUMBER :=0;
    vn_max_no VARCHAR2;
BEGIN
    -- ������ �й� ��ȸ
    SELECT MAX(�й�) 
        INTO vn_max_no
    FROM �л�;

    -- ���ǽ� (���� �⵵�� ��)
    IF SUBSTR(vn_max_no,1,4) = vn_year THEN
    vn_make_no := vn_max_no+1;
    ELSE
    vn_make_no := vn_year || '000001';
    END IF;
    
    INSERT INTO �л�(�й�, �̸�, ����)
    VALUES (vn_make_no, :�̸�, :����);
    commit;
END;

SELECT*
FROM �л�;


DECLARE
    dan NUMBER :=3;
    vn_i NUMBER :=1;
BEGIN

LOOP
    DBMS_OUTPUT.PUT_LINE(dan || '*' || vn_i || '=' ||(dan*vn_i));
    vn_i := vn_i +1;
    EXIT WHEN vn_i>9;   -- �ܼ� loop�� Ż������ �ʼ�!
    END LOOP;
END;
-- �ܼ� LOOP ������ 2~9�� ���


    
DECLARE
    dan NUMBER :=2;
    vn_i NUMBER;
    
BEGIN
    LOOP
    DBMS_OUTPUT.PUT_LINE('===============dan ||��');
    vn_i :=1;
            LOOP
            DBMS_OUTPUT.PUT_LINE(dan || '*' || vn_i || '=' ||(dan*vn_i));
                vn_i := vn_i+1;
                EXIT WHEN vn_i>9;
             END LOOP;
     dan := dan+1;
     EXIT WHEN dan>9;
    END LOOP;
END;

--while �� 
DECLARE 
    dan NUMBER:=2;
    su NUMBER :=1;
    
BEGIN

    WHILE su <=9
    LOOP
    DBMS_OUTPUT.PUT_LINE(dan*su);
    su:=su+1;
    
    END LOOP;
END;




--FOR
DECLARE 
    dan NUMBER :=3;
BEGIN
    --FOR i IN 1..9  i �� 1�� ���� ���� �Ұ�, ��������
    FOR i IN REVERSE 1..9      --9 ���� 1�� ����.
    LOOP
        CONTINUE WHEN i =5;
        DBMS_OUTPUT.PUT_LINE(dan*i);
    END LOOP;   
END;


CREATE OR REPLACE FUNCTION my_mod(num1 NUMBER, num2 NUMBER)
RETURN NUMBER
IS
    vn_remainder NUMBER :=0;
    vn_quotient NUMBER :=0;
BEGIN
vn_quotient := FLOOR (num1 / num2);
vn_remainder := num1 = (num2 * vn_quotient);
RETURN vn_remainder;
END;



-- �л��� �̸��� �Է¹޾� �̼������� �����ϴ� �Լ��� �ۼ��Ͻÿ� [�л��� �ִ� �̸����θ�.]
-- �Լ��� : fn_my_credits 
-- input : �̸�
-- output : ���� �հ�

SELECT * FROM �л�;
SELECT * FROM ����;
-- �л��� ���� ������ ��������
SELECT * FROM ���ǳ���;
SELECT * FROM ��������;


SELECT A.�̸� , B.�й� , B.����
FROM �л� A,(SELECT B.�й� �й�,SUM(A.����) ����
FROM ���� A , �������� B
WHERE A.�����ȣ = B.�����ȣ
GROUP BY B.�й�) B
WHERE A.�й� = B.�й�;


CREATE OR REPLACE FUNCTION fn_my_credit(namen VARCHAR2)
RETURN NUMBER

IS 
    v_credit NUMBER;
BEGIN

        SELECT ������
        INTO v_credit
        FROM(
        SELECT A.�̸� �̸��̿�, B.�й� , B.���� ������
        FROM �л� A,(SELECT B.�й� �й�,SUM(A.����) ����
        FROM ���� A , �������� B
        WHERE A.�����ȣ = B.�����ȣ
        GROUP BY B.�й�) B
        WHERE A.�й� = B.�й�)
        WHERE �̸��̿� = namen;
        DBMS_OUTPUT.PUT_LINE('�л��� ����' || v_credit);
        RETURN v_credit;
END;

SELECT fn_my_credit('�ּ���') FROM dual;



    SELECT ������
        FROM(
        SELECT A.�̸� �̸��̿�, B.�й� , B.���� ������
        FROM �л� A,(SELECT B.�й� �й�,SUM(A.����) ����
        FROM ���� A , �������� B
        WHERE A.�����ȣ = B.�����ȣ
        GROUP BY B.�й�) B
        WHERE A.�й� = B.�й�)
        WHERE �̸��̿� = '�ּ���';
    