/*
    데이터 암호화 
    오라클 데이터베이스에서 보안 관련 사항은 관점에 따라 크게 2가지 
    1. 사용자와 관련된 사항.
      - 사용자 계정, 비밀번호 관리와 인증방식, 권한과 롤 ( 이는 DBA가 처리함)
    2. 데이터 자체에 대한 보안.
      - 데이터보안은 개발자가 처리.
      
    데이터 보안을 강화 하는 한 가지 방법은 데이터 암호화.
    
    - 데이터 암호화란 민감하고 중요한 데이터를 암호화해서 테이블에 저장하고 이를 조회할 때 다시 복호화를 하는 일련의 과정.
    - 암호화된 데이터는 복호화 과정이 없다면 의미 없는 데이터 
    - 데이터가 통째로 유출되어도 암호화 덕분에 1차적인 안정망은 확복되었다고 볼 수 있다

    오라클 10g 부터 제공한 DBMS_CRYPTO 패키지
    

    양방향 알고리즘 : 암호화, 복호화 가능
    (대칭키,비대칭키)

    단방향 알고리즘 : 암화화 가능, 복호화 불가
    (hash)


    암호화는 여러 가지 알고리즘을 이용해 처리하는데  
    DBMS_CRYPTO 패키지를 활용해 구현 가능한 암호화 알고리즘은 
    
    --https://docs.oracle.com/cd/B19306_01/appdev.102/b14258/d_crypto.htm#i1004143 참조
    
    1.DES(Data Encryption Standard) : 미국 국립표준기술연구소에서 미국 표준으로 정했던 56비트 대칭키를 사용한 알고리즘(취약점이 발견되 표준에서 제외됨)
    2.3DES (DES 3번 반복 적용알고리즘) 
    3.AES(Advanced Encryption Standard) : DES를 대체하기 위해 만들어진 알고리즘 현재 미국 표준으로 사용 (대칭형 알고리즘) 
    4.MD5(Message-Digest algorithm5) : 128비트 암호화 해시 함수로 프로그램이나 파일이 원본 그대로인지 확인하는 무결성 검사 등에 사용 (암호화는 가능하지만 복호화가 매우 어려움)(단방향)
    5.SHA-1(Secure Hash Algorithm-1) : 160비트 해시 값을 만들어내는 암호화 해시 함수로  MD5보다 한단계 높은 버전(단방향)
    6.MAC(Message Authentication Code, 메세지인증코드) : MD5, SHA-1 같은 단방향 암호화 해시 함수인데 다른점은 비밀키를 입력 받아 사용.
    
    
    DBMS_CRYPTO 패키지 
    
    다양항 암호화 방식과 알고리즘을 사용하기 때문에 
    패키지 상수를 정의해 사용하는데 이는 모두  PLS_INTEGER 타입이다.
    
    1.암호화 알고리즘 상수 

      ENCRYPY_AES128 AES 블록 암호화로 128 비트 키를 사용
      ENCRYPY_AES192 AES 블록 암호화로 192 비트 키를 사용
      ENCRYPY_AES256 AES 블록 암호화로 256 비트 키를 사용    

    2.블록 암호화 모드 관련 상수

       블록 암호(Block Cipher)란 평문을 블록 단위로 암호화하는 대칭키 암호 시스템입니다.
       CHAIN_CBC : CBC(Chipher Block Chaing) 모드 

    3.패딩 관련 상수

      PAD_PKCS5: PKCS5(비밀번호 기반 암호화 표준으로 이루어진 패딩)
      PAD_NONE: 패딩이 없음을 의미
      PAD_ZERO: 0으로 이루어진 패딩       

    4.암호화 슈트 관련 상수 

      암호 알고리즘 + 암호화 모드 + 패딩 결합된것
      DBMS_CRYPYO 패키지의 암호화 관련 함수와 프로시저는 이런 암호화 슈트를 매개변수로 받아 데이터를 암호화 한다. 

    5.암호화 해시 함수 관련 상수 

      HASH_MD4 :MD4 128비트 해시
      HASH_MD4 :MD5 128비트 해시
      HASH_SH1 :SH1 160비트 해시

    6.MAC 함수 관련 상수 

      HMAC_MD5 : 해시 값을 검증하기 위해 비밀키를 사용함(나머지는 MD5와 같음)
      HMAC_SH1 : 해시 값을 검증하기 위해 비밀키를 사용함(나머지는 SHA1과 같음)
    


    -----------------------------------------------------------------------------
    ENCRYPT 함수는 key를 입력 받아 데이터를 암호화 슈트 방식으로 암호화한 결과를 반환(결과는 RAW 타입으로 반환)
    src : 암호화될 데이터
    typ : 암호화에 사용될 슈트
    key : 암호화 키
    iv : 초기화 벡터
    -----------------------------------------------------------------------------
    DECRYPT 함수는 암호화된 데이터를 매개변수로 받아 복호화 결과를 반환하는 함수.
    src : 복호화 데이터
    typ : 복호화에 사용될 암호화 슈트
    key : 암호화 키
    iv  : 초기화 백터
     -----------------------------------------------------------------------------   
    RAW타입으로 받아 문자형으로 반환

    
    HASH 함수 
    md4,md5,sha-1 을 사용해 해시 값을 생성 반환하는 함수. 
    
    MAC 함수 
    hash 함수와 비슷하나 매개변수로 사용할 비밀키를 더 입력받는다. 
*/




