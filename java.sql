SELECT info_no
,nm
,email
,hobby
FROM tb_info;

DROP TRIGGER INFO_TRIGGER;


INSERT INTO tb_inf0 (info_no,nm)
VALUES ((SELECT nvl(max(info_no),0)+1
                        FROM tb_info),'펭순');
                        
SELECT *
FROM 학생
                        
INSERT INTO 학생 (학번,이름)
VALUES ((SELECT nvl(max(학번),0)+1
                        FROM 학생),?);
                        