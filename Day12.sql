
/*
    �м��Լ�
    ���̺� �ִ� �ο쿡 ���� Ư�� �׷캰�� ���� ���� ���� �� �� �����.
    group by ���� ����ϴ� �����Լ��� �ٸ����� �ο�ս� ���� ���谪�� ���� �Ҽ� �ִ�.

    �м� �Լ��� �ڿ��� ���� �Һ��ϴ� ������ �־ ���� �м��Լ��� ���ÿ� ����� ���
    �ִ��� ���� �������� ����ϴ� ���� ����. (�ζ��� �� ���� ����ϱ⺸��,....)
    �м��Լ�(�Ű�����) OVER (PARTITION BY expr1, expr2...
                            ORDER BY expr3...
                            WINDOW ��)
    AVG, SUM, MAX , COUNT , CUM_DIST , DENSE_RANK, PERCENT_RANK , FIRST MLAST ,LAG...
    PATITION BY  : ��� ��� �׷��� ����
    ORDER BY     : ��� �׷쿡 ���� ������ ����
    WINDOW       :��Ƽ������ ���ҵ� �׷쿡 ���ؼ� �� ���� �׷����� ����ROW OR RANGE

*/

-- �μ��� �̸������� ���� ���
SELECT ROWNUM as rnum
        ,department_id , emp_name
        ,ROW_NUMBER() OVER(PARTITION BY department_id
                            ORDER BY emp_name ) dep_rownum
FROM employees;



-- RANNK ���� ���� �ǳʶ�          ex) 1,2,3,3,5,6,7 ...
-- DENSE_RANK() �ǳʶ��� ����      ex) 1,2,3,4,4,5,6,7 ...
SELECT *
FROM(
        SELECT department_id , emp_name, salary
                ,RANK() OVER(PARTITION BY department_id
                            ORDER BY salary DESC ) as rnk
                            
                ,DENSE_RANK() OVER(PARTITION BY department_id
                            ORDER BY salary DESC ) as DENSE_rnk
        FROM employees)
        WHERE rnk =1;
        
-- �μ��� ���� �հ�� ��ü �հ�
SELECT emp_name, salary, department_id 
        ,SUM(salary) OVER (PARTITION BY department_id)  as �μ����հ� 
        ,MAX(salary) OVER (PARTITION BY department_id)  as �μ��ִ�
        ,MIN(salary) OVER (PARTITION BY department_id)  as �μ��ּ�
        ,COUNT(*) OVER (PARTITION BY department_id)     as �μ�������
        ,SUM(salary) OVER () as ��ü�հ�
FROM employees;


-- �л����� ������ ������ �������� (��������) ������ ����Ͻÿ�.


SELECT �̸� , ���� 
    ,RANK() OVER(PARTITION BY ���� ORDER BY ���� DESC)
    ,���� 
    ,RANK() OVER(ORDER BY ���� DESC)
FROM �л�
ORDER BY 2,4;

-- ������ �л����� �������� ������ ���Ͻÿ�

SELECT 
        ����,
        COUNT (�й�) �л���
        ,RANK() OVER(ORDER BY COUNT (�й�) DESC) ����
       
FROM �л�
GROUP BY ����
ORDER BY 3 ;



SELECT ����, �л���
        ,RANK() OVER(ORDER BY �л��� DESC)
FROM (SELECT 
        ����, COUNT (*) AS �л���
        FROM �л�
        GROUP BY ����
);

/* LAG ���� �ο��� ���� ��Ⱥ
    LEAD ���� �ο��� ���� �����ͼ� ��ȯ
*/
SELECT emp_name, department_id, salary 
,LAG(emp_name,1,'�������') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) lags
,LEAD(emp_name,1,'���峷��') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) leads                                    
FROM employees
WHERE department_id IN (30,60);

-- �������� �� �л��� �������� �Ѵܰ� ���� �л����� ���� ���̸� ����Ͻÿ�.
SELECT *
FROM �л�;

SELECT �̸�, ���� ,����
    ,LAG(�̸�,1,'1��') OVER(PARTITION BY ���� ORDER BY ���� DESC) ���������л�
    ,NVL(LAG(����,1) OVER(PARTITION BY ���� ORDER BY ���� DESC)-����,0) ��������
    ,LAG(����,1,����) OVER(PARTITION BY ���� ORDER BY ���� DESC)-���� ��������
FROM �л�;


/*  WINDOW ��

    ROW                 : �ο� ������ WINDOW ���� ����
    RANGE               : ������ ������ WINDOW ��
    BETWEEN - AND       : WINDOW ���� ���۰� �� ������ ����Ѵ�,
                         BETWEEN �� ������� �ʰ� �� ��° �ɼǸ� �����ϸ� �������� ���۵ǰ�
                         �� ������ ���� �ο찡 ��.
    UNBOUNDED PRECEDING : ��Ƽ������ ���е� ù ��° �ο찡 �ß���.
    UNBOUNDED FOLLOWING : ��Ƽ������ ���е� ������ �ο찡 �� ������ ��
    CURRENT ROW         : ���� �� �� ������ ����ο�
    expr PRECEDING      : �� ������ ��� , ���������� EXPR
    expr FOLLOWING      : ���� ������ ��� �� ������ EXPR

*/

SELECT department_id ,emp_name,hire_date,salary

,SUM (salary) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN UNBOUNDED PRECEDING 
                        AND CURRENT ROW ) AS FOLLOWING_CURRENT
                        
,SUM (salary) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN CURRENT ROW 
                        AND UNBOUNDED FOLLOWING) AS CURR_FOLLOWING
                        
,SUM (salary) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN 1 PRECEDING 
                        AND CURRENT ROW) AS JUN1_CURRENT
                        
,SUM (salary) OVER (PARTITION BY department_id ORDER BY hire_date
                        ROWS BETWEEN 1 PRECEDING 
                        AND 1 FOLLOWING) AS JUN1_CURRENT
-- RANGE ���� ����(���ڿ� ��¥�� ���·� ������ �� �� ����)
,SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                    RANGE 365 PRECEDING) as years
                        -- �� ���� �������� 1�����̶� sum�� ������.
FROM employees;
--Study
-- ���� ��ü ���������� ����Ͻÿ�


PARTITION BY department_id 
                        ROWS BETWEEN UNBOUNDED PRECEDING 
                        AND CURRENT ROW

SELECT
    SUBSTR(RESERV_NO,0,6) 
    ,SUM(SALES) 
    ,SUM(SALES) OVER (ORDER BY SUBSTR(RESERV_NO,0,6)
                         ROWS BETWEEN UNBOUNDED PRECEDING 
                         AND CURRENT ROW)
FROM ORDER_INFO
GROUP BY SUBSTR(RESERV_NO,0,6)
ORDER BY 1;





SELECT ���, ������, 
SUM(������) OVER (ORDER BY ���
                         ROWS BETWEEN UNBOUNDED PRECEDING 
                         AND CURRENT ROW) ��������
FROM 
    (SELECT SUBSTR(RESERV_NO,0,6) ���
    ,SUM(SALES) ������
    FROM ORDER_INFO
    GROUP BY SUBSTR(RESERV_NO,0,6));



SELECT T1.*
,SUM(T1.������) OVER(ORDER BY ���
                         ROWS BETWEEN UNBOUNDED PRECEDING 
                         AND CURRENT ROW) AS ��������
    ,ROUND(RATIO_TO_REPORT(T1.������) OVER() * 100,2) ||'%' AS ����
    
FROM (SELECT SUBSTR(a.reserv_Date,1,6) as ���
    ,SUM(b.sales) as ������
    FROM RESERVATION A , ORDER_INFO B
    WHERE a.reserv_no = b.reserv_no
    GROUP BY substr(a.reserv_Date,1,6)
    ORDER BY 1
    ) T1;
    
    
    
    
    
-- ������, ���� ������, ����, �����ܾװ� ������ ��Ƽ�Ǵ��� ������ �����ܾ��� % �� ���Ͻÿ�.
--201210~201212

SELECT REGION , GUBUN

,(PR1||'(  '|| ROUND(RATIO_TO_REPORT(PR1) OVER(PARTITION BY REGION) *100 ) ||'% )') "201210"
,(PR2||'(  '|| ROUND(RATIO_TO_REPORT(PR2) OVER(PARTITION BY REGION) *100 ) ||'% )') "201211"
,(PR3||'(  '|| ROUND(RATIO_TO_REPORT(PR3) OVER(PARTITION BY REGION) *100 ) ||'% )') "201212"


FROM (
        SELECT REGION , GUBUN 
        ,SUM(DECODE(PERIOD,'201210',LOAN_JAN_AMT ))||'(  '|| ROUND(RATIO_TO_REPORT(PR1) OVER(PARTITION BY REGION) *100 ) ||'% )' PR1
        ,SUM(DECODE(PERIOD,'201211',LOAN_JAN_AMT )) PR2
        ,SUM(DECODE(PERIOD,'201212',LOAN_JAN_AMT )) PR3
        FROM KOR_LOAN_STATUS
        GROUP BY REGION , GUBUN 
        ORDER BY 1,2);










