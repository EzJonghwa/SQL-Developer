-- DECODE 표현식


SELECT cust_name
        ,cust_gender
        --      (대상 컬럼 , 조건1, true 일때)
        ,DECODE (cust_gender, 'M' , '남자') as gender
        --      (대상 컬럼 , 조건1, true 일때/ 그밖에else)
        ,DECODE (cust_gender, 'M' , '남자','여자') as gender
        --      (대상 컬럼 , 조건1, true 일때/ 조건 2가 true 일때)
        ,DECODE (cust_gender, 'M' , '남자','F','여자') as gender
        --      (대상 컬럼 , 조건1, true 일때/ 조건 2가 true 일때/ 그밖에 else)
        ,DECODE (cust_gender, 'M' , '남자','F','여자','?') as gender
FROM customers;

SELECT mem_name ,mem_regno2
,DECODE (substr(mem_regno2,1,1),'1','남자','여자') as gender 


FROM member;

/* 변환 함수 (타입) 타입변환 많이함.***
    to_char     문자형으로
    to_date     날짜형으로
    to_number   숫자형으로
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
-- RR은 세기를 자동으로 추적 50 -> 1950, 49->2049
-- y2k  2000년 문제에 대한 대응책으로 도입.
,TO_DATE('50','RR') AS ex5
FROM dual;

CREATE TABLE ex4_1(
    title VARCHAR2(100)
    ,D_DAY DATE
);
INSERT INTO ex4_1 VALUES ('시작일','20240802');
INSERT INTO ex4_1 VALUES ('종료일','2025.01.17');

INSERT INTO ex4_1 VALUES('탄소교육','2024 09 04');
INSERT INTO ex4_1 VALUES('회식','2024 09 06 18:05:00');-- 오류남

INSERT INTO ex4_1 VALUES('회식',TO_DATE('2024 09 06 18:05:00','YYYY MM DD HH24:MI:SS'));
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
-- 문자형태이기 때문에 첫 글자의 수를 기준으로 하기 때문에 내림차순 오름차순시 원하는 값이 안나올 수 있음
-- to number 을 이용해서 숫자화 해야함


--member 회원의 생년월일을 이용하여 나이를 걔산하시오
--올해년도 를 이용하여 (ex 2024 -2000 ->24세)
--정렬은 나이 내림차순
SELECT mem_name ,mem_bir,
TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(MEM_BIR,'YYYY')||'세' AS 나이
FROM member
ORDER BY 나이 DESC;

/* 숫자 함수(매개변수 숫자형)
ABS:절대값, ROUND :반올림 ,TRUNC:버림, CEIL :올림 ,MOD:나머지값, SQRT:제곱근
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

/*날짜 함수*/
-- ADD_MONHTS(날짜 데이터,1)     다음달
-- LAST_DAY     마지막 날, NEXT_DAY     다음오는 요일
SELECT ADD_MONTHS(SYSDATE,1) AS ex1
        ,ADD_MONTHS(SYSDATE,-2) AS ex2
        ,LAST_DAY(SYSDATE)      AS ex3
        ,NEXT_DAY(SYSDATE ,'화요일') AS ex4
        ,NEXT_DAY(SYSDATE ,'수요일') AS ex4
FROM dual;

SELECT SYSDATE -1 as ex1    --어제
        , ADD_MONTHS(SYSDATE,1)-ADD_MONTHS(SYSDATE,-1) as ex2
        --sysdate 를 이용했기에 둘다 시간이 같음 그래서 일자로 정확히 출력됨
FROM dual;

SELECT mem_name, mem_bir
        ,sysdate -mem_bir
        ,TO_CHAR(sysdate,'YYYYMMDD')- TO_CHAR(mem_bir,'YYYYMMDD') as ex1
        ,TO_DATE(TO_CHAR(sysdate,'YYYYMMDD'))- TO_DATE(TO_CHAR(mem_bir,'YYYYMMDD')) as ex2 -- 날짜계산
FROM member;

-- 이번달은 몇일 남았을까요?
SELECT TO_CHAR(LAST_DAY(SYSDATE),'DD')- TO_CHAR(SYSDATE,'DD') AS 이번달
,TO_DATE('2024 09 06')- TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDD')) AS 회식까지
FROM dual;

-- DISTINCT 중복된 데이터를 제거하고 고유한 값을 반환( 특정 컬럼의 고유한 값만 보고싶을때)
SELECT DISTINCT mem_job, MEM_LIKE
        -- 행조합이 중복 되지 않는 행만 반환
