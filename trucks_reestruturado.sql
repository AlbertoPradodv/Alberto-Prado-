--Update Flag - Inserção

UPDATE TAB_PROC_BKP_TRUCKS  SET COLUNA_INSERT_PES_VEI_NOVO = 'NAO'
;COMMIT;

--Insert - Tabela de Trucks

INSERT INTO TAB_PROC_BKP_TRUCKS
SELECT AA.IDVEHICLE
,AA.IDVEHICLEHOLDER
,AA.DSORIGINALMODEL
,AA.IDDATASOURCE
,AA.DTLASTUPDATE
,AA.IDCREATESOURCE
,AA.DTCREATE
,AA.IDDEALER
,AA.DTPURCHASE
,AA.DSVIN
,AA.CDTMA
,AA.DSMAKER
,AA.DSMODEL
,AA.DSGENERICMODEL
,AA.DSCATEGORY
,AA.DSSEGMENT
,P.IDPERSON
,P.TPPERSON
,COALESCE(I.CPF,COM.CNPJ) AS CPF_CNPJ
,COALESCE(I.NMINDIVIDUAL,COM.NMCOMPANY) AS NOME
,CORG.CDSUBCLASS
,CASE  WHEN (TRIM(AD.CDSTATE) in ('MA','PI','CE','RN','PE','PB','SE','AL','BA'))    THEN 'NORDESTE'
       WHEN (TRIM(AD.CDSTATE) in ('AM','RR','AP','PA','TO','RO','AC'))              THEN 'NORTE'
       WHEN (TRIM(AD.CDSTATE) in ('MT','MS','GO','DF'))                             THEN 'CENTRO-OESTE'
       WHEN (TRIM(AD.CDSTATE) in ('SP','RJ','ES','MG'))                             THEN 'SUDESTE'
       WHEN (TRIM(AD.CDSTATE) in ('PR','RS','SC'))                                  THEN 'SUL'
       ELSE 'N/I' END REGIAO
,AD.IDADDRESS
,AD.TPSTREET
,AD.DSADDRESS
,AD.NBADDRESS
,AD.DSCOMPLEMENT
,AD.NMDISTRICT
,AD.NBPOSTALCODE
,AD.DSCITY
,AD.CDSTATE
,TL.IDTELEPHONE
,TL.NBAREACODE
,TL.NBTELEPHONE
,EM.IDEMAIL
,EM.DSEMAIL
,NULL TAMANHO_DA_FROTA
,NULL DESC_FROTA
,NULL PURGE_EMAIL
,NULL FLOPTIN
,NULL ERROS_VT
,'SIM' AS COLUNA_INSERT_PES_VEI_NOVO
,NULL FANTASIA_DN
,NULL DESCRICAO
,NULL ENDERECO_DN
,NULL BAIRRO_DN
,NULL CIDADE_DN
,NULL UF_DN
,NULL RG_DN
,NULL CEP_DN
,NULL TELEFONE_DN
,NULL FAX_DN
,NULL GERENTE_DN
,NULL DATA_ULT_VIS
FROM
(
SELECT * FROM 
(
SELECT V.IDVEHICLE
,VR.IDVEHICLEHOLDER
,V.DSORIGINALMODEL
,VR.IDDATASOURCE
,VR.DTLASTUPDATE
,VR.IDCREATESOURCE
,VR.DTCREATE
,CASE WHEN VR.IDDEALER = '999999999' THEN TO_NUMBER(VF.IDDEALERDELIVER) ELSE VR.IDDEALER END AS IDDEALER
,VR.DTPURCHASE
,VF.DSVIN
,VF.CDTMA
,MM.DSMAKER
,MM.DSMODEL
,MM.DSGENERICMODEL
,MM.DSCATEGORY
,MM.DSSEGMENT
,ROW_NUMBER()OVER(PARTITION BY VR.IDVEHICLEHOLDER ORDER BY VR.DTPURCHASE DESC, VR.IDVEHICLE DESC)RANK_VR
FROM FORD.VEHICLE V
,FORD.VEHICLERELATIONSHIP VR
,FORD.VEHICLEFACT VF
,FORD.MAKERMODEL MM
,TAB_PROC_ETL_CAM_MODELOS AA
WHERE V.IDVEHICLE = VR.IDVEHICLE
AND V.IDVEHICLE = VF.IDVEHICLE
AND V.DSORIGINALMODEL = MM.DSORIGINALMODEL
AND (MM.DSMODEL = AA.DSMODEL OR MM.DSORIGINALMODEL = AA.DSORIGINALMODEL OR MM.DSGENERICMODEL = AA.DSGENERICMODEL)
AND VF.CDTMA NOT IN ('BDA','KHC','KFA','GDA','FHC','FFC','NFB','NFA','FAD','BFA','BFC','BHC','CFA',
                    'CHC','EUA','BUA','FFA','FFB','EEF','2BC','4BC','3BB','4BB','6BC','7BC','6BB','7BB')
AND MM.DSMAKER = 'FORD'
AND VR.DTPURCHASE BETWEEN TO_DATE('01/01/2016','DD/MM/YYYY') AND TO_DATE(SYSDATE,'DD/MM/YY')
) WHERE RANK_VR = 1 
)AA
,FORD.PERSON P
,FORD.COMPANY COM
,FORD.CORPOGRAPHICS CORG
,FORD.INDIVIDUAL I
,(SELECT AD.*, RANK() OVER(PARTITION BY IDPERSON ORDER BY DTLASTUPDATE DESC, IDADDRESS DESC) RANK_AD 
FROM FORD.ADDRESS AD
WHERE CDNIXIETYPE IS NULL
AND FLUSEROW = 'S')   AD
,(SELECT TL.*, RANK() OVER(PARTITION BY IDPERSON ORDER BY DTLASTUPDATE DESC, IDTELEPHONE DESC) RANK_TL
FROM FORD.TELEPHONE   TL
WHERE CDNIXIETYPE IS NULL
AND FLUSEROW = 'S')   TL
,(SELECT EM.*, RANK() OVER(PARTITION BY IDPERSON ORDER BY DTLASTUPDATE DESC, IDEMAIL DESC) RANK_EM
FROM FORD.EMAIL EM
WHERE CDNIXIETYPE IS NULL
AND FLUSEROW = 'S')   EM      
WHERE AA.IDVEHICLEHOLDER = P.IDPERSON
AND P.IDPERSON = I.IDINDIVIDUAL(+)
AND P.IDPERSON = COM.IDCOMPANY(+)
AND COM.IDCOMPANY = CORG.IDCOMPANY(+)
AND P.IDPERSON = EM.IDPERSON(+)
AND P.IDPERSON = TL.IDPERSON(+)
AND P.IDPERSON = AD.IDPERSON(+)
AND EM.RANK_EM(+) = 1
AND TL.RANK_TL(+) = 1
AND AD.RANK_AD(+) = 1
AND NOT EXISTS(SELECT TC.* FROM TAB_PROC_BKP_TRUCKS  TC WHERE (AA.IDVEHICLEHOLDER = TC.IDVEHICLEHOLDER))
AND NOT EXISTS(SELECT TC.* FROM TAB_PROC_BKP_TRUCKS  TC WHERE (AA.IDVEHICLE = TC.IDVEHICLE))

;COMMIT;

--Insert - Existentes / Atualizar Dados

INSERT INTO TAB_PROC_TC_CAMINHOES
SELECT LCW.* FROM TAB_PROC_BKP_TRUCKS  TC,
(
SELECT      
IDVEHICLE,IDDEALER,IDVEHICLEHOLDER,DSORIGINALMODEL,NBMODELYEAR,NBMANUFACTURERYEAR,DTPURCHASE,FLFIRSTOWNER,FLNEWVEHICLE,FLSTILLOWNED,CDTMA,DSMAKER,RANK
FROM   (SELECT   V.IDVEHICLE,CASE WHEN R.IDDEALER = '999999999' THEN TO_NUMBER(VF.IDDEALERDELIVER) ELSE R.IDDEALER END AS IDDEALER,R.IDVEHICLEHOLDER,V.DSORIGINALMODEL,V.NBMODELYEAR,V.NBMANUFACTURERYEAR,R.DTPURCHASE,R.FLFIRSTOWNER,R.FLNEWVEHICLE,R.FLSTILLOWNED,VF.CDTMA,
MM.DSMAKER,
ROW_NUMBER()OVER(PARTITION BY R.IDVEHICLEHOLDER ORDER BY R.DTPURCHASE DESC, R.IDVEHICLE DESC)RANK
FROM   FORD.VEHICLERELATIONSHIP R
, FORD.VEHICLE V
, FORD.VEHICLEFACT VF
, FORD.MAKERMODEL MM
,TAB_PROC_ETL_CAM_MODELOS AA
WHERE    (V.IDVEHICLE = R.IDVEHICLE)
AND (V.DSORIGINALMODEL = MM.DSORIGINALMODEL)
AND (V.IDVEHICLE = VF.IDVEHICLE)
AND (MM.DSMODEL = AA.DSMODEL OR MM.DSORIGINALMODEL = AA.DSORIGINALMODEL OR MM.DSGENERICMODEL = AA.DSGENERICMODEL)
) A
WHERE   A.RANK = 1 AND A.FLSTILLOWNED = 'S'
)LCW
WHERE TC.IDVEHICLEHOLDER = LCW.IDVEHICLEHOLDER
AND TC.IDVEHICLE <> LCW.IDVEHICLE
AND TC.COLUNA_INSERT_PES_VEI_NOVO NOT IN ('SIM')

;COMMIT;

--Insert - Existentes / EM. TL e AD

INSERT INTO TAB_PROC_TC_CAMINHOES_2
SELECT CDB.*
,AD.IDADDRESS
,AD.TPSTREET
,AD.DSADDRESS
,AD.NBADDRESS
,AD.DSCOMPLEMENT
,AD.NMDISTRICT
,AD.NBPOSTALCODE
,AD.DSCITY
,AD.CDSTATE
,TL.IDTELEPHONE
,TL.NBAREACODE
,TL.NBTELEPHONE
,EM.IDEMAIL
,EM.DSEMAIL
FROM TAB_PROC_TC_CAMINHOES CDB
,(SELECT AD.*, RANK() OVER(PARTITION BY IDPERSON ORDER BY DTLASTUPDATE DESC, IDADDRESS DESC) RANK_AD 
FROM FORD.ADDRESS AD WHERE CDNIXIETYPE IS NULL AND FLUSEROW = 'S') AD
,(SELECT TL.*, RANK() OVER(PARTITION BY IDPERSON ORDER BY DTLASTUPDATE DESC, IDTELEPHONE DESC) RANK_TL
FROM FORD.TELEPHONE TL  WHERE CDNIXIETYPE IS NULL AND FLUSEROW = 'S') TL
,(SELECT EM.*, RANK() OVER(PARTITION BY IDPERSON ORDER BY DTLASTUPDATE DESC, IDEMAIL DESC) RANK_EM
FROM FORD.EMAIL EM WHERE CDNIXIETYPE IS NULL AND FLUSEROW = 'S') EM  
WHERE CDB.IDVEHICLEHOLDER = EM.IDPERSON(+)
AND CDB.IDVEHICLEHOLDER = TL.IDPERSON(+)
AND CDB.IDVEHICLEHOLDER = AD.IDPERSON(+)
AND EM.RANK_EM(+) = 1
AND TL.RANK_TL(+) = 1
AND AD.RANK_AD(+) = 1

;COMMIT;


--Update - Marcação Trucks

