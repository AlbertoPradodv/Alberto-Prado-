
--PARTE 1 


--VALIDOS - QTY =  2621291
SELECT COUNT(DISTINCT CAST(I.CPF AS NUMERIC)) 

  FROM FORD.INDIVIDUAL I
 INNER JOIN FORD.VEHICLERELATIONSHIP VR
    ON I.IDINDIVIDUAL = VR.IDVEHICLEHOLDER
 INNER JOIN FORD.VEHICLEFACT VF
    ON VR.IDVEHICLE = VF.IDVEHICLE
 INNER JOIN FORD.VEHICLE V
    ON VF.IDVEHICLE = V.IDVEHICLE
 INNER JOIN FORD.MAKERMODEL MM
    ON V.DSORIGINALMODEL = MM.DSORIGINALMODEL
 INNER JOIN DIASW.DEPARA_DASH DP 
    ON VF.CDTMA = DP.CDTMA
 WHERE VR.DTPURCHASE BETWEEN TO_DATE('01/01/2000','DD/MM/YYYY') AND TO_DATE('31/12/2019','DD/MM/YYYY')
   AND (VR.IDDATASOURCE = 1 OR VR.IDCREATESOURCE = 1)7
   AND MM.DSMAKER = 'FORD'
   AND REPLACE(TRANSLATE(I.CPF, '1234567890', ' '),' ','') IS NULL
   AND NVL(I.CPF,'0')<>'0'

-- INVALIDOS - QTY =  7
SELECT COUNT(DISTINCT I.CPF ) 

  FROM FORD.INDIVIDUAL I
 INNER JOIN FORD.VEHICLERELATIONSHIP VR
    ON I.IDINDIVIDUAL = VR.IDVEHICLEHOLDER
 INNER JOIN FORD.VEHICLEFACT VF
    ON VR.IDVEHICLE = VF.IDVEHICLE
 INNER JOIN FORD.VEHICLE V
    ON VF.IDVEHICLE = V.IDVEHICLE
 INNER JOIN FORD.MAKERMODEL MM
    ON V.DSORIGINALMODEL = MM.DSORIGINALMODEL
 INNER JOIN DIASW.DEPARA_DASH DP 
    ON VF.CDTMA = DP.CDTMA
 WHERE VR.DTPURCHASE BETWEEN TO_DATE('01/01/2000','DD/MM/YYYY') AND TO_DATE('31/12/2019','DD/MM/YYYY')
   AND (VR.IDDATASOURCE = 1 OR VR.IDCREATESOURCE = 1)
   AND MM.DSMAKER = 'FORD'
   AND REPLACE(TRANSLATE(I.CPF, '1234567890', ' '),' ','') IS NOT NULL

--TOTAL - 34948110
SELECT COUNT(DISTINCT IDINDIVIDUAL ) 
FROM FORD.INDIVIDUAL

--CONCATENACAO  - QTY = 2631220
SELECT COUNT( DISTINCT CONCAT (CAST(I.CPF AS NUMERIC),I.NMFIRST) )

  FROM FORD.INDIVIDUAL I
 INNER JOIN FORD.VEHICLERELATIONSHIP VR
    ON I.IDINDIVIDUAL = VR.IDVEHICLEHOLDER
 INNER JOIN FORD.VEHICLEFACT VF
    ON VR.IDVEHICLE = VF.IDVEHICLE
 INNER JOIN FORD.VEHICLE V
    ON VF.IDVEHICLE = V.IDVEHICLE
 INNER JOIN FORD.MAKERMODEL MM
    ON V.DSORIGINALMODEL = MM.DSORIGINALMODEL
 INNER JOIN DIASW.DEPARA_DASH DP 
    ON VF.CDTMA = DP.CDTMA
 WHERE VR.DTPURCHASE BETWEEN TO_DATE('01/01/2000','DD/MM/YYYY') AND TO_DATE('31/12/2019','DD/MM/YYYY')
   AND (VR.IDDATASOURCE = 1 OR VR.IDCREATESOURCE = 1)
   AND MM.DSMAKER = 'FORD'
   AND REPLACE(TRANSLATE(I.CPF, '1234567890', ' '),' ','') IS  NULL
   AND NVL(I.CPF,'0')<>'0'
   
--CPF X CPF 
CREATE TABLE TMP_CPF_NOME_DISTN AS

SELECT CAST(I.CPF AS NUMERIC) AS CPF
,COUNT( DISTINCT I.NMFIRST) AS CONTAGEM

  FROM FORD.INDIVIDUAL I
 INNER JOIN FORD.VEHICLERELATIONSHIP VR
    ON I.IDINDIVIDUAL = VR.IDVEHICLEHOLDER
 INNER JOIN FORD.VEHICLEFACT VF
    ON VR.IDVEHICLE = VF.IDVEHICLE
 INNER JOIN FORD.VEHICLE V
    ON VF.IDVEHICLE = V.IDVEHICLE
 INNER JOIN FORD.MAKERMODEL MM
    ON V.DSORIGINALMODEL = MM.DSORIGINALMODEL
 INNER JOIN DIASW.DEPARA_DASH DP 
    ON VF.CDTMA = DP.CDTMA
 WHERE VR.DTPURCHASE BETWEEN TO_DATE('01/01/2000','DD/MM/YYYY') AND TO_DATE('31/12/2019','DD/MM/YYYY')
   AND (VR.IDDATASOURCE = 1 OR VR.IDCREATESOURCE = 1)
   AND MM.DSMAKER = 'FORD'
   AND REPLACE(TRANSLATE(I.CPF, '1234567890', ' '),' ','') IS NULL
   AND NVL(I.CPF,'0')<>'0'
   GROUP BY CAST(I.CPF AS NUMERIC)
    
    SELECT A.CONTAGEM 
,COUNT(  A.CONTAGEM) 
FROM  TMP_CPF_NOME_DISTN A 
GROUP BY A.CONTAGEM


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--PART 2 


-- Endereço TOTAL QTY = 3408824 / VALIDOS = 3376283

--TOTAL 

CREATE TABLE TMP_PROC_DBM_ENDR AS
SELECT CAST(A.CPF AS NUMERIC) AS NR_CPF
     , A.IDINDIVIDUAL   AS ID_INDV
     , B.TPSTREET       AS DS_TP_LOGR
     , B.DSADDRESS      AS DS_LOGR
     , B.NBADDRESS      AS DS_NUMR
     , B.DSCOMPLEMENT   AS DS_COMP
     , B.NMDISTRICT     AS DS_BAIR
     , B.NBPOSTALCODE   AS CD_CEP
     , B.DSCITY         AS DS_CIDD
     , B.CDSTATE        AS DS_UF
     , ROW_NUMBER() OVER(PARTITION BY CAST(A.CPF AS NUMERIC) ORDER BY B.DTLASTUPDATE DESC) AS NR_SEQC
     , 1                AS FG_VALD
  FROM FORD.INDIVIDUAL       A 
 INNER JOIN FORD.ADDRESS     B  
    ON A.IDINDIVIDUAL = B.IDPERSON
 INNER JOIN TMP_PROC_DBM_PUBL D
    ON A.IDINDIVIDUAL = D.ID_INDV 
 WHERE REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL;

DELETE FROM TMP_PROC_DBM_ENDR
 WHERE NR_SEQC <> 1;


SELECT COUNT (*) FROM TMP_PROC_DBM_ENDR


--VALIDOS

CREATE TABLE TMP_PROC_DBM_ENDR AS
SELECT CAST(A.CPF AS NUMERIC) AS NR_CPF
     , A.IDINDIVIDUAL   AS ID_INDV
     , B.TPSTREET       AS DS_TP_LOGR
     , B.DSADDRESS      AS DS_LOGR
     , B.NBADDRESS      AS DS_NUMR
     , B.DSCOMPLEMENT   AS DS_COMP
     , B.NMDISTRICT     AS DS_BAIR
     , B.NBPOSTALCODE   AS CD_CEP
     , B.DSCITY         AS DS_CIDD
     , B.CDSTATE        AS DS_UF
     , ROW_NUMBER() OVER(PARTITION BY CAST(A.CPF AS NUMERIC) ORDER BY B.DTLASTUPDATE DESC) AS NR_SEQC
     , 1                AS FG_VALD
  FROM FORD.INDIVIDUAL       A 
 INNER JOIN FORD.ADDRESS     B  
    ON A.IDINDIVIDUAL = B.IDPERSON
 INNER JOIN TMP_PROC_DBM_PUBL D
    ON A.IDINDIVIDUAL = D.ID_INDV 
 WHERE REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL;

DELETE FROM TMP_PROC_DBM_ENDR
 WHERE NR_SEQC <> 1;

UPDATE TMP_PROC_DBM_ENDR
   SET FG_VALD = 0
 WHERE ((DS_UF = 'AC' AND CD_CEP NOT LIKE '699%')
    OR  (DS_UF = 'AL' AND CD_CEP NOT LIKE '57%')
    OR  (DS_UF = 'AM' AND (CD_CEP NOT LIKE '690%' AND CD_CEP NOT LIKE '691%' AND CD_CEP NOT LIKE '692%' AND CD_CEP NOT LIKE '694%' AND CD_CEP NOT LIKE '695%' AND CD_CEP NOT LIKE '696%' AND CD_CEP NOT LIKE '697%' AND CD_CEP NOT LIKE '698%'))
    OR  (DS_UF = 'AP' AND CD_CEP NOT LIKE '689%')
    OR  (DS_UF = 'BA' AND (CD_CEP NOT LIKE '40%' AND CD_CEP NOT LIKE '41%' AND CD_CEP NOT LIKE '42%' AND CD_CEP NOT LIKE '43%' AND CD_CEP NOT LIKE '44%' AND CD_CEP NOT LIKE '45%' AND CD_CEP NOT LIKE '46%' AND CD_CEP NOT LIKE '47%' AND CD_CEP NOT LIKE '48%'))
    OR  (DS_UF = 'CE' AND (CD_CEP NOT LIKE '60%' AND CD_CEP NOT LIKE '61%' AND CD_CEP NOT LIKE '62%' AND CD_CEP NOT LIKE '63%'))
    OR  (DS_UF = 'DF' AND (CD_CEP NOT LIKE '70%' AND CD_CEP NOT LIKE '71%' AND CD_CEP NOT LIKE '72%' AND CD_CEP NOT LIKE '73%'))
    OR  (DS_UF = 'ES' AND CD_CEP NOT LIKE '29%')
    OR  (DS_UF = 'GO' AND (CD_CEP NOT LIKE '72%' AND CD_CEP NOT LIKE '73%' AND CD_CEP NOT LIKE '74%' AND CD_CEP NOT LIKE '75%' AND CD_CEP NOT LIKE '76%'))
    OR  (DS_UF = 'MA' AND CD_CEP NOT LIKE '65%')
    OR  (DS_UF = 'MG' AND CD_CEP NOT LIKE '3%')
    OR  (DS_UF = 'MS' AND CD_CEP NOT LIKE '79%')
    OR  (DS_UF = 'MT' AND (CD_CEP NOT LIKE '780%' AND CD_CEP NOT LIKE '781%' AND CD_CEP NOT LIKE '782%' AND CD_CEP NOT LIKE '783%' AND CD_CEP NOT LIKE '784%' AND CD_CEP NOT LIKE '785%' AND CD_CEP NOT LIKE '786%' AND CD_CEP NOT LIKE '787%' AND CD_CEP NOT LIKE '788%'))
    OR  (DS_UF = 'PA' AND (CD_CEP NOT LIKE '66%' AND CD_CEP NOT LIKE '67%' AND CD_CEP NOT LIKE '68%'))
    OR  (DS_UF = 'PB' AND CD_CEP NOT LIKE '58%')
    OR  (DS_UF = 'PE' AND (CD_CEP NOT LIKE '50%' AND CD_CEP NOT LIKE '51%' AND CD_CEP NOT LIKE '52%' AND CD_CEP NOT LIKE '53%' AND CD_CEP NOT LIKE '54%' AND CD_CEP NOT LIKE '55%' AND CD_CEP NOT LIKE '56%'))
    OR  (DS_UF = 'PI' AND CD_CEP NOT LIKE '64%')
    OR  (DS_UF = 'PR' AND (CD_CEP NOT LIKE '80%' AND CD_CEP NOT LIKE '81%' AND CD_CEP NOT LIKE '82%' AND CD_CEP NOT LIKE '83%' AND CD_CEP NOT LIKE '84%' AND CD_CEP NOT LIKE '85%' AND CD_CEP NOT LIKE '86%' AND CD_CEP NOT LIKE '87%'))
    OR  (DS_UF = 'RJ' AND (CD_CEP NOT LIKE '20%' AND CD_CEP NOT LIKE '21%' AND CD_CEP NOT LIKE '22%' AND CD_CEP NOT LIKE '23%' AND CD_CEP NOT LIKE '24%' AND CD_CEP NOT LIKE '25%' AND CD_CEP NOT LIKE '26%' AND CD_CEP NOT LIKE '27%' AND CD_CEP NOT LIKE '28%'))
    OR  (DS_UF = 'RN' AND CD_CEP NOT LIKE '59%')
    OR  (DS_UF = 'RO' AND CD_CEP NOT LIKE '789%')
    OR  (DS_UF = 'RR' AND CD_CEP NOT LIKE '693%')
    OR  (DS_UF = 'RS' AND CD_CEP NOT LIKE '9%')
    OR  (DS_UF = 'SC' AND (CD_CEP NOT LIKE '88%' AND CD_CEP NOT LIKE '89%'))
    OR  (DS_UF = 'SE' AND CD_CEP NOT LIKE '49%')
    OR  (DS_UF = 'SP' AND (CD_CEP NOT LIKE '0%' AND CD_CEP NOT LIKE '1%'))
    OR  (DS_UF = 'TO' AND CD_CEP NOT LIKE '77%')); COMMIT;
 
DELETE FROM TMP_PROC_DBM_ENDR
 WHERE FG_VALD = 0; COMMIT;

SELECT COUNT (*) FROM TMP_PROC_DBM_ENDR


-- UF  TOTAL QTY = 3408824 / VALIDOS = 3376283

--TOTAL 

CREATE TABLE TMP_PROC_DBM_ENDR AS
SELECT CAST(A.CPF AS NUMERIC) AS NR_CPF
     , A.IDINDIVIDUAL   AS ID_INDV
     , B.TPSTREET       AS DS_TP_LOGR
     , B.DSADDRESS      AS DS_LOGR
     , B.NBADDRESS      AS DS_NUMR
     , B.DSCOMPLEMENT   AS DS_COMP
     , B.NMDISTRICT     AS DS_BAIR
     , B.NBPOSTALCODE   AS CD_CEP
     , B.DSCITY         AS DS_CIDD
     , B.CDSTATE        AS DS_UF
     , ROW_NUMBER() OVER(PARTITION BY CAST(A.CPF AS NUMERIC) ORDER BY B.DTLASTUPDATE DESC) AS NR_SEQC
     , 1                AS FG_VALD
  FROM FORD.INDIVIDUAL       A 
 INNER JOIN FORD.ADDRESS     B  
    ON A.IDINDIVIDUAL = B.IDPERSON
 INNER JOIN TMP_PROC_DBM_PUBL D
    ON A.IDINDIVIDUAL = D.ID_INDV 
 WHERE REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL;

DELETE FROM TMP_PROC_DBM_ENDR
 WHERE NR_SEQC <> 1;

SELECT COUNT (*) FROM TMP_PROC_DBM_ENDR

--VALIDOS

CREATE TABLE TMP_PROC_DBM_ENDR AS
SELECT CAST(A.CPF AS NUMERIC) AS NR_CPF
     , A.IDINDIVIDUAL   AS ID_INDV
     , B.TPSTREET       AS DS_TP_LOGR
     , B.DSADDRESS      AS DS_LOGR
     , B.NBADDRESS      AS DS_NUMR
     , B.DSCOMPLEMENT   AS DS_COMP
     , B.NMDISTRICT     AS DS_BAIR
     , B.NBPOSTALCODE   AS CD_CEP
     , B.DSCITY         AS DS_CIDD
     , B.CDSTATE        AS DS_UF
     , ROW_NUMBER() OVER(PARTITION BY CAST(A.CPF AS NUMERIC) ORDER BY B.DTLASTUPDATE DESC) AS NR_SEQC
     , 1                AS FG_VALD
  FROM FORD.INDIVIDUAL       A 
 INNER JOIN FORD.ADDRESS     B  
    ON A.IDINDIVIDUAL = B.IDPERSON
 INNER JOIN TMP_PROC_DBM_PUBL D
    ON A.IDINDIVIDUAL = D.ID_INDV 
 WHERE REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL;

DELETE FROM TMP_PROC_DBM_ENDR
 WHERE NR_SEQC <> 1;

UPDATE TMP_PROC_DBM_ENDR
   SET FG_VALD = 0
 WHERE ((DS_UF = 'AC' AND CD_CEP NOT LIKE '699%')
    OR  (DS_UF = 'AL' AND CD_CEP NOT LIKE '57%')
    OR  (DS_UF = 'AM' AND (CD_CEP NOT LIKE '690%' AND CD_CEP NOT LIKE '691%' AND CD_CEP NOT LIKE '692%' AND CD_CEP NOT LIKE '694%' AND CD_CEP NOT LIKE '695%' AND CD_CEP NOT LIKE '696%' AND CD_CEP NOT LIKE '697%' AND CD_CEP NOT LIKE '698%'))
    OR  (DS_UF = 'AP' AND CD_CEP NOT LIKE '689%')
    OR  (DS_UF = 'BA' AND (CD_CEP NOT LIKE '40%' AND CD_CEP NOT LIKE '41%' AND CD_CEP NOT LIKE '42%' AND CD_CEP NOT LIKE '43%' AND CD_CEP NOT LIKE '44%' AND CD_CEP NOT LIKE '45%' AND CD_CEP NOT LIKE '46%' AND CD_CEP NOT LIKE '47%' AND CD_CEP NOT LIKE '48%'))
    OR  (DS_UF = 'CE' AND (CD_CEP NOT LIKE '60%' AND CD_CEP NOT LIKE '61%' AND CD_CEP NOT LIKE '62%' AND CD_CEP NOT LIKE '63%'))
    OR  (DS_UF = 'DF' AND (CD_CEP NOT LIKE '70%' AND CD_CEP NOT LIKE '71%' AND CD_CEP NOT LIKE '72%' AND CD_CEP NOT LIKE '73%'))
    OR  (DS_UF = 'ES' AND CD_CEP NOT LIKE '29%')
    OR  (DS_UF = 'GO' AND (CD_CEP NOT LIKE '72%' AND CD_CEP NOT LIKE '73%' AND CD_CEP NOT LIKE '74%' AND CD_CEP NOT LIKE '75%' AND CD_CEP NOT LIKE '76%'))
    OR  (DS_UF = 'MA' AND CD_CEP NOT LIKE '65%')
    OR  (DS_UF = 'MG' AND CD_CEP NOT LIKE '3%')
    OR  (DS_UF = 'MS' AND CD_CEP NOT LIKE '79%')
    OR  (DS_UF = 'MT' AND (CD_CEP NOT LIKE '780%' AND CD_CEP NOT LIKE '781%' AND CD_CEP NOT LIKE '782%' AND CD_CEP NOT LIKE '783%' AND CD_CEP NOT LIKE '784%' AND CD_CEP NOT LIKE '785%' AND CD_CEP NOT LIKE '786%' AND CD_CEP NOT LIKE '787%' AND CD_CEP NOT LIKE '788%'))
    OR  (DS_UF = 'PA' AND (CD_CEP NOT LIKE '66%' AND CD_CEP NOT LIKE '67%' AND CD_CEP NOT LIKE '68%'))
    OR  (DS_UF = 'PB' AND CD_CEP NOT LIKE '58%')
    OR  (DS_UF = 'PE' AND (CD_CEP NOT LIKE '50%' AND CD_CEP NOT LIKE '51%' AND CD_CEP NOT LIKE '52%' AND CD_CEP NOT LIKE '53%' AND CD_CEP NOT LIKE '54%' AND CD_CEP NOT LIKE '55%' AND CD_CEP NOT LIKE '56%'))
    OR  (DS_UF = 'PI' AND CD_CEP NOT LIKE '64%')
    OR  (DS_UF = 'PR' AND (CD_CEP NOT LIKE '80%' AND CD_CEP NOT LIKE '81%' AND CD_CEP NOT LIKE '82%' AND CD_CEP NOT LIKE '83%' AND CD_CEP NOT LIKE '84%' AND CD_CEP NOT LIKE '85%' AND CD_CEP NOT LIKE '86%' AND CD_CEP NOT LIKE '87%'))
    OR  (DS_UF = 'RJ' AND (CD_CEP NOT LIKE '20%' AND CD_CEP NOT LIKE '21%' AND CD_CEP NOT LIKE '22%' AND CD_CEP NOT LIKE '23%' AND CD_CEP NOT LIKE '24%' AND CD_CEP NOT LIKE '25%' AND CD_CEP NOT LIKE '26%' AND CD_CEP NOT LIKE '27%' AND CD_CEP NOT LIKE '28%'))
    OR  (DS_UF = 'RN' AND CD_CEP NOT LIKE '59%')
    OR  (DS_UF = 'RO' AND CD_CEP NOT LIKE '789%')
    OR  (DS_UF = 'RR' AND CD_CEP NOT LIKE '693%')
    OR  (DS_UF = 'RS' AND CD_CEP NOT LIKE '9%')
    OR  (DS_UF = 'SC' AND (CD_CEP NOT LIKE '88%' AND CD_CEP NOT LIKE '89%'))
    OR  (DS_UF = 'SE' AND CD_CEP NOT LIKE '49%')
    OR  (DS_UF = 'SP' AND (CD_CEP NOT LIKE '0%' AND CD_CEP NOT LIKE '1%'))
    OR  (DS_UF = 'TO' AND CD_CEP NOT LIKE '77%')); COMMIT;
 
DELETE FROM TMP_PROC_DBM_ENDR
 WHERE FG_VALD = 0; COMMIT;

SELECT COUNT (*) FROM TMP_PROC_DBM_ENDR

-- Telefone/CELULAR TOTAL QTY = 4028825 / VALIDOS = 2137216

--TOTAL 

CREATE TABLE TMP_PROC_DBM_TELF AS
SELECT CAST(A.CPF AS NUMERIC)  AS NR_CPF
     , A.IDINDIVIDUAL   AS ID_INDV
     , CASE WHEN TPTELEPHONE = 'M' THEN 'CELULAR' ELSE 'FIXO' END AS DS_TP_TELF
     , B.NBAREACODE     AS NR_DDD_TELF
     , B.NBTELEPHONE    AS NR_TELF
     , ROW_NUMBER() OVER(PARTITION BY CAST(A.CPF AS NUMERIC), CASE WHEN TPTELEPHONE = 'M' THEN 'CELULAR' ELSE 'FIXO' END ORDER BY B.DTLASTUPDATE DESC) AS NR_SEQC
  FROM FORD.INDIVIDUAL        A 
 INNER JOIN FORD.TELEPHONE    B  
    ON A.IDINDIVIDUAL = B.IDPERSON
 INNER JOIN TMP_PROC_DBM_PUBL D
    ON A.IDINDIVIDUAL = D.ID_INDV
 WHERE TPTELEPHONE <> 'I'
   AND REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL;  
    
