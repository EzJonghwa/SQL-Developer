SELECT info_no
,nm
,email
,hobby
FROM tb_info;

DROP TRIGGER INFO_TRIGGER;


INSERT INTO tb_inf0 (info_no,nm)
VALUES ((SELECT nvl(max(info_no),0)+1
                        FROM tb_info),'���');
                        
SELECT *
FROM �л�
                        
INSERT INTO �л� (�й�,�̸�)
VALUES ((SELECT nvl(max(�й�),0)+1
                        FROM �л�),?);
                        