FROM member;

SELECT DISTINCT prod_category , prod_subcategory
FROM products
order by 1;

-- NVL (칼람 변환값)
SELECT emp_name, salary , commission_pct, salary +(salary*commission_pct) as 상여포함
, salary +(salary*nvl(commission_pct,0)) as 상여포함

FROM employees;

-- 직원중 근속년수가 20년 이상인 직원만 출력하시오!
SELECT EMP_NAME ,HIRE_DATE,
TO_CHAR(sysdate,'YYYY')- TO_CHAR(hire_date,'YYYY') AS 근속년수
FROM employees

WHERE TO_CHAR(sysdate,'YYYY')- TO_CHAR(hire_date,'YYYY') >=25
-- 검색조건절 에서는 ALIAS 별명을 사용할 수 없어서 원본식을 넣어줘야함
ORDER BY 근속년수 DESC;

/*
고객 테이블(CUSTOMERS)에는
고객의 출생년도(CUST_YEAR_OF_BIRTH) 컬럼이 있다.
현재일 기준으로 이 컬럼을 활용해 30대,41대,50대를 구분하여 출력하고
나머지 연령대는 '기타' 로 출력하는 쿼리를 작성해보자
(1990년생 이상 출생) 정렬은 연령 오름차순
*/

SELECT CUST_YEAR_OF_BIRTH
,TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth AS 나이
,CASE WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=60 THEN '기타'
        WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=50 THEN '50대'
        WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=40 THEN '40대'
        WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=30 THEN '30대'
END AS 연령대
FROM CUSTOMERS
WHERE CUST_YEAR_OF_BIRTH >=1990
ORDER BY 연령대;

SELECT *
FROM CUSTOMERS;




SELECT CUST_YEAR_OF_BIRTH
,TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth AS 나이
,CASE WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=30 THEN '30대'
WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=40 THEN '40대'
WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=50 THEN '50대'
WHEN TO_CHAR(SYSDATE,'YYYY')-cust_year_of_birth >=60 THEN '기타'
        
END AS 연령대
FROM CUSTOMERS

ORDER BY 연령대;

/*
    집계 함수와 그룹바이절
    집계함수 대상 데이터에 대해, 총합, 평균, 최댓값, 최솟값 등을 구하는 함수
    그룹바이 절 대상 데이터를 특정 그룹으로 묶는 방법
*/
-- count row 수를 반환하는 집계함수
SELECT COUNT(*)                 -- null 값을 포함
,COUNT(department_id)           -- default all      -null값이 존재
,COUNT(ALL department_id)       -- 중복포함,null x   
,COUNT(DISTINCT department_id)  -- 중복제거          - 부서의 전체 갯수
,COUNT(employee_id)             -- employees 테이블의 pk-기본키-null허용X (*) 같음
FROM employees;

SELECT SUM(salary)      as 합계
,MAX(salary)            as 최대
,MIN(salary)            as 최소
,ROUND(AVG(salary),2)   as 평균
,COUNT(employee_id)     as 직원수
FROM employees;         -- 집계대상

SELECT department_id
,SUM(salary)      as 합계
,MAX(salary)            as 최대
,MIN(salary)            as 최소
,ROUND(AVG(salary),2)   as 평균
,COUNT(employee_id)     as 직원수
FROM employees         -- 직원 테이블의 
WHERE department_id IS NOT NULL
AND department_id IN (30,60,90)
-- + AND 다른 조건이 있다면 FROM -사이- GROUP 
GROUP BY department_id -- 부서별 (그룹으로 집계)
ORDER BY 1;

-- MEMBER 회원수와 마일리지 합계, 평균을 출력 하시오

SELECT MEM_JOB              as 직업
,count(*)                   as 회원수
,sum (mem_mileage)          as 합계
,ROUND(avg(mem_mileage),2)  as 평균
FROM member
GROUP BY MEM_JOB
ORDER BY 3 DESC;
-- ROWNUM 의사 컬럼 테이블에는 없지만 있는것 처럼 사용 가능


SELECT ROWNUM as rnum
        ,mem_name
        
FROM MEMBER
WHERE ROWNUM <= 10;

-- HAVING 집계 결과에 대해서 검색 조건을 추가하고 싶을때 사용
-- EX) 직업별 마일리지 합계가 10000 이상 
SELECT MEM_JOB              as 직업
,count(*)                   as 회원수
,sum (mem_mileage)          as 합계
,ROUND(avg(mem_mileage),2)  as 평균
FROM member
HAVING sum (mem_mileage) >= 10000   -- 집계결과에 검색조건 WHERE(단순 검색 조건) 절과는 다른 개념
GROUP BY MEM_JOB
ORDER BY 3 DESC;

