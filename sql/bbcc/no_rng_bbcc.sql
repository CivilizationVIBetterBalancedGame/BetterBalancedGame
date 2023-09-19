--============Adding Missing Yields:=============-----

--===================================================================
--in live
--===================================================================
--food

/*
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount-2) AS varchar)||'_FOOD_BBCC', 'YIELD_FOOD', Flat_CutOffYieldValues.Amount-2, 'REQSET_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount-2) AS varchar)||'_FOOD_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_FOOD' = Flat_CutOffYieldValues.YieldType
	WHERE Food<Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS'
		AND Flat_CutOffYieldValues.Amount-2 > 0;
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount-2) AS varchar)||'_FOOD_BBCC', 'YIELD_FOOD', Hill_CutOffYieldValues.Amount-2, 'REQSET_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount-2) AS varchar)||'_FOOD_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_FOOD' = Hill_CutOffYieldValues.YieldType
	WHERE Food<Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS'
		AND Hill_CutOffYieldValues.Amount-2 > 0;
--prod
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount-1) AS varchar)||'_PRODUCTION_BBCC', 'YIELD_PRODUCTION', Flat_CutOffYieldValues.Amount-1, 'REQSET_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount-1) AS varchar)||'_PRODUCTION_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_PRODUCTION' = Flat_CutOffYieldValues.YieldType
	WHERE Prod<Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS'
		AND Flat_CutOffYieldValues.Amount-1 > 0;
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount-1) AS varchar)||'_PRODUCTION_BBCC', 'YIELD_PRODUCTION', Hill_CutOffYieldValues.Amount-1, 'REQSET_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount-1) AS varchar)||'_PRODUCTION_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_PRODUCTION' = Hill_CutOffYieldValues.YieldType
	WHERE Prod<Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS'
		AND Hill_CutOffYieldValues.Amount-1 > 0;
--gold
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_GOLD_BBCC', 'YIELD_GOLD', Flat_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_GOLD_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_GOLD' = Flat_CutOffYieldValues.YieldType
	WHERE Gold<Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS'
		AND Flat_CutOffYieldValues.Amount > 0;
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_GOLD_BBCC', 'YIELD_GOLD', Hill_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_GOLD_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_GOLD' = Hill_CutOffYieldValues.YieldType
	WHERE Gold<Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS'
		AND Hill_CutOffYieldValues.Amount > 0;
--faith
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_FAITH_BBCC', 'YIELD_FAITH', Flat_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_FAITH_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_FAITH' = Flat_CutOffYieldValues.YieldType
	WHERE Faith<Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS'
		AND Flat_CutOffYieldValues.Amount > 0;
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_FAITH_BBCC', 'YIELD_FAITH', Hill_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_FAITH_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_FAITH' = Hill_CutOffYieldValues.YieldType
	WHERE Faith<Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS'
		AND Hill_CutOffYieldValues.Amount > 0;
--culture
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_CULTURE_BBCC', 'YIELD_CULTURE', Flat_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_CULTURE_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_CULTURE' = Flat_CutOffYieldValues.YieldType
	WHERE Cult<Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS'
		AND Flat_CutOffYieldValues.Amount > 0;
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_CULTURE_BBCC', 'YIELD_CULTURE', Hill_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_CULTURE_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_CULTURE' = Hill_CutOffYieldValues.YieldType
	WHERE Cult<Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS'
		AND Hill_CutOffYieldValues.Amount > 0;
--science
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_SCIENCE_BBCC', 'YIELD_SCIENCE', Flat_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Flat_CutOffYieldValues.Amount) AS varchar)||'_SCIENCE_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_SCIENCE' = Flat_CutOffYieldValues.YieldType
	WHERE Sci<Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS'
		AND Flat_CutOffYieldValues.Amount > 0;
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_SCIENCE_BBCC', 'YIELD_SCIENCE', Hill_CutOffYieldValues.Amount, 'REQSET_ADD_'||CAST(ABS(Hill_CutOffYieldValues.Amount) AS varchar)||'_SCIENCE_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_SCIENCE' = Hill_CutOffYieldValues.YieldType
	WHERE Sci<Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS'
		AND Hill_CutOffYieldValues.Amount > 0;
*/
--removing excess yields (went over to lua side completely, because it is conflicting)
/*
--flat food
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(ABS(Flat_CutOffYieldValues.Amount-BBCC.Food) AS varchar)||'_FOOD_BBCC', 'YIELD_FOOD', Flat_CutOffYieldValues.Amount-BBCC.Food, 'REQSET_REMOVE_'||CAST(ABS(Flat_CutOffYieldValues.Amount-BBCC.Food) AS varchar)||'_FOOD_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_FOOD' = Flat_CutOffYieldValues.YieldType
	WHERE Food>Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS';
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(ABS(Hill_CutOffYieldValues.Amount-BBCC.Food) AS varchar)||'_FOOD_BBCC', 'YIELD_FOOD', Hill_CutOffYieldValues.Amount-BBCC.Food, 'REQSET_REMOVE_'||CAST(ABS(Hill_CutOffYieldValues.Amount-BBCC.Food) AS varchar)||'_FOOD_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_FOOD' = Hill_CutOffYieldValues.YieldType
	WHERE Food>Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS';
--prod
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(ABS(Flat_CutOffYieldValues.Amount-BBCC.Prod) AS varchar)||'_PRODUCTION_BBCC', 'YIELD_PRODUCTION', Flat_CutOffYieldValues.Amount-BBCC.Prod, 'REQSET_REMOVE_'||CAST(ABS(Flat_CutOffYieldValues.Amount-BBCC.Prod) AS varchar)||'_PRODUCTION_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_PRODUCTION' = Flat_CutOffYieldValues.YieldType
	WHERE Prod>Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS';
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(ABS(Hill_CutOffYieldValues.Amount-BBCC.Prod) AS varchar)||'_PRODUCTION_BBCC', 'YIELD_PRODUCTION', Hill_CutOffYieldValues.Amount-BBCC.Prod, 'REQSET_REMOVE_'||CAST(ABS(Hill_CutOffYieldValues.Amount-BBCC.Prod) AS varchar)||'_PRODUCTION_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_PRODUCTION' = Hill_CutOffYieldValues.YieldType
	WHERE Prod>Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS';
--gold
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(ABS(Flat_CutOffYieldValues.Amount-BBCC.Gold) AS varchar)||'_GOLD_BBCC', 'YIELD_GOLD', Flat_CutOffYieldValues.Amount-BBCC.Gold, 'REQSET_REMOVE_'||CAST(ABS(Flat_CutOffYieldValues.Amount-BBCC.Gold) AS varchar)||'_GOLD_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_GOLD' = Flat_CutOffYieldValues.YieldType
	WHERE Gold>Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS';
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(ABS(Hill_CutOffYieldValues.Amount - BBCC.Gold) AS varchar)||'_GOLD_BBCC', 'YIELD_GOLD', Hill_CutOffYieldValues.Amount - BBCC.Gold, 'REQSET_REMOVE_'||CAST(ABS(Hill_CutOffYieldValues.Amount - BBCC.Gold) AS varchar)||'_GOLD_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_GOLD' = Hill_CutOffYieldValues.YieldType
	WHERE Gold>Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS';
--faith
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(ABS(Flat_CutOffYieldValues.Amount-BBCC.Faith) AS varchar)||'_FAITH_BBCC', 'YIELD_FAITH', Flat_CutOffYieldValues.Amount-BBCC.Faith, 'REQSET_REMOVE_'||CAST(ABS(Flat_CutOffYieldValues.Amount-BBCC.Faith) AS varchar)||'_FAITH_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_FAITH' = Flat_CutOffYieldValues.YieldType
	WHERE Faith>Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS';
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(ABS(Hill_CutOffYieldValues.Amount-BBCC.Faith) AS varchar)||'_FAITH_BBCC', 'YIELD_FAITH', Hill_CutOffYieldValues.Amount-BBCC.Faith, 'REQSET_REMOVE_'||CAST(ABS(Hill_CutOffYieldValues.Amount-BBCC.Faith) AS varchar)||'_FAITH_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_FAITH' = Hill_CutOffYieldValues.YieldType
	WHERE Faith>Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS';
--culture
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(ABS(Flat_CutOffYieldValues.Amount-BBCC.Cult) AS varchar)||'_CULTURE_BBCC', 'YIELD_CULTURE', Flat_CutOffYieldValues.Amount-BBCC.Cult, 'REQSET_REMOVE_'||CAST(ABS(Flat_CutOffYieldValues.Amount-BBCC.Cult) AS varchar)||'_CULTURE_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_CULTURE' = Flat_CutOffYieldValues.YieldType
	WHERE Cult>Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS';
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(ABS(Hill_CutOffYieldValues.Amount-BBCC.Cult) AS varchar)||'_CULTURE_BBCC', 'YIELD_CULTURE', Hill_CutOffYieldValues.Amount-BBCC.Cult, 'REQSET_REMOVE_'||CAST(ABS(Hill_CutOffYieldValues.Amount-BBCC.Cult) AS varchar)||'_CULTURE_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_CULTURE' = Hill_CutOffYieldValues.YieldType
	WHERE Cult>Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS';
--science
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(ABS(Flat_CutOffYieldValues.Amount-BBCC.Sci) AS varchar)||'_SCIENCE_BBCC', 'YIELD_SCIENCE', Flat_CutOffYieldValues.Amount-BBCC.Sci, 'REQSET_REMOVE_'||CAST(ABS(Flat_CutOffYieldValues.Amount-BBCC.Sci) AS varchar)||'_SCIENCE_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Flat_CutOffYieldValues ON 'YIELD_SCIENCE' = Flat_CutOffYieldValues.YieldType
	WHERE Sci>Flat_CutOffYieldValues.Amount
		AND TerrainType NOT LIKE '%HILLS';
INSERT INTO BBCC_Modifiers(ModifierId, YieldType, Amount, SubjectRequirementSetId, TerrainType, ResourceType, ResourceClassType, FeatureType)
	SELECT DISTINCT 'MODIFIER_REMOVE_'||CAST(ABS(Hill_CutOffYieldValues.Amount-BBCC.Sci) AS varchar)||'_SCIENCE_BBCC', 'YIELD_SCIENCE', Hill_CutOffYieldValues.Amount-BBCC.Sci, 'REQSET_REMOVE_'||CAST(ABS(Hill_CutOffYieldValues.Amount-BBCC.Sci) AS varchar)||'_SCIENCE_BBCC', BBCC.TerrainType, BBCC.ResourceType, BBCC.ResourceClassType, BBCC.FeatureType
	FROM BBCC INNER JOIN Hill_CutOffYieldValues ON 'YIELD_SCIENCE' = Hill_CutOffYieldValues.YieldType
	WHERE Sci>Hill_CutOffYieldValues.Amount
		AND TerrainType LIKE '%HILLS';
*/
--excluded terrains that already provide the correct values
--===================================================================
--in live
--===================================================================
/*
INSERT INTO Flat_SpecialTerrain
SELECT DISTINCT BBCC_Modifiers.SubjectRequirementSetId, yt, tt
	FROM BBCC_Modifiers
	INNER JOIN
	(SELECT Terrain_YieldChanges.TerrainType as tt, Terrain_YieldChanges.YieldType as yt, Flat_CutOffYieldValues.Amount as am
	FROM Terrain_YieldChanges
	INNER JOIN Flat_CutOffYieldValues ON Flat_CutOffYieldValues.YieldType = Terrain_YieldChanges.YieldType
	WHERE YieldChange>=Flat_CutOffYieldValues.Amount
		AND Terrain_YieldChanges.TerrainType NOT LIKE "%HILLS"
		AND Terrain_YieldChanges.TerrainType NOT LIKE "%OCEAN"
		AND Terrain_YieldChanges.TerrainType NOT LIKE "%COAST")
	ON BBCC_Modifiers.TerrainType = tt
	WHERE YieldType = yt AND
		SubjectRequirementSetId LIKE '%ADD%';

INSERT INTO Hill_SpecialTerrain
SELECT DISTINCT BBCC_Modifiers.SubjectRequirementSetId, yt, tt
	FROM BBCC_Modifiers
	INNER JOIN
	(SELECT Terrain_YieldChanges.TerrainType as tt, Terrain_YieldChanges.YieldType as yt, Hill_CutOffYieldValues.Amount as am
	FROM Terrain_YieldChanges
	INNER JOIN Hill_CutOffYieldValues ON Hill_CutOffYieldValues.YieldType = Terrain_YieldChanges.YieldType
	WHERE YieldChange>=Hill_CutOffYieldValues.Amount
		AND Terrain_YieldChanges.TerrainType LIKE "%HILLS")
	ON BBCC_Modifiers.TerrainType = tt
	WHERE YieldType = yt AND
		SubjectRequirementSetId LIKE '%ADD%';

--================Building Modifiers and Respective Reqsets==================--------
UPDATE BBCC_Modifiers SET InnerReqSet = REPLACE(ModifierId, 'MODIFIER_','REQSET_VALID_TFR_'), ReqSet_TFR = 'REQSET_TFR_'||TerrainType||'_'||
CASE
	WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NULL AND ResourceClassType<>'RESOURCECLASS_STRATEGIC' THEN 'HAS_'||ResourceType||'_BBCC'
	WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NULL AND ResourceClassType = 'RESOURCECLASS_STRATEGIC' THEN 'HAS_AND_SEES_'||ResourceType||'_BBCC'
	WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NOT NULL AND ResourceType IS NOT NULL THEN 'HAS_'||ResourceType||'_AND_'||FeatureType||'_BBCC'
	WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NOT NULL THEN 'HAS_'||FeatureType||'_BBCC'
	WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NULL AND ResourceType IS NULL THEN 'HAS_NO_RESOURCE_BBCC'
END
WHERE NOT EXISTS 
	(SELECT * FROM 
		(SELECT * FROM Hill_SpecialTerrain UNION SELECT * FROM Flat_SpecialTerrain) as tmp 
		WHERE tmp.SubjectRequirementSetId = BBCC_Modifiers.SubjectRequirementSetId 
			AND tmp.TerrainType=BBCC_Modifiers.TerrainType)
	AND ModifierId NOT LIKE '%REMOVE%';
*/
/*
UPDATE BBCC_Modifiers SET InnerReqSet = REPLACE(ModifierId, 'MODIFIER_','REQSET_VALID_TFR_'), ReqSet_TFR = 'REQSET_TFR_'||TerrainType||'_'||
CASE
	WHEN ModifierId LIKE '%REMOVE%' AND FeatureType IS NULL AND ResourceClassType<>'RESOURCECLASS_STRATEGIC' THEN 'HAS_'||ResourceType||'_BBCC'
	WHEN ModifierId LIKE '%REMOVE%' AND FeatureType IS NULL AND ResourceClassType = 'RESOURCECLASS_STRATEGIC' THEN 'HAS_AND_SEES_'||ResourceType||'_BBCC'
	WHEN ModifierId LIKE '%REMOVE%' AND FeatureType IS NOT NULL AND ResourceType IS NOT NULL THEN 'HAS_'||ResourceType||'_AND_'||FeatureType||'_BBCC'
	WHEN ModifierId LIKE '%REMOVE%' AND FeatureType IS NOT NULL THEN 'HAS_'||FeatureType||'_BBCC'
	WHEN ModifierId LIKE '%REMOVE%' AND FeatureType IS NULL AND ResourceType IS NULL THEN 'HAS_NO_RESOURCE_BBCC'
END
WHERE ModifierId NOT LIKE '%ADD%';
*/

