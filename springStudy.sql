-- ���� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=true;

CREATE USER jdbc IDENTIFIED BY jdbc;

GRANT CONNECT, RESOURCE TO jdbc;

GRANT UNLIMITED TABLESPACE TO  jdbc;

