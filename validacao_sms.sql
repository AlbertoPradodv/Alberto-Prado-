DROP TABLE TMP_ANALISE_SMS;
CREATE TABLE TMP_ANALISE_SMS AS
SELECT A.ID_EXTERNO AS NAV_CODE
,B.CHAVE_PROPRIETARIO_ATUAL
,B.IDDEALER
,SUBSTR(A.ENVIADO_EM,7,4) ||SUBSTR(A.ENVIADO_EM,4,2) AS DATA_ENVIOS
,B.ANOMES_EXECUCAO AS DATA_HISTORICO
,B.NAMEPLATE
,CASE WHEN B.NAVCODE IS NULL THEN 0
 WHEN B.NAVCODE IS NOT NULL THEN 1 
 END AS FLAG_PRESENTE
 FROM TMP_SMS A
 INNER JOIN SERBINOC.BASE_PERSONALIZACAO_HISTORICA B
 ON A.ID_EXTERNO = B.NAVCODE
AND SUBSTR(A.ENVIADO_EM,7,4) ||SUBSTR(A.ENVIADO_EM,4,2) = B.ANOMES_EXECUCAO
 

 DROP TABLE TMP_ANALISE_MES_SEGUINTE_SMS;
CREATE TABLE TMP_ANALISE_MES_SEGUINTE_SMS AS
SELECT A.ID_EXTERNO AS NAV_CODE
,B.CHAVE_PROPRIETARIO_ATUAL
,B.IDDEALER
,SUBSTR(A.ENVIADO_EM,7,4) ||SUBSTR(A.ENVIADO_EM,4,2) AS DATA_ENVIOS
,B.ANOMES_EXECUCAO AS DATA_HISTORICO
,B.NAMEPLATE
,CASE WHEN B.NAVCODE IS NULL THEN 0
 WHEN B.NAVCODE IS NOT NULL THEN 1 
 END AS FLAG_PRESENTE
 FROM TMP_SMS A
 INNER JOIN SERBINOC.BASE_PERSONALIZACAO_HISTORICA B
 ON A.ID_EXTERNO = B.NAVCODE
AND SUBSTR(A.ENVIADO_EM,7,4) ||CASE WHEN SUBSTR(A.ENVIADO_EM,4,2) = 12 THEN 1
                               ELSE SUBSTR(A.ENVIADO_EM,4,2) +1 
                               END                                                      = B.ANOMES_EXECUCAO
 

 
SELECT COUNT (*) FROM TMP_ANALISE_MES_SEGUINTE_SMS
SELECT COUNT  (*) FROM TMP_ANALISE_SMS
