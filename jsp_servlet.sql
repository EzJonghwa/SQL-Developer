-- bbs member 테이블 활용
CREATE TABLE tb_user as 
SELECT mem_id   as user_id
    , mem_pass  as user_pw
    , mem_name  as user_nm
    , 'Y'       as use_yn
    , SYSDATE   as create_dt
FROM member;

select user_id
    , user_pw
    , user_nm
from tb_user
WHERE user_id ='TEST'
AND use_yn ='Y';

INSERT INTO tb_user(user_id,user_pw,user_nm, use_yn,create_dt)
VALUES('TEST','TEST','TEST','Y',SYSDATE);



SELECT *
FROM tb_user;

UPDATE tb_user
SET USER_ID = 'jhpark'
WHERE USER_ID = 'qkrwjdgh12';