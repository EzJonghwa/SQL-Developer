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
    EXCEPTION 
    WHEN ZERO_DIVIDE THEN
    DBMS_OUTPUT.PUT_LINE(SQLCODE);
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('����ó��');
END;
BEGIN
    exception_proc;  -- �ش� ���ν������� ������ �Ͼ�� ���� ó���� �߱� ������ �����ܰ�� �Ѿ
    DBMS_OUTPUT.PUT_LINE('����');
END;


/*
-------------------------------------------------------------------------------------------------------------------------------------
 1.����� ���� ����
-------------------------------------------------------------------------------------------------------------------------------------
   �ý��� ���� �̿ܿ� ����ڰ� ���� ���ܸ� ���� 
   �����ڰ� ���� ���ܸ� �����ϴ� ���.
-------------------------------------------------------------------------------------------------------------------------------------
[1] ����� ���� ���ǹ�� 
 (1) ���� ���� : �����_����_���ܸ� EXCEPTION;
 (2) ���ܹ߻���Ű�� : RAISE �����_����_���ܸ�;
                    �ý��� ���ܴ� �ش� ���ܰ� �ڵ����� ���� ������, ����� ���� ���ܴ� ���� ���ܸ� �߻����Ѿ� �Ѵ�.
                  RAISE ���ܸ� ���·� ����Ѵ�.
 (3) �߻��� ���� ó�� : EXCEPTION WHEN �����_����_���ܸ� THEN ..
*/
    CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                      p_emp_name       employees.emp_name%TYPE,
                      p_department_id  departments.department_id%TYPE )
    IS
       vn_employee_id  employees.employee_id%TYPE;
       vd_curr_date    DATE := SYSDATE;
       vn_cnt          NUMBER := 0;
       ex_invalid_depid EXCEPTION; -- (1) �߸��� �μ���ȣ�� ��� ���� ����
    BEGIN
	     -- �μ����̺��� �ش� �μ���ȣ �������� üũ
	     SELECT COUNT(*)
	       INTO vn_cnt
	       FROM departments
	      WHERE department_id = p_department_id;
	     IF vn_cnt = 0 THEN
	        RAISE ex_invalid_depid; -- (2) ����� ���� ���� �߻�
	     END IF;
	     -- employee_id�� max ���� +1
	     SELECT MAX(employee_id) + 1
	       INTO vn_employee_id
	       FROM employees; 
	     -- ����ڿ���ó�� �����̹Ƿ� ��� ���̺� �ּ��� �����͸� �Է���
	     INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
                  VALUES ( vn_employee_id, p_emp_name, vd_curr_date, p_department_id );
       COMMIT;        
          
    EXCEPTION WHEN ex_invalid_depid THEN --(3) ����� ���� ���� ó������ 
                   DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �����ϴ�');
              WHEN OTHERS THEN
                   DBMS_OUTPUT.PUT_LINE(SQLERRM);              
    END;                	

EXEC ch10_ins_emp_proc ('ȫ�浿', 999);





/*
--[2]�ý��� ���ܿ� �̸� �ο��ϱ�----------------------------------------------------------------------------------------------
 �ý��� ���ܿ��� ZERO_DIVIDE, INVALID_NUMBER .... �Ͱ��� ���ǵ� ���ܰ� �ִ� ������ �̵�ó�� ���ܸ��� �ο��� ���� 
 �ý��� ���� �� �ؼҼ��̰� �������� �����ڵ常 �����Ѵ�. �̸��� ���� �ڵ忡 �̸� �ο��ϱ�.

	1.����� ���� ���� ���� 
	2.����� ���� ���ܸ�� �ý��� ���� �ڵ� ���� (PRAGMA EXCEPTION_INIT(����� ���� ���ܸ�, �ý���_����_�ڵ�)

		/*
		   PRAGMA �����Ϸ��� ����Ǳ� ���� ó���ϴ� ��ó���� ���� 
		   PRAGMA EXCEPTION_INIT(���ܸ�, ���ܹ�ȣ)
		   ����� ���� ���� ó���� �� �� ���Ǵ°����� 
		   Ư�� ���ܹ�ȣ�� ����ؼ� �����Ϸ��� �� ���ܸ� ����Ѵٴ� ���� �˸��� ���� 
		   (�ش� ���ܹ�ȣ�� �ش�Ǵ� �ý��� ������ �߻�)
           3.�߻��� ���� ó��:EXCEPTION WHEN ����� ���� ���ܸ� THEN ....
		*/
	

CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE,
                  p_hire_month  VARCHAR2  )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   ex_invalid_depid EXCEPTION; -- �߸��� �μ���ȣ�� ��� ���� ����
   ex_invalid_month EXCEPTION; -- �߸��� �Ի���� ��� ���� ����
   PRAGMA EXCEPTION_INIT (ex_invalid_month, -1843); -- ���ܸ�� �����ڵ� ����
BEGIN
	 -- �μ����̺��� �ش� �μ���ȣ �������� üũ
	 SELECT COUNT(*)
	   INTO vn_cnt
	   FROM departments
	 WHERE department_id = p_department_id;
	 IF vn_cnt = 0 THEN
	    RAISE ex_invalid_depid; -- ����� ���� ���� �߻�
	 END IF;
	 -- �Ի�� üũ (1~12�� ������ ������� üũ)
	 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
	    RAISE ex_invalid_month; -- ����� ���� ���� �߻�
	 END IF;
	 -- employee_id�� max ���� +1
	 SELECT MAX(employee_id) + 1
	   INTO vn_employee_id
	   FROM employees;
	 -- ����ڿ���ó�� �����̹Ƿ� ��� ���̺� �ּ��� �����͸� �Է���
	 INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
              VALUES ( vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
   COMMIT;              
EXCEPTION WHEN ex_invalid_depid THEN -- ����� ���� ���� ó��
               DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �����ϴ�');
          WHEN ex_invalid_month THEN -- �Ի�� ����� ���� ����
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               DBMS_OUTPUT.PUT_LINE('1~12�� ������ ��� ���Դϴ�');               
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);              	
END;    
EXEC ch10_ins_emp_proc ('ȫ�浿', 110, '201314');
/*
 [3].����� ���ܸ� �ý��� ���ܿ� ���ǵ� ���ܸ��� ���----------------------------------------------------------------------------------------------
      RAISE ����� ���� ���� �߻��� 
      ����Ŭ���� ���� �Ǿ� �ִ� ���ܸ� �߻� ��ų�� �ִ�. 
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE INVALID_NUMBER;
  END IF;
  DBMS_OUTPUT.PUT_LINE(p_num);
EXCEPTION WHEN INVALID_NUMBER THEN
               DBMS_OUTPUT.PUT_LINE('����� �Է¹��� �� �ֽ��ϴ�');
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
EXEC ch10_raise_test_proc (-10);   

/*
[4].���ܸ� �߻���ų �� �ִ� ���� ���ν��� ----------------------------------------------------------------------------------------------
  RAISE_APPLICATOIN_ERROR(�����ڵ�, ���� �޼���);
  ���� �ڵ�� �޼����� ����ڰ� ���� ����  -20000 ~ -20999 ������ �� ��밡�� 
   �ֳĸ� ����Ŭ���� �̹� ����ϰ� �ִ� ���ܵ��� �� ��ȣ ������ ������� �ʰ� �ֱ� ������)
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE_APPLICATION_ERROR (-20000, '����� �Է¹��� �� �ִ� ���Դϴ�!');
	END IF;  
  DBMS_OUTPUT.PUT_LINE(p_num);
EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
EXEC ch10_raise_test_proc (-10);               




/*
    Ʈ�� ��� TRANSECTION
    ���࿡�� �Աݰ� ����� �ϴ� '�ŷ�'�� ���ϴ� �ܾ��
    �ŷ��� �������� Ȯ���ϱ� ���� ����� Ʈ����� ó��
    ORACLE ��COMMIT �� ROLLBACK �� ����Ͽ�
    Ư�� Ʈ����� ������ ó���� ��� ����ó�� �Ǿ�� COMMIT �ǵ��� 
    ���ꤷó������ ������ ROLLBACK �Ͽ� �������� Ȯ����.
    SAVEPOINT �� ��ü ��Ұ� �ƴ� Ư�� �κп��� 
    Ʈ������� ����� ���ִ�.

*/
CREATE TABLE ex10(
    ex_no NUMBER
    ,ex_nm VARCHAR2(50)
    );
CREATE OR REPLACE PROCEDURE save_test_proc(flag VARCHAR2)
IS
    point1 EXCEPTION;
    point2 EXCEPTION;
    vn_num NUMBER;
