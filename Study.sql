ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- ���� ����
-- ���⿡�� java ������ , oracle�� ���
CREATE USER Study IDENTIFIED BY Study;
--���ӹ� �⺻ ���� �ο�
GRANT CONNECT, RESOURCE TO Study;
-- ���̺� �����̽� ���� ���� �ο�
GRANT UNLIMITED TABLESPACE TO Study; --<-- �� ��ɾ� ����
