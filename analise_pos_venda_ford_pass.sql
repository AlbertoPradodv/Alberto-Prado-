SELECT A.NR_CPF
,C.DS_NOME
,C.DS_MAIL
,A.DT_COMP
,A.CD_CHAS
,A.CD_TMA
,A.DS_MODL_RESM
,B.*
FROM TAB_PROC_DBM_TRAN A
INNER JOIN TMP_JOINED_DNS B
ON A.ID_DEAL = B.DN
LEFT JOIN TAB_PROC_DBM_CLIE_UNIF C 
ON A.NR_CPF = C.NR_CPF
WHERE DS_MAIL IS NOT NULL
-----------------------------------------------------------------------
 SELECT A.*
,B.*
,C.CD_CHAS
FROM TMP_FDPASS_GUID A
LEFT JOIN TAB_PROC_DBM_TRAN C
ON A.CPF = C.NR_CPF
INNER JOIN TMP_JOINED_DNS B
ON C.ID_DEAL = B.DN
WHERE A.GUID IS NOT NULL