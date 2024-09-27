/*
    TABLA ���̺�
    1.���̺� �� �÷����� �ִ� ���̴� 30BYTE (������1�� 1BYTE)
    2. ���̺�� �÷������� ������ ����� ������ (select, varchar2...
    3. ���̺�� �÷������� ����, ����, _,$,#, �� ���� �� ������ 
        ù���ڴ� ���ڸ� �� ������
    4. �� ���̺� ��� ������ �÷��� �ִ� 255��

*/
-- ��ɾ�� ��ҹ��� �������� ����.
-- �����ʹ� ��ҹ��ڱ�����

CREATE TABLE ex1_1(
    col1 CHAR(10)
    ,col2 VARCHAR2 (10)     -- �ϳ��� �÷��� �ϳ��� Ÿ�԰� ����� ����
);
-- ���̺� ����
DROP TABLE ex1_1; 
-- INSERT ������ ����

INSERT INTO ex1_1 (col1, col2)
VALUES ('oracle','����');
INSERT INTO ex1_1 (col1, col2)
VALUES ('oracle','����Ŭ');

-- why? VARCHAR2 (10)�� �����߱⿡ 
-- ����: ORA-12899: "JAVA"."EX1_1"."COL2" ���� ���� ���� �ʹ� ŭ(����: 11)�� �߻�
INSERT INTO ex1_1 (col1, col2)
VALUES ('oracle','����Ŭdb');
-- ���� �Ұ�

-- ������ ��ȸ
SELECT *    -- ��ü�� �ǹ���
FROM ex1_1;

SELECT col1 --���ϴ� �÷��� ��ȸ�ϰ��� �Ҷ�.
FROM ex1_1;

SELECT length(col1), length(col2)   -- �������� ���̸� ��Ÿ��
    , lengthb(col1), lengthb(col2)  -- �������� ����Ʈ ���� ��Ÿ�� �ѱ� (3byle)
FROM ex1_1;
    -- ���̺��� �״���̳� SELECT�δ� �����͸� ����ϴ°�
    -- �÷��� 4���� ������ ����!
    -- char (����):10 / varchar (����):10���� ���������� ���� ���� ���� ����.

-- ��ɾ�� ��ҹ��ڸ� �������� ����
-- ��ɾ ���� �����Ϸ��� ��ҹ��ڸ� ���
-- SQL���� ���� ���� ���⸦ �ؼ� �ۼ�

SELECT *
FROM employees; --from ���� ��ȸ�ϰ��� �ϴ� ���̺� �ۼ�
        --��� : employees ���̺��� ������ ���
        
DESC employees;    -- type �� ����� Ȯ�� ���� �۾��� Ȯ�� �ϴ� ���� ����.

SELECT emp_name    as nm       --AS ,as (alias ��Ī)
,hire_date        hd          -- �޸��� �������� �÷��� ���� ���� ���� 
                                -- ��Ī���� �ν�
,salary            sa_la       -- ��Ī���� ����� �ȵ�
,department_id     "�μ� ���̵�" -- �ѱ��� "" ������ �ѱ� ��Ī�� �Ⱦ�.
FROM employees;
-- �˻����� 

SELECT *
FROM employees
WHERE salary >= 20000;
-- ex) �Խ����� �˻� ������ ��Ÿ��
-- ������ ������ �� ��� AND or OR

SELECT *
FROM employees
WHERE salary >=1000     -- AND �� �׸��� �ǹ� (�Ѵ� ��)
AND salary <11000
AND department_id =80;

SELECT * 
FROM employees
WHERE department_id =30     --OR �� ������ �ǹ� ���� �ϳ��� ���ΰ�� ���
OR department_id =60;
--  ���� ����order by ASC:���� ���� DESC : ��������
SELECT emp_name, department_id
FROM employees
ORDER BY department_id, emp_name DESC;     -- default ASC(��������)


-- ��Ģ���� ��밡�� 
SELECT emp_name
    ,salary as ����
    ,salary - salary *0.1 as �Ǽ��ɾ�
    ,salary *12 as ����
    , ROUND(salary/30,2) as �ϴ�
FROM employees
ORDER BY ���� DESC;
-- ���� ���� FROM ->WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
-- ������ ���� �������� �������� �ƴ� ������ ������ ���� ������.
-- ���� �ȿ� ������ ���� ��� �ؼ��� ���� ���������� �ؼ��ؾ���.
    
/*
    �������� 
    NOT NULL ���� ������� �ʰڴ�.
    UNIQUE �ߺ��� ������� �ʰڴ�.
    CHECK Ư�� �����͸� �ްڴ�.
    PRIMARY KEY �⺻Ű (�ϳ��� ���̺� 1���� ��������(�ΰ��� �÷����ε� ����)
                        �ϳ��� ���� �����ϴ� �ĺ��� OR  Ű���̶�� �ϸ� PK�����
                        PK �� �⺻������ UNIQUE �ϸ� NOT NULL ��
    FOREIGN KEY �ܷ�Ű �ٸ� ���̺��� PK �� �����ϴ� Ű
*/

CREATE TABLE ex1_2(
      mem_id VARCHAR2(100) NOT NULL UNIQUE      
    , mem_nm VARCHAR2(100)  -- null ���
    , mem_email VARCHAR2(100) NOT NULL
    ,CONSTRAINT uq_ex1_2 UNIQUE(mem_email)  -- ���������� �̸��� �����ϰ� ������
            -- uq_ex_2 ��� �̸����� 
);