--===================================================================
--in live
--===================================================================
/*
UPDATE BBCC_Modifiers SET InnerReqSet = REPLACE(ModifierId, 'MODIFIER_','REQSET_VALID_TFR_');
--Building Reqsets
INSERT INTO RequirementSets
	SELECT DISTINCT BBCC_Modifiers.SubjectRequirementSetId, 'REQUIREMENTSET_TEST_ALL'
	FROM BBCC_Modifiers;
INSERT INTO RequirementSets
	SELECT DISTINCT BBCC_Modifiers.InnerReqSet, 'REQUIREMENTSET_TEST_ANY'
	FROM BBCC_Modifiers;
INSERT INTO RequirementSets
	SELECT DISTINCT BBCC_Modifiers.ReqSet_TFR, 'REQUIREMENTSET_TEST_ALL'
	FROM BBCC_Modifiers
	WHERE ReqSet_TFR IS NOT NULL;
--populating tripplets terrain, feature, requirements with concrete reqs
INSERT INTO RequirementSetRequirements
	SELECT DISTINCT ReqSet_TFR, 
	CASE
		WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NULL AND ResourceClassType<>'RESOURCECLASS_STRATEGIC' THEN 'REQ_HAS_'||ResourceType||'_BBCC'
		WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NULL AND ResourceClassType = 'RESOURCECLASS_STRATEGIC' THEN 'REQ_HAS_AND_SEES_'||ResourceType||'_BBCC'
		WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NOT NULL AND ResourceType IS NOT NULL THEN 'REQ_HAS_'||ResourceType||'_AND_'||FeatureType||'_BBCC'
		WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NOT NULL THEN 'REQ_HAS_'||FeatureType||'_BBCC'
		WHEN ModifierId LIKE '%ADD%' AND FeatureType IS NULL AND ResourceType IS NULL THEN 'REQ_HAS_NO_RESOURCE_BBCC'
		--WHEN ModifierId LIKE '%REMOVE%' AND FeatureType IS NULL AND ResourceClassType<>'RESOURCECLASS_STRATEGIC' THEN 'REQ_HAS_'||ResourceType||'_BBCC'
		--WHEN ModifierId LIKE '%REMOVE%' AND FeatureType IS NULL AND ResourceClassType = 'RESOURCECLASS_STRATEGIC' THEN 'REQ_HAS_AND_SEES_'||ResourceType||'_BBCC'
		--WHEN ModifierId LIKE '%REMOVE%' AND FeatureType IS NOT NULL AND ResourceType IS NOT NULL THEN 'REQ_HAS_'||ResourceType||'_AND_'||FeatureType||'_BBCC'
		--WHEN ModifierId LIKE '%REMOVE%' AND FeatureType IS NOT NULL THEN 'REQ_HAS_'||FeatureType||'_BBCC'
		--WHEN ModifierId LIKE '%REMOVE%' AND FeatureType IS NULL AND ResourceType IS NULL THEN 'REQ_HAS_NO_RESOURCE_BBCC'
	END
	FROM BBCC_Modifiers
	WHERE ReqSet_TFR IS NOT NULL;
INSERT INTO RequirementSetRequirements
	SELECT DISTINCT ReqSet_TFR, 'REQ_PLOT_HAS_'||TerrainType||'_BBCC'
	FROM BBCC_Modifiers
	WHERE ReqSet_TFR IS NOT NULL;
--creating tfr requirements
INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT DISTINCT REPLACE(BBCC_Modifiers.ReqSet_TFR,'REQSET_','REQ_'), 'REQUIREMENT_REQUIREMENTSET_IS_MET'
	FROM BBCC_Modifiers
	WHERE ReqSet_TFR IS NOT NULL;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT DISTINCT REPLACE(BBCC_Modifiers.ReqSet_TFR,'REQSET_','REQ_'), 'RequirementSetId', BBCC_Modifiers.ReqSet_TFR
	FROM BBCC_Modifiers
	WHERE ReqSet_TFR IS NOT NULL;
--inserting them into innerreqsets
INSERT INTO RequirementSetRequirements
	SELECT DISTINCT InnerReqSet, REPLACE(BBCC_Modifiers.ReqSet_TFR,'REQSET_','REQ_')
	FROM BBCC_Modifiers
	WHERE ReqSet_TFR IS NOT NULL;
--creating req out of inner reqsets
INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT DISTINCT REPLACE(BBCC_Modifiers.InnerReqSet,'REQSET_','REQ_'), 'REQUIREMENT_REQUIREMENTSET_IS_MET'
	FROM BBCC_Modifiers;
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT DISTINCT REPLACE(BBCC_Modifiers.InnerReqSet,'REQSET_','REQ_'), 'RequirementSetId', BBCC_Modifiers.InnerReqSet
	FROM BBCC_Modifiers;
--populating final requirementset
INSERT INTO RequirementSetRequirements
	SELECT DISTINCT BBCC_Modifiers.SubjectRequirementSetId, 'REQ_PLOT_IS_CITY_CENTER_BBCC'
	FROM BBCC_Modifiers;
INSERT INTO RequirementSetRequirements
	SELECT DISTINCT BBCC_Modifiers.SubjectRequirementSetId, REPLACE(BBCC_Modifiers.InnerReqSet,'REQSET_','REQ_')
	FROM BBCC_Modifiers;
*/
/*
INSERT INTO RequirementSetRequirements
	SELECT SubjectRequirementSetId, 'REQ_PLOT_HAS_NO_'||TerrainType||'_BBCC' 
	FROM (SELECT * FROM Hill_SpecialTerrain UNION SELECT * FROM Flat_SpecialTerrain);
*/
--===================================================================
--in live
--===================================================================
/*
--Finalizing the modifiers after the requirements are done
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId)
	SELECT DISTINCT BBCC_Modifiers.ModifierId, 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD', BBCC_Modifiers.SubjectRequirementSetId
	FROM BBCC_Modifiers;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT BBCC_Modifiers.ModifierId, 'YieldType', BBCC_Modifiers.YieldType
	FROM BBCC_Modifiers;
INSERT INTO ModifierArguments(ModifierId, Name, Value)
	SELECT DISTINCT BBCC_Modifiers.ModifierId, 'Amount', BBCC_Modifiers.Amount
	FROM BBCC_Modifiers;
--Inserting into traits
INSERT INTO TraitModifiers(TraitType, ModifierId)
	SELECT DISTINCT 'TRAIT_LEADER_MAJOR_CIV', BBCC_Modifiers.ModifierId
	FROM BBCC_Modifiers;
INSERT INTO TraitModifiers(TraitType, ModifierId)
	SELECT DISTINCT 'MINOR_CIV_DEFAULT_TRAIT', BBCC_Modifiers.ModifierId
	FROM BBCC_Modifiers;

DROP TABLE BBCC;
DROP TABLE BBCC_Modifiers;
DROP TABLE Hill_SpecialTerrain;
DROP TABLE Flat_SpecialTerrain;
*/
--=====================Removing any extra yields (outside wonder settles and disaster, for that only lua)================--------
CREATE TABLE BBCC_DynamicYields(
	ModifierB TEXT NOT NULL,
	SubjectRequirementSetId TEXT,
	Level INT DEFAULT 0,
	Count INT DEFAULT 0 NOT NULL,
	RequirementSetType TEXT,
	RequirementId TEXT,
	RequirementType TEXT,
	Inverse INT,
	ReqName TEXT,
	ReqValue TEXT,
	FeatureCount INT DEFAULT 0 NOT NULL,
	PRIMARY KEY (ModifierB, SubjectRequirementSetId, RequirementId)
);

