/*
 STUDY ������ create_table ��ũ��Ʈ�� �����Ͽ� 
 ���̺� ������ 1~ 5 �����͸� ����Ʈ�� �� 
 �Ʒ� ������ ����Ͻÿ� 
 (������ ���� ��¹��� �̹��� ����)
*/
-----------1�� ���� ---------------------------------------------------
--1988�� ���� ������� ������ �ǻ�,�ڿ��� ���� ����Ͻÿ� (� ������ ���)
SELECT *
FROM CUSTOMER
WHERE TO_CHAR(TO_DATE(BIRTH),'YYYY') >='1988'
--  == TO_NUMBER(SUBSTR(BIRTH,1,4))>=1988 VARCHAR Ÿ���̶� �ٷ� ����
AND JOB IN('�ǻ�','�ڿ���')
ORDER BY TO_CHAR(TO_DATE(BIRTH),'YYYY') DESC;
---------------------------------------------------------------------
-----------2�� ���� ---------------------------------------------------
--�������� ��� ���� �̸�, ��ȭ��ȣ�� ����Ͻÿ� 
SELECT a.customer_name , a.phone_number
FROM customer a,
ADDRESS b
WHERE a.zip_code = b.zip_code and b.ADDRESS_DETAIL IN ('������');

SELECT a.customer_name , a.phone_number
FROM customer a, address b
WHERE a.zip_code = b.zip_code 
and b.ADDRESS_DETAIL IN ('������');
---------------------------------------------------------------------
----------3�� ���� ---------------------------------------------------
--CUSTOMER�� �ִ� ȸ���� ������ ȸ���� ���� ����Ͻÿ� (���� NULL�� ����)

SELECT JOB ,COUNT(NVL(JOB,0)) AS CNT
FROM CUSTOMER
WHERE job IS NOT NULL
GROUP BY JOB
ORDER BY CNT DESC , JOB DESC;


---------------------------------------------------------------------
----------4-1�� ���� ---------------------------------------------------
-- ���� ���� ����(ó�����)�� ���ϰ� �Ǽ��� ����Ͻÿ� 
SELECT *
FROM (SELECT TO_CHAR(FIRST_REG_DATE,'DAY')AS ����, COUNT(TO_CHAR(FIRST_REG_DATE,'DAY'))AS �Ǽ�
FROM CUSTOMER
GROUP BY TO_CHAR(FIRST_REG_DATE,'DAY')
ORDER BY 2 DESC)
WHERE ROWNUM =1;

SELECT *
FROM ( SELECT TO_CHAR(first_reg_date,'day') as ����   
        ,count(*) as cnt
FROM customer
    GROUP BY TO_CHAR (first_reg_date,'day')
    ORDER BY 2 DESC)
WHERE ROWNUM =1;

---------------------------------------------------------------------
----------4-2�� ���� ---------------------------------------------------
-- ���� �ο����� ����Ͻÿ� 


SELECT NVL(DECODE (SEX_CODE ,'F','����' ,'M','����','�̵��'),'����') GENDER
     ,COUNT(DECODE (SEX_CODE ,'F','����' ,'M','����','�̵��')) CNT
    FROM CUSTOMER 
    GROUP BY ROLLUP (DECODE (SEX_CODE ,'F','����' ,'M','����','�̵��'))
    ORDER BY 
        CASE WHEN NVL(DECODE (SEX_CODE ,'F','����' ,'M','����','�̵��'),'����') = '����' THEN 1
        WHEN NVL(DECODE (SEX_CODE ,'F','����' ,'M','����','�̵��'),'����') = '����' THEN 2
        WHEN NVL(DECODE (SEX_CODE ,'F','����' ,'M','����','�̵��'),'����') = '�̵��' THEN 3
        ELSE 4
        END , CNT ASC;
        
