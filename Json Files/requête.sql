-- Tous les samples d'un utilisateur
SELECT us.lastName, us.firstName, samp.name
FROM Sample samp, Userr us
WHERE samp.userId = us.id
AND us.lastName = "Merlin"
AND us.firstName = "Croain";

-- Tous les samples qui sont dans un Dataset
SELECT samp.URI, samp.name
FROM Sample samp, Includ inc, Dataset D
WHERE samp.URI = inc.sampleURI
AND inc.DatasetId = D.id
AND D.name = "";

-- Tous les opération qui peut se suivre
SELECT *

FROM (
-- pour chaque opération, ses inputs et les assertions
SELECT op.id as operationId, inp.id as inputId, asser.id as assertionId
FROM Operation op, Input inp, Output outp, Correspond2 c2, Correspond3 c3, Assertion asser
WHERE op.id = inp.operationId
AND inp.id = c2.inputId
AND c2.assertionId = asser.id) T1

LEFT JOIN (
-- pour chaque opération, son output et l'assertions
SELECT op.id, outp.id as inputId, asser.id as assertionId
FROM Operation op as operationId, Input inp, Output outp, Correspond2 c2, Correspond3 c3, Assertion asser
AND op.id = outp.operationId
AND outp.id = c3.outputId
AND c3.assertionId = asser.id) T2

ON T1.operationId = T2.operationId
AND T1.assertionId = T2.assertionId;

-- Le nombre d'apparition d'une opération dans des workflow
SELECT op.id, count(c.operationId)
FROM Operation op, Contains c
WHERE c.operationId = op.id
GROUP BY op.id

-- Tous les samples les plus proches d'un sample défini


/*
-- tous les sources et ses samples
(SELECT s.URI as source, samp.URI as sampleURI, samp.name as sampName
FROM Sample samp, Source s
WHERE samp.sourceURI = s.URI)T1

-- tous les sources et ses sources
(SELECT *
FROM sourceFrom sf
LEFT JOIN sourceFrom sf2
ON sf.sourcefromURI = sf2.sourceURI
LEFT JOIN sourceFrom sf3
ON sf2.sourcefromURI = sf3.sourceURI
LEFT JOIN sourceFrom sf4
ON sf3.sourcefromURI = sf4.sourceURI)T2

-- tous les sample de la distance 1
SELECT 
FROM T1, sourceFrom sf
WHERE T1.sampname = ""
AND T1.URI = */


-- solution2
-- tous les samples de la distance 1
SELECT *
FROM (
SELECT samp.URI, samp.name
FROM Sample samp, Source s
WHERE s.URI = samp.sourceURI
AND s.URI = (SELECT s2.URI
             FROM Source s2, Sample samp2
			 WHERE samp2.name = ""
			 AND samp2.sourceURI = s2.URI)
AND samp.name <> "";

UNION

-- tous les samples de la distance 2

SELECT samp4.URI, samp4.name
FROM 
-- la source parente de la source actuelle
(SELECT sf.sourcefromURI as source_parente
FROM Source s, sourceFrom sf
WHERE s.URI = (SELECT s2.URI
               FROM Source s2, Sample samp2
			   WHERE samp2.name = ""
			   AND samp2.sourceURI = s2.URI)
AND s.URI = sf.sourceURI) T1,

-- la source enfante de la source actuelle
(SELECT sf.sourceURI as source_enfante
FROM Source s1, sourceFrom sf1
WHERE s1.URI = (SELECT s2.URI
               FROM Source s3, Sample samp3
			   WHERE samp3.name = ""
			   AND samp3.sourceURI = s3.URI)
AND s1.URI = sf1.sourcefromURI) T2,
Sample samp4
WHERE samp4.sourceURI = T1._parente
OR samp4.sourceURI = T2.source_enfante)
limit 50;

-- solution 3
WITH RECURSIVE dist AS (
		SELECT URI, 0 as distance
		FROM Sample
		WHERE name = ""
	UNION ALL
		SELECT samp.URI, dist.distance+1 as distance
		FROM Sample samp, Source s
		JOIN dist ON 
)

-- Tous les samples accessible par un utilisateur en sachant que un utilisateur a accès un sample si il a inséré la données ou quelqu'un d'un group auquel il appartient ou que la licence est publique
SELECT
FROM Sample samp, Userr u; hasLicense hasl, 
WHERE u.lastName = "Merlin"
AND u.firstName = "Croain"
AND (samp.userId = u.id
OR (u.id =)
OR ())
-- Tous les Dataset les plus proches

-- Toute les source qui possèdent le même tag
SELECT s.URI
FROM Source s, Correspond c, Tag t
WHERE s.URI = c.sourceURI
AND t.id = c.tagId
AND t.name = ""

-- Toutes les analyses effectuées sur un sample
SELECT a.id, a.name
FROM Sample samp, Includ inc, Dataset d, hasAnalysis ha, Analysis a,
WHERE samp.URI = inc.sampleURI
AND inc.DatasetId = d.id
AND d.id = ha.datasetId
AND ha.analysisId = a.id
AND samp.name = ""

-- Le privilège minimum nécessaire pour accéder à un Dataset
SELECT d.id, d.name, max(p.Level)
FROM hasPrivilege hp, Privilege p, Userr u, Sample samp, Includ inc, Dataset d
WHERE p.URI = hp.userId
AND hp.privilegeURI = u.id
AND u.id = samp.userId
AND samp.URI = inc.sampleURI
AND inc.DatasetId = d.id
AND d.name = ""
GROUP BY d.id, d.name;

-- Donner tous les types d'algorithme qu'un sample à nourri et pour chaque type d'algorithme donner les algorithmes
SELECT 
FROM Sample samp, Includ inc, Dataset d, hasAnalysis ha, Analysis a, Implementation implem, Algorithm2 algo, AlgoSupervised, AlgoUnsupervised, AlgoReinforcement, DeepLearning
WHERE samp.URI = inc.sampleURI
AND inc.DatasetId = d.id
AND d.id = ha.datasetId
AND ha.analysisId = a.id
AND a.implementationId = implem.id
AND implem.algorithmId = algo.id
AND (algo.id = AlgoSupervised.algorithmId
OR algo.id = AlgoUnsupervised.algorithmId
OR algo.id = AlgoReinforcement.algorithmId
OR algo.id = DeepLearning.algorithmId)
AND samp.name = "";