--CRIACAO TABELA TEMPORARIA PARA REMOVER DUPLICADOS COM O MESMO DISPARO

CREATE TABLE TMP_LEAD_RENGER_SUPPORT AS 
SELECT A.EMAILADDRESS AS EMAIL
,A.SENDID AS IDDISPARO
,B.EVENTTYPE AS OPEN
,C.EVENTTYPE AS CLICK
FROM SERBINOC.TB_EXACT_SENT A 
LEFT JOIN SERBINOC.TB_EXACT_OPENS B
ON A.EMAILADDRESS = B.EMAILADDRESS
AND A.SENDID = B.SENDID
LEFT JOIN SERBINOC.TB_EXACT_CLICKS C 
ON A.EMAILADDRESS = C.EMAILADDRESS
AND A.SENDID = C.SENDID
WHERE A.SENDID IN (100814,100820,100821,100984,102430,102431,104825,105990,108902)
GROUP BY A.EMAILADDRESS,A.SENDID,B.EVENTTYPE,C.EVENTTYPE

--UPDATE PARA TRATAMENTO DE INFORMACOES DISCREPANTES DA BASE
UPDATE TMP_LEAD_RENGER_SUPPORT  A SET A.OPEN = 'Open'
WHEN A.OPEN IS NULL 
AND A.CLICK IS NOT NULL 

-- TABELA FINAL PARA ANALISE

CREATE TABLE TMP_LEAD_RENGER_ANALYSIS AS 
SELECT A.EMAIL AS EMAIL
,A.IDDISPARO AS IDDISPARO
,B.EVENTDATE AS DATA_OPEN
,C.EVENTDATE AS DATA_CLICK
,CASE WHEN A.OPEN IS NOT NULL THEN 'Y'
     WHEN A.OPEN IS NULL THEN 'N'
     END AS FLAG_OPEN
,CASE WHEN A.CLICK IS NOT NULL THEN 'Y'
     WHEN A.CLICK IS NULL THEN 'N'
     END AS FLAG_CLICK
FROM TMP_LEAD_RENGER_SUPPORT A 
LEFT JOIN SERBINOC.TB_EXACT_OPENS B
ON A.EMAIL = B.EMAILADDRESS
AND A.IDDISPARO = B.SENDID
LEFT JOIN SERBINOC.TB_EXACT_CLICKS C 
ON A.EMAIL = C.EMAILADDRESS
AND A.IDDISPARO = C.SENDID



SELECT * FROM SERBINOC.TB_EXACT_opens -- interacao de abertura
SELECT * FROM SERBINOC.TB_EXACT_clicks -- interacao de click no lead
SELECT * FROM SERBINOC.TB_EXACT_SENT -- join pelo email 
SELECT * FROM TAB_LEAD_TMP -- TABELA DE LEADS



