SELECT nome
	   ,email
	   ,cidade
	   ,estado
	   ,nameplate
	   ,HASHBYTES('SHA2_256',email) as hash
INTO teste_globo_hash 
FROM teste_globo 
