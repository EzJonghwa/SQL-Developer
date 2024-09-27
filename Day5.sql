-- ROLLUP 
-- 그룹별 소계와 총계를 집계함
-- 표현식의 개수가 n이면 n+1 레벨까지, 하위 레벨에 상위레벨 순으로 데이터가 집계됨

-- 직업별 마일리지의 합계와 전체 합계 출력 
SELECT mem_job 
        , sum(mem_mileage) 마일리지합
FROM member
GROUP BY ROLLUP(mem_job);

-- 카테고리, 서브카테고리 별 상품수

SELECT prod_category
        , prod_subcategory
        , COUNT(prod_id) as 상품수
FROM products
GROUP BY ROLLUP (prod_category, prod_subcategory);




CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');



-- 행단위 집함 unnion union ALL minux , intersect
SELECT goods, seq
FROM exp_goods_asia
WHERE country = '한국'
UNION
SELECT goods, seq
FROM exp_goods_asia
WHERE country = '일본'
ORDER BY seq;   -- 마지막 SELECT 문에만 사용가능

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '한국'
UNION ALL   -- 각 SELECT 문의 결과 합
SELECT goods, seq
FROM exp_goods_asia
WHERE country = '일본'
ORDER BY seq;

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
MINUS   -- 차 집합
SELECT goods
FROM exp_goods_asia
WHERE country = '일본';

SELECT goods
FROM exp_goods_asia
WHERE country = '한국'
INTERSECT -- 교집합
SELECT goods
FROM exp_goods_asia
WHERE country = '일본'
UNION
SELECT '내용'
FROM dual;
-- 집합 대상의 컬럼의 수와 타입이 일치하면 사용가능.

SELECT gubun
, SUM(loan_jan_amt) as 대출합
from kor_loan_status
Group by gubun
union
SELECT '합계' ,SUM(loan_jan_amt)
FROM kor_loan_status;



/*
정규 표햔식 oracl 10g 부터 사용 가능 regexp_ <-로 시작하는 함수
    -(dot) of [] <-모든 문자 1글자를 의미함
    ^시작, $끝 [^]는 not 을 의미
    {n} :n번 반복 {n,} n 이상반복, {n,m} n이상 m 이하 반복, */
--REGEXP_LIKE : 정규식 패턴 검색
SELECT mem_name, mem_comtel
FROM member
WHERE REGEXP_LIKE(mem_comtel,'^..-') ;


-- mem_mail 데이터 중 영문자 시작 3~5 자리 이메일 주소 패턴 추출
SELECT mem_name, mem_mail
FROM member
WHERE REGEXP_LIKE (mem_mail, '^[a-zA-Z]{3,5}@');
-- mem_add2 주소에서 한글로 끝나는 패턴의 주소를 추출하시오
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2,'[가-힝]$');


-- 다음 패턴의 주소를 조회하시오
-- 한글 + 띄어쓰기 + 숫자 ex 아파트 5동
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2,'[가-힝] [0-9]');  

-- 한글만 있는 주소 검색
select mem_add2
FROM member
WHERE REGEXP_LIKE (mem_add2,'^[가-힝]+$');
--WHERE REGEXP_LIKE (mem_add2,'^[가-힝]{1,}$');
--WHERE REGEXP_LIKE (mem_add2,'^[가-힝]*$');



select mem_add2
FROM member
WHERE REGEXP_LIKE (mem_add2,'^[^가-힝]+$');

select mem_add2
FROM member
WHERE NOT REGEXP_LIKE (mem_add2,'[가-힝]');

-- | : 또는 , {} : 그룹
-- j로 시작하며, 세번째 문자가  M OR N인 직원 이름조회
SELECT emp_name
FROM employees;
WHERE REGEXP_LIKE(emp_name,'^J.(m|n)');

--REGEXP_SUBSTR 정규표현식 패턴과 일치하는 문자열을 반환
-- 이메일 기준으로 앞뒤 출력
SELECT mem_mail
,REGEXP_SUBSTR(mem_mail,'[^@]+',1,1) as 아이디
,REGEXP_SUBSTR(mem_mail,'[^@]+',1,2) as 이메일
FROM member;

SELECT REGEXP_SUBSTR('A-B-C', '[^-]+',1,1) as ex1
,REGEXP_SUBSTR('A-B-C', '[^-]+',1,2) as ex2
,REGEXP_SUBSTR('A-B-C', '[^-]+',1,3) as ex3
,REGEXP_SUBSTR('A-B-C', '[^-]+',1,4) as ex4
from dual;
--mem_add1 에서 공백을 기준으로 첫번째 단어를 출력하시오
SELECT REGEXP_SUBSTR(mem_add1, '[^ ]+',1,1)
,REGEXP_SUBSTR(mem_add1, '[^ ]+',1,2)
FroM member;

--REGEXP_REPLACE 대상 문자열에서
-- 정규 표현식 패턴을 적용하여 다른 패턴으로 대체
SELECT REGEXP_REPLACE('Ellen Hidi Smith'
                        ,'(.*) (.*) (.*)'
                        ,'\3, \1 \2') as re
FROM dual;
-- 대전의 주소등을 모드 '대전'으로 바꿔서 출력하시오 id:p001 제외
-- 대전 광역시 ->대전
-- 대전시 -> 대전
SELECT mem_add1
    --,REGEXP_REPLACE(mem_add1 ,'(대전시)|(대전광역시)', '대전') as re
    ,REGEXP_REPLACE(mem_add1 ,'(.{1,5}) (.*)', '대전 \2') as re
FROM member
WHERE mem_add1 LIKE '%대전%'
AND mem_id !='p001';
-- 펄 표기법 \w =[a-zA-Z0-9], \d = [0-9]
-- 전회번호 뒷자리에서 동일한 번호가 반복되는 사원 조회
SELECT emp_name , phone_number
FROM employees
WHERE REGEXP_LIKE(phone_number,'(\d\d)\1$');
--(\d\d\1$) (숫자숫자) \1첫번째 그룹 캡쳐 그룹을 다시 참조

-- ^\d*\.?\d{0,2}
-- ^  \d*  \.   ?\d{0,2}
-- 숫자







