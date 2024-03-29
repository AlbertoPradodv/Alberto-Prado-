
    
    SELECT INITCAP(NVL(NVL(VENDA.MODELO_COMPRA,LEAD.MODELO_INTERESSE),'N�o Dispon�vel')) as NAMEPLATE
    ,NVL(DP_ORG.ORIGEM_PARA,'Origem N�o Encontrada') AS ORIGEM
    ,LEAD.DATA_CRIACAO
    ,COUNT(DISTINCT LEAD.ID_SEQUENCIAL) AS QTD_LEAD
    ,NVL(SUM(VENDA.QTD_VENDAS),0) AS QTD_VENDAS
    ,VENDA.CDSEQ 
    FROM CRUZ_LEADS_2018_UNIFICADA LEAD
    LEFT JOIN 
        (
        SELECT A.ID_SEQUENCIAL,A.MODELO_COMPRA,COUNT(DISTINCT A.IDVEHICLE) AS QTD_VENDAS,B.CDSEQ
        FROM CRUZ_LEADS_VENDAS_HISTORICA A
        LEFT JOIN DE_PARA_CDSEQ B
        ON B.DSVIN = A.CHASSI
        GROUP BY A.ID_SEQUENCIAL,A.MODELO_COMPRA,B.CDSEQ
        ) VENDA
    ON LEAD.ID_SEQUENCIAL = VENDA.ID_SEQUENCIAL
    LEFT JOIN DEPARA_ORIGEM_LEADS_FMC DP_ORG
    ON LEAD.ORIGEM = DP_ORG.ORIGEM_DE
    WHERE SUBSTR(LEAD.DATA_CRIACAO,7,2)='19'
    ON INITCAP(NVL(NVL(VENDA.MODELO_COMPRA,LEAD.MODELO_INTERESSE),'N�o Dispon�vel')) = 'Ranger'
    GROUP BY INITCAP(NVL(NVL(VENDA.MODELO_COMPRA,LEAD.MODELO_INTERESSE),'N�o Dispon�vel'))
    ,NVL(DP_ORG.ORIGEM_PARA,'Origem N�o Encontrada')
    ,LEAD.DATA_CRIACAO
    ,VENDA.QTD_VENDAS
    ,VENDA.CDSEQ 
    