UPDATE TAB_PROC_BKP_TRUCKS  TC SET IDVEHICLE = (SELECT IDVEHICLE FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)   
,IDDEALER = (SELECT IDDEALER FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER) 
,DSORIGINALMODEL = (SELECT DSORIGINALMODEL FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER) 
,DTPURCHASE = (SELECT DTPURCHASE FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER) 
,CDTMA = (SELECT CDTMA FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER) 
,DSMAKER = (SELECT DSMAKER FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER) 
,IDADDRESS = (SELECT IDADDRESS FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
,TPSTREET = (SELECT TPSTREET FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
,DSADDRESS = (SELECT DSADDRESS FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
,NBADDRESS = (SELECT NBADDRESS FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
,DSCOMPLEMENT = (SELECT DSCOMPLEMENT FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
,NMDISTRICT = (SELECT NMDISTRICT FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
,NBPOSTALCODE = (SELECT NBPOSTALCODE FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
,DSCITY = (SELECT DSCITY FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
,IDTELEPHONE = (SELECT IDTELEPHONE FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
,NBAREACODE = (SELECT NBAREACODE FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
,NBTELEPHONE = (SELECT NBTELEPHONE FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
,IDEMAIL = (SELECT IDEMAIL FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
,DSEMAIL = (SELECT DSEMAIL FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
WHERE EXISTS (SELECT 1 FROM TAB_PROC_TC_CAMINHOES_2 TCE WHERE TC.IDVEHICLEHOLDER = TCE.IDVEHICLEHOLDER)
AND COLUNA_INSERT_PES_VEI_NOVO NOT IN ('SIM') -- COLOCAR O ULTIMO BLOCO PARA ATUALIZAR OS OUTROS / NOT IN

;COMMIT;





--Insert - Tabela Frota

INSERT INTO TAB_PROC_ETL_CAMINHOES_TODOS
SELECT AA.IDVEHICLE
,AA.IDVEHICLEHOLDER
,AA.DSORIGINALMODEL
,AA.IDDATASOURCE
,AA.DTLASTUPDATE
,AA.IDCREATESOURCE
,AA.DTCREATE
,AA.IDDEALER
,AA.DTPURCHASE
,AA.DSVIN
,AA.CDTMA
,AA.DSMAKER
,AA.DSMODEL
,AA.DSGENERICMODEL
,AA.DSCATEGORY
,AA.DSSEGMENT
,AA.RANK_VR
FROM 
(
SELECT V.IDVEHICLE
,VR.IDVEHICLEHOLDER
,V.DSORIGINALMODEL
,VR.IDDATASOURCE
,VR.DTLASTUPDATE
,VR.IDCREATESOURCE
,VR.DTCREATE
,CASE WHEN VR.IDDEALER = '999999999' THEN TO_NUMBER(VF.IDDEALERDELIVER) ELSE VR.IDDEALER END AS IDDEALER
,VR.DTPURCHASE
,VF.DSVIN
,VF.CDTMA
,MM.DSMAKER
,MM.DSMODEL
,MM.DSGENERICMODEL
,MM.DSCATEGORY
,MM.DSSEGMENT
,ROW_NUMBER()OVER(PARTITION BY VR.IDVEHICLEHOLDER ORDER BY VR.DTPURCHASE DESC, VR.IDVEHICLE DESC)RANK_VR
FROM FORD.VEHICLE V
,FORD.VEHICLERELATIONSHIP VR
,FORD.VEHICLEFACT VF
,FORD.MAKERMODEL MM
,TAB_PROC_ETL_CAM_MODELOS AA
WHERE
V.IDVEHICLE = VR.IDVEHICLE
AND V.IDVEHICLE = VF.IDVEHICLE
AND V.DSORIGINALMODEL = MM.DSORIGINALMODEL
AND (MM.DSMODEL = AA.DSMODEL OR MM.DSORIGINALMODEL = AA.DSORIGINALMODEL OR MM.DSGENERICMODEL = AA.DSGENERICMODEL)
AND MM.DSMAKER = 'FORD' AND VR.DTPURCHASE BETWEEN TO_DATE('01/01/2000','DD/MM/YYYY') AND TO_DATE(SYSDATE,'DD/MM/YY')
)AA

;COMMIT;

--Update - Frotas / Quantidades

UPDATE TAB_PROC_BKP_TRUCKS  RS SET RS.TAMANHO_DA_FROTA = (SELECT COUNT(RV.IDVEHICLE) 
FROM TAB_PROC_ETL_CAMINHOES_TODOS RV WHERE RV.IDVEHICLEHOLDER = RS.IDVEHICLEHOLDER)
WHERE EXISTS (SELECT 1 FROM TAB_PROC_ETL_CAMINHOES_TODOS RV WHERE RV.IDVEHICLEHOLDER = RS.IDVEHICLEHOLDER)

;COMMIT;

--Update - Frotas

UPDATE TAB_PROC_BKP_TRUCKS  SET TAMANHO_DA_FROTA = 1 
WHERE TAMANHO_DA_FROTA IS NULL
AND IDVEHICLE IS NOT NULL

;COMMIT;

--Update - Frotas / Descrição

UPDATE TAB_PROC_BKP_TRUCKS  SET DESC_FROTA =
CASE 
WHEN TAMANHO_DA_FROTA = 1 THEN 'AUTONOMO'
WHEN TAMANHO_DA_FROTA BETWEEN 2 AND 7 THEN 'PEQUENO'
WHEN TAMANHO_DA_FROTA BETWEEN 8 AND 59 THEN 'MEDIO'
WHEN TAMANHO_DA_FROTA >= 60 THEN 'GRANDE'
ELSE NULL END               

;COMMIT;

--PURGE


--OPTIN PURGE

UPDATE TAB_PROC_BKP_TRUCKS 
SET FLOPTIN = NULL

;COMMIT;

UPDATE TAB_PROC_BKP_TRUCKS 
SET FLOPTIN = 'N'
Where IDVEHICLEHOLDER IN (SELECT IDPERSON FROM FORD.SPECIALHANDLINGFLAGS WHERE FLPERMISSION IN ('0','N'))

;COMMIT;

UPDATE TAB_PROC_BKP_TRUCKS 
SET FLOPTIN = 'S'
WHERE FLOPTIN IS NULL

;COMMIT;

--ENDERECO PURGE

UPDATE TAB_PROC_BKP_TRUCKS 
SET PURGE_END = NULL

;COMMIT;

UPDATE TAB_PROC_BKP_TRUCKS 
SET PURGE_END = 'S'
Where dbmutil.isvalidaddress(tpstreet, dsaddress, nbaddress, dscomplement, nmdistrict, dscity, cdstate, nbpostalcode) = 0

;COMMIT;

UPDATE TAB_PROC_BKP_TRUCKS 
SET PURGE_END = 'S'
Where ((nbaddress = '.' or nbaddress = '.' or nbaddress is null) 
or nbaddress like '0%' 
or (dsaddress||nbaddress||dscomplement not like '%1%' and 
dsaddress||nbaddress||dscomplement not like '%2%' and 
dsaddress||nbaddress||dscomplement not like '%3%' and 
dsaddress||nbaddress||dscomplement not like '%4%' and 
dsaddress||nbaddress||dscomplement not like '%5%' and 
dsaddress||nbaddress||dscomplement not like '%6%' and 
dsaddress||nbaddress||dscomplement not like '%7%' and 
dsaddress||nbaddress||dscomplement not like '%8%' and 
dsaddress||nbaddress||dscomplement not like '%9%'))

;COMMIT;

UPDATE TAB_PROC_BKP_TRUCKS 
SET PURGE_END = 'S'
where ((cdstate = 'AC' and nbpostalcode not like '699%')
or (cdstate = 'AL' and nbpostalcode not like '57%')
or (cdstate = 'AM' and (nbpostalcode not like '690%' and nbpostalcode not like '691%' and nbpostalcode not like '692%' and nbpostalcode not like '694%' and nbpostalcode not like '695%' and nbpostalcode not like '696%' and nbpostalcode not like '697%' and nbpostalcode not like '698%'))
or (cdstate = 'AP' and nbpostalcode not like '689%')
or (cdstate = 'BA' and (nbpostalcode not like '40%' and nbpostalcode not like '41%' and nbpostalcode not like '42%' and nbpostalcode not like '43%' and nbpostalcode not like '44%' and nbpostalcode not like '45%' and nbpostalcode not like '46%' and nbpostalcode not like '47%' and nbpostalcode not like '48%'))
or (cdstate = 'CE' and (nbpostalcode not like '60%' and nbpostalcode not like '61%' and nbpostalcode not like '62%' and nbpostalcode not like '63%'))
or (cdstate = 'DF' and (nbpostalcode not like '70%' and nbpostalcode not like '71%' and nbpostalcode not like '72%' and nbpostalcode not like '73%'))
or (cdstate = 'ES' and nbpostalcode not like '29%')
or (cdstate = 'GO' and (nbpostalcode not like '72%' and nbpostalcode not like '73%' and nbpostalcode not like '74%' and nbpostalcode not like '75%' and nbpostalcode not like '76%'))
or (cdstate = 'MA' and nbpostalcode not like '65%')
or (cdstate = 'MG' and nbpostalcode not like '3%')
or (cdstate = 'MS' and nbpostalcode not like '79%')
or (cdstate = 'MT' and (nbpostalcode not like '780%' and nbpostalcode not like '781%' and nbpostalcode not like '782%' and nbpostalcode not like '783%' and nbpostalcode not like '784%' and nbpostalcode not like '785%' and nbpostalcode not like '786%' and nbpostalcode not like '787%' and nbpostalcode not like '788%'))
or (cdstate = 'PA' and (nbpostalcode not like '66%' and nbpostalcode not like '67%' and nbpostalcode not like '68%'))
or (cdstate = 'PB' and nbpostalcode not like '58%')
or (cdstate = 'PE' and (nbpostalcode not like '50%' and nbpostalcode not like '51%' and nbpostalcode not like '52%' and nbpostalcode not like '53%' and nbpostalcode not like '54%' and nbpostalcode not like '55%' and nbpostalcode not like '56%'))
or (cdstate = 'PI' and nbpostalcode not like '64%')
or (cdstate = 'PR' and (nbpostalcode not like '80%' and nbpostalcode not like '81%' and nbpostalcode not like '82%' and nbpostalcode not like '83%' and nbpostalcode not like '84%' and nbpostalcode not like '85%' and nbpostalcode not like '86%' and nbpostalcode not like '87%'))
or (cdstate = 'RJ' and (nbpostalcode not like '20%' and nbpostalcode not like '21%' and nbpostalcode not like '22%' and nbpostalcode not like '23%' and nbpostalcode not like '24%' and nbpostalcode not like '25%' and nbpostalcode not like '26%' and nbpostalcode not like '27%' and nbpostalcode not like '28%'))
or (cdstate = 'RN' and nbpostalcode not like '59%')
or (cdstate = 'RO' and nbpostalcode not like '789%')
or (cdstate = 'RR' and nbpostalcode not like '693%')
or (cdstate = 'RS' and nbpostalcode not like '9%')
or (cdstate = 'SC' and (nbpostalcode not like '88%' and nbpostalcode not like '89%'))
or (cdstate = 'SE' and nbpostalcode not like '49%')
or (cdstate = 'SP' and (nbpostalcode not like '0%' and nbpostalcode not like '1%'))
or (cdstate = 'TO' and nbpostalcode not like '77%'))

;COMMIT;

UPDATE TAB_PROC_BKP_TRUCKS 
SET PURGE_END = 'N'
WHERE PURGE_END IS NULL

;COMMIT;

--EMAIL PURGE

UPDATE TAB_PROC_BKP_TRUCKS 
SET PURGE_EMAIL = NULL

;COMMIT;

UPDATE TAB_PROC_BKP_TRUCKS 
SET PURGE_EMAIL = 'S'
Where ((dbmtools.isemail(dsemail) = 0 
Or dsemail  like '%@ford%'
Or dsemail  like '%@naoten%'
Or dsemail  like '%@naotem%'
Or dsemail  like '%@naoposs%'
Or dsemail  like '%@nao%'
Or dsemail  like '%@test%'
Or dsemail  like '%@asd%'
Or dsemail  like '%@.com%'
Or dsemail  like '%@xxx%')
Or dsemail Like '%.'
Or dsemail not like '%@%'
Or dsemail Like '% %'
Or dsemail Like '%naotem%'
Or dsemail Like '%naoten%'
Or dsemail Like '%nao%tem%'
Or dsemail Like '%tenho%'
Or dsemail Like '%/%'
Or dsemail Like '%(%'
Or dsemail Like '%,%'
Or dsemail Like '%;%'
Or dsemail Like '%\%'
Or dsemail Like '%.@%'
Or dsemail Like '%@.%'
Or dsemail Like '%@com%'
Or dsemail Like '%veic%'
Or dsemail Like '%auto%'
Or dsemail Like '%ford%'
Or dsemail Like '%venda%'
Or dsemail Like '%atendimento%'
Or dsemail Like '%combr' 
Or dsemail Like '%possu%'
Or dsemail like 'nao%'
Or dsemail like '%test%' 
Or dsemail like '%teste%'
Or dsemail like '%hahaha%')

;COMMIT;


UPDATE TAB_PROC_BKP_TRUCKS 
SET PURGE_EMAIL = 'N'
WHERE PURGE_EMAIL IS NULL

;COMMIT;

/*
--PURGE TELEFONE PURGE

UPDATE TAB_PROC_ETL_CAMINHOES_2 
SET PURGE_TEL = NULL

;COMMIT;

UPDATE TAB_PROC_ETL_CAMINHOES_2 
SET PURGE_TEL = 'S'
WHERE NBTELEPHONE IS NULL

;COMMIT;

UPDATE TAB_PROC_ETL_CAMINHOES_2 
SET PURGE_TEL = 'S'
WHERE NBAREACODE = SUBSTR(NBTELEPHONE,1,2)

;COMMIT;

UPDATE TAB_PROC_ETL_CAMINHOES_2 
SET PURGE_TEL = 'S'
WHERE LENGTH(NBAREACODE) < 2

;COMMIT;

UPDATE TAB_PROC_ETL_CAMINHOES_2 
SET PURGE_TEL = 'S'
WHERE LENGTH(NBAREACODE) > 2

;COMMIT;

UPDATE TAB_PROC_ETL_CAMINHOES_2 
SET PURGE_TEL = 'S'
WHERE LENGTH(NBTELEPHONE) <= 7

;COMMIT;

UPDATE TAB_PROC_ETL_CAMINHOES_2 
SET PURGE_TEL = 'S'
WHERE LENGTH(NBTELEPHONE) > 9

;COMMIT;

UPDATE TAB_PROC_ETL_CAMINHOES_2 
SET PURGE_TEL = 'S'
WHERE NBTELEPHONE LIKE '1%'

;COMMIT;

UPDATE TAB_PROC_ETL_CAMINHOES_2 
SET PURGE_TEL = 'N'
WHERE PURGE_TEL IS NULL

;COMMIT;
*/

--Update - Lista de DN's / Trucks 

UPDATE TAB_PROC_BKP_TRUCKS  AA SET AA.FANTASIA_DN  = (SELECT BB.FANTASIA FROM TAB_PROC_LISTA_DNS_CAMINHOES_2 BB
WHERE AA.IDDEALER = BB.IDDEALER)
,AA.ENDERECO_DN  = (SELECT BB.ENDERECO FROM TAB_PROC_LISTA_DNS_CAMINHOES_2 BB WHERE AA.IDDEALER = BB.IDDEALER)
,AA.BAIRRO_DN    = (SELECT BB.BAIRRO FROM TAB_PROC_LISTA_DNS_CAMINHOES_2 BB WHERE AA.IDDEALER = BB.IDDEALER)
,AA.CIDADE_DN    = (SELECT BB.CIDADE FROM TAB_PROC_LISTA_DNS_CAMINHOES_2 BB WHERE AA.IDDEALER = BB.IDDEALER)
,AA.UF_DN        = (SELECT BB.UF FROM TAB_PROC_LISTA_DNS_CAMINHOES_2 BB WHERE AA.IDDEALER = BB.IDDEALER)
,AA.CEP_DN       = (SELECT BB.CEP FROM TAB_PROC_LISTA_DNS_CAMINHOES_2 BB WHERE AA.IDDEALER = BB.IDDEALER)
,AA.TELEFONE_DN  = (SELECT BB.TELEFONE FROM TAB_PROC_LISTA_DNS_CAMINHOES_2 BB WHERE AA.IDDEALER = BB.IDDEALER)
,AA.GERENTE_DN   = (SELECT BB.GERENTE_VENDAS FROM TAB_PROC_LISTA_DNS_CAMINHOES_2 BB WHERE AA.IDDEALER = BB.IDDEALER)
WHERE EXISTS (SELECT 1 FROM TAB_PROC_LISTA_DNS_CAMINHOES_2 BB WHERE AA.IDDEALER = BB.IDDEALER)

COMMIT;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--TABELAS NA QUERY

--tabelas ford

FORD.ADDRESS
FORD.TELEPHONE
FORD.EMAIL
FORD.VEHICLERELATIONSHIP
FORD.VEHICLE
FORD.VEHICLEFACT
FORD.MAKERMODEL
FORD.PERSON
FORD.COMPANY
FORD.CORPOGRAPHICS
FORD.INDIVIDUAL

--tabelas nao criadas ou truncadas no job

ETL_CAMINHOES_2

--Descrição:listagem de caminhoes,com seus respectivos donos e dealers que venderam os mesmos

--Acoes no script:

-- campos da mesma sao atualizados a partir de infos da tabela tc_caminhoes_2
--recebe informacoes com insert a partir de tabelas ford( FORD.PERSON ,FORD.COMPANY ,FORD.CORPOGRAPHICS ,FORD.INDIVIDUAL, FORD.VEHICLE,FORD.VEHICLERELATIONSHIP ,FORD.VEHICLEFACT ,FORD.MAKERMODEL ,ETL_CAM_MODELOS,FORD.ADDRESS, FORD.TELEPHONE,FORD.EMAIL)
--flag  COLUNA_INSERT_PES_VEI_NOVO é atualizada para 'nao',assim como updates sao feitos adicionando infos calculadas(tamanho da frota,endereco de dealaer)

ETL_CAM_MODELOS

--Descrição: de para mostrando nome do modelo inteiro do caminhao para nome do modelo generico,exemplo:modelo inteiro:FORD/CARGO 814 TECAR PAS,modelo generico:B-12000

--Acoes no script:

--consulta de campos para serem adicionados dentro de insert de tabelas TC_CAMINHOES,ETL_CAMINHOES_2,ETL_CAMINHOES_TODOS

LISTA_DNS_CAMINHOES_2


--Descrição: listagem de dealers de caminhoes com suas respectivas informacoes de endereco,gerentes,nome,id e descricao

--Acoes no script:

--tabela é consultada para atualizar informacoes de endereco e gerente da tabela ETL_CAMINHOES_2


--tabelas truncadas

TC_CAMINHOES_2 --TRUNCATE
TC_CAMINHOES--TRUNCATE
ETL_CAMINHOES_TODOS--TRUNCATE

--tabela nao nao criada,nao truncada e nao utilizada no job

TB_OPENS_DEDUP_TAB1 

--Descrição: Listagem de enderecos de emails com data de leitura

--Acoes no script:

--nenhuma