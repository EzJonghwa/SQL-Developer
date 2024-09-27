-- ROLLUP 
-- �׷캰 �Ұ�� �Ѱ踦 ������
-- ǥ������ ������ n�̸� n+1 ��������, ���� ������ �������� ������ �����Ͱ� �����

-- ������ ���ϸ����� �հ�� ��ü �հ� ��� 
SELECT mem_job 
        , sum(mem_mileage) ���ϸ�����
FROM member
GROUP BY ROLLUP(mem_job);

-- ī�װ�, ����ī�װ� �� ��ǰ��

SELECT prod_category
        , prod_subcategory
        , COUNT(prod_id) as ��ǰ��
FROM products
GROUP BY ROLLUP (prod_category, prod_subcategory);




CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('�ѱ�', 1, '�������� ������');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 2, '�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 3, '��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 4, '����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 6,  '�ڵ�����ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 7,  '�޴���ȭ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 8,  'ȯ��źȭ����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 9,  '�����۽ű� ���÷��� �μ�ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 10,  'ö �Ǵ� ���ձݰ�');

INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 1, '�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 2, '�ڵ�����ǰ');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 3, '��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 4, '����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 5, '�ݵ�ü������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 6, 'ȭ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 7, '�������� ������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 8, '�Ǽ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 9, '���̿���, Ʈ��������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 10, '����');



-- ����� ���� unnion union ALL minux , intersect
SELECT goods, seq
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION
SELECT goods, seq
FROM exp_goods_asia
WHERE country = '�Ϻ�'
ORDER BY seq;   -- ������ SELECT ������ ��밡��

SELECT goods, seq
FROM exp_goods_asia
WHERE country = '�ѱ�'
UNION ALL   -- �� SELECT ���� ��� ��
SELECT goods, seq
FROM exp_goods_asia
WHERE country = '�Ϻ�'
ORDER BY seq;

SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
MINUS   -- �� ����
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�';

SELECT goods
FROM exp_goods_asia
WHERE country = '�ѱ�'
INTERSECT -- ������
SELECT goods
FROM exp_goods_asia
WHERE country = '�Ϻ�'
UNION
SELECT '����'
FROM dual;
-- ���� ����� �÷��� ���� Ÿ���� ��ġ�ϸ� ��밡��.

SELECT gubun
, SUM(loan_jan_amt) as ������
from kor_loan_status
Group by gubun
union
SELECT '�հ�' ,SUM(loan_jan_amt)
FROM kor_loan_status;



/*
���� ǥ�h�� oracl 10g ���� ��� ���� regexp_ <-�� �����ϴ� �Լ�
    -(dot) of [] <-��� ���� 1���ڸ� �ǹ���
    ^����, $�� [^]�� not �� �ǹ�
    {n} :n�� �ݺ� {n,} n �̻�ݺ�, {n,m} n�̻� m ���� �ݺ�, */
--REGEXP_LIKE : ���Խ� ���� �˻�
SELECT mem_name, mem_comtel
FROM member
WHERE REGEXP_LIKE(mem_comtel,'^..-') ;


-- mem_mail ������ �� ������ ���� 3~5 �ڸ� �̸��� �ּ� ���� ����
SELECT mem_name, mem_mail
FROM member
WHERE REGEXP_LIKE (mem_mail, '^[a-zA-Z]{3,5}@');
-- mem_add2 �ּҿ��� �ѱ۷� ������ ������ �ּҸ� �����Ͻÿ�
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2,'[��-��]$');


-- ���� ������ �ּҸ� ��ȸ�Ͻÿ�
-- �ѱ� + ���� + ���� ex ����Ʈ 5��
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2,'[��-��] [0-9]');  

-- �ѱ۸� �ִ� �ּ� �˻�
select mem_add2
FROM member
WHERE REGEXP_LIKE (mem_add2,'^[��-��]+$');
--WHERE REGEXP_LIKE (mem_add2,'^[��-��]{1,}$');
--WHERE REGEXP_LIKE (mem_add2,'^[��-��]*$');



select mem_add2
FROM member
WHERE REGEXP_LIKE (mem_add2,'^[^��-��]+$');

select mem_add2
FROM member
WHERE NOT REGEXP_LIKE (mem_add2,'[��-��]');

-- | : �Ǵ� , {} : �׷�
-- j�� �����ϸ�, ����° ���ڰ�  M OR N�� ���� �̸���ȸ
SELECT emp_name
FROM employees;
WHERE REGEXP_LIKE(emp_name,'^J.(m|n)');

--REGEXP_SUBSTR ����ǥ���� ���ϰ� ��ġ�ϴ� ���ڿ��� ��ȯ
-- �̸��� �������� �յ� ���
SELECT mem_mail
,REGEXP_SUBSTR(mem_mail,'[^@]+',1,1) as ���̵�
,REGEXP_SUBSTR(mem_mail,'[^@]+',1,2) as �̸���
FROM member;

SELECT REGEXP_SUBSTR('A-B-C', '[^-]+',1,1) as ex1
,REGEXP_SUBSTR('A-B-C', '[^-]+',1,2) as ex2
,REGEXP_SUBSTR('A-B-C', '[^-]+',1,3) as ex3
,REGEXP_SUBSTR('A-B-C', '[^-]+',1,4) as ex4
from dual;
--mem_add1 ���� ������ �������� ù��° �ܾ ����Ͻÿ�
SELECT REGEXP_SUBSTR(mem_add1, '[^ ]+',1,1)
,REGEXP_SUBSTR(mem_add1, '[^ ]+',1,2)
FroM member;

--REGEXP_REPLACE ��� ���ڿ�����
-- ���� ǥ���� ������ �����Ͽ� �ٸ� �������� ��ü
SELECT REGEXP_REPLACE('Ellen Hidi Smith'
                        ,'(.*) (.*) (.*)'
                        ,'\3, \1 \2') as re
FROM dual;
-- ������ �ּҵ��� ��� '����'���� �ٲ㼭 ����Ͻÿ� id:p001 ����
-- ���� ������ ->����
-- ������ -> ����
SELECT mem_add1
    --,REGEXP_REPLACE(mem_add1 ,'(������)|(����������)', '����') as re
    ,REGEXP_REPLACE(mem_add1 ,'(.{1,5}) (.*)', '���� \2') as re
FROM member
WHERE mem_add1 LIKE '%����%'
AND mem_id !='p001';
-- �� ǥ��� \w =[a-zA-Z0-9], \d = [0-9]
-- ��ȸ��ȣ ���ڸ����� ������ ��ȣ�� �ݺ��Ǵ� ��� ��ȸ
SELECT emp_name , phone_number
FROM employees
WHERE REGEXP_LIKE(phone_number,'(\d\d)\1$');
--(\d\d\1$) (���ڼ���) \1ù��° �׷� ĸ�� �׷��� �ٽ� ����

-- ^\d*\.?\d{0,2}
-- ^  \d*  \.   ?\d{0,2}
-- ����







