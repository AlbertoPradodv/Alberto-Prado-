--AGOSTO A DEZEMBRO -- 6,85%

--TOTAL DE VENDAS RANGER XLT - AGOSTO A DEZEMBRO
SELECT COUNT (NR_CPF) -- contagem = 2308
FROM TAB_PROC_DBM_TRAN
WHERE CD_SEQC IN (
 'H119'
,'H676'
,'H679'
,'H786'
,'HCB0'
,'HJB1'
,'HMB1'
,'6H95'
,'H019'
,'H702'
,'H749'
,'H768'
,'JSA4'
,'JSW8'
,'JSA5'
,'JSB7'
,'JSA8'
,'JSC5'
,'JSA7'
,'JSW9'
,'JSB4'
,'JSA3'
,'JS06'
,'JSX9'
,'JMB3'
,'JMN5'
,'JM86'
,'JMP7'
,'JMZ8'
,'JMZ9'
,'JMK4'
,'JMC4'
,'JMB4'
,'JMC5'
,'JMD7'
,'JMD5'
,'JMX9'
,'JMJ4'
,'JMC3'
,'JMO5'
,'JMX8'
,'JMD8'
,'JMC0'
,'H677'
,'H715'
,'H717'
,'H748'
,'HCB1'
,'786H'
,'G610'
,'H714'
,'H752'
,'HCA1'
,'HJC1'
,'HMB0'
,'HMB2'
,'6H65'
,'6H78'
,'H423'
,'H459'
,'H665'
,'H674'
,'H694'
,'H695'
,'H701'
,'HCB2'
,'HCZ1'
,'HMD1'
,'H463'
,'H722'
,'HCA0'
,'HMD0'
,'768H'
,'G671'
,'H023'
,'H123'
,'H664'
,'H678'
,'HJB2'
,'HJC0'
,'791H'
,'H637'
,'H640'
,'H720'
,'H743'
,'H791')
AND DT_COMP BETWEEN TO_DATE('11/08/19','DD/MM/YY') AND TO_DATE('31/12/19','DD/MM/YY')

--TOTAL DE VENDAS RANGER XLT CONVERTIDAS POR LEAD - AGOSTO A DEZEMBRO 
SELECT DISTINCT COUNT(CAST(A.CPF AS NUMERIC))  -- contagem = 158
FROM TAB_PROC_LEAD_HIST           A
INNER JOIN TAB_PROC_DBM_TRAN B
ON CAST (A.CPF AS NUMERIC) = B.NR_CPF
WHERE B.CD_SEQC IN (
 'H119'
,'H676'
,'H679'
,'H786'
,'HCB0'
,'HJB1'
,'HMB1'
,'6H95'
,'H019'
,'H702'
,'H749'
,'H768'
,'JSA4'
,'JSW8'
,'JSA5'
,'JSB7'
,'JSA8'
,'JSC5'
,'JSA7'
,'JSW9'
,'JSB4'
,'JSA3'
,'JS06'
,'JSX9'
,'JMB3'
,'JMN5'
,'JM86'
,'JMP7'
,'JMZ8'
,'JMZ9'
,'JMK4'
,'JMC4'
,'JMB4'
,'JMC5'
,'JMD7'
,'JMD5'
,'JMX9'
,'JMJ4'
,'JMC3'
,'JMO5'
,'JMX8'
,'JMD8'
,'JMC0'
,'H677'
,'H715'
,'H717'
,'H748'
,'HCB1'
,'786H'
,'G610'
,'H714'
,'H752'
,'HCA1'
,'HJC1'
,'HMB0'
,'HMB2'
,'6H65'
,'6H78'
,'H423'
,'H459'
,'H665'
,'H674'
,'H694'
,'H695'
,'H701'
,'HCB2'
,'HCZ1'
,'HMD1'
,'H463'
,'H722'
,'HCA0'
,'HMD0'
,'768H'
,'G671'
,'H023'
,'H123'
,'H664'
,'H678'
,'HJB2'
,'HJC0'
,'791H'
,'H637'
,'H640'
,'H720'
,'H743'
,'H791')
AND REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL   
AND A.CPF <> '00000000000'
AND B.DT_COMP BETWEEN TO_DATE('11/08/19','DD/MM/YY') AND TO_DATE('31/12/19','DD/MM/YY')
AND A.DATA_CRIACAO BETWEEN TO_DATE('11/08/19','DD/MM/YY') AND TO_DATE('31/12/19','DD/MM/YY')

-------------------------------------------------------------------------------6,85%-----------------------------------------------------------------------------------------


--TOTAL KA -JUNHO A OUTUBRO 2018 -- 8,67%

--TOTAL DE VENDAS KA -JUNHO A OUTUBRO 2018
SELECT COUNT (NR_CPF) -- contagem = 1604
FROM TAB_PROC_DBM_TRAN
WHERE CD_SEQC IN ('ZNA9','KJB9','KNA9')
AND DT_COMP BETWEEN TO_DATE('01/06/18','DD/MM/YY') AND TO_DATE('31/10/18','DD/MM/YY')

--TOTAL DE VENDAS CONVERTIDAS POR LEAD KA - JUNHO A OUTUBRO 2018
SELECT DISTINCT COUNT(CAST(A.CPF AS NUMERIC))  -- contagem = 139
FROM TAB_PROC_LEAD_HIST           A
INNER JOIN TAB_PROC_DBM_TRAN B
ON CAST (A.CPF AS NUMERIC) = B.NR_CPF
WHERE B.CD_SEQC IN ('ZNA9','KJB9','KNA9')
AND REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL   
AND A.CPF <> '00000000000'
AND B.DT_COMP BETWEEN TO_DATE('01/06/18','DD/MM/YY') AND TO_DATE('31/10/18','DD/MM/YY')
AND A.DATA_CRIACAO BETWEEN TO_DATE('01/06/18','DD/MM/YY') AND TO_DATE('31/10/18','DD/MM/YY')


---------------------------------------------------------------------------------8,67%----------------------------------------------------------------------------------------


--TOTAL ECOSTORM -JUNHO A OUTUBRO 2018 -- 15,11%

--TOTAL DE VENDAS ECOSTORM -JUNHO A OUTUBRO 2018
SELECT COUNT (NR_CPF) -- contagem = 655
FROM TAB_PROC_DBM_TRAN
WHERE CD_SEQC IN ('ESK9')
AND DT_COMP BETWEEN TO_DATE('01/02/18','DD/MM/YY') AND TO_DATE('30/06/18','DD/MM/YY')

--TOTAL DE VENDAS CONVERTIDAS POR LEAD ECOSTORM - JUNHO A OUTUBRO 2018
SELECT DISTINCT COUNT(CAST(A.CPF AS NUMERIC))  -- contagem = 99
FROM TAB_PROC_LEAD_HIST           A
INNER JOIN TAB_PROC_DBM_TRAN B
ON CAST (A.CPF AS NUMERIC) = B.NR_CPF
WHERE B.CD_SEQC IN ('ESK9')
AND REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL   
AND A.CPF <> '00000000000'
AND B.DT_COMP BETWEEN TO_DATE('01/02/18','DD/MM/YY') AND TO_DATE('30/06/18','DD/MM/YY')
AND A.DATA_CRIACAO BETWEEN TO_DATE('01/02/18','DD/MM/YY') AND TO_DATE('30/06/18','DD/MM/YY')


-------------------------------------------------------------------------------  15,11%-----------------------------------------------------------------------------------------




-- TOTAL DE VENDAS 2019 --8,01%

--TOTAL DE VENDAS  - 2019
SELECT COUNT (NR_CPF) -- contagem = 129540
FROM TAB_PROC_DBM_TRAN
WHERE DT_COMP BETWEEN TO_DATE('01/01/19','DD/MM/YY') AND TO_DATE('31/12/19','DD/MM/YY')

--TOTAL DE VENDAS CONVERTIDAS POR LEAD - 2019
SELECT DISTINCT  COUNT(CAST(A.CPF AS NUMERIC))  -- contagem = 10373
FROM TAB_PROC_LEAD_HIST           A
INNER JOIN TAB_PROC_DBM_TRAN B
ON CAST (A.CPF AS NUMERIC) = B.NR_CPF
WHERE REPLACE(TRANSLATE(A.CPF, '1234567890', ' '),' ','') IS NULL   
AND A.CPF <> '00000000000'
AND B.DT_COMP BETWEEN TO_DATE('01/01/19','DD/MM/YY') AND TO_DATE('31/12/19','DD/MM/YY')
AND A.DATA_CRIACAO BETWEEN TO_DATE('01/01/19','DD/MM/YY') AND TO_DATE('31/12/19','DD/MM/YY')



------------------------------------------------------------------------------- 8,01%-----------------------------------------------------------------------------------------



















