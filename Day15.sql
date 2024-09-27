/*
    ������ ��ȣȭ 
    ����Ŭ �����ͺ��̽����� ���� ���� ������ ������ ���� ũ�� 2���� 
    1. ����ڿ� ���õ� ����.
      - ����� ����, ��й�ȣ ������ �������, ���Ѱ� �� ( �̴� DBA�� ó����)
    2. ������ ��ü�� ���� ����.
      - �����ͺ����� �����ڰ� ó��.
      
    ������ ������ ��ȭ �ϴ� �� ���� ����� ������ ��ȣȭ.
    
    - ������ ��ȣȭ�� �ΰ��ϰ� �߿��� �����͸� ��ȣȭ�ؼ� ���̺� �����ϰ� �̸� ��ȸ�� �� �ٽ� ��ȣȭ�� �ϴ� �Ϸ��� ����.
    - ��ȣȭ�� �����ʹ� ��ȣȭ ������ ���ٸ� �ǹ� ���� ������ 
    - �����Ͱ� ��°�� ����Ǿ ��ȣȭ ���п� 1������ �������� Ȯ���Ǿ��ٰ� �� �� �ִ�

    ����Ŭ 10g ���� ������ DBMS_CRYPTO ��Ű��
    

    ����� �˰��� : ��ȣȭ, ��ȣȭ ����
    (��ĪŰ,���ĪŰ)

    �ܹ��� �˰��� : ��ȭȭ ����, ��ȣȭ �Ұ�
    (hash)


    ��ȣȭ�� ���� ���� �˰����� �̿��� ó���ϴµ�  
    DBMS_CRYPTO ��Ű���� Ȱ���� ���� ������ ��ȣȭ �˰����� 
    
    --https://docs.oracle.com/cd/B19306_01/appdev.102/b14258/d_crypto.htm#i1004143 ����
    
    1.DES(Data Encryption Standard) : �̱� ����ǥ�ر�������ҿ��� �̱� ǥ������ ���ߴ� 56��Ʈ ��ĪŰ�� ����� �˰���(������� �߰ߵ� ǥ�ؿ��� ���ܵ�)
    2.3DES (DES 3�� �ݺ� ����˰���) 
    3.AES(Advanced Encryption Standard) : DES�� ��ü�ϱ� ���� ������� �˰��� ���� �̱� ǥ������ ��� (��Ī�� �˰���) 
    4.MD5(Message-Digest algorithm5) : 128��Ʈ ��ȣȭ �ؽ� �Լ��� ���α׷��̳� ������ ���� �״������ Ȯ���ϴ� ���Ἲ �˻� � ��� (��ȣȭ�� ���������� ��ȣȭ�� �ſ� �����)(�ܹ���)
    5.SHA-1(Secure Hash Algorithm-1) : 160��Ʈ �ؽ� ���� ������ ��ȣȭ �ؽ� �Լ���  MD5���� �Ѵܰ� ���� ����(�ܹ���)
    6.MAC(Message Authentication Code, �޼��������ڵ�) : MD5, SHA-1 ���� �ܹ��� ��ȣȭ �ؽ� �Լ��ε� �ٸ����� ���Ű�� �Է� �޾� ���.
    
    
    DBMS_CRYPTO ��Ű�� 
    
    �پ��� ��ȣȭ ��İ� �˰����� ����ϱ� ������ 
    ��Ű�� ����� ������ ����ϴµ� �̴� ���  PLS_INTEGER Ÿ���̴�.
    
    1.��ȣȭ �˰��� ��� 

      ENCRYPY_AES128 AES ��� ��ȣȭ�� 128 ��Ʈ Ű�� ���
      ENCRYPY_AES192 AES ��� ��ȣȭ�� 192 ��Ʈ Ű�� ���
      ENCRYPY_AES256 AES ��� ��ȣȭ�� 256 ��Ʈ Ű�� ���    

    2.��� ��ȣȭ ��� ���� ���

       ��� ��ȣ(Block Cipher)�� ���� ��� ������ ��ȣȭ�ϴ� ��ĪŰ ��ȣ �ý����Դϴ�.
       CHAIN_CBC : CBC(Chipher Block Chaing) ��� 

    3.�е� ���� ���

      PAD_PKCS5: PKCS5(��й�ȣ ��� ��ȣȭ ǥ������ �̷���� �е�)
      PAD_NONE: �е��� ������ �ǹ�
      PAD_ZERO: 0���� �̷���� �е�       

    4.��ȣȭ ��Ʈ ���� ��� 

      ��ȣ �˰��� + ��ȣȭ ��� + �е� ���յȰ�
      DBMS_CRYPYO ��Ű���� ��ȣȭ ���� �Լ��� ���ν����� �̷� ��ȣȭ ��Ʈ�� �Ű������� �޾� �����͸� ��ȣȭ �Ѵ�. 

    5.��ȣȭ �ؽ� �Լ� ���� ��� 

      HASH_MD4 :MD4 128��Ʈ �ؽ�
      HASH_MD4 :MD5 128��Ʈ �ؽ�
      HASH_SH1 :SH1 160��Ʈ �ؽ�

    6.MAC �Լ� ���� ��� 

      HMAC_MD5 : �ؽ� ���� �����ϱ� ���� ���Ű�� �����(�������� MD5�� ����)
      HMAC_SH1 : �ؽ� ���� �����ϱ� ���� ���Ű�� �����(�������� SHA1�� ����)
    


    -----------------------------------------------------------------------------
    ENCRYPT �Լ��� key�� �Է� �޾� �����͸� ��ȣȭ ��Ʈ ������� ��ȣȭ�� ����� ��ȯ(����� RAW Ÿ������ ��ȯ)
    src : ��ȣȭ�� ������
    typ : ��ȣȭ�� ���� ��Ʈ
    key : ��ȣȭ Ű
    iv : �ʱ�ȭ ����
    -----------------------------------------------------------------------------
    DECRYPT �Լ��� ��ȣȭ�� �����͸� �Ű������� �޾� ��ȣȭ ����� ��ȯ�ϴ� �Լ�.
    src : ��ȣȭ ������
    typ : ��ȣȭ�� ���� ��ȣȭ ��Ʈ
    key : ��ȣȭ Ű
    iv  : �ʱ�ȭ ����
     -----------------------------------------------------------------------------   
    RAWŸ������ �޾� ���������� ��ȯ

    
    HASH �Լ� 
    md4,md5,sha-1 �� ����� �ؽ� ���� ���� ��ȯ�ϴ� �Լ�. 
    
    MAC �Լ� 
    hash �Լ��� ����ϳ� �Ű������� ����� ���Ű�� �� �Է¹޴´�. 
*/




/*
 ��ȣȭ ���� �׽�Ʈ�� ���� 
 sqlplus ����
 sys as sysdba ���� 
 grant execute on DBMS_CRYPTO to java;
 
 -----------------------------------------------------��� ���� 
 */

grant execute on DBMS_CRYPTO to public;


DECLARE
  input_string  VARCHAR2 (200) := 'The Oracle';  -- ��ȣȭ�� VARCHAR2 ������
  output_string VARCHAR2 (200); -- ��ȣȭ�� VARCHAR2 ������ 

  encrypted_raw RAW (2000); -- ��ȣȭ�� ������ 
  decrypted_raw RAW (2000); -- ��ȣȭ�� ������ 

  num_key_bytes NUMBER := 256/8; -- ��ȣȭ Ű�� ���� ���� (256 ��Ʈ, 32 ����Ʈ)
  key_bytes_raw RAW (32);        -- ��ȣȭ Ű 

  -- ��ȣȭ ��Ʈ 
  encryption_type PLS_INTEGER; 
  
BEGIN
	 -- ��ȣȭ ��Ʈ ����
	 encryption_type := DBMS_CRYPTO.ENCRYPT_AES256 + -- 256��Ʈ Ű�� ����� AES ��ȣȭ 
	                    DBMS_CRYPTO.CHAIN_CBC +      -- CBC ��� 
	                    DBMS_CRYPTO.PAD_PKCS5;       -- PKCS5�� �̷���� �е�
	
   DBMS_OUTPUT.PUT_LINE ('���� ���ڿ�: ' || input_string);

   -- RANDOMBYTES �Լ��� ����� ��ȣȭ Ű ���� 
   key_bytes_raw := DBMS_CRYPTO.RANDOMBYTES (num_key_bytes);
   
   -- ENCRYPT �Լ��� ��ȣȭ�� �Ѵ�. ���� ���ڿ��� UTL_I18N.STRING_TO_RAW�� ����� RAW Ÿ������ ��ȯ�Ѵ�. 
   encrypted_raw := DBMS_CRYPTO.ENCRYPT ( src => UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8'),   
                                          typ => encryption_type,
                                          key => key_bytes_raw
                                        );
                                        
   -- ��ȣȭ�� RAW �����͸� �ѹ� ����غ���
   DBMS_OUTPUT.PUT_LINE('��ȣȭ�� RAW ������: ' || encrypted_raw);                                     
   -- ��ȣȭ �� �����͸� �ٽ� ��ȣȭ ( ��ȣȭ�ߴ� Ű�� ��ȣȭ ��Ʈ�� �����ϰ� ����ؾ� �Ѵ�. )
   decrypted_raw := DBMS_CRYPTO.DECRYPT ( src => encrypted_raw,
                                          typ => encryption_type,
                                          key => key_bytes_raw
                                        );
   
   -- ��ȣȭ�� RAW Ÿ�� �����͸� UTL_I18N.RAW_TO_CHAR�� ����� �ٽ� VARCHAR2�� ��ȯ 
   output_string := UTL_I18N.RAW_TO_CHAR (decrypted_raw, 'AL32UTF8');
   -- ��ȣȭ�� ���ڿ� ��� 
   DBMS_OUTPUT.PUT_LINE ('��ȣȭ�� ���ڿ�: ' || output_string);