--���1
SELECT NVL(gender,'�հ�') AS gender
    ,count(*) as cnt
    FROM(
SELECT DECODE (SEX_CODE ,'M','����','F','����','�̵��') gender
FROM customer)
GROUP BY ROLLUP(gender);
--���2
--grouping_id : �׷�ȭ�� ������ ��, ���� �÷��� ���� ���� ��Ż�� �����ϱ� ���� �Լ�
-- ������ ������ ���� ���ϰ��� �޶��� �Ѱ�,�Ұ� ���� ����ؼ� ������ ��¹��� ���� �� ���
SELECT CASE WHEN sex_code ='F' THEN '����' 
            WHEN sex_code ='M' THEN '����'
            WHEN sex_code IS NULL AND gid = 0 THEN '�̵��'
            ELSE '�հ�'
            END as gender, cnt
        FROM(       
            SELECT sex_code
            , count(*) as cnt
            , grouping_id(sex_code) as gid
            FROM customer
            GROUP BY ROLLUP(sex_code)
        );







---------------------------------------------------------------------
----------5�� ���� ---------------------------------------------------
--���� ���� ��� �Ǽ��� ����Ͻÿ� (���� �� ���� ���)
SELECT*
FROM RESERVATION;

SELECT TO_CHAR(TO_DATE(RESERV_DATE),'MM'),
COUNT(CANCEL)
FROM RESERVATION
GROUP BY TO_CHAR(TO_DATE(RESERV_DATE),'MM')
where cancel ='Y'
ORDER BY 1 DESC;



SELECT TO_CHAR(TO_DATE(reserv_date),'MM') as ��
        ,COUNT(*) as cnt
FROM RESERVATION
where cancel ='Y'
GROUP BY TO_CHAR(TO_DATE(RESERV_DATE),'MM')
ORDER BY 2 DESC;
----------6�� ���� ---------------------------------------------------
 -- ��ü ��ǰ�� '��ǰ�̸�', '��ǰ����' �� ������������ ���Ͻÿ� 
-----------------------------------------------------------------------------

SELECT
PRODUCT_NAME ��ǰ�̸�
        , A.PRICE*B.PRI ��ǰ����
FROM ITEM A , (SELECT ITEM_ID ,SUM(QUANTITY) AS PRI
FROM ORDER_INFO
GROUP BY ITEM_ID) B
WHERE A.ITEM_ID = B.ITEM_ID
ORDER BY 2 DESC;

SELECT B.PRODUCT_NAME
,SUM(A.SALES) AS ��ǰ����
FROM ORDER_INFO A, ITEM B
WHERE A.ITEM_ID = B.ITEM_ID
GROUP BY B.ITEM_ID, B.PRODUCT_NAME
ORDER BY 2 DESC;

---------- 7�� ���� ---------------------------------------------------
-- ����ǰ�� ���� ������� ���Ͻÿ� 
-- �����, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
----------------------------------------------------------------------------

SELECT SUBSTR(RESERV_NO,0,6) �����
,SUM(NVL(DECODE(ITEM_ID,'M0001',SALES),0)) SPECIAL_SET
,SUM(NVL(DECODE(ITEM_ID,'M0002',SALES),0)) PASTA
,SUM(NVL(DECODE(ITEM_ID,'M0003',SALES),0)) PIZZA
,SUM(NVL(DECODE(ITEM_ID,'M0004',SALES),0)) SEA_FOOD
,SUM(NVL(DECODE(ITEM_ID,'M0005',SALES),0)) STEAK
,SUM(NVL(DECODE(ITEM_ID,'M0006',SALES),0)) SALAD_BAR
,SUM(NVL(DECODE(ITEM_ID,'M0007',SALES),0)) SALAD
,SUM(NVL(DECODE(ITEM_ID,'M0008',SALES),0)) SANDWICH
,SUM(NVL(DECODE(ITEM_ID,'M0009',SALES),0)) WINE
,SUM(NVL(DECODE(ITEM_ID,'M0010',SALES),0)) JUICE
FROM ORDER_INFO 
GROUP BY SUBSTR(RESERV_NO,0,6)
ORDER BY 1;



