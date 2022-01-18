
--Insert - Base Mída CRM Conteúdo Social

INSERT INTO TAB_PROC_BASES_CRM_CS
SELECT DSEMAIL AS EMAIL
     , NBAREACODE||' '||NBTELEPHONE AS TELEFONE
--   , TO_CHAR(ADD_MONTHS(SYSDATE,1),'MM/YYYY') AS REFERENCIA
     , TO_CHAR(ADD_MONTHS(TO_DATE('31/08/2018','DD/MM/YYYY'),1),'MM/YYYY') AS REFERENCIA
     , CASE 
        WHEN DD.MODELO_FE IN ('EcoSport')                           THEN 'ECOSPORT'
        WHEN DD.MODELO_FE IN ('Edge')                               THEN 'EDGE'
        WHEN DD.MODELO_FE IN ('Focus')                              THEN 'FOCUS'
        WHEN DD.MODELO_FE IN ('Focus Fastback','Focus Sedan')       THEN 'FOCUS FASTBACK'
        WHEN DD.MODELO_FE IN ('Fusion')                             THEN 'FUSION'
        WHEN DD.MODELO_FE IN ('Ka')                                 THEN 'KA'
        WHEN DD.MODELO_FE IN ('Ka Sedan')                           THEN 'KA SEDAN'
        WHEN DD.MODELO_FE IN ('New Fiesta','Fiesta')                THEN 'NEW FIESTA'
        WHEN DD.MODELO_FE IN ('New Fiesta Sedan','Fiesta Sedan')    THEN 'NEW FIESTA SEDAN'
        WHEN DD.MODELO_FE IN ('Ranger')                             THEN 'RANGER'
        ELSE NULL END AS MODELO
      FROM TAB_PROC_CAMPAIGN_INFO TC,TAB_PROC_DEPARA_DASH DD
      WHERE TC.CDTMA = DD.CDTMA 
    --AND DTPURCHASE BETWEEN ADD_MONTHS(TRUNC(SYSDATE,'MM'),-35) AND ADD_MONTHS(LAST_DAY(SYSDATE),-1)
      AND DTPURCHASE BETWEEN ADD_MONTHS(TRUNC(TO_DATE('31/08/2018','DD/MM/YYYY'),'MM'),-35) AND ADD_MONTHS(LAST_DAY(TO_DATE('31/08/2018','DD/MM/YYYY')),-1)
      AND (DSEMAIL IS NOT NULL OR NBTELEPHONE IS NOT NULL)
	 ;COMMIT;

--Insert - Base Mída CRM Varejo

INSERT INTO TAB_PROC_BASES_CRM_VRJ
SELECT  DSEMAIL AS EMAIL
      , NBAREACODE||' '||NBTELEPHONE AS TELEFONE
    --, TO_CHAR(ADD_MONTHS(SYSDATE,1),'MM/YYYY') AS REFERENCIA
      , TO_CHAR(ADD_MONTHS(TO_DATE('31/08/2018','DD/MM/YYYY'),1),'MM/YYYY') AS REFERENCIA
      , PROPENSAO_PRIMEIRA_OPCAO AS MODELO
      , DD.MODELO_FE AS MODELO_VEICULO
      , TC.DSFUEL
        FROM TAB_PROC_CAMPAIGN_INFO TC,TAB_PROC_DEPARA_DASH DD
        WHERE TC.CDTMA = DD.CDTMA 
    --  AND ATINGE_TEMPO_MEDIO_FORD BETWEEN ADD_MONTHS(TRUNC(SYSDATE,'MM'),-22) AND ADD_MONTHS(LAST_DAY(SYSDATE),6)
        AND ATINGE_TEMPO_MEDIO_FORD BETWEEN ADD_MONTHS(TRUNC(TO_DATE('31/08/2018','DD/MM/YYYY'),'MM'),-22) AND ADD_MONTHS(LAST_DAY(TO_DATE('31/08/2018','DD/MM/YYYY')),6)
        AND (DSEMAIL IS NOT NULL OR NBTELEPHONE IS NOT NULL)
	   ;COMMIT;


       -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--TABELAS NA QUERY


--BASES TRUNCADAS

BASES_CRM_CS  -- TAB_PROC_BASES_CRM_CS
BASES_CRM_VRJ -- TAB_PROC_BASES_CRM_VRJ




--tabelas nao criadas ou truncadas no job

TABLE_CAMPAIGN -- TAB_PROC_CAMPAIGN_INFO

--Descrição:listagem de carros,com seus respectivos donos e informacoes relacionadas a venda do veiculo e especificacoes tecnicas do mesmo 

--Acoes no script:

--Consulta dentro de insert para adiçao de informacoes dentro de colunas nas tabelas BASES_CRM_CS e BASES_CRM_VRJ


DEPARA_DASH -- TAB_PROC_DEPARA_DASH

--Descrição:Listagem de modelos com seus respectivos cdtmas e informacoes adicionais 

--Acoes no script:
 
--Consulta dentro de insert para adiçao de informacoes dentro de colunas nas tabelas BASES_CRM_CS e BASES_CRM_VRJ