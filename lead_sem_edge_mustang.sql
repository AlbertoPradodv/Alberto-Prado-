CREATE TABLE TMP_LEAD_RESULT AS
SELECT DISTINCT CAST (I.CPF AS NUMERIC) CPF
FROM FORD.INDIVIDUAL I
INNER JOIN FORD.VEHICLERELATIONSHIP VR
ON I.IDINDIVIDUAL = VR.IDVEHICLEHOLDER
INNER JOIN FORD.VEHICLEFACT VF
ON VR.IDVEHICLE = VF.IDVEHICLE
INNER JOIN FORD.VEHICLE V
ON VF.IDVEHICLE = V.IDVEHICLE
INNER JOIN FORD.MAKERMODEL MM
ON V.DSORIGINALMODEL = MM.DSORIGINALMODEL
--INNER JOIN LEAD_TMP_TB LT
--ON I.CPF = LT.CPF
WHERE VR.DTPURCHASE BETWEEN TO_DATE('24/06/2019','DD/MM/YYYY') AND TO_DATE('24/09/2019','DD/MM/YYYY')
AND (VR.IDDATASOURCE = 1 OR VR.IDCREATESOURCE = 1)
AND MM.DSMAKER = 'FORD'
AND REPLACE(TRANSLATE(I.CPF, '1234567890', ' '),' ','') IS NULL
--AND LT.CPF = I.CPF

DELETE FROM LEAD_TMP_TB WHERE CPF IS NULL OR REPLACE(TRANSLATE(CPF, '1234567890', ' '),' ','') IS NOT NULL,

SELECT A.* ,
CASE WHEN B.CPF IS NULL THEN 0 ELSE 1 END
FROM LEAD_TMP_TB A
LEFT JOIN TMP_LEAD_RESULT B
ON A.CPF = CAST (B.CPF AS NUMERIC )
--WHERE CAST (A.CPF AS NUMERIC) > 100000
WHERE length(A.CPF) > 6