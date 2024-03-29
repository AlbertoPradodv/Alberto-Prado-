--CRIAÇÃO TABELA AUXILIAR ANALISE DE EMAIL 
DROP TABLE TMP_AUX_EMAIL_FORD_CREDIT
CREATE TABLE TMP_AUX_EMAIL_FORD_CREDIT AS
SELECT A.ID_ENVI AS ID_ENVI_SENT
,A.DS_MAIL AS DS_MAIL_SENT
,CASE WHEN A.DS_MAIL IS NOT NULL THEN 1 ELSE 0 
      END AS  FLAG_EMAIL_SENT
,CASE WHEN A.DS_MAIL IS NOT NULL THEN SUBSTR('0'||A.DT_DIA,-2)||'/'||SUBSTR('0'||A.DT_MES,-2)||'/'|| A.DT_ANO ELSE NULL
      END AS DATA_EMAIL_SENT
,CASE WHEN B.DS_MAIL IS NOT NULL THEN 1 ELSE 0 
      END AS FLAG_ABERTURA_SENT
,CASE WHEN B.DS_MAIL IS NOT NULL THEN SUBSTR('0'||B.DT_DIA,-2)||'/'||SUBSTR('0'||B.DT_MES,-2)||'/'|| B.DT_ANO ELSE NULL 
      END AS DATA_ABERTURA_SENT
FROM TMP_PROC_FLOW_SENT A
LEFT JOIN TMP_PROC_FLOW_OPEN B
ON A.DS_MAIL = B.DS_MAIL
AND A.ID_ENVI = B.ID_ENVI
WHERE A.ID_ENVI IN (127056,127057,127058,127059)

--CRIAÇÃO TABELA AUXILIAR ANALISE DE EMAIL REAPIQUE

DROP TABLE TMP_AUX_EMAIL_FORD_CREDIT_RP
CREATE TABLE TMP_AUX_EMAIL_FORD_CREDIT_RP AS
SELECT A.ID_ENVI AS ID_ENVI_RP
,A.DS_MAIL AS DS_MAIL_RP
,CASE WHEN A.DS_MAIL IS NOT NULL THEN 1 ELSE 0 
      END AS FLAG_EMAIL_RP
,CASE WHEN A.DS_MAIL IS NOT NULL THEN SUBSTR('0'||A.DT_DIA,-2)||'/'||SUBSTR('0'||A.DT_MES,-2)||'/'|| A.DT_ANO ELSE NULL 
      END AS DATA_EMAIL_RP
,CASE WHEN B.DS_MAIL IS NOT NULL THEN 1 ELSE 0 
      END AS FLAG_ABERTURA_RP
,CASE WHEN B.DS_MAIL IS NOT NULL THEN SUBSTR('0'||B.DT_DIA,-2)||'/'||SUBSTR('0'||B.DT_MES,-2)||'/'|| B.DT_ANO ELSE NULL 
      END AS DATA_ABERTURA_RP
FROM TMP_PROC_FLOW_SENT A
LEFT JOIN TMP_PROC_FLOW_OPEN B
ON A.DS_MAIL = B.DS_MAIL
AND A.ID_ENVI = B.ID_ENVI
WHERE A.ID_ENVI IN (127485,127490,127488,127489)


--CRIAÇÃO DE TABELA UNIFICADA
DROP TABLE TMP_FORD_CREDIT_EMAIL_ANALYSIS 
CREATE TABLE TMP_FORD_CREDIT_EMAIL_ANALYSIS AS
SELECT A.* 
,B.*
,C.FLAG_EMAIL_RP
,C.DATA_EMAIL_RP
,C.FLAG_ABERTURA_RP
,C.DATA_ABERTURA_RP
,CASE WHEN A.NAMEPLATE LIKE '%KA%' THEN  'Oferta de Ka, KA Sedan e EcoSport'
      WHEN A.NAMEPLATE LIKE '%ECO%' THEN  'Oferta de EcoSport'
      WHEN A.NAMEPLATE LIKE '%FOCUS%' THEN  'Oferta de EcoSport e Ranger'
      WHEN A.NAMEPLATE LIKE '%FUSION%' THEN  'Oferta de EcoSport e Ranger'
      WHEN A.NAMEPLATE LIKE '%RANGER%' THEN  'Oferta de Ranger'
      ELSE 'OUTROS'
      END AS OFERTA_RECEBIDA
FROM TMP_BASE1_CREDIT A
LEFT JOIN TMP_AUX_EMAIL_FORD_CREDIT B 
ON A.DS_MAIL = B.DS_MAIL_SENT
LEFT JOIN TMP_AUX_EMAIL_FORD_CREDIT_RP C 
ON A.DS_MAIL = C.DS_MAIL_RP
