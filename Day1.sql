/*
    TABLA 테이블
    1.테이블 명 컬럼명의 최대 길이는 30BYTE (영문자1개 1BYTE)
    2. 테이블명 컬럼명으로 예약어는 사용할 수없음 (select, varchar2...
    3. 테이블명 컬럼명으로 문자, 숫자, _,$,#, 을 용할 수 있지만 
        첫글자는 문자만 올 수있음
    4. 한 테이블에 사용 가능한 컬럼은 최대 255개

*/
-- 명령어는 대소문자 구별되지 않음.
-- 데이터는 대소문자구별됨

CREATE TABLE ex1_1(
    col1 CHAR(10)
    ,col2 VARCHAR2 (10)     -- 하나의 컬럼은 하나의 타입과 사이즈를 가짐
);
-- 테이블 삭제
DROP TABLE ex1_1; 
-- INSERT 데이터 삽입

INSERT INTO ex1_1 (col1, col2)
VALUES ('oracle','오라');
INSERT INTO ex1_1 (col1, col2)
VALUES ('oracle','오라클');

-- why? VARCHAR2 (10)로 설정했기에 
-- 오류: ORA-12899: "JAVA"."EX1_1"."COL2" 열에 대한 값이 너무 큼(실제: 11)가 발생
INSERT INTO ex1_1 (col1, col2)
VALUES ('oracle','오라클db');
-- 삽입 불가

-- 데이터 조회
SELECT *    -- 전체를 의미함
FROM ex1_1;

SELECT col1 --원하는 컬럼만 조회하고자 할때.
FROM ex1_1;

SELECT length(col1), length(col2)   -- 데이터의 길이를 나타냄
    , lengthb(col1), lengthb(col2)  -- 데이터의 바이트 수를 나타냄 한글 (3byle)
FROM ex1_1;
    -- 테이블은 그대로이나 SELECT로는 데이터를 출력하는것
    -- 컬럼이 4개가 나오는 이유!
    -- char (고정):10 / varchar (가변):10으로 설정했으나 넣은 값에 따라 변함.

-- 명령어는 대소문자를 구분하지 않음
-- 명령어를 쉽게 구분하려고 대소문자를 사용
-- SQL문은 보기 쉽게 들어쓰기를 해서 작성

SELECT *
FROM employees; --from 절은 조회하고자 하는 테이블 작성
        --결과 : employees 테이블의 데이터 출력
        
DESC employees;    -- type 과 사이즈를 확인 가능 작업전 확인 하는 것이 좋음.

SELECT emp_name    as nm       --AS ,as (alias 별칭)
,hire_date        hd          -- 콤마를 구분으로 컬럼명 띄어쓰기 이후 쓰면 
                                -- 별칭으로 인식
,salary            sa_la       -- 별칭으로 띄어쓰기는 안됨
,department_id     "부서 아이디" -- 한글은 "" 하지만 한글 별칭은 안씀.
FROM employees;
-- 검색조건 

SELECT *
FROM employees
WHERE salary >= 20000;
-- ex) 게시판의 검색 조건을 나타냄
-- 조건이 여러개 일 경우 AND or OR

SELECT *
FROM employees
WHERE salary >=1000     -- AND 는 그리고를 의미 (둘다 참)
AND salary <11000
AND department_id =80;

SELECT * 
FROM employees
WHERE department_id =30     --OR 은 또한을 의미 둘중 하나가 참인경우 출력
OR department_id =60;
--  정렬 조건order by ASC:오름 차순 DESC : 내림차순
SELECT emp_name, department_id
FROM employees
ORDER BY department_id, emp_name DESC;     -- default ASC(오름차순)


-- 사칙연산 사용가능 
SELECT emp_name
    ,salary as 월급
    ,salary - salary *0.1 as 실수령액
    ,salary *12 as 연봉
    , ROUND(salary/30,2) as 일당
FROM employees
ORDER BY 연봉 DESC;
-- 실행 순서 FROM ->WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
-- 위에서 부터 내려오는 절차적언어가 아닌 정해진 순서에 따라 정해짐.
-- 쿼리 안에 쿼리가 들어가는 경우 해석시 실행 순서에따라 해석해야함.
    
/*
    제약조건 
    NOT NULL 널을 허용하지 않겠다.
    UNIQUE 중복을 허용하지 않겠다.
    CHECK 특정 데이터만 받겠다.
    PRIMARY KEY 기본키 (하나의 테이블에 1개만 설정가능(두개의 컬럼으로도 가능)
                        하나의 행을 구분하는 식별자 OR  키값이라고 하며 PK라고함
                        PK 는 기본적으로 UNIQUE 하며 NOT NULL 임
    FOREIGN KEY 외래키 다른 테이블의 PK 를 참조하는 키
*/

CREATE TABLE ex1_2(
      mem_id VARCHAR2(100) NOT NULL UNIQUE      
    , mem_nm VARCHAR2(100)  -- null 허용
    , mem_email VARCHAR2(100) NOT NULL
    ,CONSTRAINT uq_ex1_2 UNIQUE(mem_email)  -- 제약조건의 이름을 관리하고 싶을때
            -- uq_ex_2 라는 이름으로 
);


INSERT INTO ex1_2 (mem_id,mem_email)
VALUES ('a001','a001@gmail.com');   -- default가 null 허용이기 때문에 mem_nm 없어도 됨
INSERT INTO ex1_2 (mem_id,mem_email)
VALUES ('A001','A001@gmail.com');   -- 대 소문자를 구분함. 

SELECT *
FROM ex1_2;
-- 아이디만 삽입 하거나 이메일만 삽입 하려고 하면 오류ㅅ발생
INSERT INTO ex1_2(mem_id)
VALUES ('b001');

SELECT*
FROM user_constraints
WHERE table_name = 'EX1_2';
-- 내부에서 저장될 때는 대문자로 저장됨

/* 숫자 데이터 타입(number)
    number(p,s) p는 소수점을 기준으로 모든 유효숫자 자릿수를 의미함.
    s 는 소수점 자리수를 의미함 (디폴트 0)
    s가 2이면 소수점 2자리까지 (나머지는 반올림)
    s가 음수이면 소수점 기준 왼쪽 자리수 만큼 반올림
*/

CREATE TABLE ex1_3(
     num1 NUMBER(3)     -- 정수만 3자리
    ,num2 NUMBER(3,2)  -- 정수1 소수점2
    ,num3 NUMBER(5,-2) -- 십의자리까지 만 올림 (총 7자리)
    ,num4 NUMBER --38

);
                                    -- 정수만 3자리 = 반올림됨 NUMBER(3)
INSERT INTO ex1_3 (num1) VALUES (0.7878);
INSERT INTO ex1_3 (num1) VALUES (99.5); -- 
INSERT INTO ex1_3 (num1) VALUES (1004); --오류남 -자릿수 문제

SELECT * FROM ex1_3;

                                     -- 정수1 소수점2 NUMBER(3,2)
INSERT INTO ex1_3 (num2) VALUES (0.7878);
INSERT INTO ex1_3 (num2) VALUES (1.7898); 
INSERT INTO ex1_3 (num2) VALUES (9.9999);   -- 오류 반올림시 정수 두자리
INSERT INTO ex1_3 (num2) VALUES (32);       -- 정수 두자리

SELECT * FROM ex1_3;

                     -- 십의자리까지 만 올림 (총 7자리)num3 NUMBER(5,-2)
INSERT INTO ex1_3 (num3) VALUES (12345.2345);
INSERT INTO ex1_3 (num3) VALUES (1234569.2345); 
INSERT INTO ex1_3 (num3) VALUES (12345699.2345);   -- 오류 7자리 넘음

SELECT * FROM ex1_3;


                    -- 자릿수 지정을 하지 않으면 기본 38 자리까지 설정됨.
INSERT INTO ex1_3 (num4) VALUES (14123493.34892340);
SELECT * FROM ex1_3;

/*
    날짜 데이터 타입(date 년월일시분초 ,timestamp (년월시분일초.밀리초)
    sysdate <-현재시간, systimestamp <-현재 밀리초까지
*/

CREATE TABLE ex1_4(
    date1 DATE
    ,date2 TIMESTAMP

);
INSERT INTO ex1_4 VALUES (SYSDATE, SYSTIMESTAMP);
SELECT * FROM ex1_4;



/* CHECK 제약조건 */

CREATE TABLE ex1_5(
    nm VARCHAR2(100)
    ,age NUMBER
    ,gender VARCHAR2(1)
    ,CONSTRAINT ck_ex1_5_age CHECK (age BETWEEN 1 AND 150)
    ,CONSTRAINT ck_ex1_5_gender CHECK (gender IN ('F','M'))
);
INSERT INTO ex1_5 VALUES('펭수',10,'M');
SELECT * FROM ex1_5;
INSERT INTO ex1_5 VALUES ('길동',100,'F');
SELECT * FROM ex1_5;

CREATE TABLE dep(
    deptno NUMBER(3) PRIMARY KEY    --기본키
    ,dept_nm VARCHAR2(20)
    ,dep_floor NUMBER(5)
);
CREATE TABLE emp (
    empno NUMBER(5) PRIMARY KEY
    ,emp_nm VARCHAR2(20)
    ,title VARCHAR2(20)             -- 해당테이블의 컬럼을 참조하겠다.
    ,dno NUMBER(3) CONSTRAINT emp_fk REFERENCES dep(deptno)     
    -- 외래키 dep(deptno) 을 참조한다
);

INSERT INTO dep VALUES (1,'영업',8);
INSERT INTO dep VALUES (2,'기획',9);
INSERT INTO dep VALUES (3,'개발',10);

INSERT INTO emp VALUES (100,'펭수','대리',2);
INSERT INTO emp VALUES (200,'길동','과장',3);
INSERT INTO emp VALUES (300,'동수','부장',1);
INSERT INTO emp VALUES (300,'동동식','이사',4);  -- 참조하는 곳에 데이터가 없어서 무결성에 위배됨

SELECT * FROM dep;
SELECT * FROM emp;

SELECT *
FROM emp, dep
WHERE emp.dno = dep.deptno  -- 관계를 맺는 방법(조인)
AND emp.emp_nm ='펭수';