COMMIT;

DELETE FROM TMP_PROC_DBM_TELF
 WHERE NR_SEQC <> 1;COMMIT;

 SELECT COUNT (*) FROM TMP_PROC_DBM_TELF


 --VALIDOS

  DROP TABLE TMP_PROC_DBM_TELF; COMMIT; 
CREATE TABLE TMP_PROC_DBM_TELF AS
SELECT CAST(A.CPF AS NUMERIC)  AS NR_CPF
     , A.IDINDIVIDUAL   AS ID_INDV
     , CASE WHEN TPTELEPHONE = 'M' THEN 'CELULAR' ELSE 'FIXO' END AS DS_TP_TELF
     , B.NBAREACODE     AS NR_DDD_TELF
     , B.NBTELEPHONE    AS NR_TELF
     , ROW_NUMBER() OVER(PARTITION BY CAST(A.CPF AS NUMERIC), CASE WHEN TPTELEPHONE = 'M' THEN 'CELULAR' ELSE 'FIXO' END ORDER BY B.DTLASTUPDATE DESC) AS NR_SEQC
  FROM FORD.INDIVIDUAL        A 
 INNER JOIN FORD.TELEPHONE    B  
    ON A.IDINDIVIDUAL = B.IDPERSON
 INNER JOIN TMP_PROC_DBM_PUBL D
    ON A.IDINDIVIDUAL = D.ID_INDV
 WHERE TPTELEPHONE <> 'I'
   AND REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL;  
    
COMMIT;

DELETE FROM TMP_PROC_DBM_TELF
 WHERE NR_SEQC <> 1;COMMIT;
 
DELETE FROM TMP_PROC_DBM_TELF
 WHERE LENGTH(NR_DDD_TELF) <> 2
    OR LENGTH(NR_TELF) NOT BETWEEN 8 AND 9
    OR SUBSTR(NR_TELF,1,1) = 1
    OR NR_DDD_TELF = SUBSTR(NR_TELF,1,2);COMMIT;

DELETE FROM TMP_PROC_DBM_TELF
 WHERE SUBSTR(NR_TELF, 3,1) IN ('5','6','7','8','9')
   AND DS_TP_TELF <> 'CELULAR'; COMMIT;
   
DELETE FROM TMP_PROC_DBM_TELF
 WHERE SUBSTR(NR_TELF, 3,1) NOT IN ('5','6','7','8','9')
   AND DS_TP_TELF = 'CELULAR'; COMMIT;
   
DELETE FROM TMP_PROC_DBM_TELF
 WHERE LENGTH(NR_TELF) <> 8
   AND DS_TP_TELF <> 'CELULAR'; COMMIT;
   
UPDATE TMP_PROC_DBM_TELF
   SET NR_TELF = '9'||NR_TELF
 WHERE DS_TP_TELF = 'CELULAR'
   AND LENGTH(NR_TELF) = 8;COMMIT;
   
 SELECT COUNT (*) FROM TMP_PROC_DBM_TELF

-- Email  TOTAL QTY = 1711221 / VALIDOS = 1687646 - VERIFICAR 

--TOTAL 

CREATE TABLE TMP_PROC_DBM_MAIL AS
SELECT CAST(A.CPF AS NUMERIC) AS NR_CPF
     , A.IDINDIVIDUAL   AS ID_INDV
     , LOWER(B.DSEMAIL) AS DS_MAIL
     , 0 AS FG_INTR
     , 0 AS FG_INTR_12M
     , 0 AS FG_INTR_18M
     , 0 AS FG_INTR_24M
     , ROW_NUMBER() OVER(PARTITION BY CAST(A.CPF AS NUMERIC) ORDER BY B.DTLASTUPDATE DESC) AS NR_SEQC
  FROM FORD.INDIVIDUAL       A 
 INNER JOIN FORD.EMAIL       B  
    ON A.IDINDIVIDUAL = B.IDPERSON
 INNER JOIN TMP_PROC_DBM_PUBL D
    ON A.IDINDIVIDUAL = D.ID_INDV
   WHERE REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL;

 SELECT COUNT (*) FROM TMP_PROC_DBM_MAIL


-- VALIDADOS

 DROP TABLE TMP_PROC_DBM_MAIL; COMMIT;
CREATE TABLE TMP_PROC_DBM_MAIL AS
SELECT CAST(A.CPF AS NUMERIC) AS NR_CPF
     , A.IDINDIVIDUAL   AS ID_INDV
     , LOWER(B.DSEMAIL) AS DS_MAIL
     , 0 AS FG_INTR
     , 0 AS FG_INTR_12M
     , 0 AS FG_INTR_18M
     , 0 AS FG_INTR_24M
     , ROW_NUMBER() OVER(PARTITION BY CAST(A.CPF AS NUMERIC) ORDER BY B.DTLASTUPDATE DESC) AS NR_SEQC
  FROM FORD.INDIVIDUAL       A 
 INNER JOIN FORD.EMAIL       B  
    ON A.IDINDIVIDUAL = B.IDPERSON
 INNER JOIN TMP_PROC_DBM_PUBL D
    ON A.IDINDIVIDUAL = D.ID_INDV
 WHERE DBMTOOLS.ISEMAIL(DSEMAIL) = 1  AND DSEMAIL LIKE '%@%.%'
   AND DSEMAIL NOT LIKE '%@ford%'     AND DSEMAIL NOT LIKE '%@naote%'
   AND DSEMAIL NOT LIKE '%@nao%'      AND DSEMAIL NOT LIKE '%@test%'
   AND DSEMAIL NOT LIKE '%@asd%'      AND DSEMAIL NOT LIKE '%@.com%'
   AND DSEMAIL NOT LIKE '%@xxx%'      AND DSEMAIL NOT LIKE '%hahaha%'
   AND DSEMAIL NOT LIKE '%tenho%'     AND DSEMAIL NOT LIKE '%/%'
   AND DSEMAIL NOT LIKE '%(%'         AND DSEMAIL NOT LIKE '%,%'
   AND DSEMAIL NOT LIKE '%;%'         AND DSEMAIL NOT LIKE '%\%'
   AND DSEMAIL NOT LIKE '%.@%'        AND DSEMAIL NOT LIKE '%@.%'
   AND DSEMAIL NOT LIKE '% %'         AND DSEMAIL NOT LIKE '%nao%te%'
   AND DSEMAIL NOT LIKE '%@com%'      AND DSEMAIL NOT LIKE '%veic%'
   AND DSEMAIL NOT LIKE '%auto%'      AND DSEMAIL NOT LIKE '%ford%'
   AND DSEMAIL NOT LIKE '%venda%'     AND DSEMAIL NOT LIKE '%atendimento%'
   AND DSEMAIL NOT LIKE '%combr'      AND DSEMAIL NOT LIKE '%possu%'
   AND DSEMAIL NOT LIKE 'nao%'        AND DSEMAIL NOT LIKE '%test%' 
   AND REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL;

