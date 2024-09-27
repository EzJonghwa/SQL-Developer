/*
    with �� �� Ī���� ����� select ���� ������ ������.
    �ݺ��Ǵ� ���������� ����ó�� ��밡��
    ��������� Ʃ�� �Ҷ� ���� ���
    
    temp��� �ӽ� ���̺��� ����ؼ� ��ð� �ɸ��� ������ ����� ������ ���� 
    ������ ���� �����͸� �׼��� �ϱ� ������ ������ ���� �� ����.
    oracle 9 �����̻� ����.
    (����) �������� ����.
    
*/
-- �μ��� ���� �հ� -- GROUP BY �μ�
-- ������ ���� �հ� -- GROUP BY ����
-- ��� ��� 
WITH A as( SELECT employee_id, emp_name , department_id , job_id ,salary
            FROM employees )
, B as ( SELECT department_id ,SUM(salary) as dep_sum, COUNT(department_id) as dep_cnt
        FROM a
        GROUP BY department_id
), C as ( 
SELECT job_id, SUM(salary) as job_sum, COUNT(job_id) as job_cnt
        FROM a
        GROUP BY job_id)
        
SELECT a.employee_id , a.emp_name, a.salary 
        , b. dep_sum ,b.dep_cnt
        , a.job_id ,c.job_sum , c.job_cnt
FROM a,b,c
WHERE a.department_id = b.department_id
AND a.job_id = c.job_id;

/* ����
kor_loan_status ���̺��� '������', '������(��������)' ���� 
���� ������ ���� ���ÿ� �ܾ��� ���Ͻÿ�

------------------------------------------------------------
- 2011���� 12�� 2013���� 11������ ������ ���� ���� �ٸ�.
- ������ �������� ������� ���� �ܾ��� ���� ū �ݾ� ����
- ���� , ������  �����ܾװ� '����������ū �ܾ�' �� ���ؼ� ���� ���� ����
*/
-- ������ 
SELECT MAX(PERIOD) AS max_month
FROM KOR_LOAN_STATUS
GROUP BY SUBSTR(PERIOD,1,4);

-- JOIN --

-- ���� ������ MAX��
SELECT PERIOD , REGION , SUM(LOAN_JAN_AMT) as jan_sum
FROM KOR_LOAN_STATUS
GROUP BY PERIOD , REGION;

-- �������� ������ ���� ū �ݾ�
SELECT b.period
,max(b.jan_sum) as max_jan_amt
FROM 
        ( SELECT PERIOD , REGION , SUM(LOAN_JAN_AMT) as jan_sum
        FROM KOR_LOAN_STATUS
        GROUP BY PERIOD , REGION ) b
       ,( SELECT MAX(PERIOD) AS max_month
        FROM KOR_LOAN_STATUS
        GROUP BY SUBSTR(PERIOD,1,4) ) a

WHERE b.period = a.max_month
GROUP BY b.period;

SELECT b2.*
FROM    ( SELECT PERIOD , REGION , SUM(LOAN_JAN_AMT) as jan_sum
        FROM KOR_LOAN_STATUS
        GROUP BY PERIOD , REGION) b2
        
        ,( SELECT b.period
        ,max(b.jan_sum) as max_jan_amt
        FROM 
                ( SELECT PERIOD , REGION , SUM(LOAN_JAN_AMT) as jan_sum
                FROM KOR_LOAN_STATUS
                GROUP BY PERIOD , REGION ) b
            
               ,( SELECT MAX(PERIOD) AS max_month
                FROM KOR_LOAN_STATUS
                GROUP BY SUBSTR(PERIOD,1,4) ) a

        WHERE b.period = a.max_month
        GROUP BY b.period ) c
        
    WHERE b2.period = c.period
    AND b2.jan_sum = c.max_jan_amt
    ORDER BY 1;




WITH B AS (SELECT PERIOD , REGION , SUM(LOAN_JAN_AMT) as jan_sum
        FROM KOR_LOAN_STATUS
        GROUP BY PERIOD , REGION )  
    ,C AS (SELECT B.PERIOD, MAX(B.jan_sum) AS MAX_JAN_AMT
            FROM B,
            (SELECT MAX(PERIOD) AS max_month
            FROM KOR_LOAN_STATUS
            GROUP BY SUBSTR(PERIOD,1,4)) A
        WHERE B.PERIOD = A.MAX_MONTH
        GROUP BY B.PERIOD
        )
SELECT B.*
FROM B,C
WHERE B.PERIOD = C.PERIOD
AND B.JAN_SUM = C.MAX_JAN_AMT
ORDER BY 1;

WITH test_data AS (SELECT 'abcd' as pw FROM dual UNION ALL
SELECT 'abcd�ȳ�' as pw FROM dual UNION ALL
SELECT 'abcd�ȳ�123' as pw FROM dual )



SELECT *
FROM test_data
WHERE REGEXP_LIKE(PW, '[��-��]');

--���� īƮ �̷��� ���� ���� ���� ���� ���� ���� ������ ����Ͻÿ�.(MEMBER . CART)
SELECT MEM_ID , MEM_NAME 
FROM MEMBER;

WITH T1 AS
        (SELECT A.MEM_ID , A.MEM_NAME ,COUNT(DISTINCT B.CART_NO) CNT
        FROM MEMBER A , CART B
        WHERE A.MEM_ID = B.CART_MEMBER
        GROUP BY A.MEM_ID, A.MEM_NAME)
        
,T2 AS( SELECT MAX(T1.CNT) AS MAX_CNT ,MIN(T1.CNT) MIN_CNT
        FROM T1)
        
SELECT T1.MEM_ID , T1.MEM_NAME ,T1.CNT
FROM T1,T2
WHERE T1.CNT = T2.MAX_CNT
OR T1.CNT = T2.MIN_CNT
ORDER BY 1;


-- ���� Ǯ�� ����
--WITH A AS (SELECT MEM_ID , MEM_NAME 
--FROM MEMBER)
--,B AS(SELECT CART_MEMBER ,COUNT(DISTINCT(CART_NO)) AS CNT
--FROM CART
--GROUP BY CART_MEMBER)
--SELECT A.MEM_ID, A.MEM_NAME , CNT
--FROM A,B
--WHERE A.MEM_ID = B.CART_MEMBER;


/*
        2000 �⵵ ��Ż������ '����� �����' ���� ū '���� ��� �����'�̾���
        '���','�����' �� ����Ͻÿ� (�Ҽ��� �ݿø�)
        SALES , CUSTOMERS , COUNTRIES (���̺�)
        ��� ������� AMOUNT_SOLD <-- AVG �� (�ջ��� ���� �׳� ���)108.2444

            tip .��������!        
        (1) ���������� ��ȸ�Ǵ� ��� �׸��� ����
        (2) �ʿ��� ���̺�� �÷� �ľ�
        (3) ���� ������ �����ؼ� ���� �ۼ�
        (4) ������ ������ ������ �ϳ��� ���� ���� ����� ����
        (5) ����� ����
        
*/
WITH  A AS (SELECT cu.cust_id as custid
            FROM countries ct, customers cu
            WHERE ct.country_id = cu.country_id
            and ct.country_id = '52770')
            
        ,Y AS (SELECT SUBSTR(sales_month,0,4) 
                , AVG(amount_sold) yavg
                FROM a, sales s
                WHERE a.custid =s.cust_id 
                AND SUBSTR(sales_month,0,4)='2000'
                GROUP BY SUBSTR(sales_month,0,4))
                
        ,m AS (SELECT sales_month
                ,AVG (amount_sold) mavg
                FROM a, sales s
                WHERE custid =s.cust_id 
                AND SUBSTR(sales_month,0,4)='2000'
                GROUP BY sales_month)
SELECT sales_month 
,ROUND(m.mavg)
FroM y,m
WHERE y.yavg < m.mavg
order by 1;

-- ������ ���̺��� �ʿ��� ������
SELECT CUST_ID  -- �� ���̵�
    , SALES_MONTH   -- �����
    , AMOUNT_SOLD   -- ���� �ݾ�
FROM SALES;

--CUSTOMERS ���̺��� �ʿ��� ������
SELECT CUST_ID 
    , COUNTRY_ID
FROM CUSTOMERS;

--COUNTRIES ���̺��� �ʿ��� ������
SELECT COUNTRY_ID 
        ,COUNTRY_NAME
FROM COUNTRIES;


-- join ���� ���յ� �ʿ��� �����͵�
    WITH A as (
            SELECT A.CUST_ID  
                , A.SALES_MONTH   
                , A.AMOUNT_SOLD   
                , B.COUNTRY_ID
            FROM SALES A
                ,CUSTOMERS B
                ,COUNTRIES C
            WHERE A.CUST_ID = B.CUST_ID
            AND B.COUNTRY_ID = C.COUNTRY_ID
            AND A.SALES_MONTH BETWEEN '200001' AND '200012'
            AND C.COUNTRY_NAME = 'Italy'
    )
     ,B as(
            SELECT AVG(AMOUNT_SOLD) AS y_avg -- �����
            FROM A
        )
    ,C as(
            SELECT SALES_MONTH
            ,AVG(AMOUNT_SOLD) AS m_avg --�����
            FROM A
            GROUP BY SALES_MONTH
    )
SELECT C.SALES_MONTH, ROUND(C.m_avg)
FROM B,C
WHERE C.m_avg > B.y_avg
ORDER BY 1;


-- MEMBER ,CART ,PROD Ȱ��
-- ���� , ��ǰ��, (�� ���ż���), (��ü�Ǹż���), (�ش��ǰ ��ä �Ǹſ��� �� ���ź���)
--,(���� ������ �ش� ��ǰ ���� �ջ�),(��ü���� �ش� ��ǰ ���� �ջ�)

SELECT MEM_ID
FROM MEMBER;

SELECT CART_MEMBER , CART_PROD , CART_QTY
FROM CART;

SELECT PROD_ID , PROD_NAME , PROD_BUYER, PROD_SALE
FROM PROD;


SELECT A.MEM_ID
        ,C.PROD_NAME
        ,B.CART_QTY
        ,C.PROD_SALE
FROM MEMBER A, CART B, PROD C
WHERE A.MEM_ID = B.CART_MEMBER
AND B.CART_PROD = C.PROD_ID
ORDER BY 1;
            
SELECT A.MEM_ID
        ,C.PROD_NAME
        ,B.CART_QTY
        ,C.PROD_SALE
FROM MEMBER A, CART B, PROD C
WHERE A.MEM_ID = B.CART_MEMBER
AND B.CART_PROD = C.PROD_ID
ORDER BY 1;


    WITH A as(
            SELECT A.MEM_ID
                    ,C.PROD_NAME
                    ,C.PROD_SALE
                    ,B. CART_QTY
            FROM MEMBER A, CART B, PROD C
            WHERE A.MEM_ID=B.CART_MEMBER
            AND B.CART_PROD =C.PROD_ID
            ORDER BY 1
    )
--    ,b as(

        SELECT 
        MEM_ID,PROD_NAME,
            SUM(CART_QTY) AS ALL_COUNT
            FROM A
            GROUP BY MEM_ID,PROD_NAME;  
            )
--    ,c as(

    

    
SELECT A.MEM_ID
      ,A.PROD_NAME
      ,A.PROD_SALE
      ,A. CART_QTY
WHERE 
FROM A,B;



