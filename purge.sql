--OPTIN

UPDATE ETL_CAMINHOES_2
SET FLOPTIN = NULL;

UPDATE ETL_CAMINHOES_2
SET FLOPTIN = 'N'
Where IDVEHICLEHOLDER IN (SELECT IDPERSON FROM FORD.SPECIALHANDLINGFLAGS WHERE FLPERMISSION IN ('0','N'));


UPDATE ETL_CAMINHOES_2
SET FLOPTIN = 'S'
WHERE FLOPTIN IS NULL

--ENDERECO

UPDATE ETL_CAMINHOES_2
SET PURGE_END = NULL;

UPDATE ETL_CAMINHOES_2
SET PURGE_END = 'S'
Where dbmutil.isvalidaddress(tpstreet, dsaddress, nbaddress, dscomplement, nmdistrict, dscity, cdstate, nbpostalcode) = 0;

UPDATE ETL_CAMINHOES_2
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
dsaddress||nbaddress||dscomplement not like '%9%'));

UPDATE ETL_CAMINHOES_2
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
or (cdstate = 'TO' and nbpostalcode not like '77%'));

UPDATE ETL_CAMINHOES_2
SET PURGE_END = 'N'
WHERE PURGE_END IS NULL

--EMAIL

UPDATE ETL_CAMINHOES_2
SET PURGE_EMAIL = NULL;

UPDATE ETL_CAMINHOES_2
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
Or semail like '%hahaha%');


UPDATE ETL_CAMINHOES_2
SET PURGE_EMAIL = 'N'
WHERE PURGE_EMAIL IS NULL


--PURGE TELEFONE

UPDATE ETL_CAMINHOES_2
SET PURGE_TEL = NULL;

UPDATE ETL_CAMINHOES_2
SET PURGE_TEL = 'S'
WHERE NBTELEPHONE IS NULL;

UPDATE ETL_CAMINHOES_2
SET PURGE_TEL = 'S'
WHERE NBAREACODE = SUBSTR(NBTELEPHONE,1,2);

UPDATE ETL_CAMINHOES_2
SET PURGE_TEL = 'S'
WHERE LENGTH(NBAREACODE) < 2;

UPDATE ETL_CAMINHOES_2
SET PURGE_TEL = 'S'
WHERE LENGTH(NBAREACODE) > 2;

UPDATE ETL_CAMINHOES_2
SET PURGE_TEL = 'S'
WHERE LENGTH(NBTELEPHONE) <= 7;

UPDATE ETL_CAMINHOES_2
SET PURGE_TEL = 'S'
WHERE LENGTH(NBTELEPHONE) > 9;

UPDATE ETL_CAMINHOES_2
SET PURGE_TEL = 'S'
WHERE NBTELEPHONE LIKE '1%';

UPDATE ETL_CAMINHOES_2
SET PURGE_TEL = 'N'
WHERE PURGE_TEL IS NULL

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--TABELAS NA QUERY

FORD.SPECIALHANDLINGFLAGS
ETL_CAMINHOES_2