-- 한줄주석 ctrl +/
/* 
주석 공간
*/
-- 계정 만들기
--11g 버젼 이후 계정 명은 특정 스타일을 지켜야 만들어 지는데
-- 예전 스타일로 만들려면 아래 명령어를 실행 해야함
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- 계정 생성
-- 여기에서 java 계정명 , oracle은 비번
CREATE USER java IDENTIFIED BY oracle;
--접속및 기본 권한 부여
GRANT CONNECT, RESOURCE TO java;
-- 테이블 스페이스 접근 권한 부여
GRANT UNLIMITED TABLESPACE TO java; --<-- 로 명령어 구분

-- ^ 위의ㅡ 명령어들은 기본으로 만들어야지 사용이 가능하다.

ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- 계정 생성
-- 여기에서 java 계정명 , oracle은 비번
CREATE USER member IDENTIFIED BY member;
--접속및 기본 권한 부여
GRANT CONNECT, RESOURCE TO member;
-- 테이블 스페이스 접근 권한 부여
GRANT UNLIMITED TABLESPACE TO member; --<-- 로 명령어 구분
