/*  서브쿼리
    3. 인라인 뷰 (from)절
    select 문의 질의 결과를 마치 테이블 처럼 사용
*/

-- 수강내역 건수가 많은 학생을 5명 출력하시오
-- 서브쿼리 (인라인 뷰 를 이용)
SELECT 학생.학번,학생.이름, 학생.전공, 수강내역건수
FROM(
        SELECT 학생.학번,학생.이름
            ,COUNT(수강내역.수강내역번호) AS 수강내역건수
        FROM 학생, 수강내역
        WHERE 학생.학번 = 수강내역.학번(+)
        GROUP BY 학생.학번, 학생.이름
        ORDER BY 3 DESC
        ),학생
WHERE ROWNUM <=5;

-- ORACLE 게시판 쿼리에 많이 사용되는 SQL
SELECT *
FROM (SELECT ROWNUM as rnum, a.*  -- a 의 전체를 의미함
        FROM(
        
            SELECT mem_name ,mem_mail, mem_add1
            FROM member
            ORDER BY 1) a
    )
WHERE rnum BETWEEN 6 AND 20;


-- rowNUm 이 oreder by절 이전에 진행되기 때문에 정렬시 열의 번호가 뒤죽박죽이됨.
SELECT ROWNUM as rnum,
            mem_name 
        ,mem_mail
        , mem_add1
FROM member
ORDER BY mem_mail;


SELECT ROWNUM AS rnum
,a.*
FROM member a
WHERE ROWNUM <=2;        -- 1.검색조건 가능
                         -- 2.불가능 == 어느 한 테이블만 조회해줘 불가능
                         -- <=2  가능 (어디까지만 조회)
SELECT *
    FROM (SELECT ROWNUM AS rnum
    ,a.*
    FROM member a)
WHERE ROWNUM = 1; 



SELECT rownum as rnum2,b.*
FROM    (SELECT ROWNUM as rnum,a.*
        FROM member a
        ORDER BY 3) b;
        
-- 학생들 중 평점이 높은 상위 5명만 출력하시오

SELECT *
FROM
    ( SELECT 이름, 전공 ,평점
    FROM 학생
    ORDER BY 3 DESC )
WHERE ROWNUM <=5;

/*ANSI 문법
    (American National Standard Institute)
    ANSI 표준은 데이터 베이스 관리 시스템에서 사용하는 SQL 표준
    INNER JOIN , LEFT OUTER JOIN,  RIGHT OUTER JOIN, FULL OUTER JOIN
*/
-- 일반 inner join
SELECT a.employee_id
      ,a.emp_name
      ,a.job_id
      ,b.department_name
FROM employees a
    ,departments b
WHERE a.department_id = b.department_id;


-- ANSI INNER JOIN (프롬절에 조인문이 들어감.)
SELECT a.employee_id
      ,a.emp_name
      ,a.job_id
      ,b.department_name
FROM employees a
INNER JOIN departments b
ON (a.department_id = b.department_id)
-- ANSI 조인에 검색 조건이 있다면
WHERE a.hire_date >= TO_DATE('2003-01-01');
-- JOIN 구문 아래에 들어감.

-- USING 조인 컬럼명이 같을 때 사용가능
SELECT a.employee_id
      ,a.emp_name
      ,a.job_id
      ,b.department_name
      ,department_id        -- using 절에 사용한 컬럼 조회 할대는 테이블 명이 들가면 안됨.
FROM employees a
INNER JOIN departments b
USING (department_id)    -- 컬럼명이 같을 때 사용가능. 그렇기에 각 테이블 명이 들어가면 안됨
WHERE a.hire_date >= TO_DATE('2003-01-01');

-- 일반 outer join (+)
SELECT a.employee_id ,a.emp_name, b.job_id
FROM employees a
    ,job_history b
WHERE a.job_id = b.job_id(+) -- 널 값을 포함시킬 테이블 컬럼쪽에.
AND a.department_id =b.department_id(+);

-- LEFT OUTER JOIN  
SELECT a.employee_id ,a.emp_name, b.job_id
FROM employees a
LEFT OUTER JOIN job_history b       -- 오른쪽 테이블을 왼쪽에 붙이겠다
ON (a.job_id = b.job_id
   AND a.department_id =b.department_id);
   
--RIGHT OUTER JOIN(위의 결과가 같음)

SELECT a.employee_id , a.emp_name, b.job_id
FROM job_history b
RIGHT JOIN employees a      -- 왼쪽 테이블을 오른쪽에 붙이는 
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

--FULL OUTER JOIN 일밭 쿼리 문 조인(+)은 안됨. ANSI 만 됨.
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

-- LFFT OUTER JOIN 2개 이상
SELECT a.이름, b.강의실, c.과목이름
FROM 학생 a
LEFT OUTER JOIN 수강내역 b
ON(a.학번 = b.학번)
LEFT OUTER JOIN 과목 c
ON(b.과목번호 = c.과목번호);
-- CROSS 조인

SELECT *
FROM 학생, 수강내역;  -- 9*17 행이 나옴.

-- ANSI CROSS
SELECT *
FROM 학생
CROSS JOIN 수강내역;


--SELF 조인  동일한 테이블로
-- 20 번 부서에서 같은 부서본호를 가진 사원중
--A 사원번호가 B사원번호보다 작은 건 조회
SELECT a.emp_name , a.employee_id
        ,b.emp_name , b.employee_id
    FROM employees a
    ,employees b
WHERE a.employee_id < b.employee_id
and a.department_id = b.department_id
and a.department_id =20;
-- 중첩쿼리 IN 동시에 2개이상의 컬럼 값이 같은 건 조회.
SELECT employee_id, emp_name, job_id
FROM employees
WHERE (employee_id , job_id) IN (SELECT employee_id, job_id 
                                FROM job_history);
                                
-- 학생들의 전공 별 평점이 가장 높은 학생의 정보를 출력하시오

SELECT*
FROM 학생
WHERE (전공,평점) IN (SELECT 전공 , MAX (평점)
                    FROM 학생
                    GROUP BY 전공)
;
--2000년동 판매 (금액)왕의 정보를 출력하시오(sales,employees)
--판매 관련 컬럼 (amount_sold , quantity_sold, sales_date)


select a.employee_id,
        (SELECT emp_name FROM employees 
         WHERE employee_id = a. employee_id) 직원이름
        ,TO_CHAR(판매금액, '999,999,999,999,99') 판매금액
        ,판매수량
from (select employee_id 
                ,sum(amount_sold) as 판매금액
                ,sum(quantity_sold) as 판매수량
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