BEGIN
    INSERT INTO ex10 VALUES(1,'POINT1 BEFORE');
    SAVEPOINT mysavepoint1;
    INSERT INTO ex10 VALUES(2,'POINT2');
    SAVEPOINT mysavepoint2;
    INSERT INTO ex10 VALUES(2,'POINT2 AFTER');
    -- INSERT �� �Ͼ SAVEPOINT �� 
    
    IF flag ='1' THEN
        RAISE point1;
    ELSIF flag = '2' THEN
        RAISE point2;
    ELSIF flag ='3' THEN
        vn_num :=10/0;
    END IF;
    COMMIT;
    -- TEST �� ���� IF ��
    
EXCEPTION WHEN point1 THEN
        DBMS_OUTPUT.PUT_LINE('point1');
        ROLLBACK TO mysavepoint1;
        -- �ϴ� INSERT �� 3���� �Ͼ ��Ȳ������ SAVEPOINT �� ���ư���
        -- POINT1�� INSERT�� ��
    COMMIT;
    WHEN point2 THEN
        DBMS_OUTPUT.PUT_LINE('point2');
        ROLLBACK TO mysavepoint2;
    COMMIT;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('others');
        ROLLBACK;
END;


EXEC save_test_proc('2');
SELECT *
FROM ex10;

DELETE ex10;



/*
  Ʈ���� Trigger 
  ������ �ǹ̷� ���� ��Ƽ踦 ���Ѵ�. 
  ��Ƽ谡 ������� -> �߻�Ǵ� ����

  � ���̺� Ư���� �̺�Ʈ�� �߻� �Ǿ����� _ Trigger �� ����
  INSERT, UPDATE, DELETE �� DML�� �Ǵ� DDL ���� ���� �Ǿ����� 
  �����ͺ��̽����� Ư�� �̺�Ʈ�� �߻��Ǿ��� ��� �ϴµ� 
  �̷� �̺�Ʈ�� �߻��ϸ� �ڵ����� ������ ������ �����ϴ� �����ͺ��̽� ��ü

  * Ʈ������ ������

   1.���̺� ���� �������� ���� ���Ἲ�� ������ ���Ἲ ���� ������ ���� ������ �����ϴ� ���
   2.�����ͺ��̽� ���̺��� �����Ϳ� ����� �۾��� ����, ����
   3.�����ͺ��̽� ���̺� ����� ��ȭ�� ���� �ʿ��� �ٸ� ���α׷��� �����ϴ� ���
   4.���ʿ��� Ʈ������� �����ϱ� ���� 
   5.�÷��� ���� �ڵ����� �����ǵ��� �ϴ� ���
   6.������ �並 �����ϴ� ��� 

   [�⺻����]

   CREATE TRIGGER Ʈ���Ÿ�

   BEFORE | AFTER          INSERT | DELETE | UPDATE (OF �÷�...N)
   OF �÷��� ON ���̺�� 
   FOR EACH ROW
   BEGIN 
    Ʈ���ų���
   END;

    SQL�� ����ñ⿡ ���� �з�


 ����� ������ �޴� ���� ���� �з�

   * BEFORE OR AFTER  = ���� ������ ���� Ʈ����� �߻� ��, �Ǵ� Ʈ����� ���� Ʈ���� �۵�.
       before Ʈ���� : INSERT,UPDATE,DELETE �����ϱ� ���� Ʈ���� ���� ���� ��
       after Ʈ����  : INSERT,UPDATE,DELETE �����ϰ� �� �� Ʈ���� ���� ��


   * INSERT | UPDATE | DELETE  = �̺�Ʈ ������ ���� INSERT OR UPDATE ó�� ������ �̺�Ʈ�� ������ �� �ִ�. 

   * (OF �÷�..N) ON ���̺�� = Ʈ���Ű� �ָ��ϴ� ��� ���̺��� �����ϰ� Ư�� �÷��� �̺�Ʈ�� Ʈ���Ű� �����Ϸ��� �÷����� ������ش�. 
      OF �̸� ON �л�
   * FOR EACH ROW   = �� Ʈ���Ÿ� ������ �������� �߰��Ǵ� ���� ����ŭ Ʈ���Ű� �����Ͽ� �� ������ �̺�Ʈ�� �߻��Ǵ°� �������� Ʈ������ ����, ���� ������ ���صδ� ����.
    
     FOR EACH ROW �� ���� row(��) Ʈ���Ÿ� �����ϰ� WHEN ������ �ָ� WHEN ���ǿ� �����ϴ� ROW(��)�� Ʈ���� ���� ����.
     ��,FOR EACH ROW�� �Ⱦ��� statement(����) Ʈ���� ����.

     - row Ʈ���� (�� Ʈ����) : ����� Ʈ���Ű� row(��) �ϳ��ϳ� ���� ���� ��
     - statement Ʈ����(���� Ʈ����)
       ����� Ʈ���Ű� INSERT,UPDATE,DELETE ���忡 1���� ���� ��

   * : OLD & : NEW  = ��Ʈ���ſ��� �÷��� ���� ������ ���� �����ϴµ� ���Ǵ� ������  

      INSERT ���� ��쿡 : NEW,
      UPDATE ���� ��� ���� �� �÷� �����Ͱ��� :OLD, ������ ���ο� ������ ���� : NEW�� ��Ÿ���� 
      DELETE ���� ��� �����Ǵ� �÷����� : OLD �÷��� ����ȴ�.

      :OLD = ���� �� ���� �� (INSERT : �Է� �� �ڷ�, UPDATE : ���� �� �ڷ�, DELETE : ������ �ڷ�)
      :NEW = ���� �� ���� �� (INSERT : �Է� �� �ڷ�, UPDATE : ������ �ڷ�)

   * BEGIN ~ END = Ʈ���Ű� ������ �� ����Ǵ� ������ �����Ѵ�. 


  * Ʈ����(TRIGGER)  ������ �������

	1. Ʈ���Ŵ� �� ���̺� �ִ� 3������ �����ϴ�
	2. Ʈ���� �������� COMMIT,ROLLBACK ���� ����� �� ����.
	3. �̹� Ʈ���Ű� ���ǵ� �۾��� ���� �ٸ� Ʈ���Ÿ� �����ϸ� ������ ���� ��ü�Ѵ�.
	4. �䳪 �ӽ� ���̺��� ������ �� ������ ���� �� ���� ����.
	5. Ʈ���� ������ �̸� �����ϱ� ������ ��ӵȴ�.
*/

