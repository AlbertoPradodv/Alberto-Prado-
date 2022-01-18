TRUNCATE TABLE TAB_PROC_ETL_VND_RECMPR;
TRUNCATE TABLE TAB_PROC_TDS_ETL_VND_RECMPR;
TRUNCATE TABLE TAB_PROC_ETL_VND_RECMPR_N;
TRUNCATE TABLE TAB_PROC_TDS_ETL_VND_RECMPR_N;
TRUNCATE TABLE TAB_PROC_TDS_ETL_VND_RECMPR_V2;
TRUNCATE TABLE TAB_PROC_ABG_HISTORICO_EMAIL;

INSERT INTO TAB_PROC_ETL_VND_RECMPR -- É TRUNCADA
SELECT VR.IDVEHICLEHOLDER
, VR.IDVEHICLE
, VR.DTPURCHASE
, VR.IDDEALER
, VF.CDTMA
, VF.DSVIN
, ROW_NUMBER()OVER(PARTITION BY VR.IDVEHICLEHOLDER ORDER BY VR.DTPURCHASE ASC) AS RANK_VR_ASC
, ROW_NUMBER()OVER(PARTITION BY VR.IDVEHICLEHOLDER ORDER BY VR.DTPURCHASE DESC) AS RANK_VR_DESC
, NULL AS POSSUI_FORD_ANTERIOR
, 0 AS MES
, 0 AS ANO
FROM FORD.VEHICLE V
INNER JOIN FORD.VEHICLERELATIONSHIP VR
ON V.IDVEHICLE = VR.IDVEHICLE
INNER JOIN FORD.VEHICLEFACT VF
ON V.IDVEHICLE = VF.IDVEHICLE
INNER JOIN FORD.INDIVIDUAL I
ON VR.IDVEHICLEHOLDER = I.IDINDIVIDUAL
WHERE VF.CDTMA IN ('BDA','KHC','KFA','GDA','FHC','FFC','NFB','NFA','FAD','BFA','BFC','BHC','CFA',
'CHC','EUA','BUA','FFA','FFB','EEF','2BC','4BC','3BB','4BB','6BC','7BC','6BB','7BB','EMA','NBJ')
AND VR.DTPURCHASE BETWEEN ADD_MONTHS(TRUNC(SYSDATE,'MM'),-1) AND ADD_MONTHS(LAST_DAY(SYSDATE),-1)
AND (VR.IDCREATESOURCE = 1 OR VR.IDDATASOURCE = 1);

INSERT INTO TAB_PROC_ETL_VND_RECMPR_N -- É TRUNCADA
SELECT *
FROM (SELECT VR.IDVEHICLEHOLDER
, VR.IDVEHICLE
, VR.DTPURCHASE
, VR.IDDEALER
, VF.CDTMA
, VF.DSVIN
, ROW_NUMBER()OVER(PARTITION BY VR.IDVEHICLEHOLDER ORDER BY VR.DTPURCHASE ASC) AS RANK_VR_ASC
, ROW_NUMBER()OVER(PARTITION BY VR.IDVEHICLEHOLDER ORDER BY VR.DTPURCHASE DESC) AS RANK_VR_DESC
, NULL AS POSSUI_FORD_ANTERIOR
, 0 AS MES
, 0 AS ANO
, CDSEQ
, ROW_NUMBER() OVER(PARTITION BY IDVEHICLEHOLDER ORDER BY DTPURCHASE DESC) SEQ
, NULL
FROM FORD.VEHICLE V
INNER JOIN FORD.VEHICLERELATIONSHIP VR
ON V.IDVEHICLE = VR.IDVEHICLE
INNER JOIN FORD.VEHICLEFACT VF
ON V.IDVEHICLE = VF.IDVEHICLE
INNER JOIN FORD.INDIVIDUAL I
ON VR.IDVEHICLEHOLDER = I.IDINDIVIDUAL
WHERE VF.CDTMA IN ('BDA','KHC','KFA','GDA','FHC','FFC','NFB','NFA','FAD','BFA','BFC','BHC','CFA',
'CHC','EUA','BUA','FFA','FFB','EEF','2BC','4BC','3BB','4BB','6BC','7BC','6BB','7BB','EMA','NBJ')
AND VR.DTPURCHASE BETWEEN ADD_MONTHS(TRUNC(SYSDATE,'MM'),-1) AND ADD_MONTHS(LAST_DAY(SYSDATE),-1)
AND (VR.IDCREATESOURCE = 1 OR VR.IDDATASOURCE = 1)
)
WHERE SEQ=1;

