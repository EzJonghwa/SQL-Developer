ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- 계정 생성
-- 여기에서 java 계정명 , oracle은 비번
CREATE USER Study IDENTIFIED BY Study;
--접속및 기본 권한 부여
GRANT CONNECT, RESOURCE TO Study;
-- 테이블 스페이스 접근 권한 부여
GRANT UNLIMITED TABLESPACE TO Study; --<-- 로 명령어 구분