--
SELECT SUBSTR(a. reserv_date,1,6) as �����
        ,SUM(DECODE (b.item_id,'M0001',B.SALES,0)) AS SPECIAL_SET
        ,SUM(DECODE (b.item_id,'M0002',B.SALES,0)) AS PASTA
        ,SUM(DECODE (b.item_id,'M0003',B.SALES,0)) AS PIZZA
        ,SUM(DECODE (b.item_id,'M0004',B.SALES,0)) AS SEA_FOOD
        ,SUM(DECODE (b.item_id,'M0005',B.SALES,0)) AS STEAK
        ,SUM(DECODE (b.item_id,'M0006',B.SALES,0)) AS SALAD_BAR
        ,SUM(DECODE (b.item_id,'M0007',B.SALES,0)) AS SALAD
        ,SUM(DECODE (b.item_id,'M0008',B.SALES,0)) AS SANDWICH
        ,SUM(DECODE (b.item_id,'M0009',B.SALES,0)) AS WINE
        ,SUM(DECODE (b.item_id,'M00010',B.SALES,0)) AS JUICE
FROM reservation a ,order_info b
    where a.reserv_no = b.reserv_no
GROUP BY SUBSTR(a. reserv_date,1,6)
ORDER BY 1;



---------- 8�� ���� ---------------------------------------------------
-- ���� �¶���_���� ��ǰ ������� �Ͽ��Ϻ��� �����ϱ��� ������ ����Ͻÿ� 
-- ��¥, ��ǰ��, �Ͽ���, ������, ȭ����, ������, �����, �ݿ���, ������� ������ ���Ͻÿ� 
----------------------------------------------------------------------------
SELECT SUBSTR(RESERV_NO,0,6) ��¥
,B.PRODUCT_NAME ��ǰ��
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),1,B.PRICE*A.QUANTITY),0)) �Ͽ���
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),2,B.PRICE*A.QUANTITY),0)) ������
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),3,B.PRICE*A.QUANTITY),0)) ȭ����
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),4,B.PRICE*A.QUANTITY),0)) ������
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),5,B.PRICE*A.QUANTITY),0)) �����
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),6,B.PRICE*A.QUANTITY),0)) �ݿ���
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),7,B.PRICE*A.QUANTITY),0)) �����
FROM ORDER_INFO A , ITEM B
WHERE B.PRODUCT_NAME = 'SPECIAL_SET' AND A.ITEM_ID = B.ITEM_ID
GROUP BY SUBSTR(RESERV_NO,0,6),B.PRODUCT_NAME 
ORDER BY 1;





SELECT ����� , ��ǰ�̸� 
        ,SUM(DECODE(����,'1',sales,0)) as �Ͽ���
        ,SUM(DECODE(����,'2',sales,0)) as �Ͽ���
        ,SUM(DECODE(����,'3',sales,0)) as �Ͽ���
        ,SUM(DECODE(����,'4',sales,0)) as �Ͽ���
        ,SUM(DECODE(����,'5',sales,0)) as �Ͽ���
        ,SUM(DECODE(����,'6',sales,0)) as �Ͽ���
        ,SUM(DECODE(����,'7',sales,0)) as �Ͽ���

        
FROM(
SELECT a.reserv_date        as �����
        ,c.product_desc     as ��ǰ�̸�
        ,TO_CHAR(TO_DATE(a.reserv_date),'d') as ����
        ,b.sales
FROM reservation a
    ,order_info b
    ,item c
WHERE a.RESERV_NO = b.RESERV_NO
AND b.item_id = c.item_id
AND c.PRODUCT_DESC ='�¶��� �����ǰ')
GROUP BY �����, ��ǰ�̸�;


--




---------- 9�� ���� ----------------------------------------------------
--�����̷��� �ִ� ���� �ּ�, �����ȣ, �ش����� ������ ����Ͻÿ�
----------------------------------------------------------------------------

-- �ߺ����� --


SELECT T2.ADDRESS_DETAIL AS �ּ�
, COUNT(*) AS ȸ����
FROM (
        SELECT DISTINCT a.customer_id , a.zip_code
        FROM customer a , reservation b , order_info c
        WHERE a.customer_id = b.customer_id
        AND b.reserv_no = c.reserv_no
        ) T1 , ADDRESS T2
        WHERE T1.ZIP_CODE = T2.ZIP_CODE
        GROUP BY T1.ZIP_CODE,T2.ADDRESS_DETAIL
        ORDER BY 2 DESC;
        
-- ���� �湮�� ������ ���� ��ü ������ ǰ�� �ջ� �ݾ��� ����Ͻÿ�
--  1. (BRANCH) ���� �湮Ƚ�� ���ϱ�
--  2. �湮Ƚ���� ���� ���� ID �˾Ƴ���
--  3. �ش� ID �� �����ȣ ���ϱ�.
--  4. �����ȣ�� ���� �հ� ���ϱ�.

