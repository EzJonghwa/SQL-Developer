/*
 STUDY 계정에 create_table 스크립트를 실해하여 
 테이블 생성후 1~ 5 데이터를 임포트한 뒤 
 아래 문제를 출력하시오 
 (문제에 대한 출력물은 이미지 참고)
*/
-----------1번 문제 ---------------------------------------------------
--1988년 이후 출생자의 직업이 의사,자영업 고객을 출력하시오 (어린 고객부터 출력)
SELECT *
FROM CUSTOMER
WHERE TO_CHAR(TO_DATE(BIRTH),'YYYY') >='1988'
--  == TO_NUMBER(SUBSTR(BIRTH,1,4))>=1988 VARCHAR 타입이라서 바로 가능
AND JOB IN('의사','자영업')
ORDER BY TO_CHAR(TO_DATE(BIRTH),'YYYY') DESC;
---------------------------------------------------------------------
-----------2번 문제 ---------------------------------------------------
--강남구에 사는 고객의 이름, 전화번호를 출력하시오 
SELECT a.customer_name , a.phone_number
FROM customer a,
ADDRESS b
WHERE a.zip_code = b.zip_code and b.ADDRESS_DETAIL IN ('강남구');

SELECT a.customer_name , a.phone_number
FROM customer a, address b
WHERE a.zip_code = b.zip_code 
and b.ADDRESS_DETAIL IN ('강남구');
---------------------------------------------------------------------
----------3번 문제 ---------------------------------------------------
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 (직업 NULL은 제외)

SELECT JOB ,COUNT(NVL(JOB,0)) AS CNT
FROM CUSTOMER
WHERE job IS NOT NULL
GROUP BY JOB
ORDER BY CNT DESC , JOB DESC;


---------------------------------------------------------------------
----------4-1번 문제 ---------------------------------------------------
-- 가장 많이 가입(처음등록)한 요일과 건수를 출력하시오 
SELECT *
FROM (SELECT TO_CHAR(FIRST_REG_DATE,'DAY')AS 요일, COUNT(TO_CHAR(FIRST_REG_DATE,'DAY'))AS 건수
FROM CUSTOMER
GROUP BY TO_CHAR(FIRST_REG_DATE,'DAY')
ORDER BY 2 DESC)
WHERE ROWNUM =1;

SELECT *
FROM ( SELECT TO_CHAR(first_reg_date,'day') as 요일   
        ,count(*) as cnt
FROM customer
    GROUP BY TO_CHAR (first_reg_date,'day')
    ORDER BY 2 DESC)
WHERE ROWNUM =1;

---------------------------------------------------------------------
----------4-2번 문제 ---------------------------------------------------
-- 남녀 인원수를 출력하시오 


SELECT NVL(DECODE (SEX_CODE ,'F','여자' ,'M','남자','미등록'),'총합') GENDER
     ,COUNT(DECODE (SEX_CODE ,'F','여자' ,'M','남자','미등록')) CNT
    FROM CUSTOMER 
    GROUP BY ROLLUP (DECODE (SEX_CODE ,'F','여자' ,'M','남자','미등록'))
    ORDER BY 
        CASE WHEN NVL(DECODE (SEX_CODE ,'F','여자' ,'M','남자','미등록'),'총합') = '여자' THEN 1
        WHEN NVL(DECODE (SEX_CODE ,'F','여자' ,'M','남자','미등록'),'총합') = '남자' THEN 2
        WHEN NVL(DECODE (SEX_CODE ,'F','여자' ,'M','남자','미등록'),'총합') = '미등록' THEN 3
        ELSE 4
        END , CNT ASC;
        
--방법1
SELECT NVL(gender,'합계') AS gender
    ,count(*) as cnt
    FROM(
SELECT DECODE (SEX_CODE ,'M','남자','F','여자','미등록') gender
FROM customer)
GROUP BY ROLLUP(gender);
--방법2
--grouping_id : 그룹화를 진행할 때, 여러 컬럼에 대한 서브 토탈을 구별하기 위한 함수
-- 집계의 레벨에 따라서 리턴값이 달라짐 총계,소계 등을 사용해서 구별된 출력물을 만들 때 사용
SELECT CASE WHEN sex_code ='F' THEN '여자' 
            WHEN sex_code ='M' THEN '남자'
            WHEN sex_code IS NULL AND gid = 0 THEN '미등록'
            ELSE '합계'
            END as gender, cnt
        FROM(       
            SELECT sex_code
            , count(*) as cnt
            , grouping_id(sex_code) as gid
            FROM customer
            GROUP BY ROLLUP(sex_code)
        );







---------------------------------------------------------------------
----------5번 문제 ---------------------------------------------------
--월별 예약 취소 건수를 출력하시오 (많은 달 부터 출력)
SELECT*
FROM RESERVATION;

SELECT TO_CHAR(TO_DATE(RESERV_DATE),'MM'),
COUNT(CANCEL)
FROM RESERVATION
GROUP BY TO_CHAR(TO_DATE(RESERV_DATE),'MM')
where cancel ='Y'
ORDER BY 1 DESC;



SELECT TO_CHAR(TO_DATE(reserv_date),'MM') as 월
        ,COUNT(*) as cnt
FROM RESERVATION
where cancel ='Y'
GROUP BY TO_CHAR(TO_DATE(RESERV_DATE),'MM')
ORDER BY 2 DESC;
----------6번 문제 ---------------------------------------------------
 -- 전체 상품별 '상품이름', '상품매출' 을 내림차순으로 구하시오 
-----------------------------------------------------------------------------

SELECT
PRODUCT_NAME 상품이름
        , A.PRICE*B.PRI 상품매출
FROM ITEM A , (SELECT ITEM_ID ,SUM(QUANTITY) AS PRI
FROM ORDER_INFO
GROUP BY ITEM_ID) B
WHERE A.ITEM_ID = B.ITEM_ID
ORDER BY 2 DESC;

SELECT B.PRODUCT_NAME
,SUM(A.SALES) AS 상품매출
FROM ORDER_INFO A, ITEM B
WHERE A.ITEM_ID = B.ITEM_ID
GROUP BY B.ITEM_ID, B.PRODUCT_NAME
ORDER BY 2 DESC;

---------- 7번 문제 ---------------------------------------------------
-- 모든상품의 월별 매출액을 구하시오 
-- 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
----------------------------------------------------------------------------

SELECT SUBSTR(RESERV_NO,0,6) 매출월
,SUM(NVL(DECODE(ITEM_ID,'M0001',SALES),0)) SPECIAL_SET
,SUM(NVL(DECODE(ITEM_ID,'M0002',SALES),0)) PASTA
,SUM(NVL(DECODE(ITEM_ID,'M0003',SALES),0)) PIZZA
,SUM(NVL(DECODE(ITEM_ID,'M0004',SALES),0)) SEA_FOOD
,SUM(NVL(DECODE(ITEM_ID,'M0005',SALES),0)) STEAK
,SUM(NVL(DECODE(ITEM_ID,'M0006',SALES),0)) SALAD_BAR
,SUM(NVL(DECODE(ITEM_ID,'M0007',SALES),0)) SALAD
,SUM(NVL(DECODE(ITEM_ID,'M0008',SALES),0)) SANDWICH
,SUM(NVL(DECODE(ITEM_ID,'M0009',SALES),0)) WINE
,SUM(NVL(DECODE(ITEM_ID,'M0010',SALES),0)) JUICE
FROM ORDER_INFO 
GROUP BY SUBSTR(RESERV_NO,0,6)
ORDER BY 1;