INSERT INTO ex1_2 (mem_id,mem_email)
VALUES ('a001','a001@gmail.com');   -- default�� null ����̱� ������ mem_nm ��� ��
INSERT INTO ex1_2 (mem_id,mem_email)
VALUES ('A001','A001@gmail.com');   -- �� �ҹ��ڸ� ������. 

SELECT *
FROM ex1_2;
-- ���̵� ���� �ϰų� �̸��ϸ� ���� �Ϸ��� �ϸ� �������߻�
INSERT INTO ex1_2(mem_id)
VALUES ('b001');

SELECT*
FROM user_constraints
WHERE table_name = 'EX1_2';
-- ���ο��� ����� ���� �빮�ڷ� �����

/* ���� ������ Ÿ��(number)
    number(p,s) p�� �Ҽ����� �������� ��� ��ȿ���� �ڸ����� �ǹ���.
    s �� �Ҽ��� �ڸ����� �ǹ��� (����Ʈ 0)
    s�� 2�̸� �Ҽ��� 2�ڸ����� (�������� �ݿø�)
    s�� �����̸� �Ҽ��� ���� ���� �ڸ��� ��ŭ �ݿø�
*/

CREATE TABLE ex1_3(
     num1 NUMBER(3)     -- ������ 3�ڸ�
    ,num2 NUMBER(3,2)  -- ����1 �Ҽ���2
    ,num3 NUMBER(5,-2) -- �����ڸ����� �� �ø� (�� 7�ڸ�)
    ,num4 NUMBER --38

);
                                    -- ������ 3�ڸ� = �ݿø��� NUMBER(3)
INSERT INTO ex1_3 (num1) VALUES (0.7878);
INSERT INTO ex1_3 (num1) VALUES (99.5); -- 
INSERT INTO ex1_3 (num1) VALUES (1004); --������ -�ڸ��� ����

SELECT * FROM ex1_3;

                                     -- ����1 �Ҽ���2 NUMBER(3,2)
INSERT INTO ex1_3 (num2) VALUES (0.7878);
INSERT INTO ex1_3 (num2) VALUES (1.7898); 
INSERT INTO ex1_3 (num2) VALUES (9.9999);   -- ���� �ݿø��� ���� ���ڸ�
INSERT INTO ex1_3 (num2) VALUES (32);       -- ���� ���ڸ�

SELECT * FROM ex1_3;

                     -- �����ڸ����� �� �ø� (�� 7�ڸ�)num3 NUMBER(5,-2)
INSERT INTO ex1_3 (num3) VALUES (12345.2345);
INSERT INTO ex1_3 (num3) VALUES (1234569.2345); 
INSERT INTO ex1_3 (num3) VALUES (12345699.2345);   -- ���� 7�ڸ� ����

SELECT * FROM ex1_3;


                    -- �ڸ��� ������ ���� ������ �⺻ 38 �ڸ����� ������.
INSERT INTO ex1_3 (num4) VALUES (14123493.34892340);
SELECT * FROM ex1_3;

/*
    ��¥ ������ Ÿ��(date ����Ͻú��� ,timestamp (����ú�����.�и���)
    sysdate <-����ð�, systimestamp <-���� �и��ʱ���
*/

CREATE TABLE ex1_4(
    date1 DATE
    ,date2 TIMESTAMP

);
INSERT INTO ex1_4 VALUES (SYSDATE, SYSTIMESTAMP);
SELECT * FROM ex1_4;



/* CHECK �������� */

CREATE TABLE ex1_5(
    nm VARCHAR2(100)
    ,age NUMBER
    ,gender VARCHAR2(1)
    ,CONSTRAINT ck_ex1_5_age CHECK (age BETWEEN 1 AND 150)
    ,CONSTRAINT ck_ex1_5_gender CHECK (gender IN ('F','M'))
);
INSERT INTO ex1_5 VALUES('���',10,'M');
SELECT * FROM ex1_5;
INSERT INTO ex1_5 VALUES ('�浿',100,'F');
SELECT * FROM ex1_5;

CREATE TABLE dep(
    deptno NUMBER(3) PRIMARY KEY    --�⺻Ű
    ,dept_nm VARCHAR2(20)
    ,dep_floor NUMBER(5)
);
CREATE TABLE emp (
    empno NUMBER(5) PRIMARY KEY
    ,emp_nm VARCHAR2(20)
    ,title VARCHAR2(20)             -- �ش����̺��� �÷��� �����ϰڴ�.
    ,dno NUMBER(3) CONSTRAINT emp_fk REFERENCES dep(deptno)     
    -- �ܷ�Ű dep(deptno) �� �����Ѵ�
);

INSERT INTO dep VALUES (1,'����',8);
INSERT INTO dep VALUES (2,'��ȹ',9);
INSERT INTO dep VALUES (3,'����',10);

INSERT INTO emp VALUES (100,'���','�븮',2);
INSERT INTO emp VALUES (200,'�浿','����',3);
INSERT INTO emp VALUES (300,'����','����',1);
INSERT INTO emp VALUES (300,'������','�̻�',4);  -- �����ϴ� ���� �����Ͱ� ��� ���Ἲ�� �����

SELECT * FROM dep;
SELECT * FROM emp;

SELECT *
FROM emp, dep
WHERE emp.dno = dep.deptno  -- ���踦 �δ� ���(����)
AND emp.emp_nm ='���';






