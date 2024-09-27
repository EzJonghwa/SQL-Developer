CREATE TABLE stock(
    code VARCHAR(10) PRIMARY KEY
    ,name VARCHAR(100)
    ,market VARCHAR(100)
    ,marcap number
    ,stocks number
    ,use_yn VARCHAR(1) DEFAULT 'N'
);

    INSERT INTO stock(code,name,market,marcap,stocks)
    VALUES(:1,:2,:3,:4,:5);
    

select *
from stock;



UPDATE STOCK
SET USE_YN ='Y'
WHERE NAME = '삼성전자';



CREATE TABLE stock_price(
    code VARCHAR(10)
    ,seq NUMBER GENERATED ALWAYS AS IDENTITY
    ,price NUMBER
    ,create_dt DATE DEFAULT SYSDATE
    ,CONSTRAINT pk_stock_price PRIMARY KEY (code,seq)
--                                          복합키로 한 이유 프라이머리로 code만 넣었을때 하나만 조회가능
                                            -- 여러개가 나올 수 있게 하기위해 자동 증가값을 키로 설정
    ,CONSTRAINT fk_stock_price FOREIGN KEY (code) REFERENCES stock(code)
);


SELECT *FROM STOCK WHERE USE_YN ='Y';

INSERT INTO stock_price(code,price) VALUES(:1,:2);

SELECT *FROM stock_price;









CREATE TABLE stock_bbs(
    code VARCHAR2(10)
    ,discussion_id VARCHAR2(20)
    ,title VARCHAR2(200)
    ,contents CLOB
    ,read_count NUMBER
    ,good_count NUMBER
    ,bad_count NUMBER
    ,comment_count NUMBER
    ,create_dt DATE
-- 실제 작성된 시간을 적기 위해 비워둠    
    ,update_dt DATE DEFAULT SYSDATE
    ,CONSTRAINT pk_stock_bbs PRIMARY KEY (code, discussion_id)
);
DROP TABLE stock_bbs;

-- 동일 code, discussion_id 가 있을 경우 update, 없을경우 insert
MERGE INTO stock_bbs a
USING dual
ON (a.code = :code
    and a.discussion_id = :discussionId)
WHEN MATCHED THEN
    UPDATE SET a.read_count = :readCount
             , a.good_count = :goodCount
             , a.bad_count = :badCount
             , a.comment_count = :commentCount
WHEN NOT MATCHED THEN
    INSERT (a.code, a.discussion_id, a.read_count, a.good_count, a.bad_count
          , a.comment_count, a.title, a.contents, a.create_dt)
    VALUES (:code, :discussionId, : readCount, :goodCount, :badCount, :commentCount
          , :title , :contents, to_date(:createDt,'YYYY-MM-DD HH24:MI:SS'));



SELECT *
FROM stock_bbs;




SELECT (SELECT name
        FROM stock
        WHERE code = a.code) as nm
,a.title                     as title
,a.read_count                as read_count
,TO_CHAR(a.update_dt,'YYYYMMDD HH24:MI:SS') as update_dt
FROM stock_bbs a
ORDER BY 1,4 DESC;


SEL


















