-- member 계정의 member테이블을 조회하시오
-- 검색조건 :대전에 중구에 사는 여자
-- 주소는 mem_add
-- 성별은 mem_regno2 (홀수 남자, 짝수 여자)

SELECT *

FROM member;    

SELECT MEM_ID , MEM_NAME
,RPAD(SUBSTR(MEM_REGNO1 || '-'|| MEM_REGNO2,0,8),14,'*') AS REGNO
, MEM_ADD1
, MEM_ADD2
, MEM_JOB

FROM member
WHERE MEM_ADD1 LIKE '%대전%' AND MEM_ADD1 LIKE '%중구%' AND MEM_REGNO2 LIKE '2%';