CREATE TABLE EX11_1 AS
SELECT EMPLOYEE_ID
     , EMP_NAME
     , SALARY
FROM EMPLOYEES;


   CREATE OR REPLACE TRIGGER test1_trig
   BEFORE UPDATE
   ON EX11_1
   BEGIN
	DBMS_OUTPUT.PUT_LINE('��û�Ͻ� �۾��� ó�� �Ǿ����ϴ�.');
   END;

SELECT *
FROM EX11_1;


UPDATE EX11_1
SET salary =1000
WHERE employee_id =198;

SELECT*
FROM TB_INFO;

CREATE TRIGGER info_trigger2
BEFORE UPDATE OF EMAIL ON tb_info
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE(:OLD.EMAIL);
    DBMS_OUTPUT.PUT_LINE(:NEW.EMAIL);
    RAISE_APPLICATION_ERROR(-20001,'����������!');
END;

UPDATE tb_info
SET ENAIL ='JDJDJDJ@NABER.COM'
WHERE info_no =1;


-- Ʈ���� ���� �⺻����
/*
DROP TRIGGER Ʈ���Ÿ� 

ALTER TRIGGER Ʈ���Ÿ� [ENABLE / DISABLE]
ENABLE  : ���
DISABLE : ������� ����

INVALID : ��������
VALID   : ��밡��
*/
-- Ʈ���Ŵ� �׻� �����ͺ��̽��� �����ϱ� ������ �ý��� �ڿ��� ���� �Ҹ��Ѵ�. �׷��� �� �ʿ��� ��Ȳ���� ����ϱ⸦ ����

-- Ʈ���� ��������

SELECT A.OWNER 
     , A.TRIGGER_NAME
     , A.STATUS
     , B.STATUS
FROM ALL_TRIGGERS A
   , ALL_OBJECTS B
WHERE A.TRIGGER_NAME = B.OBJECT_NAME
AND A.OWNER = 'JAVA';


--ALL_TRIGGERS, ALL_OBJECTS ���̺��� ����Ŭ�� Ʈ���� ���� ������ OBJECT �� ���� ������ ������ �ִ� 
--����Ŭ�� ��ųʸ� ���̺�.

CREATE OR REPLACE TRIGGER test2_trig
 BEFORE UPDATE
 OF SALARY ON EX11_1  -- �÷��� üũ
BEGIN
 DBMS_OUTPUT.PUT_LINE('��û�Ͻ� �۾��� ó�� �Ǿ����ϴ�.');
END;
------------------------------------------------------------------
-- ������Ʈ�� ���� Ʈ���� Ȯ�� 
UPDATE EX11_1
SET SALARY_IMSI  = 100
WHERE EMPLOYEE_ID =199;

