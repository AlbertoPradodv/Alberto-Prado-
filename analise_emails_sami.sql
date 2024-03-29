--VERIFICANDO CPF
SELECT A.ID_REFERENCE_NUMBER
,VIN_ID
,B.CD_CHAS
,B.NR_CPF
,C.CPF
,C.IDINDIVIDUAL
FROM TMP_SAMIS_DATA A 
LEFT JOIN TMP_PROC_DBM_VEIC B
ON A.VIN_ID = B.CD_CHAS
LEFT JOIN FORD.INDIVIDUAL C
ON B.NR_CPF = C.CPF
WHERE SOURCE_CODE_DESCRIPTION = 'SAMIS'


--CRIANDO TABELA AUXILIAR 
CREATE TABLE TMP_COMP_EMAIL_SAMIS AS 
SELECT A.* 
,UPPER(B.DS_MAIL ) AS EMAIL_NOSSA_BASE

FROM TMP_COMP_EMAIL_SAMIS A
LEFT JOIN TAB_PROC_DBM_CLIE_UNIF B 
ON A.ID_REFERENCE_NUMBER = B.NR_CPF



--VERIFICANDO COMPARACAO
SELECT A.* 
,CASE WHEN  EMAIL_ADDRESS = EMAIL_NOSSA_BASE THEN 'EMAILS IGUAIS' 
WHEN EMAIL_ADDRESS <> EMAIL_NOSSA_BASE THEN 'EMAILS DIFERENTE'        
WHEN  EMAIL_ADDRESS IS NULL THEN 'EMAIL NAO PREENCHIDO BASE SAMIS'  
WHEN EMAIL_NOSSA_BASE IS NULL THEN 'EMAIL NAO PREENCHIDO NOSSA BASE' END AS COMP_EMAILS
FROM TMP_COMP_EMAIL_SAMIS A

