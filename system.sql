-- �����ּ� ctrl +/
/* 
�ּ� ����
*/
-- ���� �����
--11g ���� ���� ���� ���� Ư�� ��Ÿ���� ���Ѿ� ����� ���µ�
-- ���� ��Ÿ�Ϸ� ������� �Ʒ� ��ɾ ���� �ؾ���
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- ���� ����
-- ���⿡�� java ������ , oracle�� ���
CREATE USER java IDENTIFIED BY oracle;
--���ӹ� �⺻ ���� �ο�
GRANT CONNECT, RESOURCE TO java;
-- ���̺� �����̽� ���� ���� �ο�
GRANT UNLIMITED TABLESPACE TO java; --<-- �� ��ɾ� ����

-- ^ ���Ǥ� ��ɾ���� �⺻���� �������� ����� �����ϴ�.

ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- ���� ����
-- ���⿡�� java ������ , oracle�� ���
CREATE USER member IDENTIFIED BY member;
--���ӹ� �⺻ ���� �ο�
GRANT CONNECT, RESOURCE TO member;
-- ���̺� �����̽� ���� ���� �ο�
GRANT UNLIMITED TABLESPACE TO member; --<-- �� ��ɾ� ����
