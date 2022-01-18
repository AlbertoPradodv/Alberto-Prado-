
-- JOB 2015 UPDATE - MAX/PREV.REV.
 --JOB  2014 UPDATE - MAX/PREV.REV. É EXATAMENTE O MESMO QUERY,UNICA ALTERACAO É O UPDATE E A CONSULTA DAS TABELAS QUE SAO DO RESPECTIVO ANO,COM A MESMA ESTRUTURA,EM 2014 SAO 6 CHAVES

--update - chave_1

UPDATE ETL_FCSD_2015 AA SET AA.MAX_PREV_REV_1 = (SELECT BB.MAX_PREV_REV FROM  ETL_FCSD_2015_DATAS BB WHERE AA.CHAVE_1 = BB.CHAVE)
WHERE EXISTS (SELECT 1 FROM  ETL_FCSD_2015_DATAS BB WHERE AA.CHAVE_1 = BB.CHAVE)

--update - chave_2

UPDATE ETL_FCSD_2015 AA SET AA.MAX_PREV_REV_2 = (SELECT BB.MAX_PREV_REV FROM  ETL_FCSD_2015_DATAS BB WHERE AA.CHAVE_2 = BB.CHAVE)
WHERE EXISTS (SELECT 1 FROM  ETL_FCSD_2015_DATAS BB WHERE AA.CHAVE_2 = BB.CHAVE)

--update - chave_3

UPDATE ETL_FCSD_2015 AA SET AA.MAX_PREV_REV_3 = (SELECT BB.MAX_PREV_REV FROM  ETL_FCSD_2015_DATAS BB WHERE AA.CHAVE_3 = BB.CHAVE)
WHERE EXISTS (SELECT 1 FROM  ETL_FCSD_2015_DATAS BB WHERE AA.CHAVE_3 = BB.CHAVE)

--update - chave_4

UPDATE ETL_FCSD_2015 AA SET AA.MAX_PREV_REV_4 = (SELECT BB.MAX_PREV_REV FROM  ETL_FCSD_2015_DATAS BB WHERE AA.CHAVE_4 = BB.CHAVE)
WHERE EXISTS (SELECT 1 FROM  ETL_FCSD_2015_DATAS BB WHERE AA.CHAVE_4 = BB.CHAVE)



--TABELAS NA QUERY

--2015

ETL_FCSD_2015 - TRUNCATE
ETL_FCSD_2015_DATAS - TRUNCATE

--2014


ETL_FCSD_ATE2014 -- TRUNCATE
ETL_FCSD_ATE2014_DATAS -- TRUNCATE


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- JOB 2014 UPDATE - MIN/PREV.REV.
 --JOB  2015 UPDATE - MMIN/PREV.REV. É EXATAMENTE O MESMO QUERY,UNICA ALTERACAO É O UPDATE E A CONSULTA DAS TABELAS QUE SAO DO RESPECTIVO ANO COM A MESMA ESTRUTURA,EM 2015 SAO 4 CHAVES



--update - chave_1

UPDATE ETL_FCSD_ATE2014 AA SET AA.MIN_PREV_REV_1 = (SELECT BB.MIN_PREV_REV FROM  ETL_FCSD_ATE2014_DATAS BB WHERE AA.CHAVE_1 = BB.CHAVE)
WHERE EXISTS (SELECT 1 FROM  ETL_FCSD_ATE2014_DATAS BB WHERE AA.CHAVE_1 = BB.CHAVE)

--update - chave_2


UPDATE ETL_FCSD_ATE2014 AA SET AA.MIN_PREV_REV_2 = (SELECT BB.MIN_PREV_REV FROM  ETL_FCSD_ATE2014_DATAS BB WHERE AA.CHAVE_2 = BB.CHAVE)
WHERE EXISTS (SELECT 1 FROM  ETL_FCSD_ATE2014_DATAS BB WHERE AA.CHAVE_2 = BB.CHAVE)

--update - chave_3

UPDATE ETL_FCSD_ATE2014 AA SET AA.MIN_PREV_REV_3 = (SELECT BB.MIN_PREV_REV FROM  ETL_FCSD_ATE2014_DATAS BB WHERE AA.CHAVE_3 = BB.CHAVE)
WHERE EXISTS (SELECT 1 FROM  ETL_FCSD_ATE2014_DATAS BB WHERE AA.CHAVE_3 = BB.CHAVE)

--update - chave_4

UPDATE ETL_FCSD_ATE2014 AA SET AA.MIN_PREV_REV_4 = (SELECT BB.MIN_PREV_REV FROM  ETL_FCSD_ATE2014_DATAS BB WHERE AA.CHAVE_4 = BB.CHAVE)
WHERE EXISTS (SELECT 1 FROM  ETL_FCSD_ATE2014_DATAS BB WHERE AA.CHAVE_4 = BB.CHAVE)

--update - chave_5

UPDATE ETL_FCSD_ATE2014 AA SET AA.MIN_PREV_REV_5 = (SELECT BB.MIN_PREV_REV FROM  ETL_FCSD_ATE2014_DATAS BB WHERE AA.CHAVE_5 = BB.CHAVE)
WHERE EXISTS (SELECT 1 FROM  ETL_FCSD_ATE2014_DATAS BB WHERE AA.CHAVE_5 = BB.CHAVE)

--update - chave_6

UPDATE ETL_FCSD_ATE2014 AA SET AA.MIN_PREV_REV_6 = (SELECT BB.MIN_PREV_REV FROM  ETL_FCSD_ATE2014_DATAS BB WHERE AA.CHAVE_6 = BB.CHAVE)
WHERE EXISTS (SELECT 1 FROM  ETL_FCSD_ATE2014_DATAS BB WHERE AA.CHAVE_6 = BB.CHAVE)


--TABELAS NA QUERY


--2014

ETL_FCSD_ATE2014 -- TRUNCATE
ETL_FCSD_ATE2014_DATAS --TRUNCATE


--2015

ETL_FCSD_2015 -- TRUNCATE
ETL_FCSD_2015_DATAS --TRUNCATE

