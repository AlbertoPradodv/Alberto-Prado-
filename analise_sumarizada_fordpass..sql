
--ENGAJAMENTO 

-- OPEN 
SELECT  COUNT ( DISTINCT A.EMAILADDRESS)
FROM SERBINOC.TB_EXACT_OPENS A 
WHERE A.SENDID IN (
119687,
119686,
118559,
118558,
115971,
115969,
114939,
114938,
113499,
113498,
112494,
112493,
111440,
111439
)




-- SENT
SELECT COUNT (DISTINCT A.EMAILADDRESS)
FROM SERBINOC.TB_EXACT_SENT A 
WHERE A.SENDID IN (
119687,
119686,
118559,
118558,
115971,
115969,
114939,
114938,
113499,
113498,
112494,
112493,
111440,
111439
)


--NEW USERS FORDPASS 

SELECT  COUNT ( DISTINCT A.EMAILADDRESS)
FROM SERBINOC.TB_EXACT_OPENS A 
INNER JOIN STG_PROC_DWN_FORDPASS B
ON UPPER(A.EMAILADDRESS)=UPPER( B.CAPP01_EMAIL_ADDR_X)
WHERE A.SENDID IN (
119687,
119686,
118559,
118558,
115971,
115969,
114939,
114938,
113499,
113498,
112494,
112493,
111440,
111439
)
AND TO_DATE(B.CAPP01_CREATE_S,'DD/MM/YYYY') >=  TO_DATE(A.EVENTDATE, 'DD/MM/YY')

--NEW USER WITH VIN 
SELECT  COUNT ( DISTINCT A.EMAILADDRESS)
FROM SERBINOC.TB_EXACT_OPENS A 
INNER JOIN STG_PROC_DWN_FORDPASS B
ON UPPER(A.EMAILADDRESS)=UPPER( B.CAPP01_EMAIL_ADDR_X)
WHERE A.SENDID IN (
119687,
119686,
118559,
118558,
115971,
115969,
114939,
114938,
113499,
113498,
112494,
112493,
111440,
111439

)
AND CAPP03_VIN_C <> 'NULL'
AND TO_DATE (B.CAPP01_CREATE_S,'DD/MM/YYYY') >= TO_DATE(A.EVENTDATE, 'DD/MM/YY')

--REGUA 

-- OPEN 
SELECT  COUNT ( DISTINCT A.EMAILADDRESS)
FROM SERBINOC.TB_EXACT_OPENS A 
WHERE A.SENDID IN (
119472,
119389,
119288,
119087,
118972,
118942,
118916,
118816,
118660,
118394,
118308,
118251,
118216,
118118,
117984,
117751,
117593,
116330,
116239,
116135,
116055,
116020,
115914,
115708,
115497,
115335,
115231,
115202,
115092,
114914,
108286,
107950,
107776,
107746,
107711
)




-- SENT
SELECT COUNT (DISTINCT A.EMAILADDRESS)
FROM SERBINOC.TB_EXACT_SENT A 
WHERE A.SENDID IN (
119472,
119389,
119288,
119087,
118972,
118942,
118916,
118816,
118660,
118394,
118308,
118251,
118216,
118118,
117984,
117751,
117593,
116330,
116239,
116135,
116055,
116020,
115914,
115708,
115497,
115335,
115231,
115202,
115092,
114914,
108286,
107950,
107776,
107746,
107711
)


--NEW USERS FORDPASS

SELECT  COUNT ( DISTINCT A.EMAILADDRESS)
FROM SERBINOC.TB_EXACT_OPENS A 
INNER JOIN STG_PROC_DWN_FORDPASS B
ON UPPER(A.EMAILADDRESS)=UPPER( B.CAPP01_EMAIL_ADDR_X)
WHERE A.SENDID IN (
119472,
119389,
119288,
119087,
118972,
118942,
118916,
118816,
118660,
118394,
118308,
118251,
118216,
118118,
117984,
117751,
117593,
116330,
116239,
116135,
116055,
116020,
115914,
115708,
115497,
115335,
115231,
115202,   
115092,
114914,
108286,
107950,
107776,
107746,
107711
)
AND TO_DATE(B.CAPP01_CREATE_S,'DD/MM/YYYY') >= TO_DATE(A.EVENTDATE, 'DD/MM/YY')

--NEW USER WITH VIN 
SELECT  COUNT ( DISTINCT A.EMAILADDRESS)
FROM SERBINOC.TB_EXACT_OPENS A 
INNER JOIN STG_PROC_DWN_FORDPASS B
ON UPPER(A.EMAILADDRESS)=UPPER( B.CAPP01_EMAIL_ADDR_X)
WHERE A.SENDID IN (
119472,
119389,
119288,
119087,
118972,
118942,
118916,
118816,
118660,
118394,
118308,
118251,
118216,
118118,
117984,
117751,
117593,
116330,
116239,
116135,
116055,
116020,
115914,
115708,
115497,
115335,
115231,
115202,
115092,
114914,
108286,
107950,
107776,
107746,
107711
)
AND CAPP03_VIN_C <> 'NULL'
AND TO_DATE (B.CAPP01_CREATE_S,'DD/MM/YYYY') >= TO_DATE(A.EVENTDATE, 'DD/MM/YY')






--DISPAROS DE ENGAJAMENTO SEPARADOS 

--NEW USERS FORDPASS 

SELECT  COUNT ( DISTINCT A.EMAILADDRESS)
FROM SERBINOC.TB_EXACT_OPENS A 
INNER JOIN STG_PROC_DWN_FORDPASS B
ON UPPER(A.EMAILADDRESS)=UPPER( B.CAPP01_EMAIL_ADDR_X)
WHERE A.SENDID IN (111439)
AND TO_DATE(B.CAPP01_CREATE_S,'DD/MM/YYYY') >=  TO_DATE(A.EVENTDATE, 'DD/MM/YY')

--NEW USER WITH VIN 
SELECT  COUNT ( DISTINCT A.EMAILADDRESS)
FROM SERBINOC.TB_EXACT_OPENS A 
INNER JOIN STG_PROC_DWN_FORDPASS B
ON UPPER(A.EMAILADDRESS)=UPPER( B.CAPP01_EMAIL_ADDR_X)
WHERE A.SENDID IN (111439)
AND CAPP03_VIN_C <> 'NULL'
AND TO_DATE (B.CAPP01_CREATE_S,'DD/MM/YYYY') >= TO_DATE(A.EVENTDATE, 'DD/MM/YY')



--119687,  new users: 54,with vin :35
--119686,new users: 48,with vin :34
--118559,new users: 90,with vin :46
--118558,new users: 75,with vin :42
--115971,new users: 18,with vin :8
--115969,new users: 13,with vin :3
--114939,new users: 120,with vin :61
--114938,new users: 124,with vin :73
--113499,new users: 5,with vin :3
--113498,new users: 7,with vin :2
--112494,new users: 140,with vin :72
--112493,new users: 179,with vin :109
--111440,new users: 5,with vin :2
--111439 new users: 4, with vin :3