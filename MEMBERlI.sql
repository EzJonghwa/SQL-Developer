-- member ������ member���̺��� ��ȸ�Ͻÿ�
-- �˻����� :������ �߱��� ��� ����
-- �ּҴ� mem_add
-- ������ mem_regno2 (Ȧ�� ����, ¦�� ����)

SELECT *

FROM member;    

SELECT MEM_ID , MEM_NAME
,RPAD(SUBSTR(MEM_REGNO1 || '-'|| MEM_REGNO2,0,8),14,'*') AS REGNO
, MEM_ADD1
, MEM_ADD2
, MEM_JOB

FROM member
WHERE MEM_ADD1 LIKE '%����%' AND MEM_ADD1 LIKE '%�߱�%' AND MEM_REGNO2 LIKE '2%';