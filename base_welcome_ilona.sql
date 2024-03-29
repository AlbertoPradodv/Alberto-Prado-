DELETE FROM TMP_PILOTO_WELCOME WHERE NATIONAL_ID IS NULL OR REPLACE(TRANSLATE(CPF, '1234567890', ' '),' ','') IS NOT NULL,

DROP TABLE  TMP_ANALISE_BASE_EMAIL
CREATE TABLE TMP_ANALISE_BASE_EMAIL AS
SELECT DISTINCT CAST (A.NATIONAL_ID AS NUMERIC)  CPF
,A.ID0A72_EMAIL_ADR_X AS EMAIL_BASE_WELCOME
,B.DS_MAIL AS EMAIL_BASE_GTB
,A.ID0A72_CNTRY_ISO_C 
,A.CONSUMER_TYPE
 FROM TMP_PILOTO_WELCOME A
 LEFT JOIN  TAB_PROC_DBM_CLIE_UNIF B
 ON CAST (A.NATIONAL_ID AS NUMERIC) = B.NR_CPF

--SUMARIZACAO DE COUNT PARA CADA CASO
SELECT COUNT(*),CASE WHEN EMAIL_BASE_WELCOME = EMAIL_BASE_GTB THEN 'IGUAL' 
                     WHEN EMAIL_BASE_WELCOME <> EMAIL_BASE_GTB THEN 'DIFERENTE'        
                     WHEN EMAIL_BASE_GTB IS NULL THEN 'NULO'  END
FROM TMP_ANALISE_BASE_EMAIL
WHERE ID0A72_CNTRY_ISO_C = 'BRA'
AND CONSUMER_TYPE = 'I'
GROUP BY CASE WHEN EMAIL_BASE_WELCOME = EMAIL_BASE_GTB THEN 'IGUAL' 
                     WHEN EMAIL_BASE_WELCOME <> EMAIL_BASE_GTB THEN 'DIFERENTE'        
                     WHEN EMAIL_BASE_GTB IS NULL THEN 'NULO'  END
                     
   