DELETE FROM TMP_PROC_DBM_MAIL
 WHERE NR_SEQC <> 1;
COMMIT;

UPDATE TMP_PROC_DBM_MAIL 
   SET FG_INTR = 1
 WHERE LOWER(DS_MAIL) IN 
        (SELECT LOWER(EMAILADDRESS) AS EMAIL
           FROM SERBINOC.TB_EXACT_OPENS A
          GROUP BY LOWER(EMAILADDRESS));COMMIT;

UPDATE TMP_PROC_DBM_MAIL 
   SET FG_INTR_12M = 1
 WHERE LOWER(DS_MAIL) IN 
        (SELECT LOWER(EMAILADDRESS) AS EMAIL
           FROM SERBINOC.TB_EXACT_OPENS A
          WHERE MONTHS_BETWEEN (SYSDATE,EVENTDATE) <= 12
          GROUP BY LOWER(EMAILADDRESS));COMMIT;

UPDATE TMP_PROC_DBM_MAIL 
   SET FG_INTR_18M = 1
 WHERE LOWER(DS_MAIL) IN 
        (SELECT LOWER(EMAILADDRESS) AS EMAIL
           FROM SERBINOC.TB_EXACT_OPENS A
          WHERE MONTHS_BETWEEN (SYSDATE,EVENTDATE) <= 18
          GROUP BY LOWER(EMAILADDRESS));COMMIT;

UPDATE TMP_PROC_DBM_MAIL 
   SET FG_INTR_24M = 1
 WHERE LOWER(DS_MAIL) IN 
        (SELECT LOWER(EMAILADDRESS) AS EMAIL
           FROM SERBINOC.TB_EXACT_OPENS A
          WHERE MONTHS_BETWEEN (SYSDATE,EVENTDATE) <= 24
          GROUP BY LOWER(EMAILADDRESS));COMMIT;

 SELECT COUNT (*) FROM TMP_PROC_DBM_MAIL


-- Idade  TOTAL QTY = 18510389 / VALIDOS = 18510389

SELECT COUNT(*) DTBIRTHDATE 
FROM FORD.INDIVIDUALSTANDARDDEMOGRAPHICS
WHERE DTBIRTHDATE IS NOT NULL

-- Genero  TOTAL QTY = 34702121 / VALIDOS = 34702121

SELECT COUNT(*) TPGENDER 
FROM FORD.INDIVIDUAL
WHERE TPGENDER IS NOT NULL


--------------------------------------------------------------------------------------------------------------------------------------------------------------
--PARTE 3 EMAILS

--TOTAL DE EMAILS QTY = 6493925

SELECT COUNT ( DISTINCT DSEMAIL) FROM FORD.EMAIL

--EMAILS ASSOCIADOS  QTY = 1711221

 DROP TABLE TMP_PROC_DBM_MAIL; COMMIT;
CREATE TABLE TMP_PROC_DBM_MAIL AS
SELECT CAST(A.CPF AS NUMERIC) AS NR_CPF
     , A.IDINDIVIDUAL   AS ID_INDV
     , LOWER(B.DSEMAIL) AS DS_MAIL
     , 0 AS FG_INTR
     , 0 AS FG_INTR_12M
     , 0 AS FG_INTR_18M
     , 0 AS FG_INTR_24M
     , ROW_NUMBER() OVER(PARTITION BY CAST(A.CPF AS NUMERIC) ORDER BY B.DTLASTUPDATE DESC) AS NR_SEQC
  FROM FORD.INDIVIDUAL       A 
 INNER JOIN FORD.EMAIL       B  
    ON A.IDINDIVIDUAL = B.IDPERSON
 INNER JOIN TMP_PROC_DBM_PUBL D
    ON A.IDINDIVIDUAL = D.ID_INDV
 WHERE DBMTOOLS.ISEMAIL(DSEMAIL) = 1  AND DSEMAIL LIKE '%@%.%'
   AND DSEMAIL NOT LIKE '%@ford%'     AND DSEMAIL NOT LIKE '%@naote%'
   AND DSEMAIL NOT LIKE '%@nao%'      AND DSEMAIL NOT LIKE '%@test%'
   AND DSEMAIL NOT LIKE '%@asd%'      AND DSEMAIL NOT LIKE '%@.com%'
   AND DSEMAIL NOT LIKE '%@xxx%'      AND DSEMAIL NOT LIKE '%hahaha%'
   AND DSEMAIL NOT LIKE '%tenho%'     AND DSEMAIL NOT LIKE '%/%'
   AND DSEMAIL NOT LIKE '%(%'         AND DSEMAIL NOT LIKE '%,%'
   AND DSEMAIL NOT LIKE '%;%'         AND DSEMAIL NOT LIKE '%\%'
   AND DSEMAIL NOT LIKE '%.@%'        AND DSEMAIL NOT LIKE '%@.%'
   AND DSEMAIL NOT LIKE '% %'         AND DSEMAIL NOT LIKE '%nao%te%'
   AND DSEMAIL NOT LIKE '%@com%'      AND DSEMAIL NOT LIKE '%veic%'
   AND DSEMAIL NOT LIKE '%auto%'      AND DSEMAIL NOT LIKE '%ford%'
   AND DSEMAIL NOT LIKE '%venda%'     AND DSEMAIL NOT LIKE '%atendimento%'
   AND DSEMAIL NOT LIKE '%combr'      AND DSEMAIL NOT LIKE '%possu%'
   AND DSEMAIL NOT LIKE 'nao%'        AND DSEMAIL NOT LIKE '%test%' 
   AND REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL;

