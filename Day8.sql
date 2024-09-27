/*  ��������
    3. �ζ��� �� (from)��
    select ���� ���� ����� ��ġ ���̺� ó�� ���
*/

-- �������� �Ǽ��� ���� �л��� 5�� ����Ͻÿ�
-- �������� (�ζ��� �� �� �̿�)
SELECT �л�.�й�,�л�.�̸�, �л�.����, ���������Ǽ�
FROM(
        SELECT �л�.�й�,�л�.�̸�
            ,COUNT(��������.����������ȣ) AS ���������Ǽ�
        FROM �л�, ��������
        WHERE �л�.�й� = ��������.�й�(+)
        GROUP BY �л�.�й�, �л�.�̸�
        ORDER BY 3 DESC
        ),�л�
WHERE ROWNUM <=5;

-- ORACLE �Խ��� ������ ���� ���Ǵ� SQL
SELECT *
FROM (SELECT ROWNUM as rnum, a.*  -- a �� ��ü�� �ǹ���
        FROM(
        
            SELECT mem_name ,mem_mail, mem_add1
            FROM member
            ORDER BY 1) a
    )
WHERE rnum BETWEEN 6 AND 20;


-- rowNUm �� oreder by�� ������ ����Ǳ� ������ ���Ľ� ���� ��ȣ�� ���׹����̵�.
SELECT ROWNUM as rnum,
            mem_name 
        ,mem_mail
        , mem_add1
FROM member
ORDER BY mem_mail;


SELECT ROWNUM AS rnum
,a.*
FROM member a
WHERE ROWNUM <=2;        -- 1.�˻����� ����
                         -- 2.�Ұ��� == ��� �� ���̺� ��ȸ���� �Ұ���
                         -- <=2  ���� (�������� ��ȸ)
SELECT *
    FROM (SELECT ROWNUM AS rnum
    ,a.*
    FROM member a)
WHERE ROWNUM = 1; 



SELECT rownum as rnum2,b.*
FROM    (SELECT ROWNUM as rnum,a.*
        FROM member a
        ORDER BY 3) b;
        
-- �л��� �� ������ ���� ���� 5�� ����Ͻÿ�

SELECT *
FROM
    ( SELECT �̸�, ���� ,����
    FROM �л�
    ORDER BY 3 DESC )
WHERE ROWNUM <=5;

/*ANSI ����
    (American National Standard Institute)
    ANSI ǥ���� ������ ���̽� ���� �ý��ۿ��� ����ϴ� SQL ǥ��
    INNER JOIN , LEFT OUTER JOIN,  RIGHT OUTER JOIN, FULL OUTER JOIN
*/
-- �Ϲ� inner join
SELECT a.employee_id
      ,a.emp_name
      ,a.job_id
      ,b.department_name
FROM employees a
    ,departments b
WHERE a.department_id = b.department_id;


-- ANSI INNER JOIN (�������� ���ι��� ��.)
SELECT a.employee_id
      ,a.emp_name
      ,a.job_id
      ,b.department_name
FROM employees a
INNER JOIN departments b
ON (a.department_id = b.department_id)
-- ANSI ���ο� �˻� ������ �ִٸ�
WHERE a.hire_date >= TO_DATE('2003-01-01');
-- JOIN ���� �Ʒ��� ��.

-- USING ���� �÷����� ���� �� ��밡��
SELECT a.employee_id
      ,a.emp_name
      ,a.job_id
      ,b.department_name
      ,department_id        -- using ���� ����� �÷� ��ȸ �Ҵ�� ���̺� ���� �鰡�� �ȵ�.
FROM employees a
INNER JOIN departments b
USING (department_id)    -- �÷����� ���� �� ��밡��. �׷��⿡ �� ���̺� ���� ���� �ȵ�
WHERE a.hire_date >= TO_DATE('2003-01-01');

-- �Ϲ� outer join (+)
SELECT a.employee_id ,a.emp_name, b.job_id
FROM employees a
    ,job_history b
WHERE a.job_id = b.job_id(+) -- �� ���� ���Խ�ų ���̺� �÷��ʿ�.
AND a.department_id =b.department_id(+);

-- LEFT OUTER JOIN  
SELECT a.employee_id ,a.emp_name, b.job_id
FROM employees a
LEFT OUTER JOIN job_history b       -- ������ ���̺��� ���ʿ� ���̰ڴ�
ON (a.job_id = b.job_id
   AND a.department_id =b.department_id);
   