SELECT *
FROM test2_trig;


-- �÷� ������ �Ͽ� Ʈ���ſ� ������ ���⵵��.
ALTER TABLE EX11_1 RENAME COLUMN SALARY TO SALARY_IMSI;

UPDATE EX11_1
SET SALARY_IMSI  = 100
WHERE EMPLOYEE_ID =199;

-- Ʈ���Ű� ������ �ʵ���
ALTER TRIGGER TEST2_TRIG DISABLE;

-- �ٽ� �÷��� ����
ALTER TABLE EX11_1 RENAME COLUMN SALARY_IMSI TO  SALARY;

-- Ʈ���� ������� ����
ALTER TRIGGER TEST2_TRIG ENABLE;

-- INVALID �� Ʈ���Ŵ� �ٽ� ������ ���༭ -> VALID �� ����� �� �ֵ��� �ؾ� �۵���.



CREATE TABLE ex15_tb(
     id VARCHAR2(20)
    ,name  VARCHAR2(20)
);
CREATE TABLE ex15_check(
     memo VARCHAR2(20)
    ,createDt DATE DEFAULT SYSDATE
);
-- statement  trigger
 
-- Ʈ���Ÿ� ���� ���̺� �ڷḦ �Է�,����,���� �� �� �α�(�޸�) ���̺� �Է�,����,������ ������ ����ϰ��ϴ� Ʈ����--
DROP TRIGGER after_statement_trigger; -- �̹� ���� ��� �����ϰ� ����
 
CREATE OR REPLACE TRIGGER after_statement_trigger
   AFTER DELETE OR INSERT OR UPDATE ON ex15_tb
BEGIN
  -- ������ ��
   IF INSERTING THEN -- �� Ʈ���Ÿ� ���� ex15_tb�� insert ������ ����Ǹ� �ؿ���(ex15_check�� insert)�� ����
     INSERT INTO ex15_check(memo) VALUES ('insert');
  -- ������ ��
   ELSIF UPDATING THEN -- �� Ʈ���Ÿ� ���� ex15_tb�� update ������ ����Ǹ� �ؿ���(ex15_check�� update)�� ����
     INSERT INTO ex15_check(memo) VALUES ('update');
  -- ������ ��
   ELSIF DELETING THEN -- �� Ʈ���Ÿ� ���� ex15_tb�� delete ������ ����Ǹ� �ؿ���(ex15_check�� delete)�� ����
     INSERT INTO ex15_check(memo) VALUES ('delete');
   END IF;
END;

/
--INSERTING : �� Ʈ���Ÿ� ���� ���̺��� ������ INSERT�϶� TRUE �׷��� ������ FALSE
--UPDATING  : �� Ʈ���Ÿ� ���� ���̺��� ������ UPDATE�϶� TRUE �׷��� ������ FALSE
--DELETING  : �� Ʈ���Ÿ� ���� ���̺��� ������ DELETE�϶� TRUE �׷��� ������ FALSE
 
-- Ʈ���� ���� --
INSERT INTO ex15_tb(id, name) VALUES (1, 'aaaa');
INSERT INTO ex15_tb(id, name) VALUES (2, 'bbbb');
COMMIT;

SELECT * FROM ex15_tb;
SELECT * FROM ex15_check;