SELECT * FROM CUSTOMER;
SELECT * FROM ORDER_INFO;
SELECT * FROM RESERVATION;
SELECT * FROM ITEM;

--  1. (BRANCH) ���� �湮Ƚ�� ���ϱ�
SELECT A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
        ,COUNT(B.CUSTOMER_NAME) �湮Ƚ�� , SUM(VISITOR_CNT) �湮����
FROM RESERVATION A, CUSTOMER B
WHERE A.CUSTOMER_ID = B.CUSTOMER_ID AND CANCEL ='N'
GROUP BY A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
ORDER BY 4 DESC;


--  2. �湮Ƚ���� ���� ���� ID �˾Ƴ���
SELECT CUSTOMER_ID
FROM(
    SELECT A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
        ,COUNT(B.CUSTOMER_NAME) �湮Ƚ�� , SUM(VISITOR_CNT) �湮����
FROM RESERVATION A, CUSTOMER B
WHERE A.CUSTOMER_ID = B.CUSTOMER_ID AND CANCEL ='N'
GROUP BY A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
ORDER BY 4 DESC)
WHERE ROWNUM =1;

--  3. �ش� ID �� �����ȣ ���ϱ�.

SELECT A.RESERV_NO
FROM RESERVATION A,(SELECT CUSTOMER_ID
FROM(
    SELECT A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
    ,COUNT(B.CUSTOMER_NAME) �湮Ƚ�� , SUM(VISITOR_CNT) �湮����
    FROM RESERVATION A, CUSTOMER B
    WHERE A.CUSTOMER_ID = B.CUSTOMER_ID AND CANCEL ='N'
    GROUP BY A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
    ORDER BY 4 DESC)
    WHERE ROWNUM =1) B
WHERE A.CUSTOMER_ID = B.CUSTOMER_ID
and CANCEL ='N';






SELECT A.PRODUCT_NAME �̸� ,A.PRICE, COUNT(A.PRODUCT_NAME) ����
FROM item a,order_info b ,(SELECT A.RESERV_NO �����ȣ
FROM RESERVATION A,(SELECT CUSTOMER_ID
FROM (
    SELECT A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
    ,COUNT(B.CUSTOMER_NAME) �湮Ƚ�� , SUM(VISITOR_CNT) �湮����
    FROM RESERVATION A, CUSTOMER B
    WHERE A.CUSTOMER_ID = B.CUSTOMER_ID AND CANCEL ='N'
    GROUP BY A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
    ORDER BY 4 DESC)
    WHERE ROWNUM =1) B
WHERE A.CUSTOMER_ID = B.CUSTOMER_ID
and CANCEL ='N') c
WHERE A.ITEM_ID = B.ITEM_ID 
AND B.RESERV_NO = C.�����ȣ
GROUP BY A.PRODUCT_NAME, A.PRICE;

-- �����ȣ�� �����հ� ���ϱ�S

SELECT �̸�, ����*����
FROM (SELECT A.PRODUCT_NAME �̸� ,A.PRICE ����, COUNT(A.PRODUCT_NAME) ����
FROM item a,order_info b ,(SELECT A.RESERV_NO �����ȣ
FROM RESERVATION A,(SELECT CUSTOMER_ID
FROM (
    SELECT A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
    ,COUNT(B.CUSTOMER_NAME) �湮Ƚ�� , SUM(VISITOR_CNT) �湮����
    FROM RESERVATION A, CUSTOMER B
    WHERE A.CUSTOMER_ID = B.CUSTOMER_ID AND CANCEL ='N'
    GROUP BY A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
    ORDER BY 4 DESC)
    WHERE ROWNUM =1) B
WHERE A.CUSTOMER_ID = B.CUSTOMER_ID
and CANCEL ='N') c
WHERE A.ITEM_ID = B.ITEM_ID 
AND B.RESERV_NO = C.�����ȣ
GROUP BY A.PRODUCT_NAME, A.PRICE)
ORDER BY 2 DESC;



---------------------------------------------------------------------