END;



-- �ܹ��� ��ȣȭ �ؽ� �Լ��� HASH, MAC �Լ��� �ܹ������� ��ȣȭ�� �ſ� ��ư� 
-- ��� �Է� ���� ���� ��ȣȭ�� �����͸� �������ν� �Է� ���� �����ϴµ� ���ȴ�. 
-- ex ��й�ȣ üũ 
-- HASH, MAC �Լ�

DECLARE

  input_string  VARCHAR2 (200) := 'The Oracle';  -- �Է� VARCHAR2 ������
  input_raw     RAW(128);                        -- �Է� RAW ������ 
  encrypted_raw RAW (2000); -- ��ȣȭ ������ 
  
BEGIN
	-- VARCHAR2�� RAW Ÿ������ ��ȯ
	input_raw := UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8');
	
	
  DBMS_OUTPUT.PUT_LINE('----------- HASH �Լ� -------------');
  encrypted_raw := DBMS_CRYPTO.HASH( src => input_raw,
                                     typ => DBMS_CRYPTO.HASH_SH1);
                                     
  DBMS_OUTPUT.PUT_LINE('�Է� ���ڿ��� �ؽð� : ' || RAWTOHEX(encrypted_raw));   
    
END;



-- ���̵�� ��й�ȣ�� �Է��ϸ� �̸� üũ�� �α����ϴ� ���α׷� 
-- ��������̺��� ���̵�� ��й�ȣ�� �����ϴµ� �̶� ��й�ȣ�� �Էµ� ��ȣ �״�� �����ϴ� ���� �ƴ϶� 
-- ����ڰ� �Է��� ���� ������ �ٸ� ���� ������ �̸� HASH, MAC �Լ��� �Է� ������ �޾� ��ȯ�� ��� ���� ��й�ȣ �÷��� ����. 
-- �ý��� �����ڵ� ���̺��� ��ȣȭ�� ���� �˼� ���� ���� ����ڸ� �� �� �ִ�. 