INSERT INTO TAB_PROC_TDS_ETL_VND_RECMPR -- É TRUNCADA
SELECT VR.IDVEHICLEHOLDER
, VR.IDVEHICLE
, VR.DTPURCHASE
, VR.IDDEALER
, VF.CDTMA
, VF.DSVIN
, ROW_NUMBER()OVER(PARTITION BY VR.IDVEHICLEHOLDER ORDER BY VR.DTPURCHASE ASC) AS RANK_VR_ASC
, ROW_NUMBER()OVER(PARTITION BY VR.IDVEHICLEHOLDER ORDER BY VR.DTPURCHASE DESC) AS RANK_VR_DESC
FROM FORD.VEHICLE V
INNER JOIN FORD.VEHICLERELATIONSHIP VR
ON V.IDVEHICLE = VR.IDVEHICLE
INNER JOIN FORD.VEHICLEFACT VF
ON V.IDVEHICLE = VF.IDVEHICLE
INNER JOIN FORD.INDIVIDUAL I
ON VR.IDVEHICLEHOLDER = I.IDINDIVIDUAL
WHERE VF.CDTMA IN ('BDA','KHC','KFA','GDA','FHC','FFC','NFB','NFA','FAD','BFA','BFC','BHC','CFA',
'CHC','EUA','BUA','FFA','FFB','EEF','2BC','4BC','3BB','4BB','6BC','7BC','6BB','7BB','EMA','NBJ')
AND VR.DTPURCHASE <= ADD_MONTHS(LAST_DAY(SYSDATE),-1)
AND (VR.IDCREATESOURCE = 1 OR VR.IDDATASOURCE = 1)
AND VR.IDVEHICLEHOLDER IN (SELECT IDVEHICLEHOLDER FROM TAB_PROC_ETL_VND_RECMPR); -- CRIADA NO PROCESSO

INSERT INTO TAB_PROC_TDS_ETL_VND_RECMPR_N -- É TRUNCADA
SELECT VR.IDVEHICLEHOLDER
, VR.IDVEHICLE
, VR.DTPURCHASE
, VR.IDDEALER
, VF.CDTMA
, VF.DSVIN
, ROW_NUMBER()OVER(PARTITION BY VR.IDVEHICLEHOLDER ORDER BY VR.DTPURCHASE ASC) AS RANK_VR_ASC
, ROW_NUMBER()OVER(PARTITION BY VR.IDVEHICLEHOLDER ORDER BY VR.DTPURCHASE DESC) AS RANK_VR_DESC
, CDSEQ
, NULL
FROM FORD.VEHICLE V
INNER JOIN FORD.VEHICLERELATIONSHIP VR
ON V.IDVEHICLE = VR.IDVEHICLE
INNER JOIN FORD.VEHICLEFACT VF
ON V.IDVEHICLE = VF.IDVEHICLE
INNER JOIN FORD.INDIVIDUAL I
ON VR.IDVEHICLEHOLDER = I.IDINDIVIDUAL
WHERE VF.CDTMA IN ('BDA','KHC','KFA','GDA','FHC','FFC','NFB','NFA','FAD','BFA','BFC','BHC','CFA',
'CHC','EUA','BUA','FFA','FFB','EEF','2BC','4BC','3BB','4BB','6BC','7BC','6BB','7BB','EMA','NBJ')
AND VR.DTPURCHASE <= ADD_MONTHS(LAST_DAY(SYSDATE),-1)
AND (VR.IDCREATESOURCE = 1 OR VR.IDDATASOURCE = 1)
AND VR.IDVEHICLEHOLDER IN (SELECT IDVEHICLEHOLDER FROM TAB_PROC_ETL_VND_RECMPR_N); -- CRIADA NO PROCESSO

UPDATE TAB_PROC_ETL_VND_RECMPR AA
SET AA.POSSUI_FORD_ANTERIOR = NULL;

UPDATE TAB_PROC_ETL_VND_RECMPR AA
SET AA.POSSUI_FORD_ANTERIOR = 'SIM'
WHERE EXISTS (SELECT 1
FROM TAB_PROC_TDS_ETL_VND_RECMPR BB
WHERE AA.IDVEHICLEHOLDER = BB.IDVEHICLEHOLDER
AND AA.DTPURCHASE > BB.DTPURCHASE);

UPDATE TAB_PROC_ETL_VND_RECMPR AA
SET AA.POSSUI_FORD_ANTERIOR = 'NAO'
WHERE POSSUI_FORD_ANTERIOR IS NULL;

UPDATE TAB_PROC_ETL_VND_RECMPR
SET MES = NULL;

UPDATE TAB_PROC_ETL_VND_RECMPR
SET ANO = NULL;