---------------------------------------------------------------------------------------------
    
    
    CREATE TABLE ��ǰ (
       ��ǰ�ڵ� VARCHAR2(10) CONSTRAINT ��ǰ_PK PRIMARY KEY 
      ,��ǰ��   VARCHAR2(100) NOT NULL
      ,������  VARCHAR2(100)
      ,�Һ��ڰ��� NUMBER
      ,������ NUMBER DEFAULT 0
    );
    
    CREATE TABLE �԰� (
       �԰��ȣ NUMBER CONSTRAINT �԰�_PK PRIMARY KEY
      ,��ǰ�ڵ� VARCHAR(10) CONSTRAINT �԰�_FK REFERENCES ��ǰ(��ǰ�ڵ�)
      ,�԰����� DATE DEFAULT SYSDATE
      ,�԰���� NUMBER
      ,�԰�ܰ� NUMBER
      ,�԰�ݾ� NUMBER
    );
    
    INSERT INTO ��ǰ (��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES ('a001','���콺','�Ｚ','1000');
    INSERT INTO ��ǰ (��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES ('a002','���콺','NKEY','2000');
    INSERT INTO ��ǰ (��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES ('b001','Ű����','LG','2000');
    INSERT INTO ��ǰ (��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES ('c001','�����','�Ｚ','1000');
    
    
    SELECT *
    FROM ��ǰ;
    
    
    SELECT *
    FROM �԰�;

----------------- ������ ���� Ʈ���Ÿ� �����Ͻÿ� 

-- �԰����̺� INSERT Ʈ���� 

CREATE OR REPLACE TRIGGER warehousing_insert
AFTER INSERT ON �԰�

FOR EACH ROW -- TRIGGER OLD NEW ����� ���� ����

DECLARE
    vn_cnt ��ǰ.������%TYPE;
    vn_nm ��ǰ.��ǰ��%type;
BEGIN
    SELECT ������, ��ǰ��
    INTO vn_cnt, vn_nm
    FROM ��ǰ
    WHERE ��ǰ�ڵ� =:NEW.��ǰ�ڵ�;
    
    UPDATE ��ǰ
    SET ������ =:NEW.�԰���� + ������
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    DBMS_OUTPUT.PUT_LINE(vn_nm || '��ǰ�� ���� ������ ���� �Ǿ����ϴ�.');
    DBMS_OUTPUT.PUT_LINE('�԰��� ������:'||vn_cnt);
    DBMS_OUTPUT.PUT_LINE('�԰����:'||:NEW.�԰����);
    DBMS_OUTPUT.PUT_LINE('�԰��� ������:'||(vn_cnt+ :NEW.�԰����));
END;

INSERT INTO �԰�(�԰��ȣ,��ǰ�ڵ�,�԰����,�԰�ܰ�,�԰�ݾ�)
VALUES(1,'a002',100,1000,100000);
INSERT INTO �԰�(�԰��ȣ,��ǰ�ڵ�,�԰����,�԰�ܰ�,�԰�ݾ�)
VALUES(2,'a002',100,1000,100000);

SELECT*
FROM ��ǰ;

CREATE OR REPLACE TRIGGER warehousing_delete
AFTER DELETE ON �԰�
FOR EACH ROW
BEGIN 
    UPDATE ��ǰ
    SET ������ = ������ -:OLD.�԰����
    WHERE ��ǰ�ڵ� =:OLD.��ǰ�ڵ�;
END;
DELETE �԰�
WHERE �԰��ȣ = 2;

SELECT *
FROM ��ǰ;

-- �԰� ���̺� ���� Ʈ���� (warehousing_update)
-- �԰� ���̺� ��ǰ�� �԰� ������ ���� �Ǿ����� ��ǰ ���̺��� ��� ���� ����
CREATE OR REPLACE TRIGGER warehousing_update
AFTER UPDATE ON �԰�
FOR EACH ROW
DECLARE
    vn_cnt ��ǰ.������%TYPE;
    vn_nm ��ǰ.��ǰ��%type;
BEGIN
    SELECT ������, ��ǰ��
    INTO vn_cnt, vn_nm
    FROM ��ǰ
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    
    UPDATE ��ǰ
    SET ������ = ������ - :OLD.�԰���� + :NEW.�԰������
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    
    DBMS_OUTPUT.PUT_LINE(vn_nm || ' ��ǰ�� ���� ������ ����Ǿ����ϴ�.');
    DBMS_OUTPUT.PUT_LINE('���� �� ������: ' || vn_cnt);
    DBMS_OUTPUT.PUT_LINE('���� �԰� ����: ' || :OLD.�԰���� || ' -> ' || :NEW.�԰����);
    DBMS_OUTPUT.PUT_LINE('���� �� ������: ' || (vn_cnt + (:NEW.�԰���� - :OLD.�԰����)));
END;

UPDATE �԰�
SET �԰���� =50
WHERE �԰��ȣ =1;

SELECT *
FROM �԰�;

-- �Է�Ʈ���� (�԰����̺� ��ǰ�� �ԷµǾ��� �� ������ ����) EX (warehousing_insert)
�� ) �԰����̺� Ű���尡 10 �� �԰�Ǿ����� �ڵ����� ��ǰ���̺��� 'A002' ��ǰ�� ��� 0 -> 10 ���� ����

-- ���� Ʈ����(�԰����̺� ��ǰ�� �԰������ ����Ǿ����� ��ǰ���̺��� ������ ����) (warehousing_update)
-- ���� Ʈ����(�԰����̺� Ư�� ������ ������ ��ǰ ���� ���� ����) (warehousing_delete)
------------------------------------------------------------------------------







