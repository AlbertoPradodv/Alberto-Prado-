--ORACLE


--UNIFICACAO TABELA BOLETIM
DROP TABLE TAB_PROC_BOLETIM_ADOBE ;COMMIT;
CREATE TABLE TAB_PROC_BOLETIM_ADOBE AS 
        SELECT name
              ,LOWER(email)
              ,created_at 
FROM TMP_REPARADOR_FORD_NEWSLETTER

UNION
        SELECT name
              ,LOWER(email)
              ,created_at 
FROM TMP_REPARADOR_FORD_MEMBERSS
;COMMIT;

--SEGMENTANDO INTERACAO DE EMAIL UNICO POR MAIS RECENTE

DROP TABLE TMP_AUX_ULT_INTE;COMMIT;
CREATE TABLE TMP_AUX_ULT_INTE AS
 SELECT EMAIL
       ,MAX(TO_DATE(DATE_INTERACAO,'DD/MM/YYYY')) DATE_INTERACAO_MAX
 FROM TMP_HIST_EMAIL_INTERE_ADOBE
 GROUP BY EMAIL
 ;COMMIT;
 
--CRIANDO TABELA INTERACAO COMPLETA
DROP TABLE TMP_AUX_BOLETIM ;COMMIT;
CREATE TABLE TMP_AUX_BOLETIM  AS
SELECT A.*
      ,B.DATE_INTERACAO_MAX
      ,C.DATA_ENVIO
      ,C.CAMPAIGN_CODE
      ,C.INTERACTION
      ,C.TYPE_INTE
FROM TAB_PROC_BOLETIM_ADOBE A
LEFT JOIN TMP_AUX_ULT_INTE B
ON A.EMAIL = B.EMAIL
LEFT JOIN TMP_HIST_EMAIL_INTERE_ADOBE C
ON A.EMAIL = C.EMAIL
 ;COMMIT;

--SEGMENTANDO DESTINATARIOS POR DATA DE INTERACAO
DROP TABLE TAB_PROC_BOLETIM_NEWSLETTER;COMMIT;
CREATE TABLE TAB_PROC_BOLETIM_NEWSLETTER AS
SELECT A.*
        ,CASE
       WHEN MONTHS_BETWEEN (SYSDATE, DATE_INTERACAO_MAX)<= 3  THEN 'SEMANAL'
       WHEN MONTHS_BETWEEN (SYSDATE, DATE_INTERACAO_MAX)> 3 AND MONTHS_BETWEEN (SYSDATE, DATE_INTERACAO_MAX)<= 6 THEN 'QUINZENAL'
       WHEN MONTHS_BETWEEN (SYSDATE, DATE_INTERACAO_MAX)>= 13  THEN 'BIMESTRAL'
       WHEN DATE_INTERACAO_MAX IS NULL THEN 'QUINZENAL'
      END AS PERIODO_DE_ENVIO
FROM TMP_AUX_BOLETIM A
;COMMIT;



--SQL SERVER WITH PROCEDURE

USE [StageFord]
GO
/****** Object:  StoredProcedure [dbo].[USP_BOLETIM]    Script Date: 07/01/2021 19:35:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[USP_BOLETIM] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--UNIFICACAO TABELA BOLETIM

 IF OBJECT_ID('TAB_PROC_BOLETIM_ADOBE') IS NOT NULL

DROP TABLE TAB_PROC_BOLETIM_ADOBE
SELECT name
      ,LOWER(email)
      ,created_at 
INTO TAB_PROC_BOLETIM_ADOBE
FROM TAB_REPR_NEWS 

UNION
SELECT name
      ,LOWER(email)
      ,created_at 
FROM TAB_REPR_MEMB 


--SEGMENTANDO INTERACAO DE EMAIL UNICO POR MAIS RECENTE
 IF OBJECT_ID('TEMPDB..##TMP_AUX_ULT_INTE') IS NOT NULL

 DROP TABLE ##TMP_AUX_ULT_INTE
 SELECT EMAIL
       ,MAX(CONVERT(datetime,DATE_INTERACAO)) DATE_INTERACAO_MAX
 INTO  ##TMP_AUX_ULT_INTE
 FROM STG_ADOB_INTR_ENVI
 GROUP BY EMAIL
 
--CRIANDO TABELA INTERACAO COMPLETA
 IF OBJECT_ID('TEMPDB..##TMP_AUX_BOLETIM') IS NOT NULL

DROP TABLE ##TMP_AUX_BOLETIM
 SELECT A.*
      ,B.DATE_INTERACAO_MAX
      ,C.DATA_ENVIO
      ,C.CAMPAING_CODE
      ,C.INTERACTION
      ,C.TYPE_INTE
 INTO  ##TMP_AUX_BOLETIM
 FROM TAB_PROC_BOLETIM_ADOBE A
 LEFT JOIN TMP_AUX_ULT_INTE B
 ON A.EMAIL = B.EMAIL
 LEFT JOIN STG_ADOB_INTR_ENVI C
 ON A.EMAIL = C.EMAIL

 
--SEGMENTANDO DESTINATARIOS POR DATA DE INTERACAO

 IF OBJECT_ID('ford..TAB_PROC_BOLETIM_NEWSLETTER') IS NOT NULL

DROP TABLE ford..TAB_PROC_BOLETIM_NEWSLETTER
SELECT A.*
        ,CASE
       WHEN DATEDIFF (day,SYSDATETIME, DATE_INTERACAO_MAX)<= 90  THEN 'SEMANAL'
       WHEN DATEDIFF (day,SYSDATETIME, DATE_INTERACAO_MAX)> 90 AND DATEDIFF (day,SYSDATETIME, DATE_INTERACAO_MAX)<= 180 THEN 'QUINZENAL'
       WHEN DATEDIFF (day,SYSDATETIME, DATE_INTERACAO_MAX)>= 395  THEN 'BIMESTRAL'
       WHEN DATE_INTERACAO_MAX IS NULL THEN 'QUINZENAL'
      END AS PERIODO_DE_ENVIO
INTO ford..TAB_PROC_BOLETIM_NEWSLETTER
FROM TMP_AUX_BOLETIM A

END