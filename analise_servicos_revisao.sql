SELECT DISTINCT A.NR_CPF
                ,B.DS_NOME
                ,A.CD_CHAS
                ,A.DS_MODL_RESM
                ,B.DS_CIDD
                ,B.DS_UF
                ,'REVISAO' AS TIPO_SERVICO
                ,C.DTREVISION
                ,C.IDDEALER
                ,CONCAT(B.NR_DDD_CELL, B.NR_CELL) AS CELULAR
                ,B.DS_MAIL
FROM TAB_PROC_DBM_TRAN A
LEFT JOIN TAB_PROC_DBM_CLIE_UNIF B
 ON A.NR_CPF = B.NR_CPF
LEFT JOIN  FORD.REVISION C
 ON A.CD_CHAS = C.DSVIN
WHERE C.DTREVISION BETWEEN TO_DATE('01/01/20','DD/MM/YY') AND TO_DATE('31/12/20','DD/MM/YY')
AND B.FG_INTR_12M = 1
AND CONCAT(B.NR_DDD_CELL, B.NR_CELL) IS NOT NULL