DELETE FROM TMP_PROC_DBM_MAIL
 WHERE NR_SEQC <> 1;
COMMIT;

UPDATE TMP_PROC_DBM_MAIL 
   SET FG_INTR = 1
 WHERE LOWER(DS_MAIL) IN 
        (SELECT LOWER(EMAILADDRESS) AS EMAIL
           FROM SERBINOC.TB_EXACT_OPENS A
          GROUP BY LOWER(EMAILADDRESS));COMMIT;

UPDATE TMP_PROC_DBM_MAIL 
   SET FG_INTR_12M = 1
 WHERE LOWER(DS_MAIL) IN 
        (SELECT LOWER(EMAILADDRESS) AS EMAIL
           FROM SERBINOC.TB_EXACT_OPENS A
          WHERE MONTHS_BETWEEN (SYSDATE,EVENTDATE) <= 12
          GROUP BY LOWER(EMAILADDRESS));COMMIT;

UPDATE TMP_PROC_DBM_MAIL 
   SET FG_INTR_18M = 1
 WHERE LOWER(DS_MAIL) IN 
        (SELECT LOWER(EMAILADDRESS) AS EMAIL
           FROM SERBINOC.TB_EXACT_OPENS A
          WHERE MONTHS_BETWEEN (SYSDATE,EVENTDATE) <= 18
          GROUP BY LOWER(EMAILADDRESS));COMMIT;

UPDATE TMP_PROC_DBM_MAIL 
   SET FG_INTR_24M = 1
 WHERE LOWER(DS_MAIL) IN 
        (SELECT LOWER(EMAILADDRESS) AS EMAIL
           FROM SERBINOC.TB_EXACT_OPENS A
          WHERE MONTHS_BETWEEN (SYSDATE,EVENTDATE) <= 24
          GROUP BY LOWER(EMAILADDRESS));COMMIT;

SELECT IDPERSON
FROM  FORD.EMAIL
HAVING COUNT (IDPERSON)>1
GROUP BY I  DPERSON


SELECT COUNT (*) FROM TMP_PROC_DBM_MAIL


--MEDIA EMAILS POR PESSOA -- MEDIA = 1,33

SELECT AVG (CONTAGEM) FROM 
(SELECT CAST(B.CPF AS NUMERIC) AS CPF
,COUNT( DISTINCT A.DSEMAIL) AS CONTAGEM
FROM  FORD.EMAIL A 
INNER JOIN FORD.INDIVIDUAL B  
ON A.IDPERSON = B.IDINDIVIDUAL
WHERE REPLACE(TRANSLATE(B.CPF, '1234567890', ' '),' ','') IS NULL
AND B.CPF IS NOT NULL
GROUP BY CAST(B.CPF AS NUMERIC)
)

--QUANTIDADE DA QUANTIDADE DE PESSOAS DIFERENTES COM O MESMO EMAIL 

CREATE TABLE TMP_QTD_EMAIL_PS AS
SELECT LOWER(A.DSEMAIL) AS EMAIL
,COUNT (DISTINCT CAST(B.CPF AS NUMERIC)) AS CONTAGEM
FROM FORD.EMAIL A 
INNER JOIN FORD.INDIVIDUAL B  
ON A.IDPERSON = B.IDINDIVIDUAL
WHERE REPLACE(TRANSLATE(B.CPF, '1234567890', ' '),' ','') IS NULL
AND B.CPF IS NOT NULL
GROUP BY LOWER(A.DSEMAIL)


SELECT A.CONTAGEM 
,COUNT(  A.CONTAGEM) 
FROM  TMP_QTD_EMAIL_PS A 
GROUP BY A.CONTAGEM

--EMAILS PREENCHIDOS ERRONEAMENTE - 53337


SELECT COUNT( DISTINCT LOWER(DSEMAIL)) FROM FORD.EMAIL
WHERE  LOWER(DSEMAIL) NOT LIKE '%@%.%'
OR LOWER(DSEMAIL)  LIKE '%@ford%'     OR LOWER(DSEMAIL)  LIKE '%@naote%'
   OR LOWER(DSEMAIL)  LIKE '%@nao%'      OR LOWER(DSEMAIL)  LIKE '%@test%'
   OR LOWER(DSEMAIL)  LIKE '%@asd%'      OR LOWER(DSEMAIL)  LIKE '%@.com%'
   OR LOWER(DSEMAIL)  LIKE '%@xxx%'      OR LOWER(DSEMAIL)  LIKE '%hahaha%'
   OR LOWER(DSEMAIL)  LIKE '%tenho%'     OR LOWER(DSEMAIL)  LIKE '%/%'
   OR LOWER(DSEMAIL)  LIKE '%(%'         OR LOWER(DSEMAIL)  LIKE '%,%'
   OR LOWER(DSEMAIL)  LIKE '%;%'         OR LOWER(DSEMAIL)  LIKE '%\%'
   OR LOWER(DSEMAIL)  LIKE '%.@%'        OR LOWER(DSEMAIL)  LIKE '%@.%'
   OR LOWER(DSEMAIL)  LIKE '% %'         OR LOWER(DSEMAIL)  LIKE '%nao%te%'
   OR LOWER(DSEMAIL)  LIKE '%@com%'      OR LOWER(DSEMAIL)  LIKE '%veic%'
   OR LOWER(DSEMAIL)  LIKE '%auto%'      OR LOWER(DSEMAIL)  LIKE '%ford%'
   OR LOWER(DSEMAIL)  LIKE '%venda%'     OR LOWER(DSEMAIL)  LIKE '%atendimento%'
   OR LOWER(DSEMAIL)  LIKE '%combr'      OR LOWER(DSEMAIL)  LIKE '%possu%'
   OR LOWER(DSEMAIL)  LIKE 'nao%'        OR LOWER(DSEMAIL)  LIKE '%test%' 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--PARTE 3 TELEFONE 