INSERT INTO BBCC_DynamicYields(ModifierB, SubjectRequirementSetId, RequirementId, RequirementType, Inverse, ReqName, ReqValue)
	SELECT DISTINCT Modifiers.ModifierId, Modifiers.SubjectRequirementSetId, RequirementSetRequirements.RequirementId, Requirements.RequirementType, Requirements.Inverse, RequirementArguments.Name, RequirementArguments.Value
	FROM Modifiers 
	INNER JOIN RequirementSetRequirements ON Modifiers.SubjectRequirementSetId = RequirementSetRequirements.RequirementSetId
	INNER JOIN Requirements ON RequirementSetRequirements.RequirementId = Requirements.RequirementId
	LEFT JOIN RequirementArguments ON Requirements.RequirementId = RequirementArguments.RequirementId
	WHERE ModifierType IN ('MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'MODIFIER_PLAYER_ADJUST_PLOT_YIELD')
	AND ModifierId NOT LIKE '%BBCC' AND ModifierId NOT LIKE '%REMOVE%EXTRA%';
--run this query 3 times to ensure capturing up to 3 levels of nesting requirements with 'REQUIREMENT_REQUIREMENTSET_IS_MET'
INSERT OR IGNORE INTO BBCC_DynamicYields(ModifierB, SubjectRequirementSetId, Level, RequirementId, RequirementType, Inverse, ReqName, ReqValue)
	SELECT DISTINCT mod, srset, level, RequirementSetRequirements.RequirementId, Requirements.RequirementType, Requirements.Inverse, RequirementArguments.Name, RequirementArguments.Value
	FROM 
		(SELECT BBCC_DynamicYields.ModifierB as mod, BBCC_DynamicYields.ReqValue as srset, BBCC_DynamicYields.Level+1 as level
			FROM BBCC_DynamicYields WHERE RequirementType = 'REQUIREMENT_REQUIREMENTSET_IS_MET')
	INNER JOIN RequirementSetRequirements ON srset = RequirementSetRequirements.RequirementSetId
	INNER JOIN Requirements ON RequirementSetRequirements.RequirementId = Requirements.RequirementId
	LEFT JOIN RequirementArguments ON Requirements.RequirementId = RequirementArguments.RequirementId;

INSERT OR IGNORE INTO BBCC_DynamicYields(ModifierB, SubjectRequirementSetId, Level, RequirementId, RequirementType, Inverse, ReqName, ReqValue)
	SELECT DISTINCT mod, srset, level, RequirementSetRequirements.RequirementId, Requirements.RequirementType, Requirements.Inverse, RequirementArguments.Name, RequirementArguments.Value
	FROM 
		(SELECT BBCC_DynamicYields.ModifierB as mod, BBCC_DynamicYields.ReqValue as srset, BBCC_DynamicYields.Level+1 as level
			FROM BBCC_DynamicYields WHERE RequirementType = 'REQUIREMENT_REQUIREMENTSET_IS_MET')
	INNER JOIN RequirementSetRequirements ON srset = RequirementSetRequirements.RequirementSetId
	INNER JOIN Requirements ON RequirementSetRequirements.RequirementId = Requirements.RequirementId
	LEFT JOIN RequirementArguments ON Requirements.RequirementId = RequirementArguments.RequirementId;

INSERT OR IGNORE INTO BBCC_DynamicYields(ModifierB, SubjectRequirementSetId, Level, RequirementId, RequirementType, Inverse, ReqName, ReqValue)
	SELECT DISTINCT mod, srset, level, RequirementSetRequirements.RequirementId, Requirements.RequirementType, Requirements.Inverse, RequirementArguments.Name, RequirementArguments.Value
	FROM 
		(SELECT BBCC_DynamicYields.ModifierB as mod, BBCC_DynamicYields.ReqValue as srset, BBCC_DynamicYields.Level+1 as level
			FROM BBCC_DynamicYields WHERE RequirementType = 'REQUIREMENT_REQUIREMENTSET_IS_MET')
	INNER JOIN RequirementSetRequirements ON srset = RequirementSetRequirements.RequirementSetId
	INNER JOIN Requirements ON RequirementSetRequirements.RequirementId = Requirements.RequirementId
	LEFT JOIN RequirementArguments ON Requirements.RequirementId = RequirementArguments.RequirementId;

UPDATE OR IGNORE BBCC_DynamicYields SET Count = (SELECT count1
	FROM 
	(SELECT ModifierB as mod, SubjectRequirementSetId as srsid, Level as lvl,
		COUNT(*) as count1
		FROM BBCC_DynamicYields 
		GROUP BY ModifierB, SubjectRequirementSetId, Level)
	WHERE BBCC_DynamicYields.ModifierB = mod AND BBCC_DynamicYields.SubjectRequirementSetId = srsid AND BBCC_DynamicYields.Level = lvl);

UPDATE OR IGNORE BBCC_DynamicYields SET FeatureCount= (SELECT count1
	FROM 
	(SELECT ModifierB as mod, SubjectRequirementSetId as srsid, Level as lvl,
		COUNT(*) as count1
		FROM BBCC_DynamicYields WHERE RequirementType = 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES'
		GROUP BY ModifierB, SubjectRequirementSetId, Level)
	WHERE BBCC_DynamicYields.ModifierB = mod AND BBCC_DynamicYields.SubjectRequirementSetId = srsid AND BBCC_DynamicYields.Level = lvl);

DELETE FROM BBCC_DynamicYields 
WHERE ModifierB IN 
	(SELECT ModifierB FROM BBCC_DynamicYields
		WHERE RequirementType IN ('REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES', 'REQUIREMENT_PLOT_IMPROVED_RESOURCE_CLASS_TYPE_MATCHES') 
			OR (FeatureCount<2 AND RequirementType = 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES' AND ReqValue IN (SELECT FeatureType FROM Features WHERE Removable = 1))
			OR (RequirementType = 'REQUIREMENT_PLOT_DISTRICT_TYPE_MATCHES' AND ReqValue = 'DISTRICT_CITY_CENTER' AND Inverse=1)
			OR (RequirementType = 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES' AND ReqValue IN (SELECT FeatureType FROM Feature_ValidTerrains WHERE TerrainType NOT IN ('TERRAIN_GRASS', 'TERRAIN_GRASS_HILLS', 'TERRAIN_PLAINS', 'TERRAIN_PLAINS_HILLS', 'TERRAIN_DESERT', 'TERRAIN_DESERT_HILLS', 'TERRAIN_TUNDRA', 'TERRAIN_TUNDRA_HILLS', 'TERRAIN_SNOW', 'TERRAIN_SNOW_HILLS')))
			OR (RequirementType = 'REQUIREMENT_PLOT_TERRAIN_TYPE_MATCHES' AND ReqValue NOT IN ('TERRAIN_GRASS', 'TERRAIN_GRASS_HILLS', 'TERRAIN_PLAINS', 'TERRAIN_PLAINS_HILLS', 'TERRAIN_DESERT', 'TERRAIN_DESERT_HILLS', 'TERRAIN_TUNDRA', 'TERRAIN_TUNDRA_HILLS', 'TERRAIN_SNOW', 'TERRAIN_SNOW_HILLS')));

UPDATE BBCC_DynamicYields SET RequirementSetType = (SELECT RequirementSets.RequirementSetType
	FROM RequirementSets
	WHERE BBCC_DynamicYields.SubjectRequirementSetId = RequirementSets.RequirementSetId);

--SELECT DISTINCT SubjectRequirementSetId FROM BBCC_DynamicYields WHERE RequirementSetType = 'REQUIREMENTSET_TEST_ANY' AND Level = 0;
CREATE TABLE InvestigationLevel(
	Level INT DEFAULT 0
	);--allows incrementing level and copypasting below queries if more depth is needed due to a bug report
INSERT INTO InvestigationLevel(Level) VALUES
	(0);
--Moving free test any into test all through nesting, so we can add not a city center requirement
INSERT INTO Requirements(RequirementId, RequirementType)
	SELECT DISTINCT 'REQ_'||BBCC_DynamicYields.SubjectRequirementSetId||'_BBCC', 'REQUIREMENT_REQUIREMENTSET_IS_MET' 
	FROM BBCC_DynamicYields INNER JOIN InvestigationLevel ON BBCC_DynamicYields.Level = InvestigationLevel.Level
	WHERE RequirementSetType = 'REQUIREMENTSET_TEST_ANY';
INSERT INTO RequirementArguments(RequirementId, Name, Value)
	SELECT DISTINCT 'REQ_'||BBCC_DynamicYields.SubjectRequirementSetId||'_BBCC', 'RequirementSetId', BBCC_DynamicYields.SubjectRequirementSetId  
	FROM BBCC_DynamicYields INNER JOIN InvestigationLevel ON BBCC_DynamicYields.Level = InvestigationLevel.Level
	WHERE RequirementSetType = 'REQUIREMENTSET_TEST_ANY';
INSERT INTO RequirementSets
	SELECT DISTINCT 'REQSET_'||BBCC_DynamicYields.SubjectRequirementSetId||'_BBCC', 'REQUIREMENTSET_TEST_ALL'
	FROM BBCC_DynamicYields INNER JOIN InvestigationLevel ON BBCC_DynamicYields.Level = InvestigationLevel.Level
	WHERE RequirementSetType = 'REQUIREMENTSET_TEST_ANY';
INSERT INTO RequirementSetRequirements
	SELECT DISTINCT 'REQSET_'||BBCC_DynamicYields.SubjectRequirementSetId||'_BBCC', 'REQ_'||BBCC_DynamicYields.SubjectRequirementSetId||'_BBCC'
	FROM BBCC_DynamicYields INNER JOIN InvestigationLevel ON BBCC_DynamicYields.Level = InvestigationLevel.Level
	WHERE RequirementSetType = 'REQUIREMENTSET_TEST_ANY';
INSERT INTO RequirementSetRequirements
	SELECT DISTINCT 'REQSET_'||BBCC_DynamicYields.SubjectRequirementSetId||'_BBCC', 'REQ_PLOT_IS_NO_CITY_CENTER_BBCC'
	FROM BBCC_DynamicYields INNER JOIN InvestigationLevel ON BBCC_DynamicYields.Level = InvestigationLevel.Level
	WHERE RequirementSetType = 'REQUIREMENTSET_TEST_ANY';
--updating the respective modifiers
UPDATE Modifiers SET SubjectRequirementSetId = 'REQSET_'||SubjectRequirementSetId||'_BBCC' WHERE ModifierId IN 
	(SELECT DISTINCT ModifierB
		FROM BBCC_DynamicYields INNER JOIN InvestigationLevel ON BBCC_DynamicYields.Level = InvestigationLevel.Level
		WHERE RequirementSetType = 'REQUIREMENTSET_TEST_ANY');
--remove updated modifiers from the list
DELETE FROM BBCC_DynamicYields WHERE ModifierB IN 
	(SELECT DISTINCT ModifierB
		FROM BBCC_DynamicYields INNER JOIN InvestigationLevel ON BBCC_DynamicYields.Level = InvestigationLevel.Level
		WHERE RequirementSetType = 'REQUIREMENTSET_TEST_ANY');
--Adding Not City Center Requirement to TEST_ALL cases, unless only req is a nested requirement of type REQUIREMENT_REQUIREMENTSET_IS_MET
INSERT INTO RequirementSetRequirements
	SELECT DISTINCT BBCC_DynamicYields.SubjectRequirementSetId, 'REQ_PLOT_IS_NO_CITY_CENTER_BBCC'
		FROM BBCC_DynamicYields INNER JOIN InvestigationLevel ON BBCC_DynamicYields.Level = InvestigationLevel.Level
		WHERE ModifierB NOT IN (
			SELECT DISTINCT ModifierB FROM BBCC_DynamicYields 
			WHERE Count = 1 AND RequirementType = 'REQUIREMENT_REQUIREMENTSET_IS_MET'
			) AND RequirementSetType = 'REQUIREMENTSET_TEST_ALL';
--removing updated modifiers
DELETE FROM BBCC_DynamicYields 
	WHERE ModifierB IN 
		(SELECT DISTINCT BBCC_DynamicYields.ModifierB
		FROM BBCC_DynamicYields INNER JOIN InvestigationLevel ON BBCC_DynamicYields.Level = InvestigationLevel.Level
		WHERE ModifierB NOT IN (
			SELECT DISTINCT ModifierB FROM BBCC_DynamicYields 
			WHERE Count = 1 AND RequirementType = 'REQUIREMENT_REQUIREMENTSET_IS_MET'
			) AND RequirementSetType = 'REQUIREMENTSET_TEST_ALL');

DROP TABLE BBCC_DynamicYields;
DROP TABLE InvestigationLevel;


/*
--free modifiers to remove yields dynamically in lua
INSERT INTO RequirementSets(RequirementSetId, RequirementSetType) VALUES
	('REQSET_PLOT_IS_CITY_CENTER_BBCC', 'REQUIREMENTSET_TEST_ALL');
INSERT INTO RequirementSetRequirements(RequirementSetId, RequirementId) VALUES
	('REQSET_PLOT_IS_CITY_CENTER_BBCC', 'REQ_PLOT_IS_CITY_CENTER_BBCC');
INSERT INTO Modifiers(ModifierId, ModifierType, SubjectRequirementSetId) VALUES
	('MODIFIER_REMOVE_DYN_FOOD_BBCC', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_PLOT_IS_CITY_CENTER_BBCC'),
	('MODIFIER_REMOVE_DYN_PROD_BBCC', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_PLOT_IS_CITY_CENTER_BBCC'),
	('MODIFIER_REMOVE_DYN_GOLD_BBCC', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_PLOT_IS_CITY_CENTER_BBCC'),
	('MODIFIER_REMOVE_DYN_FAITH_BBCC', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_PLOT_IS_CITY_CENTER_BBCC'),
	('MODIFIER_REMOVE_DYN_CULT_BBCC', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_PLOT_IS_CITY_CENTER_BBCC'),
	('MODIFIER_REMOVE_DYN_SCI_BBCC', 'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD', 'REQSET_PLOT_IS_CITY_CENTER_BBCC');
INSERT INTO ModifierArguments(ModifierId, Name, Value) VALUES
	('MODIFIER_REMOVE_DYN_FOOD_BBCC', 'YieldType', 'YIELD_FOOD'),
	('MODIFIER_REMOVE_DYN_FOOD_BBCC', 'Amount', -1),
	('MODIFIER_REMOVE_DYN_PROD_BBCC', 'YieldType', 'YIELD_PRODUCTION'),
	('MODIFIER_REMOVE_DYN_PROD_BBCC', 'Amount', -1),
	('MODIFIER_REMOVE_DYN_GOLD_BBCC', 'YieldType', 'YIELD_GOLD'),
	('MODIFIER_REMOVE_DYN_GOLD_BBCC', 'Amount', -1),
	('MODIFIER_REMOVE_DYN_FAITH_BBCC', 'YieldType', 'YIELD_FAITH'),
	('MODIFIER_REMOVE_DYN_FAITH_BBCC', 'Amount', -1),
	('MODIFIER_REMOVE_DYN_CULT_BBCC', 'YieldType', 'YIELD_CULTURE'),
	('MODIFIER_REMOVE_DYN_CULT_BBCC', 'Amount', -1),
	('MODIFIER_REMOVE_DYN_SCI_BBCC', 'YieldType', 'YIELD_SCIENCE'),
	('MODIFIER_REMOVE_DYN_SCI_BBCC', 'Amount', -1);
*/