--RIGHT OUTER JOIN(���� ����� ����)

SELECT a.employee_id , a.emp_name, b.job_id
FROM job_history b
RIGHT JOIN employees a      -- ���� ���̺��� �����ʿ� ���̴� 
ON (a.job_id = b.job_id
   AND a.department_id =b.department_id);

SELECT   a.mem_id
        ,a.mem_name
        ,count(distinct b.cart_no)
        ,count(distinct b.cart_prod)
        ,sum(NVL(b.cart_qty,0))
FROM member a, cart b
WHERE a.mem_id = b.cart_member(+)
GROUP BY a.mem_id,a.mem_name
order by 5 desc;



SELECT   a.mem_id
        ,a.mem_name
        ,count(distinct b.cart_no)
        ,count(distinct b.cart_prod)
        ,sum
FROM member a(NVL(b.cart_qty,0))
LEFT OUTER JOIN cart b
ON (a.mem_id = b.cart_member)
GROUP BY a.mem_id,a.mem_name
order by 5 desc;

SELECT a.mem_id , a.mem_name
FROM 
member a ,(SELECT * FROM CART) b ;

--FULL OUTER JOIN �Ϲ� ���� �� ����(+)�� �ȵ�. ANSI �� ��.
CREATE TABLE table_a(emp_id number);
CREATE TABLE table_b(emp_id number);

INSERT INTO table_a VALUEs(10);
INSERT INTO table_a VALUEs(20);
INSERT INTO table_a VALUEs(40);

INSERT INTO table_b VALUEs(10);
INSERT INTO table_b VALUEs(20);
INSERT INTO table_b VALUEs(30);




--SELECT a.emp_id , b.emp_id
--FROM table_a a
--FULL OUTER JOIN table_b b
--ON(a.emp_id = b.emp_id);

-- LFFT OUTER JOIN 2�� �̻�
SELECT a.�̸�, b.���ǽ�, c.�����̸�
FROM �л� a
LEFT OUTER JOIN �������� b
ON(a.�й� = b.�й�)
LEFT OUTER JOIN ���� c
ON(b.�����ȣ = c.�����ȣ);
-- CROSS ����

SELECT *
FROM �л�, ��������;  -- 9*17 ���� ����.

-- ANSI CROSS
SELECT *
FROM �л�
CROSS JOIN ��������;


--SELF ����  ������ ���̺��
-- 20 �� �μ����� ���� �μ���ȣ�� ���� �����
--A �����ȣ�� B�����ȣ���� ���� �� ��ȸ
SELECT a.emp_name , a.employee_id
        ,b.emp_name , b.employee_id
    FROM employees a
    ,employees b
WHERE a.employee_id < b.employee_id
and a.department_id = b.department_id
and a.department_id =20;
-- ��ø���� IN ���ÿ� 2���̻��� �÷� ���� ���� �� ��ȸ.
SELECT employee_id, emp_name, job_id
FROM employees
WHERE (employee_id , job_id) IN (SELECT employee_id, job_id 
                                FROM job_history);
                                
-- �л����� ���� �� ������ ���� ���� �л��� ������ ����Ͻÿ�

SELECT*
FROM �л�
WHERE (����,����) IN (SELECT ���� , MAX (����)
                    FROM �л�
                    GROUP BY ����)
;
--2000�⵿ �Ǹ� (�ݾ�)���� ������ ����Ͻÿ�(sales,employees)
--�Ǹ� ���� �÷� (amount_sold , quantity_sold, sales_date)


select a.employee_id,
        (SELECT emp_name FROM employees 
         WHERE employee_id = a. employee_id) �����̸�
        ,TO_CHAR(�Ǹűݾ�, '999,999,999,999,99') �Ǹűݾ�
        ,�Ǹż���
from (select employee_id 
                ,sum(amount_sold) as �Ǹűݾ�
                ,sum(quantity_sold) as �Ǹż���
                FROM sales
                WHERE TO_CHAR(SALES_DATE,'YYYY') = '2000'
                group by employee_id
                ORDER BY 2 DESC) a
WHERE ROWNUM <=1;

SELECT employee_id 
    ,sum(amount_sold)
    ,sum(quantity_sold)
FROM sales
WHERE TO_CHAR(SALES_DATE,'YYYY') = '2000'
group by employee_id
ORDER BY 2 DESC;



















