CREATE TABLE ex2_1(
    col1 VARCHAR2(100)
    ,col2 NUMBER
    ,col3 DATE
);

--INSERT 데이터 삽입
-- 방법1. 기본형태 컬럼명 작성
INSERT INTO ex2_1(col1,col2,col3)
VALUES ('nick',10,sysdate);
--문자열 타입은 '' 숫자 타입은 그냥 숫자 하지만 문자열인데 숫자라면 가능
INSERT INTO ex2_1(col1,col2,col3)
VALUES ('jack','10',sysdate);



--특정 컬럼에만 삽입할 떄는 무조건 컬럼명 써야함.
INSERT INTO ex2_1 (col1)
VALUES('judy');

-- 방법2.테이블에 있는 전체 컬럼에 삽입할 떄는 안써도됨
INSERT INTO ex2_1 VALUES ('펭수',10,sysdate);

--방법 3. SELECT -INSERT 조회 결과를 삽입
-- 수용 가능한 데이터 타입이 맞아야한다
INSERT INTO ex2_1(col1)
SELECT emp_name 
FROM employees;

SELECT *FROM ex2_1;
--UPDATE 데이터 수정
UPDATE ex2_1
SET col3 = sysdate; -- set에는 수정하고자하는 데이터
-- where 절이 없으면 테이블 전체가 업데이트됨

UPDATE ex2_1
SET col2 =20
,col3=sysdate
WHERE col1 ='nick';
COMMIT; --변경이력 반영
ROLLBACK; -- 변경이력 취소

-- DELETE 데이터 삭제
DELETE ex2_1;   -- 테이블전체 내용삭제
--delete 도 update와 같이 검색조건 중요함
DELETE ex2_1
WHERE col1 ='nick'; -- 해당 조건이 만족하는 행을 삭제.



DROP TABLE dep;
-- 참조하는 테이블이 존재하기 떄문에 삭제 할 수없음.
-- 제약 조건도 삭제 후 테이블 삭제
DROP TABLE dep CASCADE CONSTRAINTS;

-- 산술연산자 *+/-
-- 문자연산자 (|| 문자열 더하 연산)
SELECT employee_id || '-' || emp_name as emp_info
FROM employees;
-- 논리 연산자 :>,<,>=,<=,<>,!=.^=
SELECT * FROM employees WHERE salary = 2600;    -- 같다
SELECT * FROM employees WHERE salary <> 2600;   -- 같지않다
SELECT * FROM employees WHERE salary != 2600;   -- 같지않다
SELECT * FROM employees WHERE salary ^= 2600;   -- 같지않다
SELECT * FROM employees WHERE salary > 2600;    -- 초과
SELECT * FROM employees WHERE salary < 2600;    -- 미만
SELECT * FROM employees WHERE salary <= 2600;   -- 이하
SELECT * FROM employees WHERE salary >= 2600;   -- 이상

-- 표현식 CASE WHEN 조건1 THEN 조건1이 true 일때
--            WHEN 조건2 THEN 조건2이 true 일때 
--          ELSE 그밖에
--      END 종료
-- 5000이하 C등급, 5000 초과 15000 이하 B등급, 그밖에는 A등급
SELECT employee_id ,salary
    ,CASE WHEN salary <=5000 THEN 'C등급'
        WHEN salary >5000 AND salary <=15000 THEN 'B등급'
        ELSE 'A등급'
    END as grade    -- 한컬럼에 동일하게 위치하기에 타입이 같아야함
FROM employees;

--customer 테이블에서
-- 고객의 이름과 출생년도 성별을 출력하세요(성별의 표현은 F :여자/ M: 남자)

SELECT CUST_NAME, CUST_YEAR_OF_BIRTH
    ,CASE WHEN CUST_GENDER ='M' THEN '남자'
            WHEN CUST_GENDER ='F' THEN '여자'
            END AS GENDER
FROM customers;
SELECT *
FROM CUSTOMERS;


-- 1. 필요한 데이터를 먼저 조회하기
DESC CUSTOMERS;

SELECT CUST_NAME
, CUST_GENDER
, CASE WHEN CUST_GENDER ='F' THEN '여자'
        WHEN CUST_GENDER ='M' THEN '남자'
        END AS GENDER
, CUST_YEAR_OF_BIRTH
FROM CUSTOMERS
ORDER BY CUST_YEAR_OF_BIRTH DESC, CUST_NAME ASC;

-- 컬럼명 쓰기가 귀찮을 때 테이블 기준의 순서로 번호를 매겨서 사용 가능


--1990 년 출생이며 남자만 조회하시오
SELECT CUST_NAME
, CUST_GENDER
, CASE WHEN CUST_GENDER ='F' THEN '여자'
        WHEN CUST_GENDER ='M' THEN '남자'
        END AS GENDER
, CUST_YEAR_OF_BIRTH
FROM CUSTOMERS
WHERE CUST_YEAR_OF_BIRTH =1990 AND CUST_GENDER ='M'

ORDER BY 4 DESC, 1 ASC;

-- 계정 생성    'id:member''pw:member'
-- 권한 부여   
-- 해당 계정에 접속하여 ->> MEMBER_TABLE(UTF-8).SQL 파일 실행 (TABLE &DATA)
-- 







