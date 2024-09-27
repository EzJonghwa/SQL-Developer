CREATE OR REPLACE PROCEDURE no_exception_proc
IS
    vi_num NUMBER :=0;
BEGIN
    vi_num :=10/0;
    DBMS_OUTPUT.PUT_LINE('SUCCESS!');
END;

BEGIN
    no_exception_proc;  -- 해당 프로시져 오류로 정상 종료 안됨. 중단됨
    DBMS_OUTPUT.PUT_LINE('종료');
END;





CREATE OR REPLACE PROCEDURE exception_proc
IS
    vi_num NUMBER :=0;
BEGIN
    vi_num :=10/0;
    DBMS_OUTPUT.PUT_LINE('SUCCESS!');
    EXCEPTION 
    WHEN ZERO_DIVIDE THEN
    DBMS_OUTPUT.PUT_LINE(SQLCODE);
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('오류처리');
END;
BEGIN
    exception_proc;  -- 해당 프로시저에서 문제가 일어나도 예외 처리를 했기 때문에 다음단계로 넘어감
    DBMS_OUTPUT.PUT_LINE('종료');
END;


/*
-------------------------------------------------------------------------------------------------------------------------------------
 1.사용자 정의 예외
-------------------------------------------------------------------------------------------------------------------------------------
   시스템 예외 이외에 사용자가 직접 예외를 정의 
   개발자가 직접 예외를 정의하는 방법.
-------------------------------------------------------------------------------------------------------------------------------------
[1] 사용자 예외 정의방법 
 (1) 예외 정의 : 사용자_정의_예외명 EXCEPTION;
 (2) 예외발생시키기 : RAISE 사용자_정의_예외명;
                    시스템 예외는 해당 예외가 자동으로 검출 되지만, 사용자 정의 예외는 직접 예외를 발생시켜야 한다.
                  RAISE 예외명 형태로 사용한다.
 (3) 발생된 예외 처리 : EXCEPTION WHEN 사용자_정의_예외명 THEN ..
*/
    CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                      p_emp_name       employees.emp_name%TYPE,
                      p_department_id  departments.department_id%TYPE )
    IS
       vn_employee_id  employees.employee_id%TYPE;
       vd_curr_date    DATE := SYSDATE;
       vn_cnt          NUMBER := 0;
       ex_invalid_depid EXCEPTION; -- (1) 잘못된 부서번호일 경우 예외 정의
    BEGIN
	     -- 부서테이블에서 해당 부서번호 존재유무 체크
	     SELECT COUNT(*)
	       INTO vn_cnt
	       FROM departments
	      WHERE department_id = p_department_id;
	     IF vn_cnt = 0 THEN
	        RAISE ex_invalid_depid; -- (2) 사용자 정의 예외 발생
	     END IF;
	     -- employee_id의 max 값에 +1
	     SELECT MAX(employee_id) + 1
	       INTO vn_employee_id
	       FROM employees; 
	     -- 사용자예외처리 예제이므로 사원 테이블에 최소한 데이터만 입력함
	     INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
                  VALUES ( vn_employee_id, p_emp_name, vd_curr_date, p_department_id );
       COMMIT;        
          
    EXCEPTION WHEN ex_invalid_depid THEN --(3) 사용자 정의 예외 처리구간 
                   DBMS_OUTPUT.PUT_LINE('해당 부서번호가 없습니다');
              WHEN OTHERS THEN
                   DBMS_OUTPUT.PUT_LINE(SQLERRM);              
    END;                	

EXEC ch10_ins_emp_proc ('홍길동', 999);





/*
--[2]시스템 예외에 이름 부여하기----------------------------------------------------------------------------------------------
 시스템 예외에는 ZERO_DIVIDE, INVALID_NUMBER .... 와같이 정의된 예외가 있다 하지만 이들처럼 예외명이 부여된 것은 
 시스템 예외 중 극소수이고 나머지는 예외코드만 존재한다. 이름이 없는 코드에 이름 부여하기.

	1.사용자 정의 예외 선언 
	2.사용자 정의 예외명과 시스템 예외 코드 연결 (PRAGMA EXCEPTION_INIT(사용자 정의 예외명, 시스템_예외_코드)

		/*
		   PRAGMA 컴파일러가 실행되기 전에 처리하는 전처리기 역할 
		   PRAGMA EXCEPTION_INIT(예외명, 예외번호)
		   사용자 정의 예외 처리를 할 때 사용되는것으로 
		   특정 예외번호를 명시해서 컴파일러에 이 예외를 사용한다는 것을 알리는 역할 
		   (해당 예외번호에 해당되는 시스템 에러시 발생)
           3.발생된 예외 처리:EXCEPTION WHEN 사용자 정의 예외명 THEN ....
		*/
	

CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE,
                  p_hire_month  VARCHAR2  )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   ex_invalid_depid EXCEPTION; -- 잘못된 부서번호일 경우 예외 정의
   ex_invalid_month EXCEPTION; -- 잘못된 입사월인 경우 예외 정의
   PRAGMA EXCEPTION_INIT (ex_invalid_month, -1843); -- 예외명과 예외코드 연결
BEGIN
	 -- 부서테이블에서 해당 부서번호 존재유무 체크
	 SELECT COUNT(*)
	   INTO vn_cnt
	   FROM departments
	 WHERE department_id = p_department_id;
	 IF vn_cnt = 0 THEN
	    RAISE ex_invalid_depid; -- 사용자 정의 예외 발생
	 END IF;
	 -- 입사월 체크 (1~12월 범위를 벗어났는지 체크)
	 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
	    RAISE ex_invalid_month; -- 사용자 정의 예외 발생
	 END IF;
	 -- employee_id의 max 값에 +1
	 SELECT MAX(employee_id) + 1
	   INTO vn_employee_id
	   FROM employees;
	 -- 사용자예외처리 예제이므로 사원 테이블에 최소한 데이터만 입력함
	 INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
              VALUES ( vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
   COMMIT;              
EXCEPTION WHEN ex_invalid_depid THEN -- 사용자 정의 예외 처리
               DBMS_OUTPUT.PUT_LINE('해당 부서번호가 없습니다');
          WHEN ex_invalid_month THEN -- 입사월 사용자 정의 예외
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               DBMS_OUTPUT.PUT_LINE('1~12월 범위를 벗어난 월입니다');               
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);              	
END;    
EXEC ch10_ins_emp_proc ('홍길동', 110, '201314');
/*
 [3].사용자 예외를 시스템 예외에 정의된 예외명을 사용----------------------------------------------------------------------------------------------
      RAISE 사용자 정의 예외 발생시 
      오라클에서 정의 되어 있는 예외를 발생 시킬수 있다. 
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE INVALID_NUMBER;
  END IF;
  DBMS_OUTPUT.PUT_LINE(p_num);
EXCEPTION WHEN INVALID_NUMBER THEN
               DBMS_OUTPUT.PUT_LINE('양수만 입력받을 수 있습니다');
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
EXEC ch10_raise_test_proc (-10);   

/*
[4].예외를 발생시킬 수 있는 내장 프로시저 ----------------------------------------------------------------------------------------------
  RAISE_APPLICATOIN_ERROR(예외코드, 예외 메세지);
  예외 코드와 메세지를 사용자가 직접 정의  -20000 ~ -20999 번까지 만 사용가능 
   왜냐면 오라클에서 이미 사용하고 있는 예외들이 위 번호 구간은 사용하지 않고 있기 때문에)
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE_APPLICATION_ERROR (-20000, '양수만 입력받을 수 있단 말입니다!');
	END IF;  
  DBMS_OUTPUT.PUT_LINE(p_num);
EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
EXEC ch10_raise_test_proc (-10);               




/*
    트랜 잭션 TRANSECTION
    은행에서 입금과 출근을 하는 '거래'를 말하는 단어로
    거래의 안저성을 확보하기 위한 방법이 트랜잭션 처리
    ORACLE 의COMMIT 과 ROLLBACK 을 사용하여
    특정 트랜잭션 단위의 처리가 모드 정상처리 되어야 COMMIT 되도록 
    정산ㅇ처리되지 않으면 ROLLBACK 하여 안정성을 확보함.
    SAVEPOINT 는 전체 취소가 아닌 특정 부분에서 
    트랜잭션을 취소할 수있다.

*/
CREATE TABLE ex10(
    ex_no NUMBER
    ,ex_nm VARCHAR2(50)
    );