-- ��й�ȣ�� �н� �ߴٸ�? 
-- �������� �űԺ�й�ȣ�� ������ hash, mac �Լ��� �¿� ��ȯ�� ���� ��й�ȣ �÷��� �����ϰ� ����ڿ��� �ű� ��й�ȣ�� �ο� 
-- ���ο� ����� �����ϰ� ������. 
-- ����ڰ� ���� �ű� ��й�ȣ�� HASH�� MAC �Լ��� �Ű������� �޾� �� ��ȯ ���� ��й�ȣ �÷��� ���������� ����. 
DECLARE
 key_string VARCHAR2(8) := 'secret';  -- MAC �Լ����� ����� ��� Ű
  raw_key RAW(128) := UTL_RAW.CAST_TO_RAW(CONVERT(key_string,'AL32UTF8','US7ASCII')); -- ���Ű�� RAW Ÿ������ ��ȯ
   
BEGIN
   DBMS_OUTPUT.PUT_LINE('----------- MAC �Լ� -------------'); 
  encrypted_raw := DBMS_CRYPTO.MAC( src => input_raw,
                                    typ => DBMS_CRYPTO.HMAC_MD5,
                                    key => raw_key);   
                                    
  DBMS_OUTPUT.PUT_LINE('MAC �� : ' || RAWTOHEX(encrypted_raw));
END;
/*
���������� ������ Ȯ����ġ ����(���������ΰ�� ��2011-43ȣ, 2011.9.30 ����)

 
����������ȣ���� ��й�ȣ �Ϲ��� ��ȣȭ �� �н����� ���� �ַ��
�н������� �Ϲ��� ��ȣȭ�� ���Ǵ� HASH �Լ�
��7��(���������� ��ȣȭ)
�翵 ��21�� �� �� ��30����1����3ȣ�� ���� ��ȣȭ�Ͽ��� �ϴ� ���������� �����ĺ�����, ��й�ȣ �� ���̿������� ���Ѵ�.
�谳������ó���ڴ� ��1�׿� ���� ���������� ������Ÿ��� ���Ͽ� ��.�����ϰų� ���������ü ���� ���Ͽ� �����ϴ� ��쿡�� �̸� ��ȣȭ�Ͽ��� �Ѵ�.
�鰳������ó���ڴ� ��й�ȣ �� ���̿������� ��ȣȭ�Ͽ� �����Ͽ��� �Ѵ�. �� ��й�ȣ�� �����ϴ� ��쿡�� ��ȣȭ���� �ƴ��ϵ��� �Ϲ��� ��ȣȭ�Ͽ� �����Ͽ��� �Ѵ�.
�갳������ó���ڴ� ���ͳ� ���� �� ���ͳ� ������ ���θ��� �߰� ����(DMZ : Demilitarized Zone)�� �����ĺ������� �����ϴ� ��쿡�� �̸� ��ȣȭ�Ͽ��� �Ѵ�.
*/



SELECT *
FROM member;


--1. �ܹ��� ��ȣȭ �Լ��� �����Ͻÿ�. (hash �Լ�)
--2. member ���̺�pw ��
-- ��ȣȭ �Ͽ� member_temp ���̺� �����Ͻÿ�

CREATE OR REPLACE FUNCTION fn_encode_pw(input_pw VARCHAR2)
RETURN VARCHAR2
IS
    input_raw   RAW(128);
    encrypted_raw RAW (2000);
BEGIN
    input_raw  := UTL_i18N.CAST_TO_RAW(input_pw,'AL32UTF8');
    encrypted_raw := DBMS_CRYPTO.HASH( src => input_raw,
                                        typ =>DBMS_CRYPTO.HASH_SH1);
    RETURN RAWTOHEX(encrypted_raw);
END;



SELECT fn_encode_pw('�ȳ�')
FROM dual;

CREATE TABLE member_temp AS
SELECT mem_id ,mem_name, fn_encode_pw(mem_pass) as mem_pass
FROM member;

SELECT *FROM member_temp
WHERE mem_id ='a001'
AND mem_pass = fn_encode_pw('asdfasdf');