-- KOR_LOAN_STATUS 테이블의 LOAN_JAN_AMT(대출액)
-- 2013년도 기간별 / 지역별  총 대출 잔액을 출력하시오

SELECT SUBSTR(period,1,4)  as 년도
        ,REGION as 지역
        ,sum(loan_jan_amt) as  대출합
FROM KOR_LOAN_STATUS
WHERE period LIKE '2013%'
-- WHERE substr(period,1,4) ='2013';
GROUP BY SUBSTR(period,1,4) ,REGION;


--2013 년도 지역별 구분별 합계
SELECT SUBSTR(period,1,4)  as 년도
        ,REGION as 지역
        ,gubun as 구분
        ,sum(loan_jan_amt) as  대출합
FROM KOR_LOAN_STATUS
WHERE period LIKE '2013%'
-- WHERE substr(period,1,4) ='2013';
GROUP BY SUBSTR(period,1,4) ,REGION, gubun
ORDER BY 2;


--  지역별 대출의 합계 200000 이상인 결과를 출력하시오 
-- 대출 잔액 내림차순
SELECT 
REGION as 지역,
sum(loan_jan_amt) as 대출합
FROM KOR_LOAN_STATUS
HAVING sum(loan_jan_amt)>=200000
GROUP BY REGION
ORDER BY 2 DESC;

-- 대전 서울 부산의
-- 년도별 대출의 합계에서
-- 대출의 합이 60000 넘는 결과를 출력하시오
-- 정렬 지역 오름차순, 대출합 내림차순
SELECT SUBSTR(PERIOD,1,4) AS 년도
,REGION AS 지역
,sum(loan_jan_amt) as 대출합
FROM KOR_LOAN_STATUS
WHERE REGION IN ('대전','서울','부산')
GROUP BY SUBSTR(period,1,4), REGION
HAVING sum(loan_jan_amt) >=60000
ORDER BY 2,3 DESC;

-- employees 직원들의 입사년도별 직원수를 출력하시오
SELECT 
to_char(hire_date,'yyyy')   as 년도,
count(employee_id)          as 직원수
FROM employees
GROUP BY to_char(hire_date,'yyyy')
having count(employee_id)  >=10
order by 1 asc;

-- CUSTOMER 회원의 전체 회원수, 남자 회원수, 여자 회원수를 출력하시오

SELECT  count(decode (CUST_GENDER ,'F','여자')) as 여자
        ,SUM(decode (CUST_GENDER ,'F',1,0)) as 여자2
        ,count(decode (CUST_GENDER ,'M','남자')) as 남자
        ,SUM(decode (CUST_GENDER ,'M',1,0)) as 남자2
        ,COUNT (CUST_GENDER)   as 전체
--SUM (CUST_GENDER) AS 남자,
--SUM (CUST_GENDER) AS 여자
FROM CUSTOMERS;

SELECT 
COUNT(*) AS 전체
,SUM(CASE WHEN CUST_GENDER = 'F' THEN 1
END) AS 여자
,SUM(CASE WHEN CUST_GENDER = 'M' THEN 1
END) AS 남자
FROM CUSTOMERS;


SELECT emp_name, email
FROM employees;

-- 1. 정렬 요일 일요일 부터 -(employees,hire _date)
SELECT 
DECODE(TO_CHAR(HIRE_DATE,'D') ,1,'일' ,2,'월' ,3,'화' ,4,'수' ,5,'목' ,6,'금' ,7,'토') AS 요일
,COUNT(*)
FROM employees
GROUP BY TO_CHAR(HIRE_DATE,'D')
ORDER BY TO_CHAR(HIRE_DATE,'D');


--2. 년도별 요일의 고용인원수를 출력하시오.
--(employees ,hire_date)사용
-- 정렬 년도 오름차순
SELECT 
to_char(hire_date,'YYYY') AS 년도
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,1,'일')) as sun
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,2,'월')) as mon
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,3,'화')) as tue
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,4,'수')) as wed
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,5,'목')) as thu
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,6,'금')) as fri
, COUNT(DECODE(TO_CHAR(HIRE_DATE,'D') ,7,'토')) as sat
, COUNT(TO_CHAR(HIRE_DATE)) AS 년도별고용직원의합계
FROM employees
GROUP BY to_char(hire_date,'YYYY')
ORDER BY 1;


select *
from employees;





