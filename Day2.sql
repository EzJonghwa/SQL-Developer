CREATE TABLE ex2_1(
    col1 VARCHAR2(100)
    ,col2 NUMBER
    ,col3 DATE
);

--INSERT ������ ����
-- ���1. �⺻���� �÷��� �ۼ�
INSERT INTO ex2_1(col1,col2,col3)
VALUES ('nick',10,sysdate);
--���ڿ� Ÿ���� '' ���� Ÿ���� �׳� ���� ������ ���ڿ��ε� ���ڶ�� ����
INSERT INTO ex2_1(col1,col2,col3)
VALUES ('jack','10',sysdate);



--Ư�� �÷����� ������ ���� ������ �÷��� �����.
INSERT INTO ex2_1 (col1)
VALUES('judy');

-- ���2.���̺� �ִ� ��ü �÷��� ������ ���� �Ƚᵵ��
INSERT INTO ex2_1 VALUES ('���',10,sysdate);

--��� 3. SELECT -INSERT ��ȸ ����� ����
-- ���� ������ ������ Ÿ���� �¾ƾ��Ѵ�
INSERT INTO ex2_1(col1)
SELECT emp_name 
FROM employees;

SELECT *FROM ex2_1;
--UPDATE ������ ����
UPDATE ex2_1
SET col3 = sysdate; -- set���� �����ϰ����ϴ� ������
-- where ���� ������ ���̺� ��ü�� ������Ʈ��

UPDATE ex2_1
SET col2 =20
,col3=sysdate
WHERE col1 ='nick';
COMMIT; --�����̷� �ݿ�
ROLLBACK; -- �����̷� ���

-- DELETE ������ ����
DELETE ex2_1;   -- ���̺���ü �������
--delete �� update�� ���� �˻����� �߿���
DELETE ex2_1
WHERE col1 ='nick'; -- �ش� ������ �����ϴ� ���� ����.



DROP TABLE dep;
-- �����ϴ� ���̺��� �����ϱ� ������ ���� �� ������.
-- ���� ���ǵ� ���� �� ���̺� ����
DROP TABLE dep CASCADE CONSTRAINTS;

-- ��������� *+/-
-- ���ڿ����� (|| ���ڿ� ���� ����)
SELECT employee_id || '-' || emp_name as emp_info
FROM employees;
-- �� ������ :>,<,>=,<=,<>,!=.^=
SELECT * FROM employees WHERE salary = 2600;    -- ����
SELECT * FROM employees WHERE salary <> 2600;   -- �����ʴ�
SELECT * FROM employees WHERE salary != 2600;   -- �����ʴ�
SELECT * FROM employees WHERE salary ^= 2600;   -- �����ʴ�
SELECT * FROM employees WHERE salary > 2600;    -- �ʰ�
SELECT * FROM employees WHERE salary < 2600;    -- �̸�
SELECT * FROM employees WHERE salary <= 2600;   -- ����
SELECT * FROM employees WHERE salary >= 2600;   -- �̻�

-- ǥ���� CASE WHEN ����1 THEN ����1�� true �϶�
--            WHEN ����2 THEN ����2�� true �϶� 
--          ELSE �׹ۿ�
--      END ����
-- 5000���� C���, 5000 �ʰ� 15000 ���� B���, �׹ۿ��� A���
SELECT employee_id ,salary
    ,CASE WHEN salary <=5000 THEN 'C���'
        WHEN salary >5000 AND salary <=15000 THEN 'B���'
        ELSE 'A���'
    END as grade    -- ���÷��� �����ϰ� ��ġ�ϱ⿡ Ÿ���� ���ƾ���
FROM employees;

--customer ���̺���
-- ���� �̸��� ����⵵ ������ ����ϼ���(������ ǥ���� F :����/ M: ����)

SELECT CUST_NAME, CUST_YEAR_OF_BIRTH
    ,CASE WHEN CUST_GENDER ='M' THEN '����'
            WHEN CUST_GENDER ='F' THEN '����'
            END AS GENDER
FROM customers;
SELECT *
FROM CUSTOMERS;


-- 1. �ʿ��� �����͸� ���� ��ȸ�ϱ�
DESC CUSTOMERS;

SELECT CUST_NAME
, CUST_GENDER
, CASE WHEN CUST_GENDER ='F' THEN '����'
        WHEN CUST_GENDER ='M' THEN '����'
        END AS GENDER
, CUST_YEAR_OF_BIRTH
FROM CUSTOMERS
ORDER BY CUST_YEAR_OF_BIRTH DESC, CUST_NAME ASC;

-- �÷��� ���Ⱑ ������ �� ���̺� ������ ������ ��ȣ�� �Űܼ� ��� ����


--1990 �� ����̸� ���ڸ� ��ȸ�Ͻÿ�
SELECT CUST_NAME
, CUST_GENDER
, CASE WHEN CUST_GENDER ='F' THEN '����'
        WHEN CUST_GENDER ='M' THEN '����'
        END AS GENDER
, CUST_YEAR_OF_BIRTH
FROM CUSTOMERS
WHERE CUST_YEAR_OF_BIRTH =1990 AND CUST_GENDER ='M'

ORDER BY 4 DESC, 1 ASC;

-- ���� ����    'id:member''pw:member'
-- ���� �ο�   
-- �ش� ������ �����Ͽ� ->> MEMBER_TABLE(UTF-8).SQL ���� ���� (TABLE &DATA)
-- 