UPDATE TAB_PROC_ETL_VND_RECMPR
SET MES = TO_NUMBER(TO_CHAR(DTPURCHASE,'MM'));

UPDATE TAB_PROC_ETL_VND_RECMPR
SET ANO = TO_NUMBER(TO_CHAR(DTPURCHASE,'YYYY'));

DELETE
FROM TAB_PROC_TDS_ETL_VND_RECMPR_N
WHERE DSVIN IN (SELECT DSVIN
FROM TAB_PROC_ETL_VND_RECMPR_N);
COMMIT;

UPDATE TAB_PROC_ETL_VND_RECMPR_N AA
SET AA.POSSUI_FORD_ANTERIOR = NULL;

UPDATE TAB_PROC_ETL_VND_RECMPR_N AA
SET AA.POSSUI_FORD_ANTERIOR = 'SIM'
WHERE EXISTS (SELECT 1
FROM TAB_PROC_TDS_ETL_VND_RECMPR_N BB
WHERE AA.IDVEHICLEHOLDER = BB.IDVEHICLEHOLDER
AND AA.DTPURCHASE >= BB.DTPURCHASE);

UPDATE TAB_PROC_ETL_VND_RECMPR_N AA
SET AA.POSSUI_FORD_ANTERIOR = 'NAO'
WHERE POSSUI_FORD_ANTERIOR IS NULL;

UPDATE TAB_PROC_ETL_VND_RECMPR_N
SET MES = NULL;

UPDATE TAB_PROC_ETL_VND_RECMPR_N
SET ANO = NULL;

UPDATE TAB_PROC_ETL_VND_RECMPR_N
SET MES = TO_NUMBER(TO_CHAR(DTPURCHASE,'MM'));

UPDATE TAB_PROC_ETL_VND_RECMPR_N
SET ANO = TO_NUMBER(TO_CHAR(DTPURCHASE,'YYYY'));

UPDATE TAB_PROC_TDS_ETL_VND_RECMPR_N A
SET MODELO_ANTERIOR = (SELECT MODELO_FE
FROM TAB_PROC_DEPARA_DASH B
WHERE A.CDTMA = B.CDTMA);

INSERT INTO TAB_PROC_TDS_ETL_VND_RECMPR_V2
SELECT *
FROM (SELECT IDVEHICLEHOLDER
, IDVEHICLE
, DTPURCHASE
, IDDEALER
, CDTMA
, DSVIN
, RANK_VR_ASC
, RANK_VR_DESC
, CDSEQ
, MODELO_ANTERIOR
, ROW_NUMBER() OVER(PARTITION BY IDVEHICLEHOLDER ORDER BY DTPURCHASE DESC) SEQ
FROM TAB_PROC_TDS_ETL_VND_RECMPR_N
) B
WHERE SEQ = 1

INSERT INTO TAB_PROC_ABG_HISTORICO_EMAIL -- TRUNCADA NO PROCESSO
SELECT A.IDVEHICLEHOLDER
, B.DSEMAIL
, ROW_NUMBER() OVER(PARTITION BY A.IDVEHICLEHOLDER ORDER BY B.DTLASTUPDATE DESC) SEQ
, NULL
FROM TAB_PROC_TDS_ETL_VND_RECMPR_N A INNER JOIN FORD.EMAIL B
ON A.IDVEHICLEHOLDER = B.IDPERSON;
COMMIT;

DELETE FROM TAB_PROC_ABG_HISTORICO_EMAIL
WHERE SEQ>1;COMMIT;

UPDATE TAB_PROC_ABG_HISTORICO_EMAIL
SET FLOPTIN = 'N'
WHERE IDVEHICLEHOLDER IN (SELECT IDPERSON
FROM FORD.SPECIALHANDLINGFLAGS
WHERE FLPERMISSION IN ('0','N')
);
COMMIT;

UPDATE TAB_PROC_ABG_HISTORICO_EMAIL
SET FLOPTIN = 'S'
WHERE FLOPTIN IS NULL;
COMMIT;

DELETE FROM TAB_PROC_ABG_HISTORICO_EMAIL
WHERE FLOPTIN = 'N';COMMIT;

UPDATE TAB_PROC_ETL_VND_RECMPR_N A
SET DSEMAIL = (SELECT DSEMAIL
FROM TAB_PROC_ABG_HISTORICO_EMAIL B
WHERE A.IDVEHICLEHOLDER = B.IDVEHICLEHOLDER);COMMIT;

INSERT INTO TAB_PROC_ABG_HISTORICO -- HISTORICO
SELECT *
FROM VW_ETL_REPORT_VND_RECMPR_NEW -- VIEW