CREATE OR REPLACE PROCEDURE save_test_proc(flag VARCHAR2)
IS
    point1 EXCEPTION;
    point2 EXCEPTION;
    vn_num NUMBER;
BEGIN
    INSERT INTO ex10 VALUES(1,'POINT1 BEFORE');
    SAVEPOINT mysavepoint1;
    INSERT INTO ex10 VALUES(2,'POINT2');
    SAVEPOINT mysavepoint2;
    INSERT INTO ex10 VALUES(2,'POINT2 AFTER');
    -- INSERT 가 일어남 SAVEPOINT 로 
    
    IF flag ='1' THEN
        RAISE point1;
    ELSIF flag = '2' THEN
        RAISE point2;
    ELSIF flag ='3' THEN
        vn_num :=10/0;
    END IF;
    COMMIT;
    -- TEST 를 위한 IF 문
    
EXCEPTION WHEN point1 THEN
        DBMS_OUTPUT.PUT_LINE('point1');
        ROLLBACK TO mysavepoint1;
        -- 일단 INSERT 가 3개가 일어난 상황이지만 SAVEPOINT 로 돌아가니
        -- POINT1만 INSERT가 됨
    COMMIT;
    WHEN point2 THEN
        DBMS_OUTPUT.PUT_LINE('point2');
        ROLLBACK TO mysavepoint2;
    COMMIT;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('others');
        ROLLBACK;
END;


EXEC save_test_proc('2');
SELECT *
FROM ex10;

DELETE ex10;



/*
  트리거 Trigger 
  사전적 의미로 총의 방아쇠를 뜻한다. 
  방아쇠가 당겨지면 -> 발사되는 개념

  어떤 테이블에 특정한 이벤트가 발생 되었을때 _ Trigger 가 동작
  INSERT, UPDATE, DELETE 의 DML문 또는 DDL 문이 실행 되었을때 
  데이터베이스에서 특정 이벤트가 발생되었다 라고 하는데 
  이런 이벤트가 발생하면 자동으로 정해진 동작을 실행하는 데이터베이스 객체

  * 트리거의 사용목적

   1.테이블 생성 과정에서 참조 무결성과 데이터 무결성 등의 복잡한 제약 조건을 생성하는 경우
   2.데이터베이스 테이블의 데이터에 생기는 작업의 감시, 보완
   3.데이터베이스 테이블에 생기는 변화에 따라 필요한 다른 프로그램을 실행하는 경우
   4.불필요한 트랜잭션을 금지하기 위해 
   5.컬럼의 값을 자동으로 생성되도록 하는 경우
   6.복잡한 뷰를 생성하는 경우 

   [기본형식]

   CREATE TRIGGER 트리거명

   BEFORE | AFTER          INSERT | DELETE | UPDATE (OF 컬럼...N)
   OF 컬럼명 ON 테이블명 
   FOR EACH ROW
   BEGIN 
    트리거내용
   END;

    SQL문 실행시기에 따른 분류


 실행시 영향을 받는 곳에 따른 분류

   * BEFORE OR AFTER  = 동작 시점을 설정 트랜잭션 발생 전, 또는 트랜잭션 이후 트리거 작동.
       before 트리거 : INSERT,UPDATE,DELETE 실행하기 전에 트리거 먼저 실행 됨
       after 트리거  : INSERT,UPDATE,DELETE 실행하고 난 후 트리거 실행 됨


   * INSERT | UPDATE | DELETE  = 이벤트 종류를 정의 INSERT OR UPDATE 처럼 복수의 이벤트를 정의할 수 있다. 

   * (OF 컬럼..N) ON 테이블명 = 트리거가 주목하는 대상 테이블을 정의하고 특정 컬럼의 이벤트에 트리거가 동작하려면 컬럼명을 명시해준다. 
      OF 이름 ON 학생
   * FOR EACH ROW   = 행 트리거를 정의한 내용으로 추가되는 행의 수만큼 트리거가 동작하여 행 내에서 이벤트가 발생되는걸 기준으로 트리거의 감시, 보완 범위를 정해두는 내용.
    
     FOR EACH ROW 를 쓰면 row(행) 트리거를 생성하고 WHEN 조건을 주면 WHEN 조건에 만족하는 ROW(행)만 트리거 적용 가능.
     즉,FOR EACH ROW를 안쓰면 statement(문장) 트리거 생성.

     - row 트리거 (행 트리거) : 실행된 트리거가 row(행) 하나하나 마다 실행 됨
     - statement 트리거(문장 트리거)
       실행된 트리거가 INSERT,UPDATE,DELETE 문장에 1번만 실행 됨

   * : OLD & : NEW  = 행트리거에서 컬럼의 실제 데이터 값을 제어하는데 사용되는 연산자  

      INSERT 문의 경우에 : NEW,
      UPDATE 문의 경우 변경 전 컬럼 데이터값은 :OLD, 수정할 새로운 데이터 값은 : NEW로 나타내고 
      DELETE 문의 경우 삭제되는 컬럼값은 : OLD 컬럼명에 저장된다.

      :OLD = 참조 전 열의 값 (INSERT : 입력 전 자료, UPDATE : 수정 전 자료, DELETE : 삭제할 자료)
      :NEW = 참조 후 열의 값 (INSERT : 입력 할 자료, UPDATE : 수정할 자료)

   * BEGIN ~ END = 트리거가 동작할 때 실행되는 내용을 정의한다. 


  * 트리거(TRIGGER)  생성시 고려사항

	1. 트리거는 각 테이블에 최대 3개까지 가능하다
	2. 트리거 내에서는 COMMIT,ROLLBACK 문을 사용할 수 없다.
	3. 이미 트리거가 정의된 작업에 대해 다른 트리거를 정의하면 기존의 것을 대체한다.
	4. 뷰나 임시 테이블을 참조할 수 있으나 생성 할 수는 없다.
	5. 트리거 동작은 이를 삭제하기 전까지 계속된다.
*/

CREATE TABLE EX11_1 AS
SELECT EMPLOYEE_ID
     , EMP_NAME
     , SALARY
FROM EMPLOYEES;


   CREATE OR REPLACE TRIGGER test1_trig
   BEFORE UPDATE
   ON EX11_1
   BEGIN
	DBMS_OUTPUT.PUT_LINE('요청하신 작업이 처리 되었습니다.');
   END;

SELECT *
FROM EX11_1;


UPDATE EX11_1
SET salary =1000
WHERE employee_id =198;

SELECT*
FROM TB_INFO;

CREATE TRIGGER info_trigger2
BEFORE UPDATE OF EMAIL ON tb_info
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE(:OLD.EMAIL);
    DBMS_OUTPUT.PUT_LINE(:NEW.EMAIL);
    RAISE_APPLICATION_ERROR(-20001,'수정하지마!');
END;

UPDATE tb_info
SET ENAIL ='JDJDJDJ@NABER.COM'
WHERE info_no =1;


-- 트리거 삭제 기본형식
/*
DROP TRIGGER 트리거명 

ALTER TRIGGER 트리거명 [ENABLE / DISABLE]
ENABLE  : 사용
DISABLE : 사용하지 않음

INVALID : 문제있음
VALID   : 사용가능
*/
-- 트리거는 항상 데이터베이스를 감시하기 때문에 시스템 자원을 많이 소모한다. 그래서 꼭 필요한 상황에만 사용하기를 권장

-- 트리거 상태정검

SELECT A.OWNER 
     , A.TRIGGER_NAME
     , A.STATUS
     , B.STATUS
FROM ALL_TRIGGERS A
   , ALL_OBJECTS B
WHERE A.TRIGGER_NAME = B.OBJECT_NAME
AND A.OWNER = 'JAVA';


--ALL_TRIGGERS, ALL_OBJECTS 테이블은 오라클의 트리거 상태 정보와 OBJECT 의 상태 정보를 가지고 있는 
--오라클의 딕셔너리 테이블.

CREATE OR REPLACE TRIGGER test2_trig
 BEFORE UPDATE
 OF SALARY ON EX11_1  -- 컬럼을 체크
BEGIN
 DBMS_OUTPUT.PUT_LINE('요청하신 작업이 처리 되었습니다.');
END;
------------------------------------------------------------------
-- 업데이트를 통해 트리거 확인 
UPDATE EX11_1
SET SALARY_IMSI  = 100
WHERE EMPLOYEE_ID =199;

SELECT *
FROM test2_trig;


-- 컬럼 수정을 하여 트리거에 문제가 생기도록.
ALTER TABLE EX11_1 RENAME COLUMN SALARY TO SALARY_IMSI;

UPDATE EX11_1
SET SALARY_IMSI  = 100
WHERE EMPLOYEE_ID =199;

-- 트리거가 사용되지 않도록
ALTER TRIGGER TEST2_TRIG DISABLE;

-- 다시 컬럼을 변경
ALTER TABLE EX11_1 RENAME COLUMN SALARY_IMSI TO  SALARY;

-- 트리거 사용으로 변경
ALTER TRIGGER TEST2_TRIG ENABLE;

-- INVALID 된 트리거는 다시 컴파일 해줘서 -> VALID 로 변경될 수 있도록 해야 작동함.



CREATE TABLE ex15_tb(
     id VARCHAR2(20)
    ,name  VARCHAR2(20)
);
CREATE TABLE ex15_check(
     memo VARCHAR2(20)
    ,createDt DATE DEFAULT SYSDATE
);
-- statement  trigger
 
-- 트리거를 가진 테이블 자료를 입력,수정,삭제 한 후 로그(메모) 테이블에 입력,수정,삭제한 정보를 기록하게하는 트리거--
DROP TRIGGER after_statement_trigger; -- 이미 있을 경우 삭제하고 시작
 
CREATE OR REPLACE TRIGGER after_statement_trigger
   AFTER DELETE OR INSERT OR UPDATE ON ex15_tb
BEGIN
  -- 삽입할 때
   IF INSERTING THEN -- 이 트리거를 가진 ex15_tb에 insert 문장이 실행되면 밑에것(ex15_check에 insert)도 실행
     INSERT INTO ex15_check(memo) VALUES ('insert');
  -- 수정할 때
   ELSIF UPDATING THEN -- 이 트리거를 가진 ex15_tb에 update 문장이 실행되면 밑에것(ex15_check에 update)도 실행
     INSERT INTO ex15_check(memo) VALUES ('update');
  -- 삭제할 때
   ELSIF DELETING THEN -- 이 트리거를 가진 ex15_tb에 delete 문장이 실행되면 밑에것(ex15_check에 delete)도 실행
     INSERT INTO ex15_check(memo) VALUES ('delete');
   END IF;
END;

/
--INSERTING : 이 트리거를 가진 테이블의 문장이 INSERT일때 TRUE 그렇지 않으면 FALSE
--UPDATING  : 이 트리거를 가진 테이블의 문장이 UPDATE일때 TRUE 그렇지 않으면 FALSE
--DELETING  : 이 트리거를 가진 테이블의 문장이 DELETE일때 TRUE 그렇지 않으면 FALSE
 
-- 트리거 점검 --
INSERT INTO ex15_tb(id, name) VALUES (1, 'aaaa');
INSERT INTO ex15_tb(id, name) VALUES (2, 'bbbb');
COMMIT;

SELECT * FROM ex15_tb;
SELECT * FROM ex15_check;



---------------------------------------------------------------------------------------------
    
    
    CREATE TABLE 상품 (
       상품코드 VARCHAR2(10) CONSTRAINT 상품_PK PRIMARY KEY 
      ,상품명   VARCHAR2(100) NOT NULL
      ,제조사  VARCHAR2(100)
      ,소비자가격 NUMBER
      ,재고수량 NUMBER DEFAULT 0
    );
    
    CREATE TABLE 입고 (
       입고번호 NUMBER CONSTRAINT 입고_PK PRIMARY KEY
      ,상품코드 VARCHAR(10) CONSTRAINT 입고_FK REFERENCES 상품(상품코드)
      ,입고일자 DATE DEFAULT SYSDATE
      ,입고수량 NUMBER
      ,입고단가 NUMBER
      ,입고금액 NUMBER
    );
    
    INSERT INTO 상품 (상품코드, 상품명, 제조사, 소비자가격) VALUES ('a001','마우스','삼성','1000');
    INSERT INTO 상품 (상품코드, 상품명, 제조사, 소비자가격) VALUES ('a002','마우스','NKEY','2000');
    INSERT INTO 상품 (상품코드, 상품명, 제조사, 소비자가격) VALUES ('b001','키보드','LG','2000');
    INSERT INTO 상품 (상품코드, 상품명, 제조사, 소비자가격) VALUES ('c001','모니터','삼성','1000');
    
    
    SELECT *
    FROM 상품;
    
    
    SELECT *
    FROM 입고;

----------------- 다음과 같은 트리거를 생성하시오 

-- 입고테이블 INSERT 트리거 

CREATE OR REPLACE TRIGGER warehousing_insert
AFTER INSERT ON 입고

FOR EACH ROW -- TRIGGER OLD NEW 사용을 위한 공식

DECLARE
    vn_cnt 상품.재고수량%TYPE;
    vn_nm 상품.상품명%type;
BEGIN
    SELECT 재고수량, 상품명
    INTO vn_cnt, vn_nm
    FROM 상품
    WHERE 상품코드 =:NEW.상품코드;
    
    UPDATE 상품
    SET 재고수량 =:NEW.입고수량 + 재고수량
    WHERE 상품코드 = :NEW.상품코드;
    DBMS_OUTPUT.PUT_LINE(vn_nm || '제품의 수량 정보가 변경 되었습니다.');
    DBMS_OUTPUT.PUT_LINE('입고전 재고수량:'||vn_cnt);
    DBMS_OUTPUT.PUT_LINE('입고수량:'||:NEW.입고수량);
    DBMS_OUTPUT.PUT_LINE('입고후 재고수량:'||(vn_cnt+ :NEW.입고수량));
END;

INSERT INTO 입고(입고번호,상품코드,입고수량,입고단가,입고금액)
VALUES(1,'a002',100,1000,100000);
INSERT INTO 입고(입고번호,상품코드,입고수량,입고단가,입고금액)
VALUES(2,'a002',100,1000,100000);

SELECT*
FROM 상품;

CREATE OR REPLACE TRIGGER warehousing_delete
AFTER DELETE ON 입고
FOR EACH ROW
BEGIN 
    UPDATE 상품
    SET 재고수량 = 재고수량 -:OLD.입고수량
    WHERE 상품코드 =:OLD.상품코드;
END;
DELETE 입고
WHERE 입고번호 = 2;

SELECT *
FROM 상품;

-- 입고 테이블에 수정 트리거 (warehousing_update)
-- 입고 테이블에 상품의 입고 수량이 변경 되었을때 상품 테이블의 재고 수량 변경
CREATE OR REPLACE TRIGGER warehousing_update
AFTER UPDATE ON 입고
FOR EACH ROW
DECLARE
    vn_cnt 상품.재고수량%TYPE;
    vn_nm 상품.상품명%type;
BEGIN
    SELECT 재고수량, 상품명
    INTO vn_cnt, vn_nm
    FROM 상품
    WHERE 상품코드 = :NEW.상품코드;
    
    UPDATE 상품
    SET 재고수량 = 재고수량 - :OLD.입고수량 + :NEW.입고수량ㅑ
    WHERE 상품코드 = :NEW.상품코드;
    
    DBMS_OUTPUT.PUT_LINE(vn_nm || ' 제품의 수량 정보가 변경되었습니다.');
    DBMS_OUTPUT.PUT_LINE('수정 전 재고수량: ' || vn_cnt);
    DBMS_OUTPUT.PUT_LINE('변경 입고 수량: ' || :OLD.입고수량 || ' -> ' || :NEW.입고수량);
    DBMS_OUTPUT.PUT_LINE('수정 후 재고수량: ' || (vn_cnt + (:NEW.입고수량 - :OLD.입고수량)));
END;

UPDATE 입고
SET 입고수량 =50
WHERE 입고번호 =1;

SELECT *
FROM 입고;

-- 입력트리거 (입고테이블에 상품이 입력되었을 때 재고수량 증가) EX (warehousing_insert)
예 ) 입고테이블에 키보드가 10 개 입고되었을때 자동으로 상품테이블의 'A002' 상품의 재고가 0 -> 10 으로 변경

-- 수정 트리거(입고테이블에 상품의 입고수량이 변경되었을때 상품테이블의 재고수량 변경) (warehousing_update)
-- 삭제 트리거(입고테이블 특정 데이터 삭제시 상품 제고 수량 변경) (warehousing_delete)
------------------------------------------------------------------------------