--
SELECT SUBSTR(a. reserv_date,1,6) as 매출월
        ,SUM(DECODE (b.item_id,'M0001',B.SALES,0)) AS SPECIAL_SET
        ,SUM(DECODE (b.item_id,'M0002',B.SALES,0)) AS PASTA
        ,SUM(DECODE (b.item_id,'M0003',B.SALES,0)) AS PIZZA
        ,SUM(DECODE (b.item_id,'M0004',B.SALES,0)) AS SEA_FOOD
        ,SUM(DECODE (b.item_id,'M0005',B.SALES,0)) AS STEAK
        ,SUM(DECODE (b.item_id,'M0006',B.SALES,0)) AS SALAD_BAR
        ,SUM(DECODE (b.item_id,'M0007',B.SALES,0)) AS SALAD
        ,SUM(DECODE (b.item_id,'M0008',B.SALES,0)) AS SANDWICH
        ,SUM(DECODE (b.item_id,'M0009',B.SALES,0)) AS WINE
        ,SUM(DECODE (b.item_id,'M00010',B.SALES,0)) AS JUICE
FROM reservation a ,order_info b
    where a.reserv_no = b.reserv_no
GROUP BY SUBSTR(a. reserv_date,1,6)
ORDER BY 1;



---------- 8번 문제 ---------------------------------------------------
-- 월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
-- 날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오 
----------------------------------------------------------------------------
SELECT SUBSTR(RESERV_NO,0,6) 날짜
,B.PRODUCT_NAME 상품명
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),1,B.PRICE*A.QUANTITY),0)) 일요일
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),2,B.PRICE*A.QUANTITY),0)) 월요일
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),3,B.PRICE*A.QUANTITY),0)) 화요일
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),4,B.PRICE*A.QUANTITY),0)) 수요일
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),5,B.PRICE*A.QUANTITY),0)) 목요일
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),6,B.PRICE*A.QUANTITY),0)) 금요일
,SUM(NVL(DECODE(TO_CHAR(TO_DATE(SUBSTR(RESERV_NO,0,8)),'D'),7,B.PRICE*A.QUANTITY),0)) 토요일
FROM ORDER_INFO A , ITEM B
WHERE B.PRODUCT_NAME = 'SPECIAL_SET' AND A.ITEM_ID = B.ITEM_ID
GROUP BY SUBSTR(RESERV_NO,0,6),B.PRODUCT_NAME 
ORDER BY 1;





SELECT 매출월 , 상품이름 
        ,SUM(DECODE(요일,'1',sales,0)) as 일요일
        ,SUM(DECODE(요일,'2',sales,0)) as 일요일
        ,SUM(DECODE(요일,'3',sales,0)) as 일요일
        ,SUM(DECODE(요일,'4',sales,0)) as 일요일
        ,SUM(DECODE(요일,'5',sales,0)) as 일요일
        ,SUM(DECODE(요일,'6',sales,0)) as 일요일
        ,SUM(DECODE(요일,'7',sales,0)) as 일요일

        
FROM(
SELECT a.reserv_date        as 매출월
        ,c.product_desc     as 상품이름
        ,TO_CHAR(TO_DATE(a.reserv_date),'d') as 요일
        ,b.sales
FROM reservation a
    ,order_info b
    ,item c
WHERE a.RESERV_NO = b.RESERV_NO
AND b.item_id = c.item_id
AND c.PRODUCT_DESC ='온라인 전용상품')
GROUP BY 매출월, 상품이름;


--




---------- 9번 문제 ----------------------------------------------------
--매출이력이 있는 고객의 주소, 우편번호, 해당지역 고객수를 출력하시오
----------------------------------------------------------------------------

-- 중복제거 --


SELECT T2.ADDRESS_DETAIL AS 주소
, COUNT(*) AS 회원수
FROM (
        SELECT DISTINCT a.customer_id , a.zip_code
        FROM customer a , reservation b , order_info c
        WHERE a.customer_id = b.customer_id
        AND b.reserv_no = c.reserv_no
        ) T1 , ADDRESS T2
        WHERE T1.ZIP_CODE = T2.ZIP_CODE
        GROUP BY T1.ZIP_CODE,T2.ADDRESS_DETAIL
        ORDER BY 2 DESC;
        
-- 가장 방문을 많이한 고객의 전체 구매한 품목별 합산 금액을 출력하시오
--  1. (BRANCH) 고객별 방문횟수 구하기
--  2. 방문횟수가 많은 고객의 ID 알아내기
--  3. 해당 ID 의 예약번호 구하기.
--  4. 예약번호의 구매 합계 구하기.

