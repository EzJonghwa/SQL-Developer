-- 테이블 코멘트
COMMENT ON TABLE tb_info IS '우리반';
-- 컬럼 코멘트
COMMENT ON COLUMN tb_info.info_no IS '출석부 번호';
COMMENT ON COLUMN tb_info.pc_no IS '컴퓨터 번호';
COMMENT ON COLUMN tb_info.NM IS '이름';
COMMENT ON COLUMN tb_info.email IS '이메일';
COMMENT ON COLUMN tb_info.hobby IS '취미';
-- 테이블의 코멘트 정보를 검색해서 찾아서 

SELECT table_name ,comments
FROM all_tab_comments   -- 테이블 정보 조회
--all_col_comments
WHERE table_name='TB_INFO';

--NULL 조건식과 논리 조건식 (AND , OR ,NOT)

SELECT *
FROM departments
-- WHERE praent_id=''; X
WHERE parent_id IS NULL; -- NULL 값을 조회할 때는 IS / IS NOT



SELECT *
FROM departments
WHERE parent_id IS NOT NULL;  --NULL 값이 아닌것을 검색 할때


--IN 조건식 (여러개 or가 필요할 때)
--30,50,60,80 부서 조회
SELECT *
FROM employees
WHERE department_id IN(30,50,60,80);    -- 30 OR 50 or 60 or 80



--LIKE 검색 % (문자열 패턴 검색)
SELECT *
FROM tb_info
WHERE nm LIKE '이%'; -- 이 로 시작되는 모든 

SELECT *
FROM tb_info
WHERE nm LIKE '%호'; -- 호 로 끝나는 모든 


SELECT *
FROM tb_info
WHERE nm LIKE '%민%'; -- 중간에 민이 들어있는 모든 



SELECT *
FROM tb_info
WHERE nm LIKE '%' || :param_val || '%';     --매개변수 입력 테스트


-- 학생중에 이메일 주소가 naver인 학생을 조하세요
SELECT*
FROM tb_info
WHERE email LIKE '%naver%';

-- naver 와 gmail 이 아닌 
SELECT*
FROM tb_info
WHERE email NOT LIKE '%naver%' AND email NOT LIKE '%gmail%';


-- ＃데이터베이스에서 제공하는 함수
-- 대소문자

-- 문자열 함수 LOWER *소문자로 변경 UPPER *대문자로 변경
SELECT LOWER ('i like Mac') as lowers
, UPPER ('i like Mac') as uppers
FROM dual;  -- dual 임시 테이블 형태 *sql select 문법을 맞추기 위함  

-- 
SELECT emp_name, UPPER(emp_name)as upperNm, employee_id
FROM employees;

-- employees테이블 에서 -> william 이 포함된 직원을 모두 조회하시오
SELECT emp_name 
FROM employees
WHERE lower(emp_name) LIKE '%william%' ;
-- 방법 2
SELECT emp_name 
FROM employees
WHERE upper(emp_name) LIKE '%'||upper('william')||'%' ;
-- WHERE upper(emp_name) LIKE '%'||upper(':val')||'%' ; 입력에 따른 검색'
-- like 검색에서 길이까지 정확하게 찾고 싶을때

INSERT INTO TB_INFO (info_no, pc_no ,nm, email)
VALUES (19,01,'팽수','팽수@email.com');
INSERT INTO TB_INFO (info_no, pc_no ,nm, email)
VALUES (20,31,'김팽','팽수@email.com');
INSERT INTO TB_INFO (info_no, pc_no ,nm, email)
VALUES (21,32,'김팽수다','팽수@email.com');

SELECT*
FROM tb_info

-- 문자열 자르기 substr(char,pos,len)대상 문자열 char 의 pos 번째 부터 len 길이만큼 자름
SELECT SUBSTR('ABCD EFG',1,4) AS EX1    -- POS에 0 이오면 디폴트 1
,SUBSTR('ABCD EFG',4) AS EX2    --입력값이 두개일 경우 해당 인덱스 부터 끝까지
,SUBSTR('ABCD EFG',-3,3) AS EX3 -- 시작이 음수이면 뒤에서 부터
FROM dual;


-- 문자열 위치 찾기 INSTR (P1,P2,P3,P4) 
-- P1: 대상 문자열 ,P2: 찾을 문자열,P3:시작,P4:번째
SELECT INSTR('안녕 만나서 반가워, 안녕은hi','안녕') as ex1  -- p3,p4 디폴트 1
 ,INSTR('안녕 만나서 반가워, 안녕은hi','안녕',5) as ex2 
 ,INSTR('안녕 만나서 반가워, 안녕은hi','안녕',1,2) as ex3  -- 두번째 안녕 시작위치
 ,INSTR('안녕 만나서 반가워, 안녕은hi','hello') as ex4  -- 없으면 0
FROM dual;

--tb_info 학생의 이름과 이메일 주소를 출력하시오
--(단 이메일 주소는 id,domain 분리하여 출력하시오)
-- ex) pangsu@gmail.com -> id:pengsu ,domain:gmail.com

SELECT nm , email, 
SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1) AS 아이디,
SUBSTR(EMAIL,INSTR(EMAIL,'@')+1)  AS 도메인
FROM tb_info;

-- 공백제거 TRIM,LTRIN,RTIRN
SELECT LTRIM (' ABC ') as ex1
, RTRIM (' ABC ') as ex2
, TRIM (' ABC ') as ex3
FROM dual;
--  문자열 패딩 LPAD , RPAD;
SELECT LPAD(123,5,'0') as ex1   --(대상,길이,표현값)LPAD 는 왼쪽부터 채움
,LPAD(1,5,'0') as ex2
,LPAD(123456,5,'0') as ex3      -- 넘어서면 제거됨.(주의)
,RPAD(2,5,'*') as ex4           -- R 은 오른쪽 부터
FROM dual;


-- 문자열 변경 REPLACE(대상문자열,찾는값, 변경값)
SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?','나는','너를') as ex1
--          REPLACE 는 단어 정확히 매칭 TRANSLATE 는 한글자씩 매칭
,TRANSLATE('나는 너를 모르는데 너는 나를 알겠는가?','나는','너를') as ex2
FROM dual;























