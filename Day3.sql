-- ���̺� �ڸ�Ʈ
COMMENT ON TABLE tb_info IS '�츮��';
-- �÷� �ڸ�Ʈ
COMMENT ON COLUMN tb_info.info_no IS '�⼮�� ��ȣ';
COMMENT ON COLUMN tb_info.pc_no IS '��ǻ�� ��ȣ';
COMMENT ON COLUMN tb_info.NM IS '�̸�';
COMMENT ON COLUMN tb_info.email IS '�̸���';
COMMENT ON COLUMN tb_info.hobby IS '���';
-- ���̺��� �ڸ�Ʈ ������ �˻��ؼ� ã�Ƽ� 

SELECT table_name ,comments
FROM all_tab_comments   -- ���̺� ���� ��ȸ
--all_col_comments
WHERE table_name='TB_INFO';

--NULL ���ǽİ� �� ���ǽ� (AND , OR ,NOT)

SELECT *
FROM departments
-- WHERE praent_id=''; X
WHERE parent_id IS NULL; -- NULL ���� ��ȸ�� ���� IS / IS NOT



SELECT *
FROM departments
WHERE parent_id IS NOT NULL;  --NULL ���� �ƴѰ��� �˻� �Ҷ�


--IN ���ǽ� (������ or�� �ʿ��� ��)
--30,50,60,80 �μ� ��ȸ
SELECT *
FROM employees
WHERE department_id IN(30,50,60,80);    -- 30 OR 50 or 60 or 80



--LIKE �˻� % (���ڿ� ���� �˻�)
SELECT *
FROM tb_info
WHERE nm LIKE '��%'; -- �� �� ���۵Ǵ� ��� 

SELECT *
FROM tb_info
WHERE nm LIKE '%ȣ'; -- ȣ �� ������ ��� 


SELECT *
FROM tb_info
WHERE nm LIKE '%��%'; -- �߰��� ���� ����ִ� ��� 



SELECT *
FROM tb_info
WHERE nm LIKE '%' || :param_val || '%';     --�Ű����� �Է� �׽�Ʈ


-- �л��߿� �̸��� �ּҰ� naver�� �л��� ���ϼ���
SELECT*
FROM tb_info
WHERE email LIKE '%naver%';

-- naver �� gmail �� �ƴ� 
SELECT*
FROM tb_info
WHERE email NOT LIKE '%naver%' AND email NOT LIKE '%gmail%';


-- �������ͺ��̽����� �����ϴ� �Լ�
-- ��ҹ���

-- ���ڿ� �Լ� LOWER *�ҹ��ڷ� ���� UPPER *�빮�ڷ� ����
SELECT LOWER ('i like Mac') as lowers
, UPPER ('i like Mac') as uppers
FROM dual;  -- dual �ӽ� ���̺� ���� *sql select ������ ���߱� ����  

-- 
SELECT emp_name, UPPER(emp_name)as upperNm, employee_id
FROM employees;

-- employees���̺� ���� -> william �� ���Ե� ������ ��� ��ȸ�Ͻÿ�
SELECT emp_name 
FROM employees
WHERE lower(emp_name) LIKE '%william%' ;
-- ��� 2
SELECT emp_name 
FROM employees
WHERE upper(emp_name) LIKE '%'||upper('william')||'%' ;
-- WHERE upper(emp_name) LIKE '%'||upper(':val')||'%' ; �Է¿� ���� �˻�'
-- like �˻����� ���̱��� ��Ȯ�ϰ� ã�� ������

INSERT INTO TB_INFO (info_no, pc_no ,nm, email)
VALUES (19,01,'�ؼ�','�ؼ�@email.com');
INSERT INTO TB_INFO (info_no, pc_no ,nm, email)
VALUES (20,31,'����','�ؼ�@email.com');
INSERT INTO TB_INFO (info_no, pc_no ,nm, email)
VALUES (21,32,'���ؼ���','�ؼ�@email.com');

SELECT*
FROM tb_info

-- ���ڿ� �ڸ��� substr(char,pos,len)��� ���ڿ� char �� pos ��° ���� len ���̸�ŭ �ڸ�
SELECT SUBSTR('ABCD EFG',1,4) AS EX1    -- POS�� 0 �̿��� ����Ʈ 1
,SUBSTR('ABCD EFG',4) AS EX2    --�Է°��� �ΰ��� ��� �ش� �ε��� ���� ������
,SUBSTR('ABCD EFG',-3,3) AS EX3 -- ������ �����̸� �ڿ��� ����
FROM dual;


-- ���ڿ� ��ġ ã�� INSTR (P1,P2,P3,P4) 
-- P1: ��� ���ڿ� ,P2: ã�� ���ڿ�,P3:����,P4:��°
SELECT INSTR('�ȳ� ������ �ݰ���, �ȳ���hi','�ȳ�') as ex1  -- p3,p4 ����Ʈ 1
 ,INSTR('�ȳ� ������ �ݰ���, �ȳ���hi','�ȳ�',5) as ex2 
 ,INSTR('�ȳ� ������ �ݰ���, �ȳ���hi','�ȳ�',1,2) as ex3  -- �ι�° �ȳ� ������ġ
 ,INSTR('�ȳ� ������ �ݰ���, �ȳ���hi','hello') as ex4  -- ������ 0
FROM dual;

--tb_info �л��� �̸��� �̸��� �ּҸ� ����Ͻÿ�
--(�� �̸��� �ּҴ� id,domain �и��Ͽ� ����Ͻÿ�)
-- ex) pangsu@gmail.com -> id:pengsu ,domain:gmail.com

SELECT nm , email, 
SUBSTR(EMAIL,1,INSTR(EMAIL,'@')-1) AS ���̵�,
SUBSTR(EMAIL,INSTR(EMAIL,'@')+1)  AS ������
FROM tb_info;

-- �������� TRIM,LTRIN,RTIRN
SELECT LTRIM (' ABC ') as ex1
, RTRIM (' ABC ') as ex2
, TRIM (' ABC ') as ex3
FROM dual;
--  ���ڿ� �е� LPAD , RPAD;
SELECT LPAD(123,5,'0') as ex1   --(���,����,ǥ����)LPAD �� ���ʺ��� ä��
,LPAD(1,5,'0') as ex2
,LPAD(123456,5,'0') as ex3      -- �Ѿ�� ���ŵ�.(����)
,RPAD(2,5,'*') as ex4           -- R �� ������ ����
FROM dual;


-- ���ڿ� ���� REPLACE(����ڿ�,ã�°�, ���氪)
SELECT REPLACE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?','����','�ʸ�') as ex1
--          REPLACE �� �ܾ� ��Ȯ�� ��Ī TRANSLATE �� �ѱ��ھ� ��Ī
,TRANSLATE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?','����','�ʸ�') as ex2
FROM dual;























