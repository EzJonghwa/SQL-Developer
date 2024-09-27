-- DECODE ǥ����


SELECT cust_name
        ,cust_gender
        --      (��� �÷� , ����1, true �϶�)
        ,DECODE (cust_gender, 'M' , '����') as gender
        --      (��� �÷� , ����1, true �϶�/ �׹ۿ�else)
        ,DECODE (cust_gender, 'M' , '����','����') as gender
        --      (��� �÷� , ����1, true �϶�/ ���� 2�� true �϶�)
        ,DECODE (cust_gender, 'M' , '����','F','����') as gender
        --      (��� �÷� , ����1, true �϶�/ ���� 2�� true �϶�/ �׹ۿ� else)
        ,DECODE (cust_gender, 'M' , '����','F','����','?') as gender
FROM customers;

SELECT mem_name ,mem_regno2
,DECODE (substr(mem_regno2,1,1),'1','����','����') as gender 


FROM member;

/* ��ȯ �Լ� (Ÿ��) Ÿ�Ժ�ȯ ������.***
    to_char     ����������
    to_date     ��¥������
    to_number   ����������
*/

SELECT TO_CHAR(123456,'999,999,999') AS ex1
,TO_CHAR (SYSDATE, 'YYYY-MM-DD') AS ex2
,TO_CHAR (SYSDATE, 'YYYYMMDD') AS ex3
,TO_CHAR (SYSDATE, 'YYYY/MM/DD HH24:MI:SS') AS ex4
,TO_CHAR (SYSDATE, 'YYYY/MM/DD HH12:MI:SS') AS ex5
,TO_CHAR (SYSDATE, 'day') AS ex6
,TO_CHAR (SYSDATE, 'YYYY') AS ex7
,TO_CHAR (SYSDATE, 'YY') AS ex6
,TO_CHAR (SYSDATE, 'dd') AS ex6
,TO_CHAR (SYSDATE, 'd') AS ex6
FROM dual;

--TO_DATE
SELECT TO_DATE('231229','YYMMDD') AS ex1
,TO_DATE('2024 08 02 09:10:00','YYYY MM DD HH24:MI:SS') AS ex2
,TO_DATE('24','YY') AS ex3
,TO_DATE('45','YY') AS ex4
-- RR�� ���⸦ �ڵ����� ���� 50 -> 1950, 49->2049
-- y2k  2000�� ������ ���� ����å���� ����.
,TO_DATE('50','RR') AS ex5
FROM dual;

CREATE TABLE ex4_1(
    title VARCHAR2(100)
    ,D_DAY DATE
);
INSERT INTO ex4_1 VALUES ('������','20240802');
INSERT INTO ex4_1 VALUES ('������','2025.01.17');

INSERT INTO ex4_1 VALUES('ź�ұ���','2024 09 04');
INSERT INTO ex4_1 VALUES('ȸ��','2024 09 06 18:05:00');-- ������

INSERT INTO ex4_1 VALUES('ȸ��',TO_DATE('2024 09 06 18:05:00','YYYY MM DD HH24:MI:SS'));
SELECT* FROM ex4_1;

CREATE TABLE ex4_2(
seq1 VARCHAR2(100)
,seq2 NUMBER

);

INSERT INTO ex4_2 VALUES('1234','1234');
INSERT INTO ex4_2 VALUES('99','99');
INSERT INTO ex4_2 VALUES('195','195');
SELECT *
FROM ex4_2
ORDER BY TO_NUMBER(seq1) DESC;
-- ���������̱� ������ ù ������ ���� �������� �ϱ� ������ �������� ���������� ���ϴ� ���� �ȳ��� �� ����
-- to number �� �̿��ؼ� ����ȭ �ؾ���


--member ȸ���� ��������� �̿��Ͽ� ���̸� �»��Ͻÿ�
--���س⵵ �� �̿��Ͽ� (ex 2024 -2000 ->24��)
--������ ���� ��������
SELECT mem_name ,mem_bir,
TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(MEM_BIR,'YYYY')||'��' AS ����
FROM member
ORDER BY ���� DESC;

/* ���� �Լ�(�Ű����� ������)
ABS:���밪, ROUND :�ݿø� ,TRUNC:����, CEIL :�ø� ,MOD:��������, SQRT:������
*/

SELECT ABS(-10) AS ex1
        , ABS(10)AS ex2
        ,ROUND(10.5555,1) AS ex3
        ,ROUND(10.5555)   AS ex4
        ,TRUNC(10.5555,1)   AS ex5
        ,CEIL(10.5555)   AS ex6
        ,MOD(4,2)   AS ex7
        ,MOD(5,2)   AS ex8
FROM dual;

/*��¥ �Լ�*/
-- ADD_MONHTS(��¥ ������,1)     ������
-- LAST_DAY     ������ ��, NEXT_DAY     �������� ����
SELECT ADD_MONTHS(SYSDATE,1) AS ex1
        ,ADD_MONTHS(SYSDATE,-2) AS ex2
        ,LAST_DAY(SYSDATE)      AS ex3
        ,NEXT_DAY(SYSDATE ,'ȭ����') AS ex4
        ,NEXT_DAY(SYSDATE ,'������') AS ex4
FROM dual;

SELECT SYSDATE -1 as ex1    --����
        , ADD_MONTHS(SYSDATE,1)-ADD_MONTHS(SYSDATE,-1) as ex2
        --sysdate �� �̿��߱⿡ �Ѵ� �ð��� ���� �׷��� ���ڷ� ��Ȯ�� ��µ�
FROM dual;

SELECT mem_name, mem_bir
        ,sysdate -mem_bir
        ,TO_CHAR(sysdate,'YYYYMMDD')- TO_CHAR(mem_bir,'YYYYMMDD') as ex1
        ,TO_DATE(TO_CHAR(sysdate,'YYYYMMDD'))- TO_DATE(TO_CHAR(mem_bir,'YYYYMMDD')) as ex2 -- ��¥���
FROM member;

-- �̹����� ���� ���������?
SELECT TO_CHAR(LAST_DAY(SYSDATE),'DD')- TO_CHAR(SYSDATE,'DD') AS �̹���
,TO_DATE('2024 09 06')- TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDD')) AS ȸ�ı���
FROM dual;

-- DISTINCT �ߺ��� �����͸� �����ϰ� ������ ���� ��ȯ( Ư�� �÷��� ������ ���� ���������)
SELECT DISTINCT mem_job, MEM_LIKE
        -- �������� �ߺ� ���� �ʴ� �ุ ��ȯ
FROM member;

SELECT DISTINCT prod_category , prod_subcategory
FROM products
order by 1;

-- NVL (Į�� ��ȯ��)
SELECT emp_name, salary , commission_pct, salary +(salary*commission_pct) as ������
, salary +(salary*nvl(commission_pct,0)) as ������

FROM employees;

-- ������ �ټӳ���� 20�� �̻��� ������ ����Ͻÿ�!
SELECT EMP_NAME ,HIRE_DATE,
TO_CHAR(sysdate,'YYYY')- TO_CHAR(hire_date,'YYYY') AS �ټӳ��
FROM employees

WHERE TO_CHAR(sysdate,'YYYY')- TO_CHAR(hire_date,'YYYY') >=25
-- �˻������� ������ ALIAS ������ ����� �� ��� �������� �־������
ORDER BY �ټӳ�� DESC;

/*
�� ���̺�(CUSTOMERS)����
���� ����⵵(CUST_YEAR_OF_BIRTH) �÷��� �ִ�.
������ �������� �� �÷��� Ȱ���� 30��,41��,50�븦 �����Ͽ� ����ϰ�
������ ���ɴ�� '��Ÿ' �� ����ϴ� ������ �ۼ��غ���
(1990��� �̻� ���) ������ ���� ��������
*/

SELECT CUST_YEAR_OF_BIRTH
,TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth AS ����
,CASE WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=60 THEN '��Ÿ'
        WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=50 THEN '50��'
        WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=40 THEN '40��'
        WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=30 THEN '30��'
END AS ���ɴ�
FROM CUSTOMERS
WHERE CUST_YEAR_OF_BIRTH >=1990
ORDER BY ���ɴ�;

SELECT *
FROM CUSTOMERS;




SELECT CUST_YEAR_OF_BIRTH
,TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth AS ����
,CASE WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=30 THEN '30��'
WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=40 THEN '40��'
WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=50 THEN '50��'
WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=60 THEN '��Ÿ'
        
END AS ���ɴ�
FROM CUSTOMERS

ORDER BY ���ɴ�;

/*
    ���� �Լ��� �׷������
    �����Լ� ��� �����Ϳ� ����, ����, ���, �ִ�, �ּڰ� ���� ���ϴ� �Լ�
    �׷���� �� ��� �����͸� Ư�� �׷����� ���� ���
*/
-- count row ���� ��ȯ�ϴ� �����Լ�
SELECT COUNT(*)                 -- null ���� ����
,COUNT(department_id)           -- default all      -null���� ����
,COUNT(ALL department_id)       -- �ߺ�����,null x   
,COUNT(DISTINCT department_id)  -- �ߺ�����          - �μ��� ��ü ����
,COUNT(employee_id)             -- employees ���̺��� pk-�⺻Ű-null���X (*) ����
FROM employees;

SELECT SUM(salary)      as �հ�
,MAX(salary)            as �ִ�
,MIN(salary)            as �ּ�
,ROUND(AVG(salary),2)   as ���
,COUNT(employee_id)     as ������
FROM employees;         -- ������

SELECT department_id
,SUM(salary)      as �հ�
,MAX(salary)            as �ִ�
,MIN(salary)            as �ּ�
,ROUND(AVG(salary),2)   as ���
,COUNT(employee_id)     as ������
FROM employees         -- ���� ���̺��� 
WHERE department_id IS NOT NULL
AND department_id IN (30,60,90)
-- + AND �ٸ� ������ �ִٸ� FROM -����- GROUP 
GROUP BY department_id -- �μ��� (�׷����� ����)
ORDER BY 1;

-- MEMBER ȸ������ ���ϸ��� �հ�, ����� ��� �Ͻÿ�

SELECT MEM_JOB              as ����
,count(*)                   as ȸ����
,sum (mem_mileage)          as �հ�
,ROUND(avg(mem_mileage),2)  as ���
FROM member
GROUP BY MEM_JOB
ORDER BY 3 DESC;
-- ROWNUM �ǻ� �÷� ���̺��� ������ �ִ°� ó�� ��� ����


SELECT ROWNUM as rnum
        ,mem_name
        
FROM MEMBER
WHERE ROWNUM <= 10;

-- HAVING ���� ����� ���ؼ� �˻� ������ �߰��ϰ� ������ ���
-- EX) ������ ���ϸ��� �հ谡 10000 �̻� 
SELECT MEM_JOB              as ����
,count(*)                   as ȸ����
,sum (mem_mileage)          as �հ�
,ROUND(avg(mem_mileage),2)  as ���
FROM member
HAVING sum (mem_mileage) >= 10000   -- �������� �˻����� WHERE(�ܼ� �˻� ����) ������ �ٸ� ����
GROUP BY MEM_JOB
ORDER BY 3 DESC;

-- KOR_LOAN_STATUS ���̺��� LOAN_JAN_AMT(�����)
-- 2013�⵵ �Ⱓ�� / ������  �� ���� �ܾ��� ����Ͻÿ�

SELECT SUBSTR(period,1,4)  as �⵵
        ,REGION as ����
        ,sum(loan_jan_amt) as  ������
FROM KOR_LOAN_STATUS
WHERE period LIKE '2013%'
-- WHERE substr(period,1,4) ='2013';
GROUP BY SUBSTR(period,1,4) ,REGION;


--2013 �⵵ ������ ���к� �հ�
SELECT SUBSTR(period,1,4)  as �⵵
        ,REGION as ����
        ,gubun as ����
        ,sum(loan_jan_amt) as  ������
FROM KOR_LOAN_STATUS
WHERE period LIKE '2013%'
-- WHERE substr(period,1,4) ='2013';
GROUP BY SUBSTR(period,1,4) ,REGION, gubun
ORDER BY 2;


--  ������ ������ �հ� 200000 �̻��� ����� ����Ͻÿ� 
-- ���� �ܾ� ��������
SELECT 
REGION as ����,
sum(loan_jan_amt) as ������
FROM KOR_LOAN_STATUS
HAVING sum(loan_jan_amt)>=200000
GROUP BY REGION
ORDER BY 2 DESC;

-- ���� ���� �λ���
-- �⵵�� ������ �հ迡��
-- ������ ���� 60000 �Ѵ� ����� ����Ͻÿ�
-- ���� ���� ��������, ������ ��������
SELECT SUBSTR(PERIOD,1,4) AS �⵵
,REGION AS ����
,sum(loan_jan_amt) as ������
FROM KOR_LOAN_STATUS
WHERE REGION IN ('����','����','�λ�')
GROUP BY SUBSTR(period,1,4), REGION
HAVING sum(loan_jan_amt) >=60000
ORDER BY 2,3 DESC;

-- employees �������� �Ի�⵵�� �������� ����Ͻÿ�
SELECT 
to_char(hire_date,'yyyy')   as �⵵,
count(employee_id)          as ������
FROM employees
GROUP BY to_char(hire_date,'yyyy')
having count(employee_id)  >=10
order by 1 asc;

-- CUSTOMER ȸ���� ��ü ȸ����, ���� ȸ����, ���� ȸ������ ����Ͻÿ�

SELECT  count(decode (CUST_GENDER ,'F','����')) as ����
        ,SUM(decode (CUST_GENDER ,'F',1,0)) as ����2
        ,count(decode (CUST_GENDER ,'M','����')) as ����
        ,SUM(decode (CUST_GENDER ,'M',1,0)) as ����2
        ,COUNT (CUST_GENDER)   as ��ü
--SUM (CUST_GENDER) AS ����,
--SUM (CUST_GENDER) AS ����
FROM CUSTOMERS;

SELECT 
COUNT(*) AS ��ü
,SUM(CASE WHEN CUST_GENDER = 'F' THEN 1
END) AS ����
,SUM(CASE WHEN CUST_GENDER = 'M' THEN 1
END) AS ����
FROM CUSTOMERS;


SELECT emp_name, email
FROM employees;

-- 1. ���� ���� �Ͽ��� ���� -(employees,hire _date)
SELECT 
DECODE(TO_CHAR(HIRE_DATE,'D') ,1,'��' ,2,'��' ,3,'ȭ' ,4,'��' ,5,'��' ,6,'��' ,7,'��') AS ����
,COUNT(*)
FROM employees
GROUP BY TO_CHAR(HIRE_DATE,'D')
ORDER BY TO_CHAR(HIRE_DATE,'D');


--2. �⵵�� ������ ����ο����� ����Ͻÿ�.
--(employees ,hire_date)���
-- ���� �⵵ ��������
SELECT 
to_char(hire_date,'YYYY') AS �⵵
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,1,'��')) as sun
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,2,'��')) as mon
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,3,'ȭ')) as tue
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,4,'��')) as wed
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,5,'��')) as thu
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,6,'��')) as fri
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,7,'��')) as sat
, COUNT(TO_CHAR(HIRE_DATE)) AS �⵵������������հ�
FROM employees
GROUP BY to_char(hire_date,'YYYY')
ORDER BY 1;


select *
from employees;