/*
 암호화 권한 테스트를 위해 
 sqlplus 엔터
 sys as sysdba 엔터 
 grant execute on DBMS_CRYPTO to java;
 
 -----------------------------------------------------비번 변경 
 */

grant execute on DBMS_CRYPTO to public;


DECLARE
  input_string  VARCHAR2 (200) := 'The Oracle';  -- 암호화할 VARCHAR2 데이터
  output_string VARCHAR2 (200); -- 복호화된 VARCHAR2 데이터 

  encrypted_raw RAW (2000); -- 암호화된 데이터 
  decrypted_raw RAW (2000); -- 복호화할 데이터 

  num_key_bytes NUMBER := 256/8; -- 암호화 키를 만들 길이 (256 비트, 32 바이트)
  key_bytes_raw RAW (32);        -- 암호화 키 

  -- 암호화 슈트 
  encryption_type PLS_INTEGER; 
  
BEGIN
	 -- 암호화 슈트 설정
	 encryption_type := DBMS_CRYPTO.ENCRYPT_AES256 + -- 256비트 키를 사용한 AES 암호화 
	                    DBMS_CRYPTO.CHAIN_CBC +      -- CBC 모드 
	                    DBMS_CRYPTO.PAD_PKCS5;       -- PKCS5로 이루어진 패딩
	
   DBMS_OUTPUT.PUT_LINE ('원본 문자열: ' || input_string);

   -- RANDOMBYTES 함수를 사용해 암호화 키 생성 
   key_bytes_raw := DBMS_CRYPTO.RANDOMBYTES (num_key_bytes);
   
   -- ENCRYPT 함수로 암호화를 한다. 원본 문자열을 UTL_I18N.STRING_TO_RAW를 사용해 RAW 타입으로 변환한다. 
   encrypted_raw := DBMS_CRYPTO.ENCRYPT ( src => UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8'),   
                                          typ => encryption_type,
                                          key => key_bytes_raw
                                        );
                                        
   -- 암호화된 RAW 데이터를 한번 출력해보자
   DBMS_OUTPUT.PUT_LINE('암호화된 RAW 데이터: ' || encrypted_raw);                                     
   -- 암호화 한 데이터를 다시 복호화 ( 암호화했던 키와 암호화 슈트는 동일하게 사용해야 한다. )
   decrypted_raw := DBMS_CRYPTO.DECRYPT ( src => encrypted_raw,
                                          typ => encryption_type,
                                          key => key_bytes_raw
                                        );
   
   -- 복호화된 RAW 타입 데이터를 UTL_I18N.RAW_TO_CHAR를 사용해 다시 VARCHAR2로 변환 
   output_string := UTL_I18N.RAW_TO_CHAR (decrypted_raw, 'AL32UTF8');
   -- 복호화된 문자열 출력 
   DBMS_OUTPUT.PUT_LINE ('복호화된 문자열: ' || output_string);
END;



-- 단방향 암호화 해시 함수인 HASH, MAC 함수는 단방향으로 복호화가 매우 어렵고 
-- 통상 입력 값에 따라 암호화된 데이터를 비교함으로써 입력 값을 검증하는데 사용된다. 
-- ex 비밀번호 체크 
-- HASH, MAC 함수

DECLARE

  input_string  VARCHAR2 (200) := 'The Oracle';  -- 입력 VARCHAR2 데이터
  input_raw     RAW(128);                        -- 입력 RAW 데이터 
  encrypted_raw RAW (2000); -- 암호화 데이터 
  
BEGIN
	-- VARCHAR2를 RAW 타입으로 변환
	input_raw := UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8');
	
	
  DBMS_OUTPUT.PUT_LINE('----------- HASH 함수 -------------');
  encrypted_raw := DBMS_CRYPTO.HASH( src => input_raw,
                                     typ => DBMS_CRYPTO.HASH_SH1);
                                     
  DBMS_OUTPUT.PUT_LINE('입력 문자열의 해시값 : ' || RAWTOHEX(encrypted_raw));   
    
END;



-- 아이디와 비밀번호를 입력하면 이를 체크해 로그인하는 프로그램 
-- 사용자테이블의 아이디와 비밀번호를 저장하는데 이때 비밀번호를 입력된 번호 그대로 저장하는 것이 아니라 
-- 사용자가 입력한 값과 임의의 다른 값을 결합해 이를 HASH, MAC 함수의 입력 값으로 받아 반환된 결과 값을 비밀번호 컬럼에 저장. 
-- 시스템 관리자도 테이블의 암호화된 값을 알수 없고 오직 사용자만 알 수 있다. 

-- 비밀번호를 분실 했다면? 
-- 무작위로 신규비밀번호를 생성해 hash, mac 함수를 태워 변환된 값을 비밀번호 컬럼에 저장하고 사용자에게 신규 비밀번호를 부여 
-- 새로운 비번을 생성하게 유도함. 
-- 사용자가 만든 신규 비밀번호를 HASH나 MAC 함수의 매개변수로 받아 그 반환 값을 비밀번호 컬럼에 최종적으로 저장. 
DECLARE
 key_string VARCHAR2(8) := 'secret';  -- MAC 함수에서 사용할 비밀 키
  raw_key RAW(128) := UTL_RAW.CAST_TO_RAW(CONVERT(key_string,'AL32UTF8','US7ASCII')); -- 비밀키를 RAW 타입으로 변환
   
BEGIN
   DBMS_OUTPUT.PUT_LINE('----------- MAC 함수 -------------'); 
  encrypted_raw := DBMS_CRYPTO.MAC( src => input_raw,
                                    typ => DBMS_CRYPTO.HMAC_MD5,
                                    key => raw_key);   
                                    
  DBMS_OUTPUT.PUT_LINE('MAC 값 : ' || RAWTOHEX(encrypted_raw));
END;
/*
개인정보의 안전성 확보조치 기준(안전행정부고시 제2011-43호, 2011.9.30 제정)

 
개인정보보호법의 비밀번호 일방향 암호화 및 패스워드 관리 솔루션
패스워드의 일방향 암호화에 사용되는 HASH 함수
제7조(개인정보의 암호화)
①영 제21조 및 영 제30조제1항제3호에 따라 암호화하여야 하는 개인정보는 고유식별정보, 비밀번호 및 바이오정보를 말한다.
②개인정보처리자는 제1항에 따른 개인정보를 정보통신망을 통하여 송.수신하거나 보조저장매체 등을 통하여 전달하는 경우에는 이를 암호화하여야 한다.
③개인정보처리자는 비밀번호 및 바이오정보는 암호화하여 저장하여야 한다. 단 비밀번호를 저장하는 경우에는 복호화되지 아니하도록 일방향 암호화하여 저장하여야 한다.
④개인정보처리자는 인터넷 구간 및 인터넷 구간과 내부망의 중간 지점(DMZ : Demilitarized Zone)에 고유식별정보를 저장하는 경우에는 이를 암호화하여야 한다.
*/



SELECT *
FROM member;


--1. 단방향 암호화 함수를 생성하시오. (hash 함수)
--2. member 테이블pw 를
-- 암호화 하여 member_temp 테이블에 저장하시오

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



SELECT fn_encode_pw('안녕')
FROM dual;

CREATE TABLE member_temp AS
SELECT mem_id ,mem_name, fn_encode_pw(mem_pass) as mem_pass
FROM member;

SELECT *FROM member_temp
WHERE mem_id ='a001'
AND mem_pass = fn_encode_pw('asdfasdf');