-- TOTAL DE TELEFONES QTY = 24895103

SELECT COUNT ( DISTINCT NBTELEPHONE) FROM FORD.TELEPHONE

--TOTAL TELEFONES ASSOCIADOS = 4028825

CREATE TABLE TMP_PROC_DBM_TELF AS
SELECT CAST(A.CPF AS NUMERIC)  AS NR_CPF
     , A.IDINDIVIDUAL   AS ID_INDV
     , CASE WHEN TPTELEPHONE = 'M' THEN 'CELULAR' ELSE 'FIXO' END AS DS_TP_TELF
     , B.NBAREACODE     AS NR_DDD_TELF
     , B.NBTELEPHONE    AS NR_TELF
     , ROW_NUMBER() OVER(PARTITION BY CAST(A.CPF AS NUMERIC), CASE WHEN TPTELEPHONE = 'M' THEN 'CELULAR' ELSE 'FIXO' END ORDER BY B.DTLASTUPDATE DESC) AS NR_SEQC
  FROM FORD.INDIVIDUAL        A 
 INNER JOIN FORD.TELEPHONE    B  
    ON A.IDINDIVIDUAL = B.IDPERSON
 INNER JOIN TMP_PROC_DBM_PUBL D
    ON A.IDINDIVIDUAL = D.ID_INDV
 WHERE TPTELEPHONE <> 'I'
   AND REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL;  
    
COMMIT;

DELETE FROM TMP_PROC_DBM_TELF
 WHERE NR_SEQC <> 1;COMMIT;


SELECT COUNT (*) FROM TMP_PROC_DBM_TELF


--MEDIA TELEFONES POR PESSOA -- MEDIA = 1.92

SELECT AVG (CONTAGEM) FROM 
(SELECT CAST(B.CPF AS NUMERIC) AS CPF
,COUNT( DISTINCT A.NBTELEPHONE) AS CONTAGEM
FROM  FORD.TELEPHONE A 
INNER JOIN FORD.INDIVIDUAL B  
ON A.IDPERSON = B.IDINDIVIDUAL
WHERE REPLACE(TRANSLATE(B.CPF, '1234567890', ' '),' ','') IS NULL
AND B.CPF IS NOT NULL
GROUP BY CAST(B.CPF AS NUMERIC)
)

--QUANTIDADE DA QUANTIDADE DE PESSOAS DIFERENTES COM O MESMO TELEFONE 

CREATE TABLE TMP_QTD_TELEFONE_PS AS
SELECT A.NBTELEPHONE AS TELEFONE
,COUNT (DISTINCT CAST(B.CPF AS NUMERIC)) AS CONTAGEM
FROM FORD.TELEPHONE A 
INNER JOIN FORD.INDIVIDUAL B  
ON A.IDPERSON = B.IDINDIVIDUAL
WHERE REPLACE(TRANSLATE(B.CPF, '1234567890', ' '),' ','') IS NULL
AND B.CPF IS NOT NULL
GROUP BY A.NBTELEPHONE



SELECT A.CONTAGEM 
,COUNT(  A.CONTAGEM) 
FROM  TMP_QTD_TELEFONE_PS A 
GROUP BY A.CONTAGEM


--TELEFONES PREENCHIDOS ERRONEAMENTE = 4545176 -- VERIFICAR


   SELECT COUNT( DISTINCT NBTELEPHONE )
   FROM FORD.TELEPHONE
   WHERE TPTELEPHONE ='I'
   OR  LENGTH(NBAREACODE) <> 2
   OR LENGTH(NBTELEPHONE) NOT BETWEEN 8 AND 9
   OR SUBSTR(NBTELEPHONE,1,1) = 1
   OR NBAREACODE = SUBSTR(NBTELEPHONE,1,2)
  
/*
 SELECT COUNT (DISTINCT NBTELEPHONE) FROM FORD.TELEPHONE
   WHERE TPTELEPHONE ='I'
   OR  LENGTH(NBAREACODE) = 2
   OR LENGTH(NBTELEPHONE)  BETWEEN 8 AND 9
   OR SUBSTR(NBTELEPHONE,1,1) <> 1
   OR NBAREACODE <> SUBSTR(NBTELEPHONE,1,2)
   OR SUBSTR(NBTELEPHONE, 3,1) NOT IN ('5','6','7','8','9')
   AND CASE WHEN TPTELEPHONE = 'M' THEN 'CELULAR' ELSE 'FIXO' END <> 'CELULAR'
   OR SUBSTR(NBTELEPHONE, 3,1)  IN ('5','6','7','8','9')
   AND CASE WHEN TPTELEPHONE = 'M' THEN 'CELULAR' ELSE 'FIXO' END = 'CELULAR'
   OR  LENGTH(NBTELEPHONE) <> 8
   AND CASE WHEN TPTELEPHONE = 'M' THEN 'CELULAR' ELSE 'FIXO' END <> 'CELULAR'
   OR CASE WHEN TPTELEPHONE = 'M' THEN 'CELULAR' ELSE 'FIXO' END = 'CELULAR'
   AND LENGTH(NBTELEPHONE) = 8
*/