SELECT * FROM CUSTOMER;
SELECT * FROM ORDER_INFO;
SELECT * FROM RESERVATION;
SELECT * FROM ITEM;

--  1. (BRANCH) 고객별 방문횟수 구하기
SELECT A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
        ,COUNT(B.CUSTOMER_NAME) 방문횟수 , SUM(VISITOR_CNT) 방문고객수
FROM RESERVATION A, CUSTOMER B
WHERE A.CUSTOMER_ID = B.CUSTOMER_ID AND CANCEL ='N'
GROUP BY A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
ORDER BY 4 DESC;


--  2. 방문횟수가 많은 고객의 ID 알아내기
SELECT CUSTOMER_ID
FROM(
    SELECT A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
        ,COUNT(B.CUSTOMER_NAME) 방문횟수 , SUM(VISITOR_CNT) 방문고객수
FROM RESERVATION A, CUSTOMER B
WHERE A.CUSTOMER_ID = B.CUSTOMER_ID AND CANCEL ='N'
GROUP BY A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
ORDER BY 4 DESC)
WHERE ROWNUM =1;

--  3. 해당 ID 의 예약번호 구하기.

SELECT A.RESERV_NO
FROM RESERVATION A,(SELECT CUSTOMER_ID
FROM(
    SELECT A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
    ,COUNT(B.CUSTOMER_NAME) 방문횟수 , SUM(VISITOR_CNT) 방문고객수
    FROM RESERVATION A, CUSTOMER B
    WHERE A.CUSTOMER_ID = B.CUSTOMER_ID AND CANCEL ='N'
    GROUP BY A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
    ORDER BY 4 DESC)
    WHERE ROWNUM =1) B
WHERE A.CUSTOMER_ID = B.CUSTOMER_ID
and CANCEL ='N';






SELECT A.PRODUCT_NAME 이름 ,A.PRICE, COUNT(A.PRODUCT_NAME) 수량
FROM item a,order_info b ,(SELECT A.RESERV_NO 예약번호
FROM RESERVATION A,(SELECT CUSTOMER_ID
FROM (
    SELECT A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
    ,COUNT(B.CUSTOMER_NAME) 방문횟수 , SUM(VISITOR_CNT) 방문고객수
    FROM RESERVATION A, CUSTOMER B
    WHERE A.CUSTOMER_ID = B.CUSTOMER_ID AND CANCEL ='N'
    GROUP BY A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
    ORDER BY 4 DESC)
    WHERE ROWNUM =1) B
WHERE A.CUSTOMER_ID = B.CUSTOMER_ID
and CANCEL ='N') c
WHERE A.ITEM_ID = B.ITEM_ID 
AND B.RESERV_NO = C.예약번호
GROUP BY A.PRODUCT_NAME, A.PRICE;

-- 예약번호의 구매합계 구하기S

SELECT 이름, 수량*가격
FROM (SELECT A.PRODUCT_NAME 이름 ,A.PRICE 가격, COUNT(A.PRODUCT_NAME) 수량
FROM item a,order_info b ,(SELECT A.RESERV_NO 예약번호
FROM RESERVATION A,(SELECT CUSTOMER_ID
FROM (
    SELECT A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
    ,COUNT(B.CUSTOMER_NAME) 방문횟수 , SUM(VISITOR_CNT) 방문고객수
    FROM RESERVATION A, CUSTOMER B
    WHERE A.CUSTOMER_ID = B.CUSTOMER_ID AND CANCEL ='N'
    GROUP BY A.CUSTOMER_ID, B.CUSTOMER_NAME ,A.BRANCH 
    ORDER BY 4 DESC)
    WHERE ROWNUM =1) B
WHERE A.CUSTOMER_ID = B.CUSTOMER_ID
and CANCEL ='N') c
WHERE A.ITEM_ID = B.ITEM_ID 
AND B.RESERV_NO = C.예약번호
GROUP BY A.PRODUCT_NAME, A.PRICE)
ORDER BY 2 DESC;



---------------------------------